From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Fri, 8 Jan 2010 14:40:07 -0700
Message-ID: <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262829441.29991.10.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 6, 2010 at 6:57 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrot=
e:
> On Wed, 2010-01-06 at 17:16 -0700, Chris Worley wrote:
>> 1) I'm seeing small block random writes (32KB and smaller) get bette=
r
>> performance over SRP than they do as a local drive. =A0I'm guessing =
this
>> is async behavior: once the written data is on the wire, it's deemed
>> complete, and setting a sync flag would disable this. =A0Is this
>> correct?
>
> No, from the initiator point of view, the request is not complete unt=
il
> the target has responded to the command.
>
>> If not, any ideas why SRP random writes would be faster than
>> the same writes locally?
>
> I would guess deeper queue depths and more cache available on the
> target, especially if you are using a Linux-based SRP target.

I do set the ib_srp initiator "srp_sg_tablesize" to its maximum of 58.
 On the Target, I set the "srp_max_rdma_size" to 128KB (but that won't
effect small blocks).  I also set thread=3D1, to work around another
problem.

>
> But it would only be a guess without knowing more about your setup.
>
>> 2) I'm seeing very poor sequential vs. random I/O performance (both
>> read and write) at small block sizes (random performs well, sequenti=
al
>> performance is poor). =A0I'm using direct I/O and the noop scheduler=
 on
>> the initiator, so there should be no coalescing. =A0Coalescing on th=
ese
>> drives is not a good thing to do, as they are ultra low latency, and
>> much faster if the OS doesn't try to coalesce. =A0Could anything in =
the
>> IB/SRP/SCST stack be trying to coalesce sequential data?
>
> Yes, if you have more requests outstanding than available queue depth=
 --
> ie queue backpressure/congestion -- even noop will merge sequential
> requests in the queue. You could avoid this by setting max_sectors_kb=
 to
> the maximum IO size you wish the drive to see.

I thought if the device was opened with the O_DIRECT flag, then the
scheduler should have nothing to coalesce.
>
> Though, I'd be surprised if there was no benefit at all to the OS
> coalescing under congestion.

=46or sequential I/O benchmarking, I need to see the real results for
that size packet.  Direct I/O works for me everywhere except SRP.

The problem turns out to be more curious: sequential reads and writes
are being coalesced.  I'm getting my IOPS from the diskstats, and
therefore it was very low because the block size given to the device
driver is very high (i.e. 32KB is delivered to the device driver,
while 512 byte blocks were being sent).  So, had I been looking at the
bandwidth, I would have seen it inordinately/artificially high.
What's more curious is the write performance excels when coalesced
(w.r.t. the block size you think you're benchmarking), but the read
performance does not.

>
>
>> 3) In my iSCSI (tgt) results using the HCA as a 10G interface (not
>> IPoIB, but mlnx4_en), comparing this to the results of using the sam=
e
>> HCA as IB under SRP, I get much better results with SRP when
>> benchmarking the raw device, as you'd expect. =A0This is w/ a drive =
that
>> does under 1GB/s. =A0When I use MD to mirror that SRP or iSCSI devic=
e w/
>> an identical local device, and benchmark the raw MD device, iSCSI ge=
ts
>> superior write performance and about equal read performance. =A0Does
>> iSCSI/TGT have some special hook into MD devices that IB/SRP isn't
>> privy to?
>
> Are trying to achieve high IOPS or high bandwidth? I'm guessing IOPS
> from your other comments, but device-mapper (and I suspect MD as well=
)
> used to suffer from an internal limit on the max_sectors_kb -- you co=
uld
> have it set to 8 MB on the raw devices, but MD would end up restricti=
ng
> it to 512 KB. This is unlikely the problem if you are going for IOPS,

I'm doing the MD on the initiator side.  I'll try playing with this.

> but can play a factor in bandwidth.
>
> Then again, since the setup seems to be identical, I'm not sure it is
> your problem here either. :(
>
> Have you tried using the function tracer or perf tools found in recen=
t
> kernels to follow the data path and find the hotspots?

I have not.  I parse the data from diskstats.  A pointer to these
tools would be appreciated.

Chris
>
> Dave
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
