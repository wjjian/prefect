clear all;
%设置数据格式
format long;
%设置粒子群算法参数
max_iteration=1000;         %最大迭代次数
swarm_size=200;             %种群规模（粒子数量）
particle_size=2;            %粒子维数（求解变量个数）
particle_min=[-100,-100];   %粒子各维最小值
particle_max=[100,100];     %粒子各维最大值
velocity_min=0;             %粒子速度最小值
velocity_max=1;             %粒子速度最大值
c1=1.3;                     %学习因子C1
c2=1.3;                     %学习因子C2
w=1.2;                      %惯性权重
%初始化粒子群算法变量
fitness_size=particle_size+1;                                       %位置及适应度结合矩阵维数
particle=zeros(swarm_size,fitness_size,max_iteration);              %粒子群位置及适应度矩阵
velocity=zeros(swarm_size,particle_size,max_iteration);             %粒子群速度矩阵
pbest=zeros(swarm_size,fitness_size,max_iteration);                 %局部最优粒子位置及适应度矩阵
gbest=zeros(1,fitness_size,max_iteration);                          %全局最优粒子位置及适应度矩阵
 
%初始化粒子群
%初始化迭代数
z=1;
%%%%%%%%初始化粒子群的位置，速度和适应度
for x=1:swarm_size
    for y=1:particle_size
        particle(x,y,z)=(particle_min(y)+(particle_max(y)-particle_min(y))*rand);
        velocity(x,y,(z+1))=rand;
        %粒子位置更新函数UpdateP( particle,velocity,index,dimen,iter,particle_min,particle_max )
        particle(x,y,(z+1))=UpdateP(particle,velocity,x,y,z,particle_min,particle_max);         
    end
    %适应度函数Fitness( particle,index,iter )
    particle(x,fitness_size,z)=Fitness(particle,x,z);
end
%%%%%%%%初始化局部最优粒子的位置和适应度
pbest(:,:,z)=particle(:,:,z);
%%%%%%%%初始化全局最优粒子的位置和适应度
gbest(1,:,z)=pbest(1,:,z);  
for x=1:swarm_size
    if pbest(x,fitness_size,z)<gbest(1,fitness_size,z)
       gbest(1,:,z)=pbest(x,:,z);    
    end
end
 
%%%%迭代
for z=2:max_iteration
%评价粒子
    for x=1:swarm_size   
        %适应度函数Fitness( particle,index,iter )  
        particle(x,fitness_size,z)=Fitness(particle,x,z); 
        if particle(x,fitness_size,z)<pbest(x,fitness_size,(z-1))
           pbest(x,:,z)=parti 节目cle(x,:,z);
        else
           pbest(x,:,z)=pbest(x,:,(z-1));
        end   
    end
    for x=1:swarm_size
        if pbest(x,fitness_size,z)<gbest(1,fitness_size,(z-1))
           gbest(1,:,z)=pbest(x,:,z); 
        else
           gbest(1,:,z)=gbest(1,:,(z-1));
        end
    end
%更新粒子
    for x=1:swarm_size
        for y=1:particle_size
            %粒子速度更新函数
%UpdateV( particle,velocity,pbest,gbest,index,dimen,iter,velocity_min,velocity_max,c1,c2 )
            velocity(x,y,(z+1))=UpdateV(particle,velocity,pbest,gbest,x,y,z,velocity_min,velocity_max,c1,c2,w);
            %粒子位置更新函数UpdateP( particle,velocity,index,dimen,iter,particle_min,particle_max )
            particle(x,y,(z+1))=UpdateP(particle,velocity,x,y,z,particle_min,particle_max);         
        end
    end
end
%%%%数据处理
DataManage(particle,velocity,pbest,gbest,max_iteration,swarm_size,particle_size,fitness_size);
