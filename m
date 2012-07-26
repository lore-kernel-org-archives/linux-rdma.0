From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Work completion error: "transport retry counter exceeded"
Date: Wed, 25 Jul 2012 19:07:19 -0700
Message-ID: <20120725190719.475605dc169353b775cd3463@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am at a loss.  I am hacking some RDMA code to do an RDMA write from a server
to a client.

I have it working perfectly on a small 2 node test system.  When I move the
code to another system I am getting a "transport retry counter exceeded"
error.  I just can't figure out why an RDMA Write is timing out like this.

What ibv_qp_init_attr's in ibv_create_qp or ibv_qp_attr's in ibv_modify_qp might I
have to change to account for different hardware?

NOTE: On both of these tests I am trying to xfer data from 2 nodes on the same
switch.  The hardware is different and the payload in small (<512 bytes).

Here is my init code on the server side:

rdma_create_qp...

	struct ibv_qp *qp;

	struct ibv_qp_init_attr attr = {
		.send_cq = p_sa->rdma_ctx.cq,
		.recv_cq = p_sa->rdma_ctx.cq,
		.cap     = {
			.max_send_wr  = 10,
			.max_recv_wr  = 500,
			.max_send_sge = 1,
			.max_recv_sge = 1
		},
		.qp_type = IBV_QPT_RC
	};
	
	qp = ibv_create_qp(p_sa->rdma_ctx.pd, &attr);
	if (!qp) {
		return (IB_INSUFFICIENT_RESOURCES);
	}

	{
		struct ibv_qp_attr attr = {
			.qp_state        = IBV_QPS_INIT,
			.pkey_index      = 0,
			.port_num        = rdma_ctx.device_port,
			.qp_access_flags = IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_REMOTE_READ | IBV_ACCESS_LOCAL_WRITE
		};

		if (ibv_modify_qp(qp, &attr,
				  IBV_QP_STATE              |
				  IBV_QP_PKEY_INDEX         |
				  IBV_QP_PORT               |
				  IBV_QP_ACCESS_FLAGS)) {
			goto DestroyQP;
		}
	}
...

rdma_modify_qp...

	/* transition it to RTR/RTS with eth_info and path record */
	struct ibv_qp_attr attr = {
		.qp_state		= IBV_QPS_RTR,
		.path_mtu		= path->mtu,
		.dest_qp_num		= eth_info->qpn,
		.rq_psn			= 1,
		.max_dest_rd_atomic	= 1,
		.min_rnr_timer		= 12,
		.ah_attr		= {
			.is_global	= 0,
			.dlid		= path->dlid,
			.sl		= path->sl,
			.src_path_bits	= 0,
			.port_num	= rdma_ctx.device_port
		}
	};

	if (ibv_modify_qp(qp, &attr,
			  IBV_QP_STATE              |
			  IBV_QP_PATH_MTU           |
			  IBV_QP_DEST_QPN           |
			  IBV_QP_RQ_PSN             |
			  IBV_QP_MAX_DEST_RD_ATOMIC |
			  IBV_QP_MIN_RNR_TIMER      |
			  IBV_QP_AV)) {
		return 1;
	}

	attr.qp_state	    = IBV_QPS_RTS;
	attr.timeout	    = 14;
	attr.retry_cnt	    = 7;
	attr.rnr_retry	    = 7;
	attr.sq_psn	    = 1;
	attr.max_rd_atomic  = 1;
	if (ibv_modify_qp(qp, &attr,
			  IBV_QP_STATE              |
			  IBV_QP_TIMEOUT            |
			  IBV_QP_RETRY_CNT          |
			  IBV_QP_RNR_RETRY          |
			  IBV_QP_SQ_PSN             |
			  IBV_QP_MAX_QP_RD_ATOMIC)) {
		return 1;
	}
...


Here is the code on the client:

rdma_create_qp...

	struct ibv_qp_init_attr attr = {
		.send_cq = rdma_ctx.cq,
		.recv_cq = rdma_ctx.cq,
		.cap     = {
			.max_send_wr  = 10,
			.max_recv_wr  = 10,
			.max_send_sge = 1,
			.max_recv_sge = 1
		},
		.qp_type = IBV_QPT_RC
	};
	
	qp = ibv_create_qp(rdma_ctx.pd, &attr);
	if (!qp) {
		return (-ENOMEM);
	}

	{
		struct ibv_qp_attr attr = {
			.qp_state        = IBV_QPS_INIT,
			.pkey_index      = 0,
			.port_num	 = rdma_ctx.device_port,
			.qp_access_flags = IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_REMOTE_READ | IBV_ACCESS_LOCAL_WRITE
		};

		if (ibv_modify_qp(qp, &attr,
				  IBV_QP_STATE              |
				  IBV_QP_PKEY_INDEX         |
				  IBV_QP_PORT               |
				  IBV_QP_ACCESS_FLAGS)) {
			return (-ENOMEM);
		}
	}

...

rdma_connect_qp...

	struct ibv_qp_attr attr = {
		.qp_state		= IBV_QPS_RTR,
		.path_mtu		= conn->path.mtu,
		.dest_qp_num		= conn->rqpn,
		.rq_psn			= 1,
		.max_dest_rd_atomic	= 1,
		.min_rnr_timer		= 12,
		.ah_attr		= {
			.is_global	= 0,
			.dlid		= conn->path.dlid,
			.sl		= conn->path.sl,
			.src_path_bits	= 0,
			.port_num	= rdma_ctx.device_port
		}
	};

	if (ibv_modify_qp(conn->qp, &attr,
			  IBV_QP_STATE              |
			  IBV_QP_PATH_MTU           |
			  IBV_QP_DEST_QPN           |
			  IBV_QP_RQ_PSN             |
			  IBV_QP_MAX_DEST_RD_ATOMIC |
			  IBV_QP_MIN_RNR_TIMER      |
			  IBV_QP_AV)) {
		return 1;
	}

	attr.qp_state	     = IBV_QPS_RTS;
	attr.timeout	     = 14;
	attr.retry_cnt	     = 7;
	attr.rnr_retry	     = 7;
	attr.sq_psn	     = 1;
	attr.max_rd_atomic   = 1;
	if (ibv_modify_qp(conn->qp, &attr,
			  IBV_QP_STATE              |
			  IBV_QP_TIMEOUT            |
			  IBV_QP_RETRY_CNT          |
			  IBV_QP_RNR_RETRY          |
			  IBV_QP_SQ_PSN             |
			  IBV_QP_MAX_QP_RD_ATOMIC)) {
		return 1;
	}
...


Thanks,
Ira

-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
