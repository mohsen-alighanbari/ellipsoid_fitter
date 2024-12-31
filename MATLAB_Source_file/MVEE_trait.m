% MIT License
% 
% Copyright (c) 2024 Mohsen Alighanbari, Sina Alighanbari, Lisa Griffin
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function Trait_Results = MVEE_trait()
    % Input for the CoP and CoM optimization code model:
    diaWindow = dialog('Position', [300, 300, 350, 300], 'Name', 'Questions');
    % Q1:
    Text1 = uicontrol('Parent',diaWindow, ...
        'Style','text', ...
        'Position',[20 250 300 40], ...
        'String','Do you want to display the final fitted ellipse to data?');
    choice1 = uibuttongroup('Parent',diaWindow,'Position',[0.1 0.75 0.8 0.15]);
        opt1 = uicontrol('Parent',choice1, ...
            'Style','radiobutton', ...
            'Position',[60 10 60 25], ...
            'String','Yes');
        opt2 = uicontrol('Parent',choice1, ...
            'Style','radiobutton', ...
            'Position',[170 10 60 25], ...
            'String','No');
    % Q2:
    Text2 = uicontrol('Parent',diaWindow, ...
        'Style','text','Position',[20 165 300 40], ...
        'String','Do you want to see precentage of fit on command window?');
    choice2 = uibuttongroup('Parent',diaWindow,'Position',[0.1 0.45 0.8 0.15]);
        opt3 = uicontrol('Parent',choice2,'Style','radiobutton', ...
            'Position',[60 10 60 25],'String','Yes');
        opt4 = uicontrol('Parent',choice2,'Style','radiobutton', ...
            'Position',[170 10 60 25],'String','No');
    % Q3:
    Text3 = uicontrol('Parent',diaWindow,'Style','text', ...
        'Position',[20 75 300 40], ...
        'String','Does your data consist of values smaller than 0.0001?');
    choice3 = uibuttongroup('Parent',diaWindow,'Position',[0.1 0.15 0.8 0.15]);
        opt5 = uicontrol('Parent',choice3,'Style','radiobutton', ...
            'Position',[60 10 60 25],'String','Yes');
        opt6 = uicontrol('Parent',choice3,'Style','radiobutton', ...
            'Position',[170 10 60 25],'String','No');
    % make an Ok button:
    OkBtn = uicontrol('Parent',diaWindow,'Position',[130 10 70 25], ...
        'String','OK','Callback',@DialWinResponse);
    uiwait(diaWindow);

    function DialWinResponse(~,~)
        Trait_Results = struct();
        Trait_Results.Q1 = get_selected_option(choice1);
        Trait_Results.Q2 = get_selected_option(choice2);
        Trait_Results.Q3 = get_selected_option(choice3);
        delete(diaWindow);
    end
    function selected = get_selected_option(choice)
        selectedButton = get(choice,'SelectedObject');
        if isempty(selectedButton)
            selected = 'None';
        else 
            selected = get(selectedButton,'String');
        end
    end
end