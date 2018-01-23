From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA
 subsystem
Date: Tue, 23 Jan 2018 17:21:54 +0000
Message-ID: <OF19AC575F.7C7F1B2D-ON0025821E.005EB9EC-0025821E.005F63D2@notes.na.collabserv.com>
References: <20180123164316.GC30670@ziepe.ca>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123164316.GC30670-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote: -----

>To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
>Date: 01/23/2018 05:43PM
>Cc: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network
>and RDMA subsystem
>
>On Tue, Jan 23, 2018 at 10:33:48AM -0600, Steve Wise wrote:
>
>> > +/* Restrict usage of GSO, if hardware peer iwarp is unable to
>process
>> > + * large packets. gso_seg_limit = 1 lets siw send only packets
>up to
>> > + * one real MTU in size, but severly limits maximum bandwidth.
>> > + * gso_seg_limit = 0 makes use of GSO (and more than doubles
>throughput
>> > + * for large transfers).
>> > + */
>> > +const int gso_seg_limit;
>> > +
>> 
>> The GSO configuration needs to default to enable interoperation
>with all
>> vendors (and comply with the RFCs).  So make it 1 please.
>
>The thing we call GSO in the netstack should be totally transparent
>on
>the wire, so at the very least this needs some additional
>elaboration.
>
>> Jason, would configfs be a reasonable way to allow tweaking these
>globals?
>
>Why would we ever even bother to support a mode that is
>non-conformant
>on the wire? Just remove it..
>

siw as a software RDMA provider benefits from GSO alot.
Building 8 frames with 8 headers and trailers brings max
throughput down to some 3.5GB/s. Using GSO, and shipping
64K we see 7.8GB/s or so. That's what TCP on the socket API
has to offer.

Strictly speaking, siw reads the current segment size
as it gets it from TCP. Older Chelsio adapters were able
to process large packets, the latest HW is not it seems.

I was thinking of leaving frame size as one MTU, but check
if the peer (siw?) can handle more. There are sufficient
spare bits in the MPA req/rep header to negotiate that,
which shall be ignored by hardware ;)

siw can never fully comply with what a hardware iwarp
wants to get - it sits on top of a TCP stream. Under
load, we see lots of frame fragmentation somewhere in
the middle - sometimes just the header makes it glued
after the trailer of the previous frame in one TCP
segment, sometimes the wire-frame breaks in the middle
of the data part, sometimes all data of a DDP frame are
there, but the trailer checksum is still missing...the
TCP send window is something siw cannot influence.

Thanks,
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
