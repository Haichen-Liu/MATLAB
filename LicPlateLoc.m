function plate_image = LicPlateLoc(car_image)

% ����������ʵ�ֳ��ƶ�λ �����͸�ӽ�����ĳ���
% ����λʧ�ܣ��򷵻� -1
% �ȶ�����ͼ�񰴽Ͽ��ɵĲ������ж�λ��
% ���û�ҵ����ƣ������ϸ�Ĳ����ٴζ�λ

%% ������ͼ��
I = car_image;
[a, b, ~] = size(I);

%% ���� point4 ���������ѡ�����������Ӿ��ε��ĸ���������
% lie �� 3*4 �ľ��� ÿ�д���һ����ѡ������ĸ������������
% hang ��3*4 �ľ���ÿ�д���һ����ѡ������ĸ������������
point4 = struct('lie',zeros(3,4),'hang',zeros(3,4),'top',0);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��һ�ζ�λ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ԥ����
H = rgb2hsi(I);     % HSI �ռ��ͼ��
minH = 170/360;     % H ��������Сֵ
maxH = 245/360;     % H ���������ֵ
threshS = 0.2;      % S ��������Сֵ
bw = findblue(H, minH, maxH,threshS);
bw = medfilt2(bw, [5, 5]); % �Զ�ֵͼbw������ֵ�˲�

%% Ѱ����ɫ��ͨ��
[L,number] = bwlabel(bw); 
total = number;     % ��ͨ���ܸ�����0�����㣩

%% ��ͨ��ɸѡ �� ɸѡ����ѡ��������
for i3 = 1 : number
    [r, c] = find(L == i3);
    x = length(r);
    a1 = min(r);
    a2 = max(r);
    b1 = min(c);
    b2 = max(c);
    
    % 1��ɾ���ڱ�Ե����ͨ�� 
    if a1 < a/20 || a2 > a - a/20
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    if b1 < b/20 || b2 > b - b/20
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    
    % 2 ��ɾ�����̫�����̫С����ͨ��
    if x < a*b/400 || x > a*b/10
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    
    % 3������ͨ������С�����Σ���ɾ��������Ҫ�����ͨ��
    minbox = minBoundingBox([c'; r']); % ��С��Ӿ��ε��ĸ�����
    [phibox, Lbox, Hbox] = BoxFeature(minbox); % ��Ӿ��ε�����
    if phibox > 1 || Lbox < 2.68*Hbox || Lbox > 5*Hbox %��Ӿ��ε���б�ǶȺͳ����������������
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    if x < 0.5*Lbox*Hbox %��Ӿ����� ��ͨ�����̫С
        L = clean(L, r, c);
        total = total - 1;
        continue
    end
    
    % ����Ӿ��ε��ĸ�������� point4
    point4.top = point4.top + 1;
    point4.lie(point4.top, :) = minbox(1, :);
    point4.hang(point4.top, :) = minbox(2, :);
end

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% �ڶ��ζ�λ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if point4.top == 0
    % Ԥ����
    H = rgb2hsi(I);     % HSI �ռ��ͼ��
    minH = 210/360;     % H ��������Сֵ
    maxH = 245/360;     % H ���������ֵ
    threshS = 0.4;      % S ��������Сֵ

    bw = findblue(H, minH, maxH,threshS);
    bw = medfilt2(bw, [5, 5]); % �Զ�ֵͼbw������ֵ�˲�
    
    %% Ѱ����ɫ��ͨ��
    [L,number] = bwlabel(bw);
    total = number;     % ��ͨ���ܸ�����0�����㣩
    
    %% ��ͨ��ɸѡ �� ɸѡ����ѡ��������
    for i3 = 1 : number
        [r, c] = find(L == i3);
        x = length(r);
        a1 = min(r);
        a2 = max(r);
        b1 = min(c);
        b2 = max(c);
        
        % 1��ɾ���ڱ�Ե����ͨ��
        if a1 < a/20 || a2 > a - a/20
            L = clean(L, r, c);
            total = total - 1;
            continue
        end
        if b1 < b/20 || b2 > b - b/20
            L = clean(L, r, c);
            total = total - 1;
            continue
        end
        
        % 2 ��ɾ�����̫�����̫С����ͨ��
        if x < a*b/400 || x > a*b/10
            L = clean(L, r, c);
            total = total - 1;
            continue
        end
        
        % 3������ͨ������С�����Σ���ɾ��������Ҫ�����ͨ��
        minbox = minBoundingBox([c'; r']); % ��С��Ӿ��ε��ĸ�����
        [phibox, Lbox, Hbox] = BoxFeature(minbox); % ��Ӿ��ε�����
        if phibox > 1 || Lbox < 2.68*Hbox || Lbox > 5*Hbox %��Ӿ��ε���б�ǶȺͳ����������������
            L = clean(L, r, c);
            total = total - 1;
            continue
        end
        if x < 0.5*Lbox*Hbox %��Ӿ����� ��ͨ�����̫С
            L = clean(L, r, c);
            total = total - 1;
            continue
        end
        
        % ����Ӿ��ε��ĸ�������� point4
        point4.top = point4.top + 1;
        point4.lie(point4.top, :) = minbox(1, :);
        point4.hang(point4.top, :) = minbox(2, :);
    end
