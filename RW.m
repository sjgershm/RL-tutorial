function model = RW(X,r,param)
    
    % Rescorla-Wagner model
    %
    % USAGE: model = RW(X,r,[param])
    %
    % INPUTS:
    %   X - [N x D] matrix of stimulus features, where N is the number of
    %       timepoints, D is the number of features.
    %   r - [N x 1] vector of rewards
    %   param (optional) - parameter structure with the following fields:
    %                       .alpha - learning rate (default: 0.3)
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
    
    % parameters
    if nargin < 3 || isempty(param); param = struct('alpha',0.3); end
    alpha = param.alpha;    % learning rate
    
    % run Kalman filter
    for n = 1:N
        
        rhat = X(n,:)*w;            % reward prediction
        dt = r(n) - rhat;           % prediction error
        w = w + alpha*dt*X(n,:)';   % weight update
        
        % store results
        model(n) = struct('w',w,'dt',dt,'rhat',rhat);
        
    end