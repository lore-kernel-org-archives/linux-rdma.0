From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Mon, 12 May 2014 00:35:23 -0600
Message-ID: <20140512063523.GC27716@obsidianresearch.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com>
 <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com>
 <20140508190951.GB25849@obsidianresearch.com>
 <CAL1RGDUiBtOaYKZVR3ghOZzG6J0p5EV5o4FTTW0E43mHz-BaVQ@mail.gmail.com>
 <20140509181043.GC18257@obsidianresearch.com>
 <536F6EAC.8020109@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <536F6EAC.8020109-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 11, 2014 at 03:35:56PM +0300, Or Gerlitz wrote:

> Jason, I am clueless on what you are talking (please read below), I
> think you are mixing things (see the DD comment below too)

Way back at the start, in 2011, when Liran posted this - the first
patch set of this concept did not reorganize the driver startup
process so it needed to have two function pointers to allow libverbs a
chance to hook things.

Instead we re-organized the startup process so that verbs allocates
the context entirely and calls into the driver to set it up. This
allows verbs to do whatever it wants to the function pointers,
including copying the driver version to verbs-private-memory and
overriding with it's own - should that be necessary.

For this reason the drv_/ib_ scheme was entirely removed.

The patches that Tzahi/Sean/etc posted to implement XRC did not use
it, it hasn't been part of the concept for 3 years. Not sure where
you+Matan got the idea from.

> >Or, it would be helpful to me if you could go back to libibverbs
> >commit cbf2a35162a [...] and post the corrected flow steering
> >patches with the ABI/API change as a distinct patch. I think I
> >caught everything, but lets also correct that process error and
> >hopefully Sean/etc can comment too.

> I'm not sure we need to roll back to  commit cbf2a35162a and start
> from there, but if people feel this is the right thing to do, let it
> be.

I would like to see at the very least a clean patch, introducing only
the API for flow steering, that follows the procedure I suggested.

This is to show we are all on the same page. I'm not suggesting
rolling back Roland's tree, just that you go back to that point and
re-issue the patches as a learning exercise for us all.

Follow up with a correction patch to Roland's tip.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
