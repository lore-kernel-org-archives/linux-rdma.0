From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 14:10:33 -0600
Message-ID: <20170424201033.GA28656@obsidianresearch.com>
References: <20170424104259.GH14088@mtr-leonro.local>
 <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local>
 <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
 <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
 <20170424181351.GM14088@mtr-leonro.local>
 <CACaajQvf4fioVGoYqJexhOAbNFJPK0aYGbFW+52z3NFU9RKQcA@mail.gmail.com>
 <20170424183137.GA27506@obsidianresearch.com>
 <CACaajQt8WZrCWXN5-JGovCcknwV9TKiy5gntzNmTjpmdxf6PJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACaajQt8WZrCWXN5-JGovCcknwV9TKiy5gntzNmTjpmdxf6PJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 10:49:00PM +0300, Vasiliy Tolstov wrote:
> Hm. For example some times ago i'm use srp/scst that utilize only
> kernel space code.
> I don't know any performance issues with it (but may be it presented..).

Sorry, I ment the kernel API to userspace. The internal kernal API is
internally complete of course.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
