From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/14] IB/mad: Create handle_ib_smi
Date: Wed, 20 May 2015 13:52:31 -0400
Message-ID: <20150520175230.GA14309@phlsvsds.ph.intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com> <1432109615-19564-4-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FDDA89@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDDA89-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 20, 2015 at 11:24:22AM -0600, Hefty, Sean wrote:
> > diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> > index 9cd4ce8dfbd0..96daba58afad 100644
> > --- a/drivers/infiniband/core/mad.c
> > +++ b/drivers/infiniband/core/mad.c
> > @@ -1924,6 +1924,52 @@ static void ib_mad_complete_recv(struct
> > ib_mad_agent_private *mad_agent_priv,
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
> Make static

done.

Can I add your reviewed by after this change?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
