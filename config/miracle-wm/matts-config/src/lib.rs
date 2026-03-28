use miracle_plugin::{
    Key, Modifier,
    animation::{AnimationFrameData, AnimationFrameResult},
    config::{BorderConfig, Configuration, CustomKeyAction, Gaps, StartupApp},
    container::{Container, LayoutScheme},
    core::Rect,
    plugin::Plugin,
    window::WindowInfo,
};
use std::collections::HashMap;

#[derive(Default)]
struct MyPlugin {
    window_directions: HashMap<u64, SlideDirection>,
}

impl Plugin for MyPlugin {
    fn configure(&mut self) -> Option<Configuration> {
        let mut config: Configuration = Configuration::default();

        config.primary_modifier = Some(miracle_plugin::Modifier::Meta);

        let mut custom_actions: Vec<CustomKeyAction> = vec![];
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("d".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "wofi --show=drun".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("S".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "grimshot copy area".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("L".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "swaylock".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("XF86AudioLowerVolume".to_string()),
            modifiers: vec![],
            command: "pamixer -d 10".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("XF86AudioRaiseVolume".to_string()),
            modifiers: vec![],
            command: "pamixer -i 10".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("XF86AudioMute".to_string()),
            modifiers: vec![],
            command: "pamixer -t".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("XF86MonBrightnessDown".to_string()),
            modifiers: vec![],
            command: "brightnessctl s 100-".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("XF86MonBrightnessUp".to_string()),
            modifiers: vec![],
            command: "brightnessctl s +100".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("E".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "wlogout --protocol layer-shell".to_string(),
        });
        custom_actions.push(CustomKeyAction {
            action: miracle_plugin::BindingAction::Down,
            key: Key("M".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "miraclemsg workspace music".to_string(),
        });

        config.custom_key_actions = Some(custom_actions);
        config.inner_gaps = Some(Gaps { x: 16, y: 16 });
        config.outer_gaps = Some(Gaps { x: 8, y: 8 });

        let mut startup_apps: Vec<StartupApp> = vec![];
        startup_apps.push(StartupApp {
            command: "waybar".to_string(),
            restart_on_death: false,
            no_startup_id: false,
            should_halt_compositor_on_death: false,
            in_systemd_scope: false,
        });
        startup_apps.push(StartupApp {
            command: "~/.local/bin/launch-swaybg.sh".to_string(),
            restart_on_death: false,
            no_startup_id: false,
            should_halt_compositor_on_death: false,
            in_systemd_scope: false,
        });
        startup_apps.push(StartupApp {
            command: "swaync".to_string(),
            restart_on_death: false,
            no_startup_id: false,
            should_halt_compositor_on_death: false,
            in_systemd_scope: false,
        });
        config.startup_apps = Some(startup_apps);

        config.terminal = Some("foot".to_string());

        config.resize_jump = Some(50);
        config.border = Some(BorderConfig {
            size: 2,
            radius: 4.0,
            color: "0xbd93f9ff".to_string(),
            focus_color: "0x50fa7bff".to_string(),
        });

        Some(config)
    }

    fn window_open_animation(
        &mut self,
        data: &AnimationFrameData,
        window: &WindowInfo,
    ) -> Option<AnimationFrameResult> {
        let container = window.container()?;
        let direction = slide_direction_for_container(&container);

        let progress = (data.runtime_seconds / 0.25).clamp(0.0, 1.0);
        let eased = ease_out_cubic(progress);

        let dest = &data.destination;
        let start = slide_offset_rect(dest, &direction);

        self.window_directions.insert(window.id(), direction);

        Some(animate_between(&start, dest, eased, data, progress))
    }

    fn window_close_animation(
        &mut self,
        data: &AnimationFrameData,
        window: &WindowInfo,
    ) -> Option<AnimationFrameResult> {
        let direction = self.window_directions.get(&window.id())?;

        let progress = (data.runtime_seconds / 0.25).clamp(0.0, 1.0);
        let eased = ease_in_cubic(progress);

        let origin = &data.origin;
        let end = slide_offset_rect(origin, direction);

        if progress >= 1.0 {
            self.window_directions.remove(&window.id());
        }

        Some(animate_between(origin, &end, eased, data, progress))
    }
}

enum SlideDirection {
    FromBottom,
    FromLeft,
    FromTop,
    FromRight,
    InPlace,
}

/// Returns the off-screen rect for a given base rect and slide direction.
/// For open animations this is the start; for close animations this is the end.
fn slide_offset_rect(base: &Rect, direction: &SlideDirection) -> Rect {
    match direction {
        SlideDirection::FromBottom => Rect {
            x: base.x,
            y: base.y + base.height,
            width: base.width,
            height: base.height,
        },
        SlideDirection::FromLeft => Rect {
            x: base.x - base.width,
            y: base.y,
            width: base.width,
            height: base.height,
        },
        SlideDirection::FromTop => Rect {
            x: base.x,
            y: base.y - base.height,
            width: base.width,
            height: base.height,
        },
        SlideDirection::FromRight => Rect {
            x: base.x + base.width,
            y: base.y,
            width: base.width,
            height: base.height,
        },
        SlideDirection::InPlace => *base,
    }
}

/// Interpolate between two rects and compute opacity for one animation frame.
fn animate_between(
    start: &Rect,
    end: &Rect,
    eased: f32,
    data: &AnimationFrameData,
    progress: f32,
) -> AnimationFrameResult {
    let area = Rect {
        x: start.x + (end.x - start.x) * eased,
        y: start.y + (end.y - start.y) * eased,
        width: start.width + (end.width - start.width) * eased,
        height: start.height + (end.height - start.height) * eased,
    };
    let opacity = data.opacity_start + (data.opacity_end - data.opacity_start) * eased;

    AnimationFrameResult {
        completed: progress >= 1.0,
        area: Some(area),
        transform: None,
        opacity: Some(opacity),
    }
}

/// Walk up the full container tree and accumulate which sides have neighbors.
///
/// A side is considered to have a neighbor if, at any ancestor level with a matching
/// layout scheme, a sibling exists on that side. This handles nested layouts where,
/// for example, a window in a vertical column may have a left neighbor via a grandparent
/// horizontal split.
fn collect_neighbors(container: &Container) -> (bool, bool, bool, bool) {
    let mut has_left = false;
    let mut has_right = false;
    let mut has_top = false;
    let mut has_bottom = false;

    let mut current = *container;
    loop {
        let parent = match current.parent() {
            Some(Container::Parent(p)) => p,
            _ => break,
        };

        let children = parent.get_children();
        let my_id = current.id();
        let index = match children.iter().position(|c| c.id() == my_id) {
            Some(i) => i,
            None => break,
        };
        let len = children.len();

        match parent.layout_scheme {
            LayoutScheme::Horizontal => {
                if index > 0 {
                    has_left = true;
                }
                if index + 1 < len {
                    has_right = true;
                }
            }
            LayoutScheme::Vertical => {
                if index > 0 {
                    has_top = true;
                }
                if index + 1 < len {
                    has_bottom = true;
                }
            }
            _ => {}
        }

        current = Container::Parent(parent);
    }

    (has_left, has_right, has_top, has_bottom)
}

/// Determine which direction a container should slide in from, based on its neighbors.
///
/// Heuristics (in priority order):
/// 1. No neighbors → slide from bottom
/// 2. Only left/right neighbors → slide from bottom
/// 3. Only top/bottom neighbors → slide from left
/// 4. Exactly one side without a neighbor → slide from that side
/// 5. All four sides have neighbors → fade in place (no slide)
/// Mixed (open sides on multiple axes): prefer the open horizontal side.
fn slide_direction_for_container(container: &Container) -> SlideDirection {
    let (has_left, has_right, has_top, has_bottom) = collect_neighbors(container);

    // Rule 5: all sides surrounded → fade in place
    if has_left && has_right && has_top && has_bottom {
        return SlideDirection::InPlace;
    }

    // Rule 4: exactly one side open → slide from that side
    let missing = (!has_left as u8) + (!has_right as u8) + (!has_top as u8) + (!has_bottom as u8);
    if missing == 1 {
        if !has_left {
            return SlideDirection::FromLeft;
        }
        if !has_right {
            return SlideDirection::FromRight;
        }
        if !has_top {
            return SlideDirection::FromTop;
        }
        if !has_bottom {
            return SlideDirection::FromBottom;
        }
    }

    let has_h = has_left || has_right;
    let has_v = has_top || has_bottom;

    // Rules 1 & 2: no vertical neighbors (with or without horizontal) → slide from bottom
    if !has_v {
        return SlideDirection::FromBottom;
    }

    // Rule 3: only top/bottom neighbors (no left/right) → slide from left
    if !has_h {
        return SlideDirection::FromLeft;
    }

    // Mixed (neighbors on both axes, multiple sides open): prefer the open horizontal side,
    // then the open vertical side.
    if !has_right {
        return SlideDirection::FromRight;
    }
    if !has_left {
        return SlideDirection::FromLeft;
    }
    if !has_bottom {
        return SlideDirection::FromBottom;
    }
    SlideDirection::FromTop
}

fn ease_out_cubic(t: f32) -> f32 {
    1.0 - (1.0 - t).powi(3)
}

fn ease_in_cubic(t: f32) -> f32 {
    t.powi(3)
}

miracle_plugin::miracle_plugin!(MyPlugin);
