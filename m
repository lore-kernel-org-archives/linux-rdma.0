From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Thu, 25 Apr 2013 23:56:16 +0300
Message-ID: <CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
	<CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
	<CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
	<20130425201255.GB31863@obsidianresearch.com>
	<1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
	<20130425204357.GD31863@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130425204357.GD31863-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Thu, Apr 25, 2013 at 08:26:45PM +0000, Hefty, Sean wrote:
> > After speaking with Tzahi, my understanding is that the receive work
> > queues all receive on the same QPN, but the send work queues use
> > different QPNs.  The on-wire packets are affected, specifically the
> > ipoib header.  This is why the send QPNs must be sequential, so that
> > a mask can be applied at the receiving side to determine a single
> > source QPN.

> Ah, this seems contrary to the IPoIB specification? Someone should probably talk about how sending from the wrong QPN is acceptable..



AFAIK the IPoIB specification doesn't mandate the QPN of the sender


> As I said, that is ugly. 'TSS' that changes the on-the-wire packet is not TSS. It is just ganging QPs together.
>
> Allocating sequential TSS QPNs is an awful hack, what we really need is a way to force a UD QP's outgoing QPN.


INDEED, but this must be supported by the HW. The patch set is already
supporting the case of HW the knows to do that forcing, quoting  --->
IB_DEVICE_UD_TSS which is set to indicate that the device supports "HW
TSS" which means that the HW is capable of over-riding the source UD
QPN present in sent IB datagram header (DTH) with the parent's QPN
<--- where over such HW the on-the-wire IPoIB header isn't touched.

BUT for the sake of improving performance and being competitive with
tons of Linux Ethernet drivers that support TSS/MQ we still need IPoIB
to support MQ/TSS before such HW is introduced, and as such the chosen
solution was to use reserved fields of the wire header.

How about we discuss RSS 1st? for RSS no wire change is introduced,
lets see if/how we can come to an agreement how the RSS related verbs
should look like and we'll take it from there to TSS.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
