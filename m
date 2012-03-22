From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Thu, 22 Mar 2012 07:27:05 -0700
Message-ID: <88B766C272F2C64B944B21AD078333151C964A65C7@EXMAIL.ad.emulex.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <3f46a051-ee2e-4e18-becf-60f6c023c3c6@exht1.ad.emulex.com>
 <1828884A29C6694DAF28B7E6B8A82373451977F5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373451977F5-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, March 21, 2012 10:49 PM
> To: Pandit, Parav; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH 1/9] ocrdma: Driver for Emulex OneConnect RDMA
> adapter
> 
> > +struct ocrdma_cq {
> > +	struct ib_cq ibcq;
> > +	struct ocrdma_dev *dev;
> 
> nit: There are several structures where you store ocrdma_dev *.  You can
> remove these and use the struct ib_* to reach it as well.

Removed from all the ocrdma_xxx structures except ocrdma_eq and ocrdma_qp.
ocrdma_eq is anyway necessary.
Removing it from ocrdma_qp will require a lot bigger test cycle at my end.
I prefer to have it in this first patch and once the internal test cycle is finish (with removed code) in few days, will submit the separate patch?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
