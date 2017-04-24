From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 12:31:37 -0600
Message-ID: <20170424183137.GA27506@obsidianresearch.com>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local>
 <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
 <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
 <20170424181351.GM14088@mtr-leonro.local>
 <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 09:26:17PM +0300, Vasiliy Tolstov wrote:
> 2017-04-24 21:13 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > Yes, if performance is not critical to you.
> > Otherwise, the best solution will be to take a look on implementation
> > of data transfer (various post_send functions) in rdma-core library.
> 
> 
> Hm.. performance is critical for me... How can i create binding for it
> without C deps.

You would have to re-write the user space verbs provider for your
hardware in a non-C language.

What you are asking is enormously non-trivial, rdma is 'special'
because it has a user space driver component that directly
communicates with the hardware, for performance.

I'm not even sure one could implement a non-performant verbs using
just the kernel API without a driver specific helper. The kernel API
does not cover things like CQ parsing, for instance? At least nobody
has ever done it...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
