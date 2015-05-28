From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be
 returned from verbs API and cache API
Date: Thu, 28 May 2015 11:07:11 -0600
Message-ID: <20150528170711.GA4345@obsidianresearch.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
 <1432045637-9090-8-git-send-email-matanb@mellanox.com>
 <20150519180649.GC18675@obsidianresearch.com>
 <CAAKD3BAifeMcHbDwcaK7F6cjj=mAn3W0Ms2mOmoXDhaquFqKTA@mail.gmail.com>
 <20150520181718.GD28496@obsidianresearch.com>
 <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ@mail.gmail.com>
 <20150528160748.GC2962@obsidianresearch.com>
 <5567439C.7080700@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5567439C.7080700-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 28, 2015 at 07:34:36PM +0300, Or Gerlitz wrote:

> As for the RoCE GID table itself, adding in properly net-devices in their
> native Linux kernel form, namely with if_index and name-space -- seems to me
> the correct way to go.

Well, no, it is goofy. Callers with a path have a if_index/net pair.
Several other callers have an actual struct netdevice.

The first thing roce_gid_table_find_gid_by_port does is convert the
if_index/net pair back to a netdevice. This tells me the API is wrong,
callers that already have a netdevice should just pass it in, and path
is one that should be special cased to search.

But I don't even want to talk about that for a clean up series.

I want to know that the behavior of ib_find_cached_gid does not
change. If it hasn't changed then we don't need to change call
sites to pass in the optional netdev, because it must work as it does
today. Otherwise the cleanup is broken.

So, my specific advice is:

- roce_gid_table_find_gid_by_port should accept a netdevice or null
- Always pass null for the netdevice for all call sites
- Do not change the ib_* APIs during the clean up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
