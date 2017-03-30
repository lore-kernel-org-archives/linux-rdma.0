From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] IB/core: Change completion channel to
 use the reworked objects schema
Date: Thu, 30 Mar 2017 10:12:26 -0600
Message-ID: <20170330161226.GB19074@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-8-git-send-email-matanb@mellanox.com>
 <20170329145344.GB2586@obsidianresearch.com>
 <CAAKD3BCaq2xndM_xtU7OY=wX2Mvw0y2+sqWBg-BSQPKYpfyEWg@mail.gmail.com>
 <20170329222935.GB30605@obsidianresearch.com>
 <CAAKD3BBwiKPLaOvKbmKL0skr8gv3=9==_60L6HiU4SmqGrJOOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBwiKPLaOvKbmKL0skr8gv3=9==_60L6HiU4SmqGrJOOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 30, 2017 at 06:47:02PM +0300, Matan Barak wrote:

> The problem with that is that get_read also locks the object for
> reading (so if you try to lock it for write or destroy it, you'll
> get a locking error).  So, you want to increase the reference count
> to ensure it exists in the memory, but unlock it.

Okay, I see. I've looked at the whole thing more closely and there are
more places that should be holding krefs, so I think you should make a
function specifically for this pattern.

/* Convert a locked reference obtained from rdma_lookup_get_uobject to
   a simple kref by dropping the read/write lock. The caller must pair
   this with uverbs_uobject_put */
void rdma_lookup_to_kref(struct ib_uobject *uobj, bool write);

Similarly I think you should add a uobj_remove_commit_kref() wrapper
which does remove_commit but leaves the caller with a kref, as that
pattern seems to come up alot in this code as well.

Looking at things after this series is applied, there are two more
areas that need some more work in future patches before adding the new
uapi stuff..

usecnt is confused, the uapi part makes sense, we must hold uobj read
when doing atomic_inc and uobj write when doing atomic_dec. However
the kapi does something entirely different. Maybe we should delete
usecnt from the kapi side?

Lots of places that incr usecnt fail to hold the kref:

     pd = uobj_get_obj_read(pd, cmd.pd_handle, file->ucontext);
     
     mr->device  = pd->device;
     mr->pd      = pd;
     mr->uobject = uobj;
     atomic_inc(&pd->usecnt);

     uobj_put_obj_read(pd);

It really should be doing rdma_lookup_to_kref(pd) and have the proper
put in the destroy of the pd uobj. Many other places like this as
well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
