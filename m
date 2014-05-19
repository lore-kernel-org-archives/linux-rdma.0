From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V2 RFC 0/3] svcrdma: refactor marshalling logic
Date: Mon, 19 May 2014 19:07:11 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FDFE42E@CMEXMB1.ad.emulex.com>
References: <20140506174621.18208.24242.stgit@build.ogc.int>
 <20140506192730.GK18281@fieldses.org>
 <53694F72.9010007@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53694F72.9010007-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

While testing with ocrdma driver I am finding server side SQ full. Following is the log, yet to identify why it's happening. Once this is reported Client side crashes due to some reason.
My kdump is not working properly therefore I am not able to analyze the situation properly.

May 19 23:47:02 neo01-el64 kernel: svcrdma: RDMA_WRITE rmr=8008b12, to=45a2d790c, xdr_off=0, write_len=68, vec->sge=ffff88086cb4a0c8, vec->count=2
May 19 23:47:02 neo01-el64 kernel: svcrdma: send_reply returns 0
May 19 23:47:02 neo01-el64 kernel: svc: server ffff88086409a000 waiting for data (to = 3600000)
May 19 23:47:02 neo01-el64 kernel: svc: transport ffff88087dfa2400 served by daemon ffff88086409a000
May 19 23:47:02 neo01-el64 kernel: svc: server ffff88086409a000, pool 0, transport ffff88087dfa2400, inuse=18
May 19 23:47:02 neo01-el64 kernel: svcrdma: rqstp=ffff88086409a000
May 19 23:47:02 neo01-el64 kernel: svcrdma: processing ctxt=ffff880866754540 on xprt=ffff88087dfa2400, rqstp=ffff88086409a000, status=0
May 19 23:47:02 neo01-el64 kernel: svcrdma: failed to post SQ WR rc=-22, sc_sq_count=0, sc_sq_depth=128
May 19 23:47:02 neo01-el64 kernel: svcrdma: Error -22 posting RDMA_READ
May 19 23:47:02 neo01-el64 kernel: svc: got len=0
May 19 23:47:02 neo01-el64 kernel: svc: transport ffff88087dfa2400 served by daemon ffff88086e782000
May 19 23:47:02 neo01-el64 kernel: svc: transport ffff88087dfa2400 busy, not enqueued
May 19 23:47:02 neo01-el64 kernel: svc: server ffff88086409a000 waiting for data (to = 3600000)
May 19 23:47:02 neo01-el64 kernel: svc_recv: found XPT_CLOSE
May 19 23:47:02 neo01-el64 kernel: svc: svc_delete_xprt(ffff88087dfa2400)
May 19 23:47:02 neo01-el64 kernel: svc: svc_rdma_detach(ffff88087dfa2400)

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Wednesday, May 07, 2014 2:39 AM
> To: J. Bruce Fields
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
> Subject: Re: [PATCH V2 RFC 0/3] svcrdma: refactor marshalling logic
> 
> On 5/6/2014 2:27 PM, J. Bruce Fields wrote:
> > On Tue, May 06, 2014 at 12:46:21PM -0500, Steve Wise wrote:
> >> This patch series refactors the NFSRDMA server marshalling logic to
> >> remove the intermediary map structures.  It also fixes an existing
> >> bug where the NFSRDMA server was not minding the device fast register
> >> page list length limitations.
> >>
> >> I've also made a git repo available with these patches on top of 3.15-rc4:
> >>
> >> git://git.openfabrics.org/~swise/linux svcrdma-refactor
> >>
> >> Changes since V1:
> >>
> >> - fixed regression for devices that don't support FRMRs (see
> >>    rdma_read_chunk_lcl())
> >>
> >> - split patch up for closer review.  However I request it be squashed
> >>    before merging as they is not bisectable, and I think these changes
> >>    should all be a single commit anyway.
> > If it's not split up in a way that's bisectable, then yes, just don't
> > bother.
> 
> I didn't see a good way to split it up, have it bisectable, and not have all the
> big stuff in one patch.  I think its a little more reviewable in these 3 patches,
> but when I post V3, I'll put it back as an uber patch.
> Hopefully folks can have a look at these 3 patches ignoring the bisect
> issue.    Having said that, the rdma read logic really is better
> reviewed by look at the code after applying the patches.   That's why I
> published a git branch.
> 
> Thanks!
> 
> Steve.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
