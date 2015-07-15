From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 13:39:21 -0500
Message-ID: <005001d0bf2d$90a3c5b0$b1eb5110$@opengridcomputing.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150713163015.GA23832@obsidianresearch.com> <55A4CABC.5050807@dev.mellanox.co.il> <20150714153347.GA11026@infradead.org> <55A534D1.6030008@dev.mellanox.co.il> <20150714163506.GC7399@obsidianresearch.com> <55A53F0B.5050009@dev.mellanox.co.il> <20150714170859.GB19814@obsidianresearch.com> <55A6136A.8010204@dev.mellanox.co.il> <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com> <20150715171926.GB23588@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715171926.GB23588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, July 15, 2015 12:19 PM
> To: Chuck Lever
> Cc: Sagi Grimberg; Christoph Hellwig; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Ste=
ve Wise; Or Gerlitz; Oren Duer; Bart Van Assche; Liran Liss; Hefty,
> Sean; Doug Ledford; Tom Talpey
> Subject: Re: Kernel fast memory registration API proposal [RFC]
>=20
> On Wed, Jul 15, 2015 at 10:32:55AM -0400, Chuck Lever wrote:
>=20
> > I would rather not build a non-deterministic delay into the
> > unmap interface. Using a pool or having map do an implicit
> > unmap are both solutions I=E2=80=99d rather avoid.
>=20
> Can you explain how NFS is using FMR today? When does it unmap a FMR
> rkey and lkey?
>=20
> If NFS/etc currently have a hole on rkey invalidation when using FMR,
> and that hole simply cannot reasonably be solved, I'm actually mildly=
 OK
> with enshrining that in a new MR API..
>=20
> So, it would seem to me, the only major addition we'd need to Sagi's
> draft to support FMR, would be a way to catch the completion (the
> rdma_unreg_mr) and trigger async MR recycling async in a work queue.
>=20
> Sagi, how does cleanup of the temporary FRMR work in your draft
> proposal? What does the ULP do upon completion?
>=20
> [Also, just mildly curious, how do we get into an unsleepable
>  context anyhow? is the IB completion pending callback called in a
>  sleepable context?]
>=20

=46rom Documentation/infiniband/core_locking.txt:

  The context in which completion event and asynchronous event
  callbacks run is not defined.  Depending on the low-level driver, it
  may be process context, softirq context, or interrupt context.
  Upper level protocol consumers may not sleep in a callback.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
