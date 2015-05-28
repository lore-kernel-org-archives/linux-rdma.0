From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Thu, 28 May 2015 00:19:23 -0600
Message-ID: <20150528061923.GA4054@obsidianresearch.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
 <20150525165449.GA4379@obsidianresearch.com>
 <1432742669.28905.228.camel@redhat.com>
 <55662D63.3030806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55662D63.3030806-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 11:47:31PM +0300, Yishai Hadas wrote:
> That's correct, it was chosen from performance reasons to enable parallel
> commands as part of ib_uverbs_write with minimum synchronization overhead
> comparing the rwsem.

The locking scheme makes no sense, see my other email, design it for a
rwsem and then consider rcu if necessary.

Hint: Get rid of dev->disassociated and use ib_dev == null to
accomplish the same thing. Now it is clear that ib_dev is what must be
protected by a rwlock and the locking scheme will flow sanely from
that point. If you must use RCU for performance then it is now clear
that rcu_dereference must be applied to the ib_dev.

Then the other locking can stop being so subtle:

-----
ib_uverbs_close:

down(lists_mutex)
tmp = file->ucontext;
if (tmp) {
   list_del(&file->list);
   file->ucontext = NULL;
}
up(lists_mutex);

if (tmp)
  ib_uverbs_cleanup_ucontext(file, tmp);

-----
ib_uverbs_free_hw_resources:

down(lists_mutex)
while (!lists_empty(&uverbs_dev->uverbs_file_list) {
  file = list_first_entry(&uverbs_dev->uverbs_file_list, list)
  tmp = file->ucontext;
  list_del(&file->list);
  file->ucontext = NULL;
  kref_get(&file->ref);
  up(list_mutex);
      
  ib_uverbs_cleanup_ucontext(file, tmp);

  down(list_mutex);
  kref_put(&file->ref,ib_uverbs_release_file);
}
up(list_mutex);

Now the krefs are unquestionably paired, we don't leave a dangling
ucontext pointer, we don't leave a dangling list entry, locking of the
list is explicit and doesn't rely on an unlocked access with an
implicit exclusion. Basically, it is actually obvious what each lock
is protecting.

> In case the low level driver can be unloaded (e.g. rmmod mlx4_ib)
> unconditionally to active uverbs clients we should prevent the module
> dependency by ignoring the get/put mechanism. Hope that it clarifies the
> usage here.

Okay, that does make sense. But I do suspect try_module_get should still
be run, just immediately released. Otherwise the check for in-progress
module removal is skipped.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
