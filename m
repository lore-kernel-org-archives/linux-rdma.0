From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Convert UMR CQ to new CQ API
Date: Fri, 4 Mar 2016 17:54:26 +0100
Message-ID: <20160304165426.GA29122@lst.de>
References: <1456565984-28998-1-git-send-email-hch@lst.de> <1456565984-28998-2-git-send-email-hch@lst.de> <56D2D731.5060904@dev.mellanox.co.il> <56D3F1EA.9090800@mellanox.com> <20160303083822.GB13828@lst.de> <56D7FE93.9020503@dev.mellanox.co.il> <56D865AF.5000507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D865AF.5000507-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 03, 2016 at 11:26:23AM -0500, Doug Ledford wrote:
> I took the later version of the patch, but I had to fix it up due to
> conflicts with both the rereg_me patchset and the mmkey cleanup
> patchset.  Please double check this in the mlx5 branch of my github repo
> to make sure it's all good.

Looks like we'll need the one liner below to get the manually applied patch
to compile, but otherwise it looks fine to me.


diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index f1464b8..4d5bff1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1201,7 +1201,7 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 
 	mlx5_ib_init_umr_context(&umr_context);
 
-	umrwr.wr.wr_cqe = &umr_context.cqe
+	umrwr.wr.wr_cqe = &umr_context.cqe;
 	prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmkey.key);
 
 	down(&umrc->sem);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
