From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp: avoid NULL pointer dereference when processing
  invalid SRP_RSP
Date: Thu, 29 Jul 2010 18:36:14 -0400
Message-ID: <1280442974.31468.23.camel@obelisk.thedillows.org>
References: <201007291756.31172.bvanassche@acm.org>
	 <1280424106.20975.11.camel@lap75545.ornl.gov>
	 <AANLkTinecqHFervVh6t+QFcvW0Zhhz-VU43nq1N3rdnD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinecqHFervVh6t+QFcvW0Zhhz-VU43nq1N3rdnD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-07-29 at 20:07 +0200, Bart Van Assche wrote:
> On Thu, Jul 29, 2010 at 7:21 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > While I'm all for increasing the robustness of the initiator, I'm
> > curious how you would hit this -- I don't see where we would send a SRP
> > request without an associated SCSI command.
> >
> > I'm also not sure you're doing the right thing here -- you seem to skip
> > the cleanup of the associated SRP request. I suppose that may be handled
> > for you if/when srp_abort() gets called for a missed SCSI request, but
> > again, we should never be in the situation where a request doesn't have
> > a SCSI command. And if srp_abort() doesn't get called, we've leaked a
> > request and possibly a DMA mapping, no?
> 
> This condition was hit accidentally while testing newly added target
> code that sent an SRP_RSP not associated with an SRP_CMD or
> SRP_TSK_MGMT information unit. Since I was surprised to find a test of
> the scmnd pointer in ib_srp.c followed by an unconditional dereference
> of it, I coded up this patch.

Hmm, looking at it, it seems you got lucky or unlucky depending on the
viewpoint -- you must have either sent the SRP_RSP early on with a tag
that matched an unused request (so that req->scmnd would still be NULL)
or the tag value was garbage that happened to have a NULL pointer at the
correct offset.

In any event, it would seem that the initiator is a bit too trusting of
the target's returned tag. I hate to add a conditional check to the
path, but it does seem preferable to letting a buggy or malicious target
induce us to read random kernel memory.

> The target code that triggered this condition has been fixed by now
> and even was never committed to its source code repository, so this
> patch isn't important to me.
> 
> Regarding leaks: isn't there already a leak in the current ib_srp code
> if any information unit with another opcode than SRP_RSP is received ?

I don't think so -- we only allocate them for SCSI commands we send, and
look them up based on the tag value in the SRP_RSP.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
