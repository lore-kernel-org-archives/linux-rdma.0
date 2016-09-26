From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/hfi1: Restore EPROM read ability
Date: Mon, 26 Sep 2016 11:42:04 -0600
Message-ID: <20160926174204.GE22965@obsidianresearch.com>
References: <20160925144724.13602.38549.stgit@scvm10.sc.intel.com>
 <20160925144926.13602.47716.stgit@scvm10.sc.intel.com>
 <20160926165247.GB12011@obsidianresearch.com>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BE0838F@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580BE0838F-AtyAts71sc9Qxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hariharan, Easwar" <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > If it is not being used by userpsace then do not call copy_to_user...
> 
> The first patch in the series is a straight (partial) restore of the
> old code.  This is what you are commenting on.  The second patch
> does a "fixup" of the restored code and removes this call.  Should
> we squash patches 1 and 2 so that this never shows up?  It is a
> question of how much "show your work" is desired.

Yes, squish them - do not make patches that are wrong and then fix
them up later in the series without a really good reason...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
