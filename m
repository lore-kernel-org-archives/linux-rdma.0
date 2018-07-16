From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 16 Jul 2018 12:08:25 -0500
Message-ID: <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
 <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hey Max:


On 7/16/2018 11:46 AM, Max Gurtovoy wrote:
>
>
> On 7/16/2018 5:59 PM, Sagi Grimberg wrote:
>>
>>> Hi,
>>> I've tested this patch and seems problematic at this moment.
>>
>> Problematic how? what are you seeing?
>
> Connection failures and same error Steve saw:
>
> [Mon Jul 16 16:19:11 2018] nvme nvme0: Connect command failed, error
> wo/DNR bit: -16402
> [Mon Jul 16 16:19:11 2018] nvme nvme0: failed to connect queue: 2 ret=-18
>
>
>>
>>> maybe this is because of the bug that Steve mentioned in the NVMe
>>> mailing list. Sagi mentioned that we should fix it in the NVMe/RDMA
>>> initiator and I'll run his suggestion as well.
>>
>> Is your device irq affinity linear?
>
> When it's linear and the balancer is stopped the patch works.
>
>>
>>> BTW, when I run the blk_mq_map_queues it works for every irq affinity.
>>
>> But its probably not aligned to the device vector affinity.
>
> but I guess it's better in some cases.
>
> I've checked the situation before Leon's patch and set all the vetcors
> to CPU 0. In this case (I think that this was the initial report by
> Steve), we use the affinity_hint (Israel's and Saeed's patches were we
> use dev->priv.irq_info[vector].mask) and it worked fine.
>
> Steve,
> Can you share your configuration (kernel, HCA, affinity map, connect
> command, lscpu) ?
> I want to repro it in my lab.
>

- linux-4.18-rc1 + the nvme/nvmet inline_data_size patches + patches to
enable ib_get_vector_affinity() in cxgb4 + sagi's patch + leon's mlx5
patch so I can change the affinity via procfs. 

- mlx5 MT27700 RoCE card, cxgb4 T62100-CR iWARP card

- The system has 2 numa nodes with 8 real cpus in each == 16 cpus all
online.  HT disabled.

- i'm testing over HW loopback for simplicity, so the node is both the
nvme target and host.  Connecting one device like this: nvme connect -t
rdma -a 172.16.2.1 -n nvme-nullb0

- to reproduce the nvme-rdma bug, just map any two hca cq comp vectors
to the same cpu. 

- lscpu output:

[root@stevo1 linux]# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                16
On-line CPU(s) list:   0-15
Thread(s) per core:    1
Core(s) per socket:    8
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 45
Model name:            Intel(R) Xeon(R) CPU E5-2687W 0 @ 3.10GHz
Stepping:              7
CPU MHz:               3400.057
CPU max MHz:           3800.0000
CPU min MHz:           1200.0000
BogoMIPS:              6200.10
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              20480K
NUMA node0 CPU(s):     0-7
NUMA node1 CPU(s):     8-15
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2
x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm epb pti
tpr_shadow vnmi flexpriority ept vpid xsaveopt dtherm ida arat pln pts

Steve
