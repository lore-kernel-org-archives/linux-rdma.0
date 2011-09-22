From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 15:39:07 -0600
Message-ID: <20110922213907.GK28454@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com>
 <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E67532@ORSMSX101.amr.corp.intel.com>
 <20110922212756.GJ28454@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E675B2@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E675B2-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 22, 2011 at 09:33:24PM +0000, Hefty, Sean wrote:
> > Adding a cast is just pointless noise, doesn't fix or prove anything.
> 
> It fixes the build on windows.  You can call that pointless, but I do not.

It supresses a warning, warnings are not build failures.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
