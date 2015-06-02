From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 for-next 07/14] IB/core: GID attribute should be
 returned from verbs API and cache API
Date: Tue, 2 Jun 2015 11:39:56 -0600
Message-ID: <20150602173956.GC17776@obsidianresearch.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
 <1432045637-9090-8-git-send-email-matanb@mellanox.com>
 <20150519180649.GC18675@obsidianresearch.com>
 <CAAKD3BAifeMcHbDwcaK7F6cjj=mAn3W0Ms2mOmoXDhaquFqKTA@mail.gmail.com>
 <20150520181718.GD28496@obsidianresearch.com>
 <CAAKD3BDJtpEhfhsB=o4hc=ARWMt7JgpqvbjXJVvsL_vLZRn8yQ@mail.gmail.com>
 <20150528160748.GC2962@obsidianresearch.com>
 <5567439C.7080700@mellanox.com>
 <20150528170711.GA4345@obsidianresearch.com>
 <CAAKD3BALO6ts66Q0n-BVFz4Niu7L6jX0N-GHLXGp0DQ7Z7c9HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BALO6ts66Q0n-BVFz4Niu7L6jX0N-GHLXGp0DQ7Z7c9HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 02, 2015 at 07:13:00PM +0300, Matan Barak wrote:

> ib_find_cached_gid is used in cm_init_av_by_path. ndev is necessary
> in order to find the correct GID in the GID table, as otherwise if two upper
> devices has the same IP (hence GID), we might not found the bounded
> device correctly.

But this is exactly what the current state of affairs is, right?

> In addition, vendors need to get the MAC of the ndev that relates to the GID
> in order to output a correct Ethernet header. This is currently done though
> ib_get_cached_gid. Without adding gid_attr, you get a buggy implementation
> that upper devices with different HW addresses would all map to the same MAC.

Again, that is current state of affairs, so this change is a bug fix.

And, we don't expect macvlan to work today with RDMA, so it isn't even
a bug fix, it is a feature add.

And.. given the patches I've seen for roce namespaces, I'm not even
convinced this is the right API approach.

So, save it for the roce namespace support discussion, and we can
figure out how to comprehsively deal with multiple netdevs and
roce.

Otherwise, keep with the current code's assumption that there is
on netdev for each roce device.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
