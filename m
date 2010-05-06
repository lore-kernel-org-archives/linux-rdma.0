From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCH] mlx4_core: request MSIX vectors as much as there
	CPU	cores
Date: Thu, 6 May 2010 10:49:40 +0300
Message-ID: <20100506074940.GA23576@mtldesk030.lab.mtl.com>
References: <20100505113047.GA12242@mtldesk030.lab.mtl.com>
	<adahbmmpfep.fsf@roland-alpha.cisco.com>
	<20100505163252.GG15969@obsidianresearch.com>
	<4BE1C82F.4000009@mellanox.co.il> <adaaasejfew.fsf@roland-alpha.cisco.com>
	<ada6332jf79.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada6332jf79.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 05, 2010 at 12:55:54PM -0700, Roland Dreier wrote:
>  > We found it in performance work of our EN (10G) driver
> 
> By the way, it would certainly make sense for the ethernet driver to use
> a number of queues that matches num_online_cpus() at the time the
> interface is brought up.  Since we can't change the # of MSI-X vectors
> very easily I think we need to allow for the possible CPUs, but bouncing
> a net interface seems lighter weight to me.
> 
> Although perhaps reloading a driver on CPU hotplug is OK too?
> 

Yes, we have a system where num_possible_cpus is 32 and
num_online_cpus is 16. It's a RH5.4 and the kernel has no problem
allocating 33 MSI-X vectors. The point is that using more than one EQ
per CPU core does not buy us anything; in fact it can contiribute to a
higher rate of interrupts since the same EQ serves less CQs and the
chances for coalescing EQEs are lower.

So what do you think about the following patch to mlx4_en:


diff --git a/drivers/net/mlx4/en_cq.c b/drivers/net/mlx4/en_cq.c
index 21786ad..07c0779 100644
--- a/drivers/net/mlx4/en_cq.c
+++ b/drivers/net/mlx4/en_cq.c
@@ -49,11 +49,12 @@ int mlx4_en_create_cq(struct mlx4_en_priv *priv,
 {
 	struct mlx4_en_dev *mdev = priv->mdev;
 	int err;
+	int num_active_vectors = min_t(int, num_online_cpus(), mdev->dev->caps.num_comp_vectors);
 
 	cq->size = entries;
 	if (mode == RX) {
 		cq->buf_size = cq->size * sizeof(struct mlx4_cqe);
-		cq->vector   = ring % mdev->dev->caps.num_comp_vectors;
+		cq->vector   = ring % num_active_vectors;
 	} else {
 		cq->buf_size = sizeof(struct mlx4_cqe);
 		cq->vector   = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
