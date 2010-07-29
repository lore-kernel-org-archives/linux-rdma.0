From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: avoid NULL pointer dereference when processing
	invalid SRP_RSP
Date: Thu, 29 Jul 2010 20:07:52 +0200
Message-ID: <AANLkTinecqHFervVh6t+QFcvW0Zhhz-VU43nq1N3rdnD@mail.gmail.com>
References: <201007291756.31172.bvanassche@acm.org>
	<1280424106.20975.11.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280424106.20975.11.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 29, 2010 at 7:21 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>
> On Thu, 2010-07-29 at 17:56 +0200, Bart Van Assche wrote:
> > If an SRP target sends an invalid SRP_RSP information unit to the SRP
> > initiator this can cause a NULL pointer dereference on the initiator system.
> > This patch avoids such NULL pointer dereferences and makes sure the SRP
> > inititator keeps working.
>
> While I'm all for increasing the robustness of the initiator, I'm
> curious how you would hit this -- I don't see where we would send a SRP
> request without an associated SCSI command.
>
> I'm also not sure you're doing the right thing here -- you seem to skip
> the cleanup of the associated SRP request. I suppose that may be handled
> for you if/when srp_abort() gets called for a missed SCSI request, but
> again, we should never be in the situation where a request doesn't have
> a SCSI command. And if srp_abort() doesn't get called, we've leaked a
> request and possibly a DMA mapping, no?

This condition was hit accidentally while testing newly added target
code that sent an SRP_RSP not associated with an SRP_CMD or
SRP_TSK_MGMT information unit. Since I was surprised to find a test of
the scmnd pointer in ib_srp.c followed by an unconditional dereference
of it, I coded up this patch.

The target code that triggered this condition has been fixed by now
and even was never committed to its source code repository, so this
patch isn't important to me.

Regarding leaks: isn't there already a leak in the current ib_srp code
if any information unit with another opcode than SRP_RSP is received ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
