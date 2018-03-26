clear all;
%�������ݸ�ʽ
format long;
%��������Ⱥ�㷨����
max_iteration=1000;         %����������
swarm_size=200;             %��Ⱥ��ģ������������
particle_size=2;            %����ά����������������
particle_min=[-100,-100];   %���Ӹ�ά��Сֵ
particle_max=[100,100];     %���Ӹ�ά���ֵ
velocity_min=0;             %�����ٶ���Сֵ
velocity_max=1;             %�����ٶ����ֵ
c1=1.3;                     %ѧϰ����C1
c2=1.3;                     %ѧϰ����C2
w=1.2;                      %����Ȩ��
%��ʼ������Ⱥ�㷨����
fitness_size=particle_size+1;                                       %λ�ü���Ӧ�Ƚ�Ͼ���ά��
particle=zeros(swarm_size,fitness_size,max_iteration);              %����Ⱥλ�ü���Ӧ�Ⱦ���
velocity=zeros(swarm_size,particle_size,max_iteration);             %����Ⱥ�ٶȾ���
pbest=zeros(swarm_size,fitness_size,max_iteration);                 %�ֲ���������λ�ü���Ӧ�Ⱦ���
gbest=zeros(1,fitness_size,max_iteration);                          %ȫ����������λ�ü���Ӧ�Ⱦ���
 
%��ʼ������Ⱥ
%��ʼ��������
z=1;
%%%%%%%%��ʼ������Ⱥ��λ�ã��ٶȺ���Ӧ��
for x=1:swarm_size
    for y=1:particle_size
        particle(x,y,z)=(particle_min(y)+(particle_max(y)-particle_min(y))*rand);
        velocity(x,y,(z+1))=rand;
        %����λ�ø��º���UpdateP( particle,velocity,index,dimen,iter,particle_min,particle_max )
        particle(x,y,(z+1))=UpdateP(particle,velocity,x,y,z,particle_min,particle_max);         
    end
    %��Ӧ�Ⱥ���Fitness( particle,index,iter )
    particle(x,fitness_size,z)=Fitness(particle,x,z);
end
%%%%%%%%��ʼ���ֲ��������ӵ�λ�ú���Ӧ��
pbest(:,:,z)=particle(:,:,z);
%%%%%%%%��ʼ��ȫ���������ӵ�λ�ú���Ӧ��
gbest(1,:,z)=pbest(1,:,z);  
for x=1:swarm_size
    if pbest(x,fitness_size,z)<gbest(1,fitness_size,z)
       gbest(1,:,z)=pbest(x,:,z);    
    end
end
 
%%%%����
for z=2:max_iteration
%��������
    for x=1:swarm_size   
        %��Ӧ�Ⱥ���Fitness( particle,index,iter )  
        particle(x,fitness_size,z)=Fitness(particle,x,z); 
        if particle(x,fitness_size,z)<pbest(x,fitness_size,(z-1))
           pbest(x,:,z)=parti ��Ŀcle(x,:,z);
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
%��������
    for x=1:swarm_size
        for y=1:particle_size
            %�����ٶȸ��º���
%UpdateV( particle,velocity,pbest,gbest,index,dimen,iter,velocity_min,velocity_max,c1,c2 )
            velocity(x,y,(z+1))=UpdateV(particle,velocity,pbest,gbest,x,y,z,velocity_min,velocity_max,c1,c2,w);
            %����λ�ø��º���UpdateP( particle,velocity,index,dimen,iter,particle_min,particle_max )
            particle(x,y,(z+1))=UpdateP(particle,velocity,x,y,z,particle_min,particle_max);         
        end
    end
end
%%%%���ݴ���
DataManage(particle,velocity,pbest,gbest,max_iteration,swarm_size,particle_size,fitness_size);
