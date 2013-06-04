From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibverbs v6 6/7] libibverbs: Add man page for
 ibv_open_qp
Date: Tue, 4 Jun 2013 21:49:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD2CFAB@ORSMSX109.amr.corp.intel.com>
References: <1370371791-15018-1-git-send-email-sean.hefty@intel.com>
 <1370371791-15018-7-git-send-email-sean.hefty@intel.com>
 <20130604205413.GB30182@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130604205413.GB30182-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +uint32_t          qp_num;     /* QP number */
> > +void             *qp_context; /* Associated context of the QP */
> 
> Would be nice to clarify what this value is too. I took a quick peak
> and it wasn't clear to me. The XRC example does not use it.
> 
> Is it a user defined cookie? If so can we call it a cookie instead?

This is similar to qp_context in ibv_qp_init_attr and ibv_qp, which is also consistent with cq_context and srq_context.  It is a user defined context.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
