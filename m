From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IB equivalent of virtual IP address ?
Date: Wed, 23 Feb 2011 09:51:39 -0700
Message-ID: <20110223165139.GB2363@obsidianresearch.com>
References: <AANLkTinTwygiSzBC3-AJjt070RTz_B=qYqcm9AayPwPn@mail.gmail.com>
 <20110222174729.GA10273@obsidianresearch.com>
 <AANLkTimwRGWNG76xkHxHATnbOZsNTSC=1s_8pOng_B9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimwRGWNG76xkHxHATnbOZsNTSC=1s_8pOng_B9f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 23, 2011 at 12:13:53PM +0100, Bart Van Assche wrote:

> The reason I started looking for an alternative for setting up
> multipath between one SRP initiator and redundant SRP targets is
> because such a configuration is a little awkward to set up.

You don't actually have to setup multipath, just use the data as a
fail over list. If the first GID's PR fails, try the next, etc. Same
effect as GID migration, but without the special cases.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
