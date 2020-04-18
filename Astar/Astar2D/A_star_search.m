function path = A_star_search(map,MAX_X,MAX_Y)
%%
%This part is about map/obstacle/and other settings
    %pre-process the grid map, add offset
    size_map = size(map,1);
    Y_offset = 0;
    X_offset = 0;
    
    %Define the 2D grid map array.
    %Obstacle=-1, Target = 0, Start=1
    MAP=2*(ones(MAX_X,MAX_Y));
    
    %Initialize MAP with location of the target
    xval=floor(map(size_map, 1)) + X_offset;
    yval=floor(map(size_map, 2)) + Y_offset;
    xTarget=xval;
    yTarget=yval;
    MAP(xval,yval)=0;
    
    %Initialize MAP with location of the obstacle
    for i = 2: size_map-1
        xval=floor(map(i, 1)) + X_offset;
        yval=floor(map(i, 2)) + Y_offset;
        MAP(xval,yval)=-1;
    end 
    
    %Initialize MAP with location of the start point
    xval=floor(map(1, 1)) + X_offset;
    yval=floor(map(1, 2)) + Y_offset;
    xStart=xval;
    yStart=yval;
    MAP(xval,yval)=1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %LISTS USED FOR ALGORITHM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %OPEN LIST STRUCTURE
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
    %--------------------------------------------------------------------------
    OPEN=[];
    %CLOSED LIST STRUCTURE
    %--------------
    %X val | Y val |
    %--------------
    % CLOSED=zeros(MAX_VAL,2);
    CLOSED=[];

    %Put all obstacles on the Closed list
    k=1;%Dummy counter
    for i=1:MAX_X
        for j=1:MAX_Y
            if(MAP(i,j) == -1)
                CLOSED(k,1)=i;
                CLOSED(k,2)=j;
                k=k+1;
            end
        end
    end
    CLOSED_COUNT=size(CLOSED,1);
    %set the starting node as the first node
    xNode=xval;
    yNode=yval;
    OPEN_COUNT=1;
    goal_distance=distance(xNode,yNode,xTarget,yTarget);
    path_cost=0;
    OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,goal_distance,path_cost,goal_distance);
%     OPEN(OPEN_COUNT,1)=0;
%     CLOSED_COUNT=CLOSED_COUNT+1;
%     CLOSED(CLOSED_COUNT,1)=xNode;
%     CLOSED(CLOSED_COUNT,2)=yNode;
    NoPath=1;

%%
%This part is your homework
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    goalID = -1;
    while(1) %you have to decide the Conditions for while loop exit 
        % find the node with minimum fn from OPEN list
        i_min = min_fn(OPEN, OPEN_COUNT, xTarget, yTarget);
        % no path
        if i_min == -1
            break
            NoPath = 1;
        end
        % expand the i_min point
        node_x = OPEN(i_min, 2);
        node_y = OPEN(i_min, 3);   
        gn = OPEN(i_min, 7);
        if node_x == xTarget && node_y == yTarget
            NoPath = 0;
            goalID = i_min;
            % disp('find end')
            break
        end
        exp_array = expand_array(node_x,node_y,gn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y);
        % push i_min's unexpanded neghbors into OPEN
        for idx = 1: size(exp_array, 1)
            inOPEN = 0;
            idxOPEN = -1;
            for i = 1:size(OPEN, 1)
                if exp_array(idx, 1) == OPEN(i, 2) && exp_array(idx, 2) == OPEN(i, 3)
                    inOPEN = 1;
                    idxOPEN = i;
                    break;
                end
            end
            if inOPEN == 0
                % push into OPEN list
                OPEN_COUNT = OPEN_COUNT + 1;
                OPEN(OPEN_COUNT,:)=insert_open(exp_array(idx, 1),exp_array(idx, 2),node_x,node_y,exp_array(idx, 3),exp_array(idx, 4),exp_array(idx, 5));
            else
                if exp_array(idx, 4) < OPEN(idxOPEN, 7)
                    OPEN(idxOPEN, :) = insert_open(exp_array(idx, 1),exp_array(idx, 2),node_x,node_y,exp_array(idx, 3),exp_array(idx, 4),exp_array(idx, 5));
                end
            end
        end
        % push the i_min point into CLOSED
        OPEN(i_min,1)=0;
        CLOSED_COUNT=CLOSED_COUNT+1;
        CLOSED(CLOSED_COUNT,1)=node_x;
        CLOSED(CLOSED_COUNT,2)=node_y;
     %
     %finish the while loop
     %
     
    end %End of While Loop
    
    %Once algorithm has run The optimal path is generated by starting of at the
    %last node(if it is the target node) and then identifying its parent node
    %until it reaches the start node.This is the optimal path
    
    %
    %How to get the optimal path after A_star search?
    %please finish it
    %
    
    % get the optimal path
    path = [];
    pathCount = 0;
    if NoPath == 0 && goalID ~= - 1
        now = OPEN(goalID, :);
        while 1
            pathCount = pathCount + 1;
            path(pathCount, 1) = now(1, 2);
            path(pathCount, 2) = now(1, 3);
            % if reach the start point 
            if now(1, 2) == xStart && now(1, 3) == yStart
                break
            end
            % find pre point in OPEN
            for i = 1:OPEN_COUNT
                if OPEN(i, 2) == now(1, 4) && OPEN(i, 3) == now(1, 5)
                    now = OPEN(i, :);
                    break;
                end
            end % end for
        end % end while
    end
    % reverse to make path in normal order
    path = flip(path)
end