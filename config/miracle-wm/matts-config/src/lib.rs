use miracle_plugin::{
    Key, Modifier,
    config::{BorderConfig, Configuration, CustomKeyAction, Gaps, StartupApp},
    plugin::Plugin,
};

#[derive(Default)]
struct MyPlugin;

impl Plugin for MyPlugin {
    fn configure(&mut self) -> Option<Configuration> {
        let mut config: Configuration = Configuration::default();

        config.primary_modifier = Some(miracle_plugin::Modifier::Meta);

        let mut custom_actions: Vec<CustomKeyAction> = vec![];

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
            key: Key("M".to_string()),
            modifiers: vec![Modifier::Primary],
            command: "miraclemsg workspace music".to_string(),
        });

        config.custom_key_actions = Some(custom_actions);
        config.inner_gaps = Some(Gaps { x: 16, y: 16 });
        config.outer_gaps = Some(Gaps { x: 8, y: 8 });

        let mut startup_apps: Vec<StartupApp> = vec![];
        startup_apps.push(StartupApp {
            command: "moonswing".to_string(),
            restart_on_death: false,
            no_startup_id: false,
            should_halt_compositor_on_death: false,
            in_systemd_scope: true,
        });

        config.startup_apps = Some(startup_apps);

        config.terminal = Some("kitty".to_string());

        config.resize_jump = Some(50);
        config.border = Some(BorderConfig {
            size: 2,
            radius: 4.0,
            color: "0xbd93f9ff".to_string(),
            focus_color: "0x50fa7bff".to_string(),
        });

        Some(config)
    }
}

miracle_plugin::miracle_plugin!(MyPlugin);
