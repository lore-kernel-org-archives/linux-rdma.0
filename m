From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/14] IB/mad: Create handle_ib_smi
Date: Wed, 20 May 2015 21:34:38 -0400
Message-ID: <20150521013438.GJ22981@phlsvsds.ph.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com> <1432109615-19564-4-git-send-email-ira.weiny@intel.com> <20150520182832.GH28496@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150520182832.GH28496-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 12:28:32PM -0600, Jason Gunthorpe wrote:
> On Wed, May 20, 2015 at 04:13:24AM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Make a function to process Directed Route SMPs in ib_mad_recv_done_handler.
> > This change will help in later patches which separate the processing of OPA
> > SMPs from IBTA SMPs.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >  drivers/infiniband/core/mad.c | 85 +++++++++++++++++++++++++------------------
> >  1 file changed, 49 insertions(+), 36 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> > index 9cd4ce8dfbd0..96daba58afad 100644
> > +++ b/drivers/infiniband/core/mad.c
> > @@ -1924,6 +1924,52 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
> >  	}
> >  }
> >  
> > +enum smi_action handle_ib_smi(struct ib_mad_port_private *port_priv,
> > +			      struct ib_mad_qp_info *qp_info,
> > +			      struct ib_wc *wc,
> > +			      int port_num,
> > +			      struct ib_mad_private *recv,
> > +			      struct ib_mad_private *response)
> 
> const on input parameters please

Just so we are all on the same page here this results in a couple of new
patches which require massive parameter conversions to const.  I've already
done the work but I wanted to warn everyone there will then be a couple more
sizeable patches to review.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
