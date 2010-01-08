From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is
 sequential I/O coalesced, and 3) why is iSCSI faster than SRP in some
 instances
Date: Fri, 08 Jan 2010 18:07:57 -0500
Message-ID: <1262992077.14204.39.camel@obelisk.thedillows.org>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>
	 <1262829441.29991.10.camel@obelisk.thedillows.org>
	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>
	 <1262989053.14204.21.camel@obelisk.thedillows.org>
	 <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001081439j3730acefrbfcf523b0da06306-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-01-08 at 15:39 -0700, Chris Worley wrote:
> On Fri, Jan 8, 2010 at 3:17 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> > On Fri, 2010-01-08 at 14:40 -0700, Chris Worley wrote:
> >> I do set the ib_srp initiator "srp_sg_tablesize" to its maximum of 58.
> >
> > The max is 255, which will guarantee you can send up to a 1020 KB I/O
> > without breaking it into two SCSI commands. In practice, you're likely
> > to be able to send larger requests, as you will often have some
> > contiguous runs in the data pages.
> 
> I've tried a larger max... 58 is all I can get.  Maybe getting more is
> dependent on some other setting.

options ib_srp srp_sg_tablesize=255

in modprobe.conf is all that's needed. You can
check /sys/module/ib_srp/parameters/srp_sg_tablesize
to be sure it took effect. 255 is not dependent on any other settings,
but other limits can keep you from using all of the S/G entries.

But this still isn't hurting you at the small request sizes we seem to
be talking about. Or do you mean 58 KB, which is believable -- the
default is 12, which guarantees a 48 KB request size is possible, and
you'd only need a few pages to coalesce and you be there. Of course, 58
isn't a multiple of 4, so maybe it isn't just me misunderstanding.

> >> I thought if the device was opened with the O_DIRECT flag, then the
> >> scheduler should have nothing to coalesce.
> >
> > Depends on how many I/Os your application has in flight at once,
> > assuming it is using AIO or threads. If you have more requests in flight
> > than can be queued, the block layer will coalesce if possible.
> 
> I do use AIO, always 64 threads, each w/ 64 outstanding I/O's.  Local
> or iSER initiator based, I never see any coalescing.  Only w/ SRP.

With 64 requests, you open the possibility of coalescing, as the maximum
queue depth of the unmodified SRP initiator is 63. Or do you mean 64 *
64 == 4096 requests? In that case you are virtually guaranteed to get
coalescing.

Have you tried lower numbers of requests in flight to see if there is a
threshold where the coalescing stops?

> >> For sequential I/O benchmarking, I need to see the real results for
> >> that size packet.  Direct I/O works for me everywhere except SRP.
> >
> > Hmm, that seems a bit odd, but there is nothing in the SRP initiator
> > that would cause the behavior you are seeing -- it just hands over the
> > requests the SCSI and block layers give it. Are you observing this via
> > diskstats at the initiator or the target side of the SRP connection?
> 
> Diskstats on the initiator side.

> > You may have mentioned this, but are you using the raw device, or a
> > filesystem over top of it?
> 
> It depends: this #2 issue, sequential vs random: it's atop the raw
> block device.  The third issue was atop MD.  As some of this thread
> has been snipped, I'm not completely sure which issue we're
> discussing.

Sorry, I hate to wade through oceans of text to find a reply, but
sometimes I snip too much. I was curious if any of the tests were over a
filesystem, and it sounds like the answer is no. That's good, it rules
out a variable. Let's focus on getting the raw block device tests doing
what you want, and then worry about the MD layer later.

> > What does the output of 'cd /sys/block/sda/queue && head *' look like,
> > where sda should be replaced with the SRP disk. It would also be
> > interesting to see that for iSCSI, and
> > in /sys/class/scsi_disk/0:0:0:0/device for both connection types to see
> > if there is a difference.
> 
> Initiator or target?  The target side isn't a SCSI device, it's a
> block device.  I guess I could use scst_local to make it look
> scsi-ish.

Let's just worry about initiator side for now -- I know very little
about SCST's implementation. If we can get to where we're sending the
desired requests from the initiator, you can take up issues with the
target side with someone else. :)

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
