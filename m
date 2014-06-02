From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH V3] svcrdma: refactor marshalling logic
Date: Mon, 2 Jun 2014 12:51:52 -0400
Message-ID: <20140602165151.GA20031@fieldses.org>
References: <20140529165532.16349.95248.stgit@build.ogc.int>
 <EE7902D3F51F404C82415C4803930ACD3FE01265@CMEXMB1.ad.emulex.com>
 <000001cf7c07$72e613d0$58b23b70$@opengridcomputing.com>
 <EE7902D3F51F404C82415C4803930ACD3FE01355@CMEXMB1.ad.emulex.com>
 <004101cf7e82$68b58ad0$3a20a070$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004101cf7e82$68b58ad0$3a20a070$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Devesh Sharma' <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 02, 2014 at 11:47:58AM -0500, Steve Wise wrote:
> 
> 
> > Steve
> > 
> > I have not checked the code because I am away from my laptop
> > But I assume mlx and mthca is using fmr and cxgb4 is using rdma-read-with-invalidate
> which
> > has implicit fence.
> > 
> > If invalidate is issued before read is completed its a problem.
> > 
> 
> You're correct.  And this bug appears to be in the current upstream code as well.  If an
> IB_WR_LOCAL_INV wr is used, it must include IB_SEND_FENCE to fence it until the prior read
> completes.
> 
> Good catch!  I'll post V4 soon.

Any chance that can be handled as a separate patch rather than folded
in?

(Disclaimer: I've been following the discussion only very
superficially.)

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
