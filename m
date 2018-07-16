From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 16 Jul 2018 19:46:05 +0300
Message-ID: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/16/2018 5:59 PM, Sagi Grimberg wrote:
> 
>> Hi,
>> I've tested this patch and seems problematic at this moment.
> 
> Problematic how? what are you seeing?

Connection failures and same error Steve saw:

[Mon Jul 16 16:19:11 2018] nvme nvme0: Connect command failed, error 
wo/DNR bit: -16402
[Mon Jul 16 16:19:11 2018] nvme nvme0: failed to connect queue: 2 ret=-18


> 
>> maybe this is because of the bug that Steve mentioned in the NVMe 
>> mailing list. Sagi mentioned that we should fix it in the NVMe/RDMA 
>> initiator and I'll run his suggestion as well.
> 
> Is your device irq affinity linear?

When it's linear and the balancer is stopped the patch works.

> 
>> BTW, when I run the blk_mq_map_queues it works for every irq affinity.
> 
> But its probably not aligned to the device vector affinity.

but I guess it's better in some cases.

I've checked the situation before Leon's patch and set all the vetcors 
to CPU 0. In this case (I think that this was the initial report by 
Steve), we use the affinity_hint (Israel's and Saeed's patches were we 
use dev->priv.irq_info[vector].mask) and it worked fine.

Steve,
Can you share your configuration (kernel, HCA, affinity map, connect 
command, lscpu) ?
I want to repro it in my lab.

-Max.
