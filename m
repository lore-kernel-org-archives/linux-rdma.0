From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/libmlx4] Return ERRNO codes from ibv_post_send/recv
 instead of -1
Date: Wed, 9 Mar 2011 10:00:29 -0700
Message-ID: <20110309170029.GA15419@obsidianresearch.com>
References: <20110309012810.GM22729@obsidianresearch.com>
 <AANLkTikfGw=ORf=B9x0Z8rrfnxOV=j0ynaSvRZ6j1sVt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikfGw=ORf=B9x0Z8rrfnxOV=j0ynaSvRZ6j1sVt-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2011 at 05:04:30PM +0100, Bart Van Assche wrote:
> On Wed, Mar 9, 2011 at 2:28 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > - ? ? ? ? ? ? ? ? ? ? ? ret = -1;
> > + ? ? ? ? ? ? ? ? ? ? ? ret = ENOMEM;
> 
> I'm afraid that this will break any code that tests return values with
> the test "< 0". Introducing error codes is good, but why to change
> negative return codes into positive ?

Any code that checks for < 0 is already broken. This is just the mlx4
userspace driver, other drivers correctly return positive errno, eg
any driver that uses the ibv_cmd_post_send path returns positive
errno.

The standard convention for ibverbs, clearly stated in the manual
is that 0 is success and everything else is errno.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
