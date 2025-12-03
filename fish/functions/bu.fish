function bu --wraps='brew update && brew upgrade && brew cleanup && brew autoremove' --description 'alias bu=brew update && brew upgrade && brew cleanup && brew autoremove'
  brew update && brew upgrade && brew cleanup && brew autoremove $argv
        
end
