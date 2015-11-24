From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: staging/rdma/hfi1: pre-compute sc and sde for RC/UC QPs
Date: Tue, 24 Nov 2015 21:20:21 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259C1106@fmsmsx120.amr.corp.intel.com>
References: <20151124125755.GA7088@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > drivers/staging/rdma/hfi1/qp.c
> >    817          if (attr_mask & IB_QP_PATH_MIG_STATE) {
> >    818                  qp->s_mig_state = attr->path_mig_state;
> >    819                  if (mig) {
> >    820                          qp->remote_ah_attr = qp->alt_ah_attr;
> >    821                          qp->port_num = qp->alt_ah_attr.port_num;
> >    822                          qp->s_pkey_index = qp->s_alt_pkey_index;
> >    823                          qp->s_flags |= HFI1_S_AHG_CLEAR;
> >    824                          qp->s_sc = ah_to_sc(ibqp->device, &qp-
> > >remote_ah_attr);
> >
> > Do we need to verify (hfi1_check_ah(ibqp->device,
> > &qp->remote_ah_attr)) before calling ah_to_sc()?
> >
> 
> The modify code validates the IB_QP_ALT_PATH above:
> 647         if (attr_mask & IB_QP_ALT_PATH) {
>  648                 u8 sc;
>  649
>  650                 if (attr->alt_ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
>  651                         goto inval;
>  652                 if (hfi1_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
>  653                         goto inval;
>  654                 if (attr->alt_pkey_index >= hfi1_get_npkeys(dd))
>  655                         goto inval;
>  656                 sc = ah_to_sc(ibqp->device, &attr->alt_ah_attr);
>  657                 if (!qp_to_sdma_engine(qp, sc) &&
>  658                     dd->flags & HFI1_HAS_SEND_DMA)
>  659                         goto inval;
>  660         }
> 

I should point out the the IB core insures these two attributes are present in the same modify.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
