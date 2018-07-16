From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 16 Jul 2018 17:59:05 +0300
Message-ID: <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Hi,
> I've tested this patch and seems problematic at this moment.

Problematic how? what are you seeing?

> maybe this is because of the bug that Steve mentioned in the NVMe 
> mailing list. Sagi mentioned that we should fix it in the NVMe/RDMA 
> initiator and I'll run his suggestion as well.

Is your device irq affinity linear?

> BTW, when I run the blk_mq_map_queues it works for every irq affinity.

But its probably not aligned to the device vector affinity.
