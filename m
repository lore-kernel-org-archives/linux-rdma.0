From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V3
Date: Sun, 30 Aug 2015 18:31:35 +0300
Message-ID: <55E321D7.7000209@dev.mellanox.co.il>
References: <1440579639-10684-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440579639-10684-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>   - patch 2 now explicitly replaces the weird overloading in the mlx5
>     driver with an explicit embedding of struct ib_send_wr, similar
>     to what we do for all other MRs.

That's nice,

There is one non-trivial spot that was missed in mlx5_ib_post_send
though:

diff --git a/drivers/infiniband/hw/mlx5/qp.c 
b/drivers/infiniband/hw/mlx5/qp.c
index 7ddfb74..35a18d6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2802,7 +2802,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct 
ib_send_wr *wr,
                                 goto out;
                         }
                         qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
-                       ctrl->imm = cpu_to_be32(fast_reg_wr(wr)->rkey);
+                       ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
                         set_reg_umr_segment(seg, wr);
                         seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
                         size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;

Care to fold this in?

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
