if status is-interactive

    alias helix="sudo hx"

    abbr -a cd z
    abbr -a ls eza
    abbr -a cat bat
    abbr -a cls clear

    set -g fish_greeting ""
    set -g fish_prompt_pwd_dir_length 0
    set -g fish_color_autosuggestion 7c6f64

    set -gx NNN_COLORS 3214
    set -gx NNN_F_BOLD 1
    set -gx EDITOR "zellij action edit"

    function fish_prompt
        set -l last_status $status

        set_color b8bb26
        echo -n "$USER "

        set_color 83a598
        echo -n (prompt_pwd)

        if set -q __fish_git_prompt_showupstream
            set_color b16286
            printf '%s ' (fish_vcs_prompt)
        end

        set_color FE8019
        echo -n "> "

        set_color normal
    end
end
