From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: mlx5: Add driver for Mellanox Connect-IB adapters
Date: Fri, 20 Jun 2014 20:58:32 +0300
Message-ID: <20140620175832.GA11900@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Eli Cohen,

This is a semi-automatic email about new static checker warnings.

The patch e126ba97dba9: "mlx5: Add driver for Mellanox Connect-IB 
adapters" from Jul 7, 2013, leads to the following Smatch complaint:

drivers/infiniband/hw/mlx5/qp.c:979 create_qp_common()
	 error: we previously assumed 'pd->uobject' could be null (see line 847)

drivers/infiniband/hw/mlx5/qp.c
   846		if (pd) {
   847			if (pd->uobject) {
                            ^^^^^^^^^^^
There are a bunch of checks for pd->uobject.

   848				mlx5_ib_dbg(dev, "requested sq_wqe_count (%d)\n", ucmd.sq_wqe_count);
   849				if (ucmd.rq_wqe_shift != qp->rq.wqe_shift ||
   850				    ucmd.rq_wqe_count != qp->rq.wqe_cnt) {
   851					mlx5_ib_dbg(dev, "invalid rq params\n");
   852					return -EINVAL;
   853				}
   854				if (ucmd.sq_wqe_count > dev->mdev.caps.max_wqes) {
   855					mlx5_ib_dbg(dev, "requested sq_wqe_count (%d) > max allowed (%d)\n",

[ snip ]

   971		qp->doorbell_qpn = swab32(qp->mqp.qpn << 8);
   972	
   973		qp->mqp.event = mlx5_ib_qp_event;
   974	
   975		return 0;
   976	
   977	err_create:
   978		if (qp->create_type == MLX5_QP_USER)
   979			destroy_qp_user(pd, qp);
                        ^^^^^^^^^^^^^^^
But we dereference it inside destroy_qp_user() unconditionally.

   980		else if (qp->create_type == MLX5_QP_KERNEL)
   981			destroy_qp_kernel(dev, qp);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
