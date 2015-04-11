From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Stepping down as maintainer (was Re: [PATCH for-next 0/9] mlx4
 changes in virtual GID management)
Date: Sun, 12 Apr 2015 01:51:23 +0300
Message-ID: <CAJ3xEMiky+s55zsqH0Vxpw8wmk3uGsx1wyMdNqsFihCaiBDgtw@mail.gmail.com>
References: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxPQX+hBiEcaWD7DOAeLEmi9bWMeE06to+QyCdo3pAU+Yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 9, 2015 at 8:41 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Apr 7, 2015 at 10:12 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> I don't think you understand how deep the problem Or is describing goes.

>> [...Appropriate and correct critique...]

> This thread has made me realize that even as I am able to carve out
> more time to work on things like IB maintaintership, I no longer have
> the desire to spend my time maintaining the IB subsystem.  Since my
> current level of activity is clearly hurting the community, I've
> decided to step down as maintainer.

> I'm on a perhaps-unfortunately-timed vacation this week

OK, but this is the last time for making these excuses (...)

> but to make the transition smooth, I'll handle the easy patches that are in flight
> for 4.1 and then turn things over to the community for 4.2

Sounds a fair plan to me.

As we're just two days before the merge window is likely to open,
could you please but ASAP immediately make what's queued @ your
for-next branch private clone public?!

currently, there's nothing there expect for one 4.- rc fix.

Some from top of my head quick listing contains:

1. Doug's IPoIB patches which finally passed full review and
regression by Erez Shitrit @ Mellanox plus some review and testing by
Intel/Ira
http://marc.info/?t=142456493600003&r=1&w=2

2. Erez's followup patch series which few IPoIB changes and one mlx4 fix
http://marc.info/?l=linux-rdma&m=142797117721383&w=2

3. Yishai's mlx4 patches (where we started this thread)
http://marc.info/?l=linux-rdma&m=142788688230585&w=2

4. Sagi's iSER updates for 4.1 - which you acked but didn't make public

Unfortunately, Sean -- you haven't provided for > 2 months any
feedback on the patches to the CM/CMA modules which you own/maintain
for supporting name-spaces and such which are part of enabling proper
RDMA support for containers.
http://marc.info/?l=linux-netdev&m=142366747608908&w=2 This makes your
co-maintainer position sort of problematic, BTW. Jason, any chance you
can look on
that?

As for the core and driver RoCE changes, I see that there are comments
from Sean and Bart, so the review isn't over yet.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
