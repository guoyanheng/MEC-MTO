function Span_index = Span(pos_fit)
n_obj = size(pos_fit,2);

max_fit = max(pos_fit,[],1);
min_fit = min(pos_fit,[],1);
d_fit = [];
for i = 1:size(pos_fit,2)
    d_fit = [d_fit max_fit(i)/max_fit(i)-min_fit(i)/max_fit(i)];
end
Span_index = 0;
Span_index = sqrt(sum(d_fit.^2));
end