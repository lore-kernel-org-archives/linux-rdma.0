From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cma: Set default gid type to RoCEv2
Date: Fri, 28 Jul 2017 13:50:41 -0400
Message-ID: <1501264241.2593.21.camel@redhat.com>
References: <20170530064734.4731-1-leon@kernel.org>
         <20170607090750.GC1127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170607090750.GC1127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-07 at 12:07 +0300, Leon Romanovsky wrote:
> On Tue, May 30, 2017 at 09:47:34AM +0300, Leon Romanovsky wrote:
> > From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > RoCEv2 is the preferred RDMA protocol for Ethernet link layer
> > because
> > of its advantages over RoCEv1. For better user experience make it
> > the
> > default choice for RDMA_CM connections if device/port support it.
> > 
> > Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/cma.c
> > b/drivers/infiniband/core/cma.c
> > index 91b7a2fe5a55..5ce3c9e1657e 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -72,6 +72,7 @@ MODULE_LICENSE("Dual BSD/GPL");
> >  #define CMA_MAX_CM_RETRIES 15
> >  #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
> >  #define CMA_IBOE_PACKET_LIFETIME 18
> > +#define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
> 
> It should be (1 << IB_GID_TYPE_ROCE_UDP_ENCAP) and not as was written
> above. We will send a fix for that.

I didn't see a followup that fixed this, so I took this patch and then
created a fix patch myself.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
