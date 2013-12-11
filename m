From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 01:40:19 +0300
Message-ID: <20131211224019.GC3955@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Upinder Malhi,

The patch b1819c455542: "IB/usnic: Add Cisco VIC low-level hardware
driver" from Sep 10, 2013, leads to the following Smatch
warning:
	drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c:467
	usnic_ib_qp_grp_create()
	error: scheduling with locks held: 'spin_lock:lock'

drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
   449          BUG_ON(!spin_is_locked(&vf->lock));
                        ^^^^^^^^^^^^^^^^^^^^^^^^
Holding lock.
Don't call BUG_ON(), use WARN_ON()?

   450  
   451          err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
   452                                                  res_spec);
   453          if (err) {
   454                  usnic_err("Spec does not meet miniumum req for transport %d\n",
   455                                  transport);
   456                  log_spec(res_spec);
   457                  return ERR_PTR(err);
   458          }
   459  
   460          port_num = usnic_transport_rsrv_port(transport, 0);
   461          if (!port_num) {
   462                  usnic_err("Unable to allocate port for %s\n",
   463                                  netdev_name(ufdev->netdev));
   464                  return ERR_PTR(-EINVAL);
   465          }
   466  
   467          qp_grp = kzalloc(sizeof(*qp_grp), GFP_KERNEL);
                                                  ^^^^^^^^^^
Sleeping allocation.

   468          if (!qp_grp) {
   469                  usnic_err("Unable to alloc qp_grp - Out of memory\n");
   470                  return NULL;
   471          }

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
