From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v6 6/7] libibverbs: Add man page for
 ibv_open_qp
Date: Tue, 4 Jun 2013 16:02:47 -0600
Message-ID: <20130604220247.GB5733@obsidianresearch.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
 <1370371791-15018-7-git-send-email-sean.hefty@intel.com>
 <20130604205413.GB30182@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD2CFAB@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2CFAB-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2013 at 09:49:00PM +0000, Hefty, Sean wrote:
> > > +uint32_t          qp_num;     /* QP number */
> > > +void             *qp_context; /* Associated context of the QP */
> > 
> > Would be nice to clarify what this value is too. I took a quick peak
> > and it wasn't clear to me. The XRC example does not use it.
> > 
> > Is it a user defined cookie? If so can we call it a cookie instead?
> 
> This is similar to qp_context in ibv_qp_init_attr and ibv_qp, which
> is also consistent with cq_context and srq_context.  It is a user
> defined context.

Hum, I honestly had no idea about qp_context in struct ibv_qp, it
really is not documented well..

Keep the name, but please clarify what it is:

 'User defined opaque value'

Ideally in the other places too..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
