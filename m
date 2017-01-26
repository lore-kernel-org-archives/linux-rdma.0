From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] RDS/IB: Disallow connections less than RDS 3.1
Date: Thu, 26 Jan 2017 12:30:11 +0300
Message-ID: <20170126093011.GA13945@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Andy Grover,

The patch f147dd9ecabf: "RDS/IB: Disallow connections less than RDS
3.1" from Jan 13, 2010, leads to the following static checker warning:

	net/rds/rdma_transport.c:140 rds_rdma_cm_event_handler()
	warn: 'conn' was already freed.

net/rds/ib_cm.c
    96  void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_event *event)
    97  {
    98          const struct rds_ib_connect_private *dp = NULL;
    99          struct rds_ib_connection *ic = conn->c_transport_data;
   100          struct ib_qp_attr qp_attr;
   101          int err;
   102  
   103          if (event->param.conn.private_data_len >= sizeof(*dp)) {
   104                  dp = event->param.conn.private_data;
   105  
   106                  /* make sure it isn't empty data */
   107                  if (dp->dp_protocol_major) {
   108                          rds_ib_set_protocol(conn,
   109                                  RDS_PROTOCOL(dp->dp_protocol_major,
   110                                  dp->dp_protocol_minor));
   111                          rds_ib_set_flow_control(conn, be32_to_cpu(dp->dp_credit));
   112                  }
   113          }
   114  
   115          if (conn->c_version < RDS_PROTOCOL(3, 1)) {
   116                  pr_notice("RDS/IB: Connection <%pI4,%pI4> version %u.%u no longer supported\n",
   117                            &conn->c_laddr, &conn->c_faddr,
   118                            RDS_PROTOCOL_MAJOR(conn->c_version),
   119                            RDS_PROTOCOL_MINOR(conn->c_version));
   120                  rds_conn_destroy(conn);

We free "conn" here.  There is only one caller rds_rdma_cm_event_handler()
which is not expecting it to be freed so it will oops when it tries to
mutex_unlock(&conn->c_cm_lock).  Or potentially it won't oops if you
don't have poisoning or kasan enabled?  It feels like there should be
some way to test this.

   121                  return;
   122          } else {
   123                  pr_notice("RDS/IB: %s conn connected <%pI4,%pI4> version %u.%u%s\n",
   124                            ic->i_active_side ? "Active" : "Passive",
   125                            &conn->c_laddr, &conn->c_faddr,
   126                            RDS_PROTOCOL_MAJOR(conn->c_version),
   127                            RDS_PROTOCOL_MINOR(conn->c_version),
   128                            ic->i_flowctl ? ", flow control" : "");
   129          }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
