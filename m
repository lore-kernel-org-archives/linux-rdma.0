From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 01:43:30 +0300
Message-ID: <20131211224330.GD3955@elgon.mountain>
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
driver" from Sep 10, 2013, leads to the following static checker
warning:
	drivers/infiniband/hw/usnic/usnic_ib_verbs.c:114
	usnic_ib_fill_create_qp_resp()
	warn: check that 'resp' doesn't leak information (struct has
	a hole after 'transport')

drivers/infiniband/hw/usnic/usnic_ib_verbs.c
   109          WARN_ON(chunk->type != USNIC_VNIC_RES_TYPE_CQ);
   110          resp.cq_cnt = chunk->cnt;
   111          for (i = 0; i < chunk->cnt; i++)
   112                  resp.cq_idx[i] = chunk->res[i]->vnic_idx;
   113  
   114          err = ib_copy_to_udata(udata, &resp, sizeof(resp));
                                              ^^^^^
The "resp" struct has a struct hole and uninitialized struct members so
it leaks uninitialized stack information to the user (information
disclosure security bug).

   115          if (err) {
   116                  usnic_err("Failed to copy udata for %s", us_ibdev->ib_dev.name);
   117                  return err;
   118          }

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
