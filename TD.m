function model = TD(X,r,param)
    
    % Temporal difference learning model
    %
    % USAGE: model = TD(X,r,[param])
    %
    % INPUTS:
    %   X - [N x D] matrix of stimulus features, where N is the number of
    %       timepoints, D is the number of features.
    %   r - [N x 1] vector of rewards
    %   param (optional) - parameter structure with the following fields:
    %                       .alpha - learning rate (default: 0.17)
    %                       .g - discount factor (default: 0.9)
    %
    % OUTPUTS:
    %   model - [1 x N] structure with the following fields for each timepoint:
    %           .w - [D x 1] estimated weight vector
    %           .dt - prediction error
    %           .rhat - reward prediction
    %           .V - value estimate
    %
    % Sam Gershman, June 2017
    
    % initialization
    [N,D] = size(X);
    w = zeros(D,1);         % weights
    X = [X; zeros(1,D)];    % add buffer at end
    
    % parameters
    if nargin < 3 || isempty(param); param = struct('alpha',0.17,'g',0.9); end
    alpha = param.alpha;    % learning rate
    g = param.g;            % discount factor
    
    % run Kalman filter
    for n = 1:N
        
        h = X(n,:) - g*X(n+1,:);    % temporal difference features
        V = X(n,:)*w;               % value estimate
        rhat = h*w;                 % reward prediction
        dt = r(n) - rhat;           % prediction error
        w = w + alpha*dt*h';         % weight update
        
        % store results
        model(n) = struct('w',w,'dt',dt,'rhat',rhat,'V',V);
        
    end