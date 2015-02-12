From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19] IB/ipoib: make sure we reap all our ah on
 shutdown
Date: Thu, 12 Feb 2015 20:10:39 +0200
Message-ID: <54DCEC9F.8030304@mellanox.com>
References: <31ba9a1b4528599de17670083aad043b28eff755.1421964024.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31ba9a1b4528599de17670083aad043b28eff755.1421964024.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/23/2015 12:02 AM, Doug Ledford wrote:
> The introduction of garbage collection for neighbors in the ipoib stack
> caused a leak of resources.  In particular, an ah can have a refcount
> from a mcast struct, from a neigh struct, and from a path struct.  When
> we put an ah ref, the ah gets moved to a dead list to be reaped later if
> the refcount goes to 0.
>
> During ipoib_ib_dev_stop we attempt to reap these ah entries, but since
> that function does not force the neigh garbage collection to be run, it
> can leak any entries held by a neighbor.  And even though the code
> attempts to warn us that we will leak entries, that warning is broken
> because the entries we are leaking will not yet be on the dead_ahs list
> because they still have valid references held elsewhere.  It is during
> shutdown, when we finally kill the neighbor garbage collection, that our
> final ahs will get put on the dead_ahs list, but after the point at
> which we run the neighbor garbage collection, no attempt is made to reap
> the newly added ahs, and because during ipoib_ib_dev_stop we killed the
> ah_reap task, no timed attempt will be made to clear them either.
>
> Instead, create a an ipoib_flush_ah and ipoib_stop_ah routines to use at
> appropriate times to flush out all remaining ah entries before we shut
> the device down.
>
> Additionally do one final flush of our priv->wq before we start tearing
> down ib resources to make sure all possible queued work is done and
> all possible resources freed.
>
> This is done to prevent resource leaks on shutdown, which manifest with
> this message on ib_ipoib module remove:
>
> <ibdev>: ib_dealloc_pd failed

Doug,

If you make this bug fix apply-able before the rest of the series we can 
push it to stable
kernels too, can you make it?

>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Please add above your signature a "Fixes:" line which specifies which 
commit you are fixing, is it this one?

b63b70d87741 IPoIB: Use a private hash table for path lookup in xmit path




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
