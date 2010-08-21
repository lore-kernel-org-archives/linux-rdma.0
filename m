From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 12:27:23 -0400
Message-ID: <1282408043.20840.13.camel@obelisk.thedillows.org>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
	 <AANLkTimMoyEpfYPFSLLqS9ZCg3VyyOQcd4i2zzCQjHMN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimMoyEpfYPFSLLqS9ZCg3VyyOQcd4i2zzCQjHMN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>, general-G2znmakfqn7U1rindQTSdQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2010-08-21 at 13:14 +0200, Bart Van Assche wrote:
> On Fri, Aug 20, 2010 at 9:49 AM, Bernd Schubert
> <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org> wrote:
> >
> > In ib_srp.c sg_tablesize is defined as 255. With that value we see lots of IO
> > requests of size 1020. As I already wrote on linux-scsi, that is really sub-
> > optimal for DDN storage, as lots of IO requests of size 1020 come up.
> >
> > Now the question is if we can safely increase it. Is there somewhere a
> > definition what is the real hardware supported size? And shouldn't we increase
> > sg_tablesize, but also set the .dma_boundary value?
> 
> (resending as plain text)
> 
> The request size of 1020 indicates that there are less than 60 data
> buffer descriptors in the SRP_CMD request. So you are probably hitting
> another limit than srp_sg_tablesize.

4 KB * 255 descriptors = 1020 KB

IIRC, we verified that we were seeing 255 entries in the S/G list with a
few printk()s, but it has been a few years.

I'm not sure how you came up with 60 descriptors -- could you elaborate
please? 

> Did this occur with buffered (asynchronous) or unbuffered (direct) I/O
> ? And in the first case, which I/O scheduler did you use ?

I'm sure Bernd will speak for his situation, but we've seen it with both
buffered and unbuffered, with the deadline and noop schedulers (mostly
on vendor 2.6.18 kernels). CFQ never gave us larger than 512 KB
requests. Our main use is Lustre, which does unbuffered IO from the
kernel.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
