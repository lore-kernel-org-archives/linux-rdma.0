From: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Tue, 10 Feb 2015 16:56:43 +0100
Message-ID: <20150210155643.GB13690@fholler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

We are using Linux 3.14.29 with mlx4 drivers and trying to use automatic path
migration for RC connections.
The path migration works, but no IB_EVENT_PATH_MIG* events are generated when
it happens.

APM is configured on machine A by the following code snippet:
        [..]
        err = ib_query_qp(qp, &qp_attr, 0, &init_attr);                                                                                            
        if (err)                                                                                                                                   
                return err;                                                                                                                        
                                                                                                                                                   
        memcpy(&qp_attr.alt_ah_attr, &qp_attr.ah_attr,
               sizeof(qp_attr.alt_ah_attr));
                                                                                                                                                   
        qp_attr.alt_pkey_index          = qp_attr.pkey_index;
        qp_attr.alt_timeout             = qp_attr.timeout;
        qp_attr.path_mig_state          = IB_MIG_REARM;
        qp_attr.alt_ah_attr.dlid        = dlid; /* peer's 2. port dlid */

        err = ib_modify_qp(con->qp, &qp_attr,
                           IB_QP_ALT_PATH | IB_QP_PATH_MIG_STATE);

(I experiment with setting also the ah_attr.port_num and alt_port_num
attributes, they seem to have no effect.)

The QP event handler is registered when calling rdma_create_qp():
        [..]
        init_attr.event_handler = qp_event_handler;
        init_attr.qp_context = con;
        ret = rdma_create_qp(cm_id, pd, &init_attr);


Both machines have MT26428 HCAs.
1 Port of machine A, both ports of machine B are connected to a switch.
We establish the connection to the 1. port of machine B, unplug the
corresponding cable and the path is migrated transparently to the second port
of machine B.
The connection can be used like nothing happens.

As soon as the migration happens I expect that a IB_EVENT_PATH_MIG* is
generated on the QP event handler, but I don't receive any QP events.

We need the event notification to rearm the path migration state machine for
another migration.

Does anybody have an idea what could be wrong?
Are the PATH_MIG* notifications with mlx4 drivers are working for somebody?


thanks

Fabian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
