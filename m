From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: manual merge of the infiniband tree with the vfs tree
Date: Fri, 26 Feb 2010 14:02:55 -0800
Message-ID: <adazl2vvenk.fsf@roland-alpha.cisco.com>
References: <20100226130518.94c5a5f8.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100226130518.94c5a5f8.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> (Stephen
	Rothwell's message of "Fri, 26 Feb 2010 13:05:18 +1100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Today's linux-next merge of the infiniband tree got a conflict in
 > drivers/infiniband/core/uverbs_main.c between commit
 > ce916e2b935f8b3402da1457ff23b9f9f786c09b ("switch infiniband uverbs to
 > anon_inodes") from the vfs tree and commit
 > 4169c4a9735d6434c9e39fa81ae5517e3afd4cd8 ("IB/uverbs: Use anon_inodes
 > instead of private infinibandeventfs") from the infiniband tree.
 > 
 > These two commits purport to do something similar.  Someone should look
 > at them both and decide which one is right.  For now I have used the
 > version from the vfs tree - with the addition of the part from the
 > infiniband tree version that selects ANON_INODES in the Kconfig file.

Huh, I didn't see that vfs commit and as far as I can tell it was never
posted anywhere.  Which I guess is why we have linux-next :)

Anyway, both commits look essentially equivalent -- Al's moves the fd
allocation to callers, which is OK with me (a bit of duplicated code but
maybe a bit better layering of functions).  I would like to see the
Kconfig part go in as part of the patch, although I guess it's not such
a terrible bit of breakage to fix up a bit after the fact.  (Not a real
bisection killer)

Al, let me know what you want to do -- I can pick up your patch or drop
the patch from my tree, either way is fine.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
