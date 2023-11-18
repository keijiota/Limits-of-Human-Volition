function h = lineplot(varargin)

%lineplot  直線のプロット
%
%lineplot(X,'v',...) はカレントのaxesの x=X に、上端から下端まで直線をプロットします
%すなわち、plot([X,X],gca(get,'YLim'),...) と等価です
%...部分には plot に用いるプロパティを入力します
%Xが長さnのベクトルの場合n本の直線をプロットします
%
%lineplot(Y,'h',...) はカレントのaxesの y=Y に、左端から右端まで直線をプロットします
%
%lineplot([X,Y],'c',...) はカレントのaxesに x=X, y=Y となる十字をプロットします
%n個の十字をプロットする場合は X,Y に長さnのベクトルを入力します
%
%lineplot(AX,...) はカレントの代わりにAXにlineplotを行います
%
%h = lineplot は h にハンドルを出力します
%n本の直線をプロットした場合、hはｎ要素からなるベクトルとなります

%--------------------------------------------------------------------------
%Axesの取得
P = 0 ;
if isempty(axescheck(varargin{1})) 
    AX = gca ; value = varargin{1} ; direction = varargin{2} ;
    if nargin >= 3
        p = 3 ;  P = 1 ;
    end
else
    AX = varargin{1} ; value = varargin{2} ; direction = varargin{3} ;
    if nargin >= 4
        p = 4 ;  P = 1 ;
    end
end

%--------------------------------------------------------------------------
%プロパティ値の取得
NextPlot = get(AX,'nextplot') ;
set(AX,'nextplot','add') ;                                 %重ねがき
XLim = get(AX,'XLim') ;
YLim = get(AX,'YLim') ;

switch direction
    case 'v'                                                %縦の直線のプロット
        if min(size(value)) == 1 ;                          %第一引数（ｘ）はベクトルまたはスカラでなければならない
            X = value ;
            for k = 1:length(X) ;
                if P==0
                    h(k) = plot(AX,[X(k),X(k)],YLim) ;               %ｎ本の直線をプロット
                elseif P==1 
                    h(k) = plot(AX,[X(k),X(k)],YLim,varargin{p:end}) ;
                end
            end
            set(AX,'XLim',XLim,'YLim',YLim) ;              %ｘ、ｙ軸のプロット範囲を元に戻す
        else
            disp('directionがvのときvalueはスカラまたはベクトルでなければなりません') ;
            set(AX,'nextplot',NextPlot) ;
            return
        end
    case 'h'                                                %横の直線のプロット
        if min(size(value)) == 1 ;
            Y = value ;
            for k = 1:length(Y) ;
                if P==0
                    h(k) = plot(AX,XLim,[Y(k),Y(k)]) ;
                elseif P==1
                    h(k) = plot(AX,XLim,[Y(k),Y(k)],varargin{p:end}) ;
                end
            end
            set(AX,'XLim',XLim,'YLim',YLim) ;
        else
            disp('directionがhのときvalueはスカラまたはベクトルでなければなりません') ;
            set(AX,'nextplot',NextPlot) ;
            return
        end
    case 'c'                                                %十字のプロット
        if prod(size(value)) == 2
            X = value(1) ;  Y = value(2) ;
            if P==0
                h(k) = plot(AX,XLim,[Y,Y]) ;
                h(k) = plot(AX,[X,X],YLim) ;
            elseif P==1
                h(k) = plot(AX,XLim,[Y,Y],varargin{p:end}) ;
                h(k) = plot(AX,[X,X],YLim,varargin{p:end}) ;
            end
            set(AX,'XLim',XLim,'YLim',YLim) ;
        elseif size(value,2) == 2
            X = value(:,1) ;   Y = value(:,2) ;
            for k = 1:length(X) ;
                if P==0
                    h(k) = plot(AX,XLim,[Y(k),Y(k)]) ;
                    h(k) = plot(AX,[X(k),X(k)],YLim) ;
                elseif P==1
                    h(k) = plot(AX,XLim,[Y(k),Y(k)],varargin{p:end}) ;
                    h(k) = plot(AX,[X(k),X(k)],YLim,varargin{p:end}) ;
                end
                set(AX,'XLim',XLim,'YLim',YLim) ;
            end
            set(AX,'XLim',XLim,'YLim',YLim) ;
        else
            disp('directionがcのときvalueは２要素からなるベクトルもしくは列数が２の配列でなければなりません') ;
            set(AX,'nextplot',NextPlot) ;
            return
        end
    otherwise
        disp('directionは''v'',''h'',''c''のいずれかでなければなりません') ;
        set(AX,'nextplot',NextPlot) ;
        return
end
    
set(AX,'nextplot',NextPlot) ;                               %nextplotプロパティを元に戻す



