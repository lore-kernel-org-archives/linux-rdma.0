From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/hfi1: Remove inline from trace functions
Date: Thu, 13 Aug 2015 20:16:12 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25786778@ORSMSX160.amr.corp.intel.com>
References: <20150813140614.4969.99821.stgit@phlsvslse11.ph.intel.com>
 <20150813165831.GA13535@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150813165831.GA13535-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > inline in trace functions causes the following build error when
> > CONFIG_OPTIMIZE_INLINING is not defined in the kernel config:
> > error: function can never be inlined because it uses variable argument
> > lists
> 
> There are all manner of tracing things in the kernel. Does this driver really
> need a custom designed one?
> 

All of our trace infrastructure is built out of events/tracepoints, so we are not inventing anything new here.

The fast patch traces are built out of tracepoints.

The *_cdbg() ones are intended for slow path code and compared to the native trace points are easier to new trace capabilities.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
