From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be
 returned from verbs API and cache API
Date: Thu, 28 May 2015 10:07:48 -0600
Message-ID: <20150528160748.GC2962@obsidianresearch.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
 <1432045637-9090-8-git-send-email-matanb@mellanox.com>
 <20150519180649.GC18675@obsidianresearch.com>
 <CAAKD3BAifeMcHbDwcaK7F6cjj=mAn3W0Ms2mOmoXDhaquFqKTA@mail.gmail.com>
 <20150520181718.GD28496@obsidianresearch.com>
 <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 04:50:09PM +0300, Matan Barak wrote:

> The argument for removing the gid_type seems reasonable to me.
> However, I don't think we should be removing net.
> if_index should always come with net - passing only if_index makes
> roce_gid_table's API a bit broken.

Well, get rid of if_index too? Isn't all of that rocev2 stuff? Todays
roce drivers do not need if_index at this point to do gid index lookup.

It isn't clear to me why that should change in a refactoring exercise.

> Patch 8 (the ndev part) is relevant. GID is now related to a ndev and
> we would like
> to expose this information to the user.
> In non rdma-cm applications, how would a user select the gid_index he wants?

I don't mean drop forever, I mean, concentrate on getting this clean
up done, then start discussing UAPI changes separately. Please don't
bury UAPI changes, new features, etc in a cleanup patch series.

> > I'm also not sure about patch 10, that looks like a functional
> > change? It should not be in a cleanup series.
> 
> We drop smac and vlan_id from path and av. Instead, it's taken
> from the netdev in roce_gid_table. That's a crucial part of the new
> architecture.

Again, I didn't say drop it forever, these patches belong in a later
series, perhaps as a precursor series to rocev2.

> It's not worth adding roce_gid_table and not taking the parameters
> based on its information.

It should be worth adding roce_gid_table because it factors duplicate
existing code out of several drivers. Get that merged, then deal with
adding rocev2, adding new UAPIs, etc.

If that isn't true then we have a problem :)

You started with a giagantic series that added new UAPIs, refactored
code, clean ups, added rocev2, and maybe more I haven't noticed. That
is too big to review. Make it smaller:

- Refactor the gid table code from the drivers - as is. Minimize
  changes elsewhere
- Add rocev2 in stages
- New UAPIs for rocev2
- Anything else I missed.

Don't try and do so much at once.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
