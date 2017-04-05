From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] IB/core: Change completion channel to
 use the reworked objects schema
Date: Wed, 5 Apr 2017 10:10:30 -0600
Message-ID: <20170405161030.GE11251@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-8-git-send-email-matanb@mellanox.com>
 <20170329145344.GB2586@obsidianresearch.com>
 <CAAKD3BCaq2xndM_xtU7OY=wX2Mvw0y2+sqWBg-BSQPKYpfyEWg@mail.gmail.com>
 <20170329222935.GB30605@obsidianresearch.com>
 <CAAKD3BBwiKPLaOvKbmKL0skr8gv3=9==_60L6HiU4SmqGrJOOw@mail.gmail.com>
 <20170330161226.GB19074@obsidianresearch.com>
 <CAAKD3BANZG4966aFz4mDa-xPhVbqrNiuAs_=ZvBcft1SzU5eEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BANZG4966aFz4mDa-xPhVbqrNiuAs_=ZvBcft1SzU5eEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 30, 2017 at 09:54:52PM +0300, Matan Barak wrote:
> > /* Convert a locked reference obtained from rdma_lookup_get_uobject to
> >    a simple kref by dropping the read/write lock. The caller must pair
> >    this with uverbs_uobject_put */
> > void rdma_lookup_to_kref(struct ib_uobject *uobj, bool write);
> >
> > Similarly I think you should add a uobj_remove_commit_kref() wrapper
> > which does remove_commit but leaves the caller with a kref, as that
> > pattern seems to come up alot in this code as well.
> >
> 
> Actually, this isn't that frequent pattern. It mainly happens in
> ib_uverbs_lookup_comp_file.  There's a different pattern of inc_kref
> and then remove_commit which is used in order to copy the latest
> events_reported info before releasing the uobject's memory.

That is the one I was talking about..

> When this destroy function comes from the user-space, the pd object
> is locked, so this test would be atomic and safe. The uobject won't
> be destroyed, until the object itself is destroyed. So effectively,
> it's like taking another kref :)

And this is the sketchyness I don't like - this is something that
would be easy to break and you have to rely on quite a few assumptions
to know that this is 'safe'.

It would be much better to hold the kref - that should be cleaned up
before start messing with this much more.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
