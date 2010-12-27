From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 1/8] IB/srp: allow task management without a previous
 request
Date: Mon, 27 Dec 2010 12:31:51 -0500
Message-ID: <1293471111.2896.17.camel@obelisk.thedillows.org>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
	 <1293139893-11678-2-git-send-email-dillowda@ornl.gov>
	 <AANLkTi=sUbRP=Cg74DhXMRuhMRPMcW=JG-GsbuSd-gJ0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=sUbRP=Cg74DhXMRuhMRPMcW=JG-GsbuSd-gJ0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-12-27 at 16:01 +0100, Bart Van Assche wrote:
> On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> >
> > We can only have one task management comment outstanding, so move the
> > completion and status to the target port. This allows us to handle
> > resets of a LUN without a corresponding request having been sent.
> > Meanwhile, we don't need to play games with host_scribble, just use it
> > as the pointer it is.
> >
> > This fixes a crash when we issue a bus reset using sg_reset.
> >
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=13893
> > Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> 
> You can add here "Reported-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>"
> if you want.

Good idea, will do.

> >
> > -       SRP_TAG_TSK_MGMT        = 1 << (SRP_RQ_SHIFT + 1),
> > +       SRP_TAG_NO_REQ          = ~0UL,
> > +       SRP_TAG_TSK_MGMT        = 1UL << 31,
> 
> According to ANSI C, enumeration types have the same size as an int,
> so the above two declarations will assign a long to an int. The types
> long and int do not need to have the same size, so I suggest to leave
> out the capital L in the above.

Yeah, wil ldo.

> 
> And checkpatch says this:
> 
> WARNING: please, no space before tabs
> #114: FILE: drivers/infiniband/ulp/srp/ib_srp.c:1462:

Heh, usually I catch those... oh well. Will fix.

Thanks!


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
