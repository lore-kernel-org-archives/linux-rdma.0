From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Fri, 9 Dec 2016 12:20:44 +0300
Message-ID: <20161209092044.GA4640@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Sagi Grimberg,

The patch e6631814fb3a: "IB/mlx5: Support IB_WR_REG_SIG_MR" from Feb
23, 2014, leads to the following static checker warning:

	net/rds/ib_recv.c:672 rds_ib_send_ack()
	warn: 'ret' can be either negative or positive

drivers/infiniband/hw/mlx5/qp.c
  3614  static int set_psv_wr(struct ib_sig_domain *domain,
  3615                        u32 psv_idx, void **seg, int *size)
  3616  {
  3617          struct mlx5_seg_set_psv *psv_seg = *seg;
  3618  
  3619          memset(psv_seg, 0, sizeof(*psv_seg));
  3620          psv_seg->psv_num = cpu_to_be32(psv_idx);
  3621          switch (domain->sig_type) {
  3622          case IB_SIG_TYPE_NONE:
  3623                  break;
  3624          case IB_SIG_TYPE_T10_DIF:
  3625                  psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
  3626                                                       domain->sig.dif.app_tag);
  3627                  psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
  3628                  break;
  3629          default:
  3630                  pr_err("Bad signature type given.\n");
  3631                  return 1;

Why do we return 1 here instead of a negative error code?

  3632          }
  3633  
  3634          *seg += sizeof(*psv_seg);
  3635          *size += sizeof(*psv_seg) / 16;
  3636  
  3637          return 0;
  3638  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
