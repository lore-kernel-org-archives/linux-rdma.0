From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Sat, 9 Jan 2010 18:49:13 +0100
Message-ID: <e2e108261001090949x6b4c9e25mfb9e6ad0320879dc@mail.gmail.com>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
	 <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
	 <e2e108261001090505w58a70e8ax5cfa522cbf2da9cf@mail.gmail.com>
	 <1263057402.14204.55.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1263057402.14204.55.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 9, 2010 at 6:16 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>
> On Sat, 2010-01-09 at 14:05 +0100, Bart Van Assche wrote:
> > The SRP spec says that the target must specify the maximum message
> > size in the SRP_LOGIN_RSP information unit. The largest value one can
> > set the srp_sg_tablesize initiator parameter to is (max. SRP message
> > size defined by the target - 68) / 16. With older SCST-SRPT revisions
> > the maximum SRP message size was 996 bytes, hence a maximum of 58 for
> > srp_sg_tablesize. With newer SCST-SRPT revisions the maximum message
> > size defaults to 2116, which corresponds to a maximum of 128 for
> > srp_sg_tablesize.
>
> I see, thanks for the reminder. It's been a while since I've had to deal
> with that part of the spec, and I've been fortunate that all of the
> vendors I work with have max message sizes that allow 255 entries.
>
> Does SRPT support the RDMA'ing the indirect buffer descriptors from the
> Initiator such that it isn't constrained by the partial memory
> descriptor list in the command request? The initiator restricts itself
> to 255 SG entries because I've not found a target that implemented the
> spec fully, though it'd be nice to be able to guarantee the ability to
> send larger request sizes. I think this will also become important for
> running bidirectional commands, since the room for descriptors cached in
> the command is shared for both directions.

At this time SRPT only supports indirect buffer descriptors that are
present entirely in the command request. Regarding the number of SG
entries: I'm not sure that I understand why you want to be able to
send SG-lists containing more than 255 SG entries. In the tests I have
run the throughput gain resulting from SG list sizes above 128 was
marginal (a few percent).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
