From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Why don't we always check that attr->port_num is valid?
Date: Mon, 2 Oct 2017 14:34:31 +0300
Message-ID: <20171002113431.lqkf4ilmimjfouc7@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch 926a01dc000d: "RDMA/hns: Add QP operations support for
hip08 SoC" from Aug 30, 2017, leads to the following static checker
warning:

	drivers/infiniband/hw/hns/hns_roce_hw_v2.c:2721 hns_roce_v2_modify_qp()
	error: buffer overflow 'hr_dev->iboe.phy_port' 6 <= 255

drivers/infiniband/hw/hns/hns_roce_hw_v2.c
  2716  
  2717          if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
  2718                  hr_qp->resp_depth = attr->max_dest_rd_atomic;
  2719          if (attr_mask & IB_QP_PORT) {
                    ^^^^^^^^^^^^^^^^^^^^^^

  2720                  hr_qp->port = attr->port_num - 1;
                                      ^^^^^^^^^^^^^^^^^^
  2721                  hr_qp->phy_port = hr_dev->iboe.phy_port[hr_qp->port];
                                                                ^^^^^^^^^^^
The warning here is that hns_roce_v2_modify_qp() is called with a user
controlled hr_qp->port and it can be in the 0-255 range.  This is true.
*However* when IB_QP_PORT mask is set then ->port_num is checked.

  2722          }

Here is how it looks in the caller, hns_roce_modify_qp():

drivers/infiniband/hw/hns/hns_roce_qp.c
   757          if ((attr_mask & IB_QP_PORT) &&
   758              (attr->port_num == 0 || attr->port_num > hr_dev->caps.num_ports)) {
   759                  dev_err(dev, "attr port_num invalid.attr->port_num=%d\n",
   760                          attr->port_num);
   761                  goto out;
   762          }

We deliberately allow invalid attr->port_nums if IB_QP_PORT is not set.
Why must we do that?  From a kernel hardening perspective it would be
better to ban invalid values all together...

I'm trying to think of a way to handle this kind of thing in Smatch but
it's like I end up with an explosion of states that end up consuming all
the RAM.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
