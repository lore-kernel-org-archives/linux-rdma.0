From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: fix dangling pointer references to
	ipoib_neigh and ipoib_path
Date: Thu, 25 Feb 2010 16:41:41 -0800
Message-ID: <1267144901.30294.57.camel@chromite.mv.qlogic.com>
References: <1267126142.30294.25.camel@chromite.mv.qlogic.com>
	 <aday6ihvzqg.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6ihvzqg.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-02-25 at 12:15 -0800, Roland Dreier wrote:
> > When using connected mode, ipoib_cm_create_tx() kmallocs a
>  > struct ipoib_cm_tx which contains pointers to ipoib_neigh and
>  > ipoib_path. If the paths are flushed or the struct neighbour is
>  > destroyed, the pointers held by struct ipoib_cm_tx can reference
>  > freed memory. The fix is to add reference counts to struct
>  > ipoib_neigh and ipoib_path and to add locking when getting
>  > new references.
> 
> Good debugging.
> 
> First look at this patch is that it ends up being rather invasive.  I
> wonder if we could fix this in the other direction by keeping a list of
> the ipoib_cm_tx structures affected in the neigh and path structures,
> and clean the cm_tx stuff up when flushing?
> 
> Also I don't see any issues from a first read, but can you confirm that
> you're not adding more locking/atomic ops (via kref) to the main data path?
> 
>  - R.

I agree it is invasive. I thought it would be easier to discuss
an actual patch than me trying to hand wave about a solution.
Plus, now that I understand the problems better, I'm thinking
of new ways to fix them.

There is most definitely a new lock/unlock in the normal send path
because ipoib_start_xmit() now calls neighbour_priv() which
acquires the priv->lock() and does a kref_get(). I'm not really
sure what things can change while ipoib_start_xmit() is active so
I was being cautious. I guess at a minimum, ipoib_neigh_cleanup()
won't be called by the network stack while ipoib_start_xmit() is
active so the to_ipoib_neigh(neighbour) should be valid without
my added locking.

We could avoid adding a kref_t to struct ipoib_path by replacing
the pointer to ipoib_path in struct ipoib_cm_tx with a
struct ib_sa_path_rec. Otherwise, I think ipoib_flush_paths()
could call into ipoib_cm.c to make sure no ipoib_cm_tx is queued
on the priv->cm.start_list which points to the given struct ipoib_path
(and remove it from the list if found).

I will try these ideas out and send an updated patch based
on the results.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
