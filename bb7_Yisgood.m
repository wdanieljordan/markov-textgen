%start by pasting text within single quotes, naming it A. It needs to be
%like a few paragraphs long and it can't have any apostrophes ' like that.
B = strsplit(A)'

X = zeros(length(B),round(length(B)/40),2);
X = size(X);
Y = cell(X(1),X(2));
X = cell(X);
X(:,:,1) = {'X%X%X'};
X(:,:,2) = {0};
Xwrite = 0;

for q = 1:length(B)-1 %stepping thru B, 
    r = B{q};   %picking up the word and calling it r.
    s = strmatch({r},X(:,1,1),'exact'); %if not new word, word already has address X(s,1,1)
    if isempty(s) == 1;  %then we have a new word 
        Xwrite = Xwrite + 1;  %moving the index to next free zone.
        X(Xwrite,1,1) = {r};
        X(Xwrite,2,1) = B(q+1);  %writes word after r in second column.
        X(Xwrite,1,2) = {1};  %giving first points
        X(Xwrite,2,2) = {1};
    else       %r is not a new word (found in X(:,1,1))
        X{s,1,2} = X{s,1,2} + 1;   %give a point to original r
        for p = 1:size(X,2)  %scanning row-wise
            if isequal(B{q+1},X{s,p,1}) == 1; %if next word of original string is found in scan of X
                X{s,p,2} = X{s,p,2} + 1;  %that word gets a point
                break
            elseif isequal(X{s,p,1},'X%X%X') == 1; %word q+1 not found, so it gets written here at p
                X{s,p,1} = B{q+1};
                X{s,p,2} = X{s,p,2} + 1;
                break
            end
        end
    end
end

for g = 1:size(X,1) %stepping down thru X
    Y(g,2:3) = X(g,1:2,1); %writing first row of Y with X words.
    w = 3; %w is COL# (horizontal coord) in Y.
    y = 1; %local filling. will be numder couting up for instances (X(:,:,2))... resets each time z increases.
    z = 2; %z is COL# in X.
    rowlength = X{g,1,2};
    Y{g,1} = rowlength; %making col 1 of Y the index of how many words are in the row.
    while w - 2 <= rowlength; %w is now set for entire Y row length. can use this later for rand choosing before you get to %X%X%
        while y <= X{g,z,2}; %while local filling coord <= points
            Y{g,w} = X{g,z,1};
            Y(1:5,1:7)
            y = y + 1;
            w = w + 1;
        end
        y = 1;
        z = z + 1;
    end
end

%cleanup blank rows
cleanit = strfind(cell2mat(Y(:,1))',0)
Y(cleanit,:) = []


%start writing!
R = 2000;
P = 1;
text = cell(R,1);
zz = 1; %this is starting row? ("seed word")
text{1} = Y{zz,2};
while P < R
    P = P + 1;
    text{P} = Y{zz,ceil(rand*Y{zz,1})+2};
    zz = strmatch(text{P},Y(:,2),'exact');
    text;
end

text = text'
text = strjoin(text)