From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter
Date: Thu, 26 Feb 2015 17:54:04 +0000
Message-ID: <866503b4-fa4e-41da-827a-baa2c060e16b@CMEXHTCAS2.ad.emulex.com>
References: <20150226123000.GA6728@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150226123000.GA6728@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Parav Pandit <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Dan for pointing out, we will address this issue and send out a patch to fix this.

-Regards
Devesh

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dan Carpenter
> Sent: Thursday, February 26, 2015 6:00 PM
> To: Parav Pandit
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: re: RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA
> adapter
> 
> Hello Parav Pandit,
> 
> The patch fe2caefcdf58: "RDMA/ocrdma: Add driver for Emulex OneConnect
> IBoE RDMA adapter" from Mar 21, 2012, leads to the following static checker
> warning:
> 
> 	drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1426
> _ocrdma_modify_qp()
> 	warn: bool is not less than zero.
> 
> drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
>   1411  int _ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
>   1412                        int attr_mask)
>   1413  {
>   1414          int status = 0;
>   1415          struct ocrdma_qp *qp;
>   1416          struct ocrdma_dev *dev;
>   1417          enum ib_qp_state old_qps;
>   1418
>   1419          qp = get_ocrdma_qp(ibqp);
>   1420          dev = get_ocrdma_dev(ibqp->device);
>   1421          if (attr_mask & IB_QP_STATE)
>   1422                  status = ocrdma_qp_state_change(qp, attr->qp_state,
> &old_qps);
>   1423          /* if new and previous states are same hw doesn't need to
>   1424           * know about it.
>   1425           */
>   1426          if (status < 0)
> 
> This check is never true.  Based on the comment then the check should
> be:
> 		if (status == 1)
> 			return SOMETHING;
> 
>   1427                  return status;
>   1428          status = ocrdma_mbx_modify_qp(dev, qp, attr, attr_mask);
>   1429
>   1430          return status;
>   1431  }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
