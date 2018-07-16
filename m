From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 16 Jul 2018 17:54:13 +0300
Message-ID: <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716103046.GJ3152@mtr-leonro.mtl.com>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
I've tested this patch and seems problematic at this moment.
maybe this is because of the bug that Steve mentioned in the NVMe 
mailing list. Sagi mentioned that we should fix it in the NVMe/RDMA 
initiator and I'll run his suggestion as well.
BTW, when I run the blk_mq_map_queues it works for every irq affinity.

On 7/16/2018 1:30 PM, Leon Romanovsky wrote:
> On Mon, Jul 16, 2018 at 01:23:24PM +0300, Sagi Grimberg wrote:
>> Leon, I'd like to see a tested-by tag for this (at least
>> until I get some time to test it).
> 
> Of course.
> 
> Thanks
> 
>>
>> The patch itself looks fine to me.


-Max.
