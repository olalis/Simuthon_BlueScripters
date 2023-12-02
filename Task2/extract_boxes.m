% Function extracts bounding boxesb from delivered data structure
function result = extract_boxes(data)
    len = length(data);
    for i = 1:len
            extracted_size{i} = data(i).BoundingBox;
    end
    
    result = reshape(extracted_size, len, 1);
end