end

%% �Դ�ѡ����������жϣ������жϽ����͸�ӻ������
if point4.top > 1
    temp = zeros(1, point4.top);
    for index = 1 : point4.top
        xx1 = round(point4.lie(index,:));
        yy1 = round(point4.hang(index,:));
        x0 = sum(xx1)/4;
        y0 = sum(yy1)/4;
        temp(1,index) = sqrt((x0-b/2)^2 + (y0 - a/2)^2);
    end
    tem = find(temp == min(temp));
    point4.lie(1,:) = point4.lie(tem,:);
    point4.hang(1,:) = point4.hang(tem,:);
    point4.top = 1;
end

%͸�ӻ������
if total > 0
    xx = round(point4.lie(1, :)); % ����������С��Ӿ��ε��ĸ���������
    yy = round(point4.hang(1, :)); % ����������С��Ӿ��ε��ĸ���������
    b1 = min(xx);
    b2 = max(xx);
    a1 = min(yy);
    a2 = max(yy);
    Ig = L(a1:a2, b1:b2); % ��ͨͼ�еĳ�������
    bwIg = bw(a1:a2, b1:b2); % ��ֵͼ�еĳ������� 
    
    %���ҳ��Ƶ��ĸ����� ��45�ȵ�б��
    
    % ���ϣ�
    target = 0;
    for i = 1 : a2-a1+1
        temp_sum = i+1;
        for j = 1:i
            k = temp_sum - j;
            if Ig(j,k) > 0
                p1 = [k,j]; % [��, ��]
                target = 1;
                break
            end
        end
        if target ==1
            break
        end
    end
    
    % ���ϣ�
    target = 0;
    for i = 1:a2-a1+1
        temp_sum = i+1;
        for j = 1:i
            k = temp_sum - j;
            k = b2 - b1 + 2 - k;
            if Ig(j,k) > 0
                p2 = [k,j]; % [��, ��]
                target = 1;
                break
            end
        end
        if target ==1
            break
        end
    end
    
    % ���£�
    target = 0;
    for i = 1:a2-a1+1
        temp_sum = i+1;
        for j = 1:i
            j1 = a2-a1+2 - j;
            k = temp_sum - j;
            if Ig(j1,k) > 0
                p3 = [k,j1]; % [��, ��]
                target = 1;
                break
            end
        end
        if target ==1
            break
        end
    end
    
    % ���£�
    target = 0;
    for i = 1:a2-a1+1
        temp_sum = i+1;
        for j = 1:i
            k = temp_sum - j;
            k = b2 - b1 + 2 - k;
            j1 = a2-a1+2 - j;
            if Ig(j1,k) > 0
                p4 = [k,j1]; % [��, ��]
                target = 1;
                break
            end
        end
        if target ==1
            break
        end
    end
    
    PP = [p1; p2; p3; p4]; %�ĸ����㣬����Ϊ�� ���� ���� ���� ����
    plate_image = adjust(bwIg, PP); % ͸�ӻ������
    
else
    plate_image = -1;
end

end