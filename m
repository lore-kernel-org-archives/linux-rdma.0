From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 05/20] IB/mad: Change cast in rcv_has_same_class
Date: Wed, 14 Jan 2015 16:19:07 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC004AF@CRSMSX101.amr.corp.intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-6-git-send-email-ira.weiny@intel.com>
 <54B608AE.5040900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B608AE.5040900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 1/12/2015 7:10 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Save dereference and clarifies that rcv_has_same_class can process
> > both IB and OPA MADs.
> 
> I don't see any clarification below... something missing here?

Nothing missing.  I was trying to indicate that this change simply indicates that this function can operate on any buffer which has an ib_mad_hdr. 

Ira

> 
> >
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >   drivers/infiniband/core/mad.c |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/mad.c
> > b/drivers/infiniband/core/mad.c index 66b3940..819b794 100644
> > --- a/drivers/infiniband/core/mad.c
> > +++ b/drivers/infiniband/core/mad.c
> > @@ -1750,7 +1750,7 @@ static int is_rmpp_data_mad(struct
> ib_mad_agent_private *mad_agent_priv,
> >   static inline int rcv_has_same_class(struct ib_mad_send_wr_private *wr,
> >   				     struct ib_mad_recv_wc *rwc)
> >   {
> > -	return ((struct ib_mad *)(wr->send_buf.mad))->mad_hdr.mgmt_class
> ==
> > +	return ((struct ib_mad_hdr *)(wr->send_buf.mad))->mgmt_class ==
> >   		rwc->recv_buf.mad->mad_hdr.mgmt_class;
> >   }
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
