From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 10/29] net/mlx4_core: Implement mechanism for
 reserved qkeys
Date: Fri, 6 Jul 2012 05:51:35 +0300
Message-ID: <CAJZOPZJ4YWzpzUv6KrhGFF+AGMttf88nT+STFHdUbveQVmdobg@mail.gmail.com>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
	<1340094121-14858-11-git-send-email-jackm@dev.mellanox.co.il>
	<CAL1RGDVXTWs6Xi2JQ=7-RiZUePfc6SoUsCHHdbS9XLUQyim6UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVXTWs6Xi2JQ=7-RiZUePfc6SoUsCHHdbS9XLUQyim6UA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 6, 2012 at 2:26 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Part of my problem is I don't see anywhere that
> MLX4_RESERVED_QKEY_MASK is actually used in this patch...

see in patch 13/29

@ -1209,8 +1375,24 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
        if (attr_mask & IB_QP_RQ_PSN)
                context->rnr_nextrecvpsn |= cpu_to_be32(attr->rq_psn);

+       /* proxy and tunnel qp qkeys will be changed in modify-qp wrappers */
        if (attr_mask & IB_QP_QKEY) {
-               context->qkey = cpu_to_be32(attr->qkey);
+               if (qp->mlx4_ib_qp_type &
+                   (MLX4_IB_QPT_PROXY_SMI_OWNER | MLX4_IB_QPT_TUN_SMI_OWNER))
+                       context->qkey = cpu_to_be32(IB_QP_SET_QKEY);
+               else {
+                       if (mlx4_is_mfunc(dev->dev) &&
+                           !(qp->mlx4_ib_qp_type & MLX4_IB_QPT_ANY_SRIOV) &&
+                           (attr->qkey & MLX4_RESERVED_QKEY_MASK) ==
+                           MLX4_RESERVED_QKEY_BASE) {
+                               pr_err("Cannot use reserved QKEY"
+                                      " 0x%x (range 0xffff0000..0xffffffff"
+                                      " is reserved)\n", attr->qkey);
+                               err = -EINVAL;
+                               goto out;
+                       }
+                       context->qkey = cpu_to_be32(attr->qkey);
+               }
                optpar |= MLX4_QP_OPTPAR_Q_KEY;
        }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
