# Harmonycloud Minio
MinIO 是一个基于Apache License v2.0开源协议的对象存储服务。它兼容亚马逊S3云存储服务接口，非常适合于存储大容量非结构化的数据。

注意
1. 分布式Minio至少需要4个硬盘，使用分布式Minio自动引入了纠删码功能

2. 建议运行分布式MinIO设置的所有节点都是同构的，即相同的操作系统，相同数量的磁盘和相同的网络互连。

3. MinIO 可创建每组4到16个磁盘组成的纠删码集合。所以你提供的磁盘总数必须是其中一个数字的倍数。例如只有一个节点时最少需要4快硬盘，两个节点时，每个节点最少两个硬盘。

4. 每个对象被写入一个EC集合中，因此该对象分布在不超过16个磁盘上。

5. Minio采用Reed-solomon codes将对象分片为数据和奇偶校验块。默认情况下, MinIO 将对象拆分成N/2数据和N/2 奇偶校验盘. 虽然可以通过 存储类型 自定义配置, 但是我们还是推荐N/2个数据和奇偶校验块, 因为它可以确保对硬盘故障提供最佳保护。通过默认配置运行MinIO服务的话,集群可以丢失任意N/2块盘（不管其是存放的数据块还是奇偶校验块），集群仍可以从剩下的盘中的数据进行恢复。
例如一个有 m 台服务器， 每个服务器上n 块硬盘的分布式Minio,只要有 m/2 台服务器或者 m*n/2 及更多硬盘在线，你的数据就是安全的此时数据可读不可写，大于m/2+1台服务器或 (m*n/2)+1快硬盘在线才可以写。

6. 存储空间利用率与集群内数据盘个数和校验盘个数有关，默认情况下文件空间使用量约为两倍， 即100M文件将占用200M空间。可以使用公式: 盘总个数 (N)/数据盘个数 (D)来计算大概的空间使用率，详细参考：https://github.com/minio/minio/tree/master/docs/zh_CN/erasure/storage-class

7. 分布式Minio里的节点时间差不能超过15分钟

# 快速入门
## 部署Minio
参照: charts/minio/README.md
