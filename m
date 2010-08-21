From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 16:38:55 -0400
Message-ID: <1282423135.20840.21.camel@obelisk.thedillows.org>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
	 <AANLkTimMoyEpfYPFSLLqS9ZCg3VyyOQcd4i2zzCQjHMN@mail.gmail.com>
	 <1282408043.20840.13.camel@obelisk.thedillows.org>
	 <AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-21 at 19:28 +0200, Bart Van Assche wrote:
> On Sat, Aug 21, 2010 at 6:27 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> >
> > On Sat, 2010-08-21 at 13:14 +0200, Bart Van Assche wrote:
> > > The request size of 1020 indicates that there are less than 60 data
> > > buffer descriptors in the SRP_CMD request. So you are probably hitting
> > > another limit than srp_sg_tablesize.
> >
> > 4 KB * 255 descriptors = 1020 KB
> >
> > IIRC, we verified that we were seeing 255 entries in the S/G list with a
> > few printk()s, but it has been a few years.
> >
> > I'm not sure how you came up with 60 descriptors -- could you elaborate
> > please?
> 
> The original message mentions "size 1020" but not the unit of that
> size. So I guessed that this referred to an SRP_CMD information unit
> of 1020 bytes. And in a SRP_CMD message of 1020 bytes there fit at
> most 59 descriptors ((1020-68)/16). Now that I see your computation,
> I'm afraid that my guess about the meaning of the original message was
> wrong. Looks like I have been delving too deep into the SRP protocol

Sorry, 1020 KB requests have been a perennial thorn in our side, so I'm
intimately familiar with that number. And your deep dives into SRP is
why I asked you to elaborate -- I may have missed something.

> If ib_srp is already sending SRP commands with 255 descriptors,
> changing the configuration of the I/O scheduler or the I/O mode will
> not help.

This is all on the initiator side, but with CFQ we weren't getting 255
descriptors; we only got 512 KB requests. We'd see that with deadline as
well sometimes, but not as much. It seemed to be something in the
scheduler breaking up large requests but we never investigated it since
noop was the recommended scheduler for DDN hardware. We've been
re-evaluating that recently, though.

dm-multipath is another source of size restrictions, since it defaults
to a max_sectors_kb of 512 if the underlying devices have larger limits.
So far the only way to fix that is to patch the kernel or run a
systemtap script to fix it up.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
