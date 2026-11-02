function sync-skills --description 'Install new skills from nvie/skills, then update all global skills'
    npx skills add nvie/skills -g -s '*' -y
    and npx skills update -g -y
end
