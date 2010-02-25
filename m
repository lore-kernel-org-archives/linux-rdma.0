From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: fix dangling pointer references to ipoib_neigh and ipoib_path
Date: Thu, 25 Feb 2010 12:15:19 -0800
Message-ID: <aday6ihvzqg.fsf@roland-alpha.cisco.com>
References: <1267126142.30294.25.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1267126142.30294.25.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Thu, 25 Feb 2010 11:29:02 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > When using connected mode, ipoib_cm_create_tx() kmallocs a
 > struct ipoib_cm_tx which contains pointers to ipoib_neigh and
 > ipoib_path. If the paths are flushed or the struct neighbour is
 > destroyed, the pointers held by struct ipoib_cm_tx can reference
 > freed memory. The fix is to add reference counts to struct
 > ipoib_neigh and ipoib_path and to add locking when getting
 > new references.

Good debugging.

First look at this patch is that it ends up being rather invasive.  I
wonder if we could fix this in the other direction by keeping a list of
the ipoib_cm_tx structures affected in the neigh and path structures,
and clean the cm_tx stuff up when flushing?

Also I don't see any issues from a first read, but can you confirm that
you're not adding more locking/atomic ops (via kref) to the main data path?

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
