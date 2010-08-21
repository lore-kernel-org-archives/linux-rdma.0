From: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 20:04:38 +0200
Message-ID: <201008212004.38523.bs_lists@aakef.fastmail.fm>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm> <AANLkTimMoyEpfYPFSLLqS9ZCg3VyyOQcd4i2zzCQjHMN@mail.gmail.com> <1282408043.20840.13.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282408043.20840.13.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, general-G2znmakfqn7U1rindQTSdQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Saturday, August 21, 2010, David Dillow wrote:
> On Sat, 2010-08-21 at 13:14 +0200, Bart Van Assche wrote:
> > On Fri, Aug 20, 2010 at 9:49 AM, Bernd Schubert
> > 
> > <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org> wrote:
> > > In ib_srp.c sg_tablesize is defined as 255. With that value we see lots
> > > of IO requests of size 1020. As I already wrote on linux-scsi, that is
> > > really sub- optimal for DDN storage, as lots of IO requests of size
> > > 1020 come up.
> > > 
> > > Now the question is if we can safely increase it. Is there somewhere a
> > > definition what is the real hardware supported size? And shouldn't we
> > > increase sg_tablesize, but also set the .dma_boundary value?
> > 
> > (resending as plain text)
> > 
> > The request size of 1020 indicates that there are less than 60 data
> > buffer descriptors in the SRP_CMD request. So you are probably hitting
> > another limit than srp_sg_tablesize.
> 
> 4 KB * 255 descriptors = 1020 KB

We at least verified it indirectly. Lustre-1.8.4 will include a patch to 
incrase SG_ALL from 255 to 256 (not ideal at least for older kernels, as it 
will require at least a order 1 allocation, instead of the previous order 0).
But including that patch into our release and then testing IO sizes with 
QLogic FC definitely made 1020K IO requests to vanish. 

> 
> IIRC, we verified that we were seeing 255 entries in the S/G list with a
> few printk()s, but it has been a few years.

I probably should do that as well, just some time limitations.

> 
> I'm not sure how you came up with 60 descriptors -- could you elaborate
> please?
> 
> > Did this occur with buffered (asynchronous) or unbuffered (direct) I/O
> > ? And in the first case, which I/O scheduler did you use ?
> 
> I'm sure Bernd will speak for his situation, but we've seen it with both
> buffered and unbuffered, with the deadline and noop schedulers (mostly
> on vendor 2.6.18 kernels). CFQ never gave us larger than 512 KB
> requests. Our main use is Lustre, which does unbuffered IO from the
> kernel.

I'm in the DDN Lustre group, so I mainly speak for Lustre as well. I think 
Lustres filterio is directio-like. It is not the classical kernel direct-IO 
interface and provides a few buffers for writes, AFAIK. But it is still almost 
direct-IO and its filterio also immediately sends a disk commit request.

We use the deadline scheduler by default. Differences to noop are  small for 
streaming writes, but for example for mke2fs it is 5 times faster with 
deadline compared to noop.

Cheers,
Bernd

-- 
Bernd Schubert
DataDirect Networks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
