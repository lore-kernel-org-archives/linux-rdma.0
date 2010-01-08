From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Fri, 8 Jan 2010 15:39:24 -0700
Message-ID: <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262989053.14204.21.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 8, 2010 at 3:17 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrot=
e:
> On Fri, 2010-01-08 at 14:40 -0700, Chris Worley wrote:
>> On Wed, Jan 6, 2010 at 6:57 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> w=
rote:
>> > On Wed, 2010-01-06 at 17:16 -0700, Chris Worley wrote:
>> >> 1) I'm seeing small block random writes (32KB and smaller) get be=
tter
>> >> performance over SRP than they do as a local drive. =A0I'm guessi=
ng this
>> >> is async behavior: once the written data is on the wire, it's dee=
med
>> >> complete, and setting a sync flag would disable this. =A0Is this
>> >> correct?
>
>> >> If not, any ideas why SRP random writes would be faster than
>> >> the same writes locally?
>> >
>> > I would guess deeper queue depths and more cache available on the
>> > target, especially if you are using a Linux-based SRP target.
>>
>> I do set the ib_srp initiator "srp_sg_tablesize" to its maximum of 5=
8.
>
> The max is 255, which will guarantee you can send up to a 1020 KB I/O
> without breaking it into two SCSI commands. In practice, you're likel=
y
> to be able to send larger requests, as you will often have some
> contiguous runs in the data pages.

I've tried a larger max... 58 is all I can get.  Maybe getting more is
dependent on some other setting.
>
> This is probably not hurting you at smaller request sizes.
>
>> >> 2) I'm seeing very poor sequential vs. random I/O performance (bo=
th
>> >> read and write) at small block sizes (random performs well, seque=
ntial
>> >> performance is poor). =A0I'm using direct I/O and the noop schedu=
ler on
>> >> the initiator, so there should be no coalescing. =A0Coalescing on=
 these
>> >> drives is not a good thing to do, as they are ultra low latency, =
and
>> >> much faster if the OS doesn't try to coalesce. =A0Could anything =
in the
>> >> IB/SRP/SCST stack be trying to coalesce sequential data?
>> >
>> > Yes, if you have more requests outstanding than available queue de=
pth --
>> > ie queue backpressure/congestion -- even noop will merge sequentia=
l
>> > requests in the queue. You could avoid this by setting max_sectors=
_kb to
>> > the maximum IO size you wish the drive to see.
>>
>> I thought if the device was opened with the O_DIRECT flag, then the
>> scheduler should have nothing to coalesce.
>
> Depends on how many I/Os your application has in flight at once,
> assuming it is using AIO or threads. If you have more requests in fli=
ght
> than can be queued, the block layer will coalesce if possible.

I do use AIO, always 64 threads, each w/ 64 outstanding I/O's.  Local
or iSER initiator based, I never see any coalescing.  Only w/ SRP.

>
>> > Though, I'd be surprised if there was no benefit at all to the OS
>> > coalescing under congestion.

Benefit isn't the issue.  It needs to be benchmarked w/o artificial
aids that cloud the results.  I'm not really fond of sequential I/O,
as it seldom really exists in real applications (except for logging
apps), but if I'm going to test it, I need valid numbers.

I could do like the SAN/FC vendors do, and just take the throughput
for 1MB blocks and divide the TPS by 2M and call that the 512 byte
block IOPS ;)

>>
>> For sequential I/O benchmarking, I need to see the real results for
>> that size packet. =A0Direct I/O works for me everywhere except SRP.
>
> Hmm, that seems a bit odd, but there is nothing in the SRP initiator
> that would cause the behavior you are seeing -- it just hands over th=
e
> requests the SCSI and block layers give it. Are you observing this vi=
a
> diskstats at the initiator or the target side of the SRP connection?

Diskstats on the initiator side.

There is the scst_vdisk "Direct I/O" option that's been commented out
of the code, as it's not supposed to work... maybe direct I/O doesn't
work... but that would be the target side.

>
> You could also try using sgp_dd from lustre-iokit, but I've seen some
> oddities from it -- it couldn't drive the hardware I was testing at f=
ull
> speed, where XDD and some custom tools I wrote did.
>
> You may have mentioned this, but are you using the raw device, or a
> filesystem over top of it?

It depends: this #2 issue, sequential vs random: it's atop the raw
block device.  The third issue was atop MD.  As some of this thread
has been snipped, I'm not completely sure which issue we're
discussing.

>
> Also, I've seen some interesting things like device mapper reporting =
a 4
> KB read as 8 512 byte sectors, even though it was handed to DM as a 4=
KB
> request, so there could be gremlins there as well. I don't know how t=
he
> MD device driver reports this.
>
> What does the output of 'cd /sys/block/sda/queue && head *' look like=
,
> where sda should be replaced with the SRP disk. It would also be
> interesting to see that for iSCSI, and
> in /sys/class/scsi_disk/0:0:0:0/device for both connection types to s=
ee
> if there is a difference.

Initiator or target?  The target side isn't a SCSI device, it's a
block device.  I guess I could use scst_local to make it look
scsi-ish.

>
>> > Have you tried using the function tracer or perf tools found in re=
cent
>> > kernels to follow the data path and find the hotspots?
>>
>> I have not. =A0I parse the data from diskstats. =A0A pointer to thes=
e
>> tools would be appreciated.
>
> You can find information on them in the kernel source, under
> Documentation/trace/ftrace.txt and tools/perf/Documentation
>
> You can also try blktrace.

Thanks,

Chris
>
> Dave
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
