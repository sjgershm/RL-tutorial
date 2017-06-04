function model = KTD(X,r,param)
    
    % Kalman temporal difference learning model
    %
    % USAGE: model = KTD(X,r,[param])
    %
    % INPUTS:
    %   X - [N x D] matrix of stimulus features, where N is the number of
    %       timepoints, D is the number of features.
    %   r - [N x 1] vector of rewards
    %   param (optional) - parameter structure with the following fields:
    %                       .c - prior variance (default: 1)
    %                       .s - observation noise variance (default: 1)
    %                       .q - transition noise variance (default: 0.01)
    %                       .g - discount factor (default: 0.9)
    %
    % OUTPUTS:
    %   model - [1 x N] structure with the following fields for each timepoint:
    %           .w - [D x 1] posterior mean weight vector
    %           .C - [D x D] posterior weight covariance
    %           .K - [D x 1] Kalman gain (learning rates for each dimension)
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
    if nargin < 3 || isempty(param); param = struct('c',1,'s',1,'q',0.005,'g',0.9); end
    C = param.c*eye(D); % prior variance
    s = param.s;        % observation noise variance
    Q = param.q*eye(D); % transition noise variance
    g = param.g;        % discount factor
    
    % run Kalman filter
    for n = 1:N
        
        h = X(n,:) - g*X(n+1,:);    % temporal difference features
        V = X(n,:)*w;               % value estimate
        rhat = h*w;                 % reward prediction
        dt = r(n) - rhat;           % prediction error
        C = C + Q;                  % a priori covariance
        P = h*C*h'+s;               % residual covariance
        K = C*h'/P;                 % Kalman gain
        w = w + K*dt;               % weight update
        C = C - K*h*C;              % posterior covariance update
        
        % store results
        model(n) = struct('w',w,'C',C,'K',K,'dt',dt,'rhat',rhat,'V',V);
        
    end