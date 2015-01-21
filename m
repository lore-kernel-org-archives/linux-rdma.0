From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for multicast handling
Date: Wed, 21 Jan 2015 22:34:22 +0200
Message-ID: <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ@mail.gmail.com>
References: <cover.1421725318.git.dledford@redhat.com>
	<54BE7F66.4070404@dev.mellanox.co.il>
	<CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 21, 2015 at 7:19 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jan 20, 2015 at 8:16 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

>> After trying your V4 patch series, I can tell that first, the endless scheduling of
>> the mcast task is indeed over, but still, the multicast functionality in ipoib is unstable.

> Is this worse than 3.18?  (Have you tested that?)

Roland, Doug,

To be fully clear here by "this" we're talking on seven patches of
complexity and volume which I think go way beyond post -rc5 timeline:

  IB/ipoib: Fix failed multicast joins/sends
  IB/ipoib: Add a helper to restart the multicast task
  IB/ipoib: make delayed tasks not hold up everything
  IB/ipoib: Handle -ENETRESET properly in our callback
  IB/ipoib: don't restart our thread on ENETRESET
  IB/ipoib: remove unneeded locks
  IB/ipoib: fix race between mcast_dev_flush and mcast_join

 drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 204 +++++++++++++++----------
 2 files changed, 121 insertions(+), 84 deletions(-)

Doug, I understand your claim and frustration that with 3.18 and such
(older kernels) your ifdown/up loop manages to break the driver, but
fixing the driver such that this test works and in the same time
practically breaking IPv6 and IPv5 multicast introduces a deep
regression vs. 3.18 - which as you wrote here, would be wrong to fix
with such a further big change.

Are you really sure that reverting the offending patch 016d9fb25cd9
"IPoIB: fix MCAST_FLAG_BUSY usage" and maybe some more dependent
related hunks from downstream patches of that series isn't possible?

If this is the case, I would suggest that we either revive the review
on the fix we sent [1] or drop the whole 3.19-rc1 changes. I vote for
the former.

[1] http://marc.info/?l=linux-rdma&m=142064313123254&w=2

> Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
> the other hand we don't want to introduce new regressions to fix the
> old issues.

See above, we did introduced regressions.

> I think we only have a few days to decide whether to revert back to
> 3.18 code, or push forward with these fixes.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
