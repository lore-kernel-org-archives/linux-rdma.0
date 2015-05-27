From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 09/10] IB/mlx4: Add timestamp_mask and
 hca_core_clock to query_device
Date: Wed, 27 May 2015 16:21:08 -0600
Message-ID: <20150527222108.GA7855@obsidianresearch.com>
References: <CAJ3xEMgppUPqOFm7L0+fR3z_N2ALZFb+GpSAGvyyNROZoFCUPA@mail.gmail.com>
 <CAJ3xEMinNsQrmQ7atAVkshefBDBQ1HRuGbOT_cJ4RxEj4dWUPA@mail.gmail.com>
 <20150526160624.GA11800@obsidianresearch.com>
 <CAJ3xEMj5qphSq5QQHKPsihuK6StmJ+NHiPbkY-ZVGmpViB1AXA@mail.gmail.com>
 <20150526185315.GF11800@obsidianresearch.com>
 <CAJ3xEMh7JYN8sP5MYdVjH=tqPFURwvD7jVvV0=PBiEn1qEFi2A@mail.gmail.com>
 <20150526220724.GC4502@obsidianresearch.com>
 <CAJ3xEMgdqBnn6hobRJFut6Nyu2pKt40rb46Z3dYx3MaohR2urA@mail.gmail.com>
 <20150527184856.GA16059@obsidianresearch.com>
 <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMh_g0zBza5HoVZTy9cTRbXqatzvBMAJcRjQhH7Zi=cHAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 12:33:58AM +0300, Or Gerlitz wrote:

> (2) instantly rejecting a usage of a mechanism existing just for that
> use case since the first year of our life (2005)

I didn't reject anything, I said I wanted to see the user side to
continue my review.

> This series is (1) simple compared to other stuff being reviewed here
> nowadays,

What? It is 11 patches, long, introduces several UAPI changes, does
not implement a standardized feature, adds new uses of latent kernel
functions and exists to support a unique feature of a single hardware
vendor that few understand the usecase for.

I would describe this as one of the toughest to review series on
patchworks right now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
