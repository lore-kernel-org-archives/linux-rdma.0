From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/mlx5: Support IB_WR_REG_SIG_MR
Date: Wed, 12 Aug 2015 13:36:59 +0300
Message-ID: <20150812103659.GA22571@mwanda>
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

	drivers/infiniband/ulp/ipoib/ipoib_cm.c:764 ipoib_cm_send()
	warn: 'rc' can be either negative or positive

drivers/infiniband/hw/mlx5/qp.c
  2417  static int set_psv_wr(struct ib_sig_domain *domain,
  2418                        u32 psv_idx, void **seg, int *size)
  2419  {
  2420          struct mlx5_seg_set_psv *psv_seg = *seg;
  2421  
  2422          memset(psv_seg, 0, sizeof(*psv_seg));
  2423          psv_seg->psv_num = cpu_to_be32(psv_idx);
  2424          switch (domain->sig_type) {
  2425          case IB_SIG_TYPE_NONE:
  2426                  break;
  2427          case IB_SIG_TYPE_T10_DIF:
  2428                  psv_seg->transient_sig = cpu_to_be32(domain->sig.dif.bg << 16 |
  2429                                                       domain->sig.dif.app_tag);
  2430                  psv_seg->ref_tag = cpu_to_be32(domain->sig.dif.ref_tag);
  2431                  break;
  2432          default:
  2433                  pr_err("Bad signature type given.\n");
  2434                  return 1;

Probably we should return -EINVAL here?  It actually really upsets the
static checker because all the callers expect negative error codes and
there are lot of callers.

  2435          }
  2436  
  2437          *seg += sizeof(*psv_seg);
  2438          *size += sizeof(*psv_seg) / 16;
  2439  
  2440          return 0;
  2441  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
