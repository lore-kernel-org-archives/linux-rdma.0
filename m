From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Fri, 12 Jan 2018 11:53:22 -0800
Message-ID: <85116e56-52b1-944d-6ee2-916ccfc3a7a6@mellanox.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515775567.131759.42.camel@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: tariqt@mellanox.com, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 01/12/2018 08:46 AM, Eric Dumazet wrote:
> On Fri, 2018-01-12 at 09:32 -0700, Jason Gunthorpe wrote:
>> On Fri, Jan 12, 2018 at 11:42:22AM +0800, Jianchao Wang wrote:
>>> Customer reported memory corruption issue on previous mlx4_en driver
>>> version where the order-3 pages and multiple page reference counting
>>> were still used.
>>>
>>> Finally, find out one of the root causes is that the HW may see stale
>>> rx_descs due to prod db updating reaches HW before rx_desc. Especially
>>> when cross order-3 pages boundary and update a new one, HW may write
>>> on the pages which may has been freed and allocated again by others.
>>>
>>> To fix it, add a wmb between rx_desc and prod db updating to ensure
>>> the order. Even thougth order-0 and page recycling has been introduced,
>>> the disorder between rx_desc and prod db still could lead to corruption
>>> on different inbound packages.
>>>
>>> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
>>>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>>> index 85e28ef..eefa82c 100644
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>>> @@ -555,7 +555,7 @@ static void mlx4_en_refill_rx_buffers(struct mlx4_en_priv *priv,
>>>   			break;
>>>   		ring->prod++;
>>>   	} while (likely(--missing));
>>> -
>>> +	wmb(); /* ensure rx_desc updating reaches HW before prod db updating */
>>>   	mlx4_en_update_rx_prod_db(ring);
>>>   }
>>>   
>>
>> Does this need to be dma_wmb(), and should it be in
>> mlx4_en_update_rx_prod_db ?
>>
> 
> +1 on dma_wmb()
> 
> On what architecture bug was observed ?
> 
> In any case, the barrier should be moved in mlx4_en_update_rx_prod_db()
> I think.
> 

+1 on dma_wmb(), thanks Eric for reviewing this.

The barrier is also needed elsewhere in the code as well, but I wouldn't 
put it in mlx4_en_update_rx_prod_db(), just to allow batch filling of 
all rx rings and then hit the barrier only once. As a rule of thumb, mem 
barriers are the ring API caller responsibility.

e.g. in mlx4_en_activate_rx_rings():
between mlx4_en_fill_rx_buffers(priv); and the loop that updates rx prod 
for all rings ring, the dma_wmb is needed, see below.

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c 
b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index b4d144e67514..65541721a240 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -370,6 +370,8 @@ int mlx4_en_activate_rx_rings(struct mlx4_en_priv *priv)
         if (err)
                 goto err_buffers;

+       dma_wmb();
+
         for (ring_ind = 0; ring_ind < priv->rx_ring_num; ring_ind++) {
                 ring = priv->rx_ring[ring_ind];
