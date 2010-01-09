From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is
 sequential I/O coalesced, and 3) why is iSCSI faster than SRP in some
 instances
Date: Sat, 09 Jan 2010 13:13:32 -0500
Message-ID: <1263060812.14204.69.camel@obelisk.thedillows.org>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
	 <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
	 <e2e108261001090505w58a70e8ax5cfa522cbf2da9cf@mail.gmail.com>
	 <1263057402.14204.55.camel@obelisk.thedillows.org>
	 <e2e108261001090949x6b4c9e25mfb9e6ad0320879dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001090949x6b4c9e25mfb9e6ad0320879dc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-01-09 at 18:49 +0100, Bart Van Assche wrote:
> On Sat, Jan 9, 2010 at 6:16 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > Does SRPT support the RDMA'ing the indirect buffer descriptors from the
> > Initiator such that it isn't constrained by the partial memory
> > descriptor list in the command request? The initiator restricts itself
> > to 255 SG entries because I've not found a target that implemented the
> > spec fully, though it'd be nice to be able to guarantee the ability to
> > send larger request sizes. I think this will also become important for
> > running bidirectional commands, since the room for descriptors cached in
> > the command is shared for both directions.
> 
> At this time SRPT only supports indirect buffer descriptors that are
> present entirely in the command request. Regarding the number of SG
> entries: I'm not sure that I understand why you want to be able to
> send SG-lists containing more than 255 SG entries. In the tests I have
> run the throughput gain resulting from SG list sizes above 128 was
> marginal (a few percent).

It depends on the hardware I suppose. It may not make sense for SRPT,
but for some of the vendors I deal with, being able to guarantee 1 MB
requests on IB is worth quite a bit of performance, and their tests on
FC show that larger requests still show enough performance gains to make
it worth it. I've done some experiments, and it looks like while IB is
less happy with all the 4 KB requests, it still can get enough data to
the device to saturate the RAID controller.

For the controllers we're using, 1 MB requests perform better than 512
KB requests, and sending a 4 MB random write request stream (highly seek
intensive) gets us to ~90% IIRC of the 1 MB pure sequential write
performance, without using writeback cache. The controllers have a fair
amount of overhead per request, so doing fewer large requests helps.

Our workload is often largely sequential, with large volumes of data,
but once enough clients start writing, it an become random in a hurry.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
