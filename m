From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 2/3] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Fri, 9 May 2014 07:03:02 -0700
Message-ID: <CAL1RGDXEBxAEUF0rn+xkL47wyVkb8+KfkAteLo3S=dnJn2C78A@mail.gmail.com>
References: <CAJZOPZLrLL444ce_hXdnN5_JPfUVAy_Qsj+eVo2-YG3Jqqe01Q@mail.gmail.com>
 <20140508201549.GA32622@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140508201549.GA32622-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 8, 2014 at 1:15 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> From now on I think every proposed API/ABI change should be in an
> isolated patch from anything else, it should be accompanied by other
> patches showing the implementation, and the ABI patch specifically
> should earn a public Reviewed-By from at least two of people who
> designed this monster: Sean, Liran and myself.
>
> Roland?

That would be extremely helpful to me and I support that rule 100%.

> .. and you should start by correcting the flow steering changes, they
> are not up to the standard and haven't earned the above reviews.

Do we have a way of fixing things without breaking ABI, or at least
making the ABI break painless?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
