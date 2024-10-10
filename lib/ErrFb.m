function ErrFb()
    msgbox('Error occurred, program terminated! Please view more specific information in the command line window',...
            'Error','error');
    for i = 1:4
        system('rundll32 user32.dll,MessageBeep');
        pause(0.5);
    end
    error('Error occurred, program terminated! Please view more specific information in the command line window');
end