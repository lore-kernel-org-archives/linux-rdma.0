From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/rdmavt: Add create queue pair functionality
Date: Tue, 22 Mar 2016 23:01:32 +0300
Message-ID: <20160322200132.GA27901@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Dennis Dalessandro,

The patch 515667f8f8b4: "IB/rdmavt: Add create queue pair
functionality" from Jan 22, 2016, leads to the following static
checker warning:

	drivers/infiniband/sw/rdmavt/qp.c:835 rvt_create_qp()
	warn: odd binop '0x4 & 0xe0'

drivers/infiniband/sw/rdmavt/qp.c
   823          /*
   824           * We have our QP and its good, now keep track of what types of opcodes
   825           * can be processed on this QP. We do this by keeping track of what the
   826           * 3 high order bits of the opcode are.
   827           */
   828          switch (init_attr->qp_type) {
   829          case IB_QPT_SMI:
   830          case IB_QPT_GSI:
   831          case IB_QPT_UD:
   832                  qp->allowed_ops = IB_OPCODE_UD_SEND_ONLY & RVT_OPCODE_QP_MASK;
   833                  break;
   834          case IB_QPT_RC:
   835                  qp->allowed_ops = IB_OPCODE_RC_SEND_ONLY & RVT_OPCODE_QP_MASK;
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                          0x4                    & 0xE0
is zero.  I couldn't figure out where IB_OPCODE_RC_SEND_ONLY is
defined but presumably Smatch is correct that it's 4.

   836                  break;
   837          case IB_QPT_UC:
   838                  qp->allowed_ops = IB_OPCODE_UC_SEND_ONLY & RVT_OPCODE_QP_MASK;
   839                  break;
   840          default:
   841                  ret = ERR_PTR(-EINVAL);
   842                  goto bail_ip;
   843          }


regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
