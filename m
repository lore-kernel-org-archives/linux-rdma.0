From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [infiniband:for-next 41/47] drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:2875:3:
 warning: case value '7' not in enumerated type 'enum qp_transition'
Date: Fri, 30 May 2014 15:43:39 -0700
Message-ID: <CAL1RGDXoVByoFadRiH7iRxWj9AdShEJtvpoj_5uNhkudGrwJPQ@mail.gmail.com>
References: <53882b5a.UAE9BgmHCPuDMdrw%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53882b5a.UAE9BgmHCPuDMdrw%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 29, 2014 at 11:55 PM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-next
> head:   73b878af35148015273fb09b4a4af80c770ff763
> commit: 99ec41d0a48cb6d14af25765f9449762f9d101f6 [41/47] mlx4: Add infrastructure for selecting VFs to enable QP0 via MLX proxy QPs
> config: x86_64-rhel (attached as .config)
>
> All warnings:
>
>    drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: In function 'verify_qp_parameters':
>>> drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:2875:3: warning: case value '7' not in enumerated type 'enum qp_transition' [-Wswitch]
>       case MLX4_QP_ST_MLX:
>       ^
>
> vim +2875 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
>
>   2859                                                  num_gids = mlx4_get_slave_num_gids(dev, slave, port);
>   2860                                          else
>   2861                                                  num_gids = 1;
>   2862                                          if (qp_ctx->pri_path.mgid_index >= num_gids)
>   2863                                                  return -EINVAL;
>   2864                                  }
>   2865                                  if (optpar & MLX4_QP_OPTPAR_ALT_ADDR_PATH) {
>   2866                                          port = (qp_ctx->alt_path.sched_queue >> 6 & 1) + 1;
>   2867                                          if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB)
>   2868                                                  num_gids = mlx4_get_slave_num_gids(dev, slave, port);
>   2869                                          else
>   2870                                                  num_gids = 1;
>   2871                                          if (qp_ctx->alt_path.mgid_index >= num_gids)
>   2872                                                  return -EINVAL;
>   2873                                  }
>   2874                          break;
>> 2875                  case MLX4_QP_ST_MLX:
>   2876                          qpn = vhcr->in_modifier & 0x7fffff;
>   2877                          port = (qp_ctx->pri_path.sched_queue >> 6 & 1) + 1;
>   2878                          if (transition == QP_TRANS_INIT2RTR &&
>   2879                              slave != mlx4_master_func_num(dev) &&
>   2880                              mlx4_is_qp_reserved(dev, qpn) &&
>   2881                              !mlx4_vf_smi_enabled(dev, slave, port)) {
>   2882                                  /* only enabled VFs may create MLX proxy QPs */
>   2883                                  mlx4_err(dev, "%s: unprivileged slave %d attempting to create an MLX proxy special QP on port %d\n",

Looks like this is actually a bug... assuming you guys agree the patch
is correct, I'll add the following:

commit 165cb465f73c (HEAD, mlx4)
Author: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Date:   Fri May 30 15:38:58 2014

    mlx4_core: Move handling of MLX4_QP_ST_MLX to proper switch statement

    The handling of MLX4_QP_ST_MLX in verify_qp_parameters() was
    accidentally put inside the inner switch statement (that handles which
    transition of RC/UC/XRC QPs is happening).  Fix this by moving the case
    to the outer switch statement.

    The compiler pointed this out with:

        drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: In
function 'verify_qp_parameters':
     >> drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:2875:3:
warning: case value '7' not in enumerated type 'enum qp_transition'
[-Wswitch]
           case MLX4_QP_ST_MLX:

    Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Fixes: 99ec41d0a48c ("mlx4: Add infrastructure for selecting VFs
to enable QP0 via MLX proxy QPs")
    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index ad98162a8d79..10db83ee0e58 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -2872,25 +2872,25 @@ static int verify_qp_parameters(struct mlx4_dev *dev,
                                                return -EINVAL;
                                }
                        break;
-               case MLX4_QP_ST_MLX:
-                       qpn = vhcr->in_modifier & 0x7fffff;
-                       port = (qp_ctx->pri_path.sched_queue >> 6 & 1) + 1;
-                       if (transition == QP_TRANS_INIT2RTR &&
-                           slave != mlx4_master_func_num(dev) &&
-                           mlx4_is_qp_reserved(dev, qpn) &&
-                           !mlx4_vf_smi_enabled(dev, slave, port)) {
-                               /* only enabled VFs may create MLX proxy QPs */
-                               mlx4_err(dev, "%s: unprivileged slave
%d attempting to create an MLX proxy special QP on port %d\n",
-                                        __func__, slave, port);
-                               return -EPERM;
-                       }
-                       break;
-
                default:
                        break;
                }
+               break;

+       case MLX4_QP_ST_MLX:
+               qpn = vhcr->in_modifier & 0x7fffff;
+               port = (qp_ctx->pri_path.sched_queue >> 6 & 1) + 1;
+               if (transition == QP_TRANS_INIT2RTR &&
+                   slave != mlx4_master_func_num(dev) &&
+                   mlx4_is_qp_reserved(dev, qpn) &&
+                   !mlx4_vf_smi_enabled(dev, slave, port)) {
+                       /* only enabled VFs may create MLX proxy QPs */
+                       mlx4_err(dev, "%s: unprivileged slave %d
attempting to create an MLX proxy special QP on port %d\n",
+                                __func__, slave, port);
+                       return -EPERM;
+               }
                break;
+
        default:
                break;
        }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
