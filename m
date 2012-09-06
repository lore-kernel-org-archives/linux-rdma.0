From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 01/22] IB/core: Reserve bits in enum ib_qp_create_flags for low-level driver use
Date: Thu, 6 Sep 2012 13:06:35 +0300
Message-ID: <201209061306.35434.jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-2-git-send-email-jackm@dev.mellanox.co.il> <504767EB.6090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504767EB.6090004-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks, Doug!

-Jack

On Wednesday 05 September 2012 17:55, Doug Ledford wrote:
> On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> > Reserve bits 26-31 for internal use by low-level drivers. Two
> > such bits are used in the mlx4 driver SRIOV IB implementation.
> > 
> > These enum additions guarantee that the core layer will never use
> > these bits, so that low level drivers may safely make use of them.
> > 
> > Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> > ---
> >  include/rdma/ib_verbs.h |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 07996af..46bc045 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -614,6 +614,9 @@ enum ib_qp_type {
> >  enum ib_qp_create_flags {
> >  	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
> >  	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
> > +	/* reserve bits 26-31 for low level drivers' internal use */
> > +	IB_QP_CREATE_RESERVED_START		= 1 << 26,
> > +	IB_QP_CREATE_RESERVED_END		= 1 << 31,
> >  };
> >  
> >  struct ib_qp_init_attr {
> > 
> 
> Reserving 6 bits for driver use out of 32 seems reasonable.
> 
> Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
