From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: staging/rdma/hfi1: pre-compute sc and sde for RC/UC QPs
Date: Tue, 24 Nov 2015 14:09:10 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259C0753@fmsmsx120.amr.corp.intel.com>
References: <20151124125755.GA7088@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124125755.GA7088@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch d7b8ba5121e8: "staging/rdma/hfi1: pre-compute sc and sde for
> RC/UC QPs" from Nov 9, 2015, leads to the following static checker warning:
> 
> 	drivers/staging/rdma/hfi1/verbs.c:1657 ah_to_sc()
> 	error: buffer overflow 'ibp->sl_to_sc' 32 <= 255
> 
> drivers/staging/rdma/hfi1/qp.c
>    817          if (attr_mask & IB_QP_PATH_MIG_STATE) {
>    818                  qp->s_mig_state = attr->path_mig_state;
>    819                  if (mig) {
>    820                          qp->remote_ah_attr = qp->alt_ah_attr;
>    821                          qp->port_num = qp->alt_ah_attr.port_num;
>    822                          qp->s_pkey_index = qp->s_alt_pkey_index;
>    823                          qp->s_flags |= HFI1_S_AHG_CLEAR;
>    824                          qp->s_sc = ah_to_sc(ibqp->device, &qp-
> >remote_ah_attr);
> 
> Do we need to verify (hfi1_check_ah(ibqp->device, &qp->remote_ah_attr))
> before calling ah_to_sc()?
> 

Looking at this now.

What was the static checker?  Is it available for us to add to our testing?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
