From: Aaron Knister <aaron.s.knister-NSQ8wuThN14@public.gmane.org>
Subject: Re: sriov dmar errors
Date: Wed, 10 Jan 2018 22:32:11 -0500
Message-ID: <158a35ac-8e04-8495-3d50-7eecb3c7066b@nasa.gov>
References: <7f4de804-9095-9c62-719e-1d5d90ce518b@nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7f4de804-9095-9c62-719e-1d5d90ce518b-NSQ8wuThN14@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Interesting, after making this change ontop of commit 4be90bc the card
comes up:

diff --git a/drivers/infiniband/hw/mlx4/main.c
b/drivers/infiniband/hw/mlx4/main.c
index 1437ed5..820b481 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -423,8 +423,8 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
            (dev->dev->rev_id != MLX4_IB_CARD_REV_A0) &&
            (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_BLH))
                props->device_cap_flags |= IB_DEVICE_UD_TSO;
-       if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
-               props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
+       //if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
+       //      props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
        if ((dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_LOCAL_INV) &&
            (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_REMOTE_INV) &&
            (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_FAST_REG_WR))

There are ConnectX2 cards in the particular system I'm working on and
even without this change the ConnectX3 cards work just fine so perhaps
this is ultimately a firmware issue with the CX2 cards (which, I know,
are old, but when you have 1200 of them...) interacting with whatever
the "local dma lkey" feature is.

Still, any thoughts would be great.

-Aaron

On 1/10/18 9:52 PM, Aaron Knister wrote:
> It looks like commit 4be90bc (IB/mad: Remove ib_get_dma_mr calls
> ) broke SR-IOV usage with some of our older Mellanox IB cards. After
> loading the mlx4_core module with some number of vfs specified (e.g.
> modprobe mlx4_core num_vfs=16) the following errors appear and the
> port's state never changes from INIT to ACTIVE:
> 
> [ 1946.325804] DMAR: DRHD: handling fault status reg 302
> [ 1946.331442] DMAR: DMAR:[DMA Write] Request device [16:06.1] fault
> addr fcb6e000
> DMAR:[fault reason 02] Present bit in context entry is clear
> [ 1946.525788] DMAR: DRHD: handling fault status reg 402
> [ 1946.531416] DMAR: DMAR:[DMA Write] Request device [16:06.1] fault
> addr fcb6d000
> DMAR:[fault reason 02] Present bit in context entry is clear
> 
> If I revert to the parent commit (96249d7) the HCA and virtual functions
> all initialize as expected.
> 
> I'm not sure where to turn next to debug the issue further. Any tips?
> 

-- 
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
