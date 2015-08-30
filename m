From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V3
Date: Sun, 30 Aug 2015 20:26:20 +0300
Message-ID: <55E33CBC.3090000@dev.mellanox.co.il>
References: <1440579639-10684-1-git-send-email-hch@lst.de>
 <55E321D7.7000209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E321D7.7000209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/30/2015 6:31 PM, Sagi Grimberg wrote:
>>   - patch 2 now explicitly replaces the weird overloading in the mlx5
>>     driver with an explicit embedding of struct ib_send_wr, similar
>>     to what we do for all other MRs.
>
> That's nice,
>
> There is one non-trivial spot that was missed in mlx5_ib_post_send
> though:
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c
> b/drivers/infiniband/hw/mlx5/qp.c
> index 7ddfb74..35a18d6 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2802,7 +2802,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
> ib_send_wr *wr,
>                                  goto out;
>                          }
>                          qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
> -                       ctrl->imm = cpu_to_be32(fast_reg_wr(wr)->rkey);
> +                       ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
>                          set_reg_umr_segment(seg, wr);
>                          seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
>                          size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
>
> Care to fold this in?
>

There is another problem I'm seeing in this patch. in reg_umr the
local variable is a type ib_send_wr which is passed to
prep_umr_reg_wqe() which casts it to mlx5_umr_wr (container_of). It
should have probably been mlx5_umr_wr to begin with...

I think this needs to be folded in as well:
diff --git a/drivers/infiniband/hw/mlx5/mr.c 
b/drivers/infiniband/hw/mlx5/mr.c
index 9fac2c1..6f8f3d8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -752,7 +752,8 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, 
struct ib_umem *umem,
         struct device *ddev = dev->ib_dev.dma_device;
         struct umr_common *umrc = &dev->umrc;
         struct mlx5_ib_umr_context umr_context;
-       struct ib_send_wr wr, *bad;
+       struct mlx5_umr_wr umrwr;
+       struct ib_send_wr *bad;
         struct mlx5_ib_mr *mr;
         struct ib_sge sg;
         int size;
@@ -798,14 +799,14 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd 
*pd, struct ib_umem *umem,
                 goto free_pas;
         }

-       memset(&wr, 0, sizeof(wr));
-       wr.wr_id = (u64)(unsigned long)&umr_context;
-       prep_umr_reg_wqe(pd, &wr, &sg, dma, npages, mr->mmr.key, page_shift,
-                        virt_addr, len, access_flags);
+       memset(&umrwr, 0, sizeof(umrwr));
+       umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
+       prep_umr_reg_wqe(pd, &umrwr.wr, &sg, dma, npages, mr->mmr.key,
+                        page_shift, virt_addr, len, access_flags);

         mlx5_ib_init_umr_context(&umr_context);
         down(&umrc->sem);
-       err = ib_post_send(umrc->qp, &wr, &bad);
+       err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
         if (err) {
                 mlx5_ib_warn(dev, "post send failed, err %d\n", err);
                 goto unmap_dma;
@@ -1134,16 +1135,17 @@ static int unreg_umr(struct mlx5_ib_dev *dev, 
struct mlx5_ib_mr *mr)
  {
         struct umr_common *umrc = &dev->umrc;
         struct mlx5_ib_umr_context umr_context;
-       struct ib_send_wr wr, *bad;
+       struct mlx5_umr_wr umrwr;
+       struct ib_send_wr *bad;
         int err;

-       memset(&wr, 0, sizeof(wr));
-       wr.wr_id = (u64)(unsigned long)&umr_context;
-       prep_umr_unreg_wqe(dev, &wr, mr->mmr.key);
+       memset(&umrwr, 0, sizeof(umrwr));
+       umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
+       prep_umr_unreg_wqe(dev, &umrwr.wr, mr->mmr.key);

         mlx5_ib_init_umr_context(&umr_context);
         down(&umrc->sem);
-       err = ib_post_send(umrc->qp, &wr, &bad);
+       err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
         if (err) {
                 up(&umrc->sem);
                 mlx5_ib_dbg(dev, "err %d\n", err);
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
