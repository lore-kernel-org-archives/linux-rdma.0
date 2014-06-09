From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/mlx4: Implement IB_QP_CREATE_USE_GFP_NOIO
Date: Mon, 9 Jun 2014 17:26:02 +0300
Message-ID: <20140609142602.GA7095@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jkosina-AlSwsSmVLrQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Jiri Kosina,

The patch 40f2287bd583: "IB/mlx4: Implement
IB_QP_CREATE_USE_GFP_NOIO" from May 11, 2014, leads to the following
static checker warning:

	drivers/infiniband/hw/mlx4/qp.c:677 create_qp_common()
	warn: use 'gfp' here instead of GFP_XXX?

drivers/infiniband/hw/mlx4/qp.c
   673          if (!*caller_qp) {
   674                  if (qp_type == MLX4_IB_QPT_SMI || qp_type == MLX4_IB_QPT_GSI ||
   675                      (qp_type & (MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_SMI_OWNER |
   676                                  MLX4_IB_QPT_PROXY_GSI | MLX4_IB_QPT_TUN_SMI_OWNER))) {
   677                          sqp = kzalloc(sizeof (struct mlx4_ib_sqp), GFP_KERNEL);
                                                                           ^^^^^^^^^^
   678                          if (!sqp)
   679                                  return -ENOMEM;
   680                          qp = &sqp->qp;
   681                          qp->pri.vid = 0xFFFF;
   682                          qp->alt.vid = 0xFFFF;
   683                  } else {
   684                          qp = kzalloc(sizeof (struct mlx4_ib_qp), GFP_KERNEL);
                                                                         ^^^^^^^^^^

   685                          if (!qp)
   686                                  return -ENOMEM;
   687                          qp->pri.vid = 0xFFFF;
   688                          qp->alt.vid = 0xFFFF;
   689                  }
   690          } else
   691                  qp = *caller_qp;

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
