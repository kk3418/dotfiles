require("codegpt.config")

vim.g["codegpt_commands"] = {
  ["refactor"] = {
    user_message_template = "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nRefactor the above code to {{language_instructions}}. Only return the code snippet and comments.",
    -- Language specific instructions for vue filetype
    language_instructions = {
        vue = "vue3 composition api",
        jsx = "react functional component and use hooks",
        tsx = "react functional component and use hooks",
    },
    temperature = 0.3,
    callback_type = "replace_lines",
  },
}

