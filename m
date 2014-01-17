From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/usnic: Add UDP support in usnic_ib_qp_grp.[hc]
Date: Fri, 17 Jan 2014 14:19:09 +0300
Message-ID: <20140117111909.GA27461@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Upinder Malhi,

The patch e45e614e4015: "IB/usnic: Add UDP support in
usnic_ib_qp_grp.[hc]" from Jan 9, 2014, leads to the following
static checker warning:

	drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c:638 qp_grp_id_from_flow()
	warn: passing casted pointer 'id' to 'usnic_transport_sock_get_addr()' 32 vs 16.

drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
   627  static int qp_grp_id_from_flow(struct usnic_ib_qp_grp_flow *qp_flow,
   628                                  uint32_t *id)
   629  {
   630          enum usnic_transport_type trans_type = qp_flow->trans_type;
   631          int err;
   632  
   633          switch (trans_type) {
   634          case USNIC_TRANSPORT_ROCE_CUSTOM:
   635                  *id = qp_flow->usnic_roce.port_num;
   636                  break;
   637          case USNIC_TRANSPORT_IPV4_UDP:
   638                  err = usnic_transport_sock_get_addr(qp_flow->udp.sock,
   639                                                          NULL, NULL,
   640                                                          (uint16_t *) id);
                                                                ^^^^^^^^^^^^^^^
This doesn't work on big endian systems.

   641                  if (err)
   642                          return err;
   643                  break;

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
