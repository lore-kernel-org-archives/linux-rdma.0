From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Tue, 25 Apr 2017 11:39:12 -0600
Message-ID: <20170425173912.GA6242@obsidianresearch.com>
References: <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
 <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
 <20170424181351.GM14088@mtr-leonro.local>
 <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA@mail.gmail.com>
 <20170424183137.GA27506@obsidianresearch.com>
 <CACaajQt8WZrCWXN5-JGovCcknwV9TKiy5gntzNmTjpmdxf6PJg@mail.gmail.com>
 <20170424201033.GA28656@obsidianresearch.com>
 <CACaajQsMdNt++M=DStZ+27km04xNRRxpbcrSGS9av_qtUgPJHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQsMdNt++M=DStZ+27km04xNRRxpbcrSGS9av_qtUgPJHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 25, 2017 at 02:29:58PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 23:10 GMT+03:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>:
> > Sorry, I ment the kernel API to userspace. The internal kernal API is
> > internally complete of course.
> 
> 
> =(. SO as i understand i need to know how mellanox userspace library
> interract with kernel and hardware ?

and also how to implement user space access to hardware in your new
language, this includes something like the C11 multi-threaded memory
model, unlocked atomics, and processor specific memory barriers (that
even C requires inline asm for)

You may find implementing the above at all will always require some
kind of C calls out..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
