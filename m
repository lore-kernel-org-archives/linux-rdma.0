From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/cma: Fix net_dev reference leak with failed requests
Date: Wed, 16 Sep 2015 17:10:39 +0300
Message-ID: <20150916141039.GA7449@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Haggai Eran,

The patch be688195bd08: "IB/cma: Fix net_dev reference leak with
failed requests" from Aug 27, 2015, leads to the following static
checker warning:

	drivers/infiniband/core/cma.c:1306 cma_id_from_event()
	error: potential NULL dereference '*net_dev'.

drivers/infiniband/core/cma.c
  1279  static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
  1280                                                   struct ib_cm_event *ib_event,
  1281                                                   struct net_device **net_dev)
  1282  {
  1283          struct cma_req_info req;
  1284          struct rdma_bind_list *bind_list;
  1285          struct rdma_id_private *id_priv;
  1286          int err;
  1287  
  1288          err = cma_save_req_info(ib_event, &req);
  1289          if (err)
  1290                  return ERR_PTR(err);
  1291  
  1292          *net_dev = cma_get_net_dev(ib_event, &req);
  1293          if (IS_ERR(*net_dev)) {
  1294                  if (PTR_ERR(*net_dev) == -EAFNOSUPPORT) {
  1295                          /* Assuming the protocol is AF_IB */
  1296                          *net_dev = NULL;

Set to NULL here.

  1297                  } else {
  1298                          return ERR_CAST(*net_dev);
  1299                  }
  1300          }
  1301  
  1302          bind_list = cma_ps_find(rdma_ps_from_service_id(req.service_id),
  1303                                  cma_port_from_service_id(req.service_id));
  1304          id_priv = cma_find_listener(bind_list, cm_id, ib_event, &req, *net_dev);
  1305          if (IS_ERR(id_priv)) {
  1306                  dev_put(*net_dev);

Dereferenced inside function call.  This warning is from a work in
progress Smatch check (unpublished).

  1307                  *net_dev = NULL;
  1308          }
  1309  
  1310          return id_priv;
  1311  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
