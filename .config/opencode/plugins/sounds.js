const sounds = "~/.config/opencode/sound-packs";

export const SoundPlugin = async ({ $ }) => {
  const play = async (name) => {
    try {
      await $`afplay -v 0.5 ${sounds}/${name}.wav`;
    } catch {}
  };

  return {
    event: async ({ event }) => {
      if (event.type === "session.created") {
        await play("session-start");
      }

      if (event.type === "session.idle") {
        await play("stop");
      }

      if (event.type === "session.error") {
        await play("notification");
      }
    },

    "tui.command.execute": async () => {
      await play("prompt-submit");
    },
  };
};
