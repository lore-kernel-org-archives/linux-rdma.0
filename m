From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Thu, 25 Jun 2015 11:09:37 -0600
Message-ID: <20150625170937.GE21033@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-4-git-send-email-yishaih@mellanox.com>
 <20150624182519.GD21033@obsidianresearch.com>
 <558C0775.4000104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <558C0775.4000104-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 04:51:49PM +0300, Yishai Hadas wrote:
> On 6/24/2015 9:25 PM, Jason Gunthorpe wrote:
> >Is not holding the RCU lock while ib_uverbs_release_dev is reading
> >ib_dev. The barriers in kref are not strong enough to guarentee the RCU
> >protected data will be visible. (remember when I asked if you checked
> >all of these?)
> 
> This is not a locking problem, the only option that here the reference count
> becomes 0 is if ib_uverbs_remove_one was previously called and decreased the
> reference count that was taken upon load. However, it was done after that
> rcu_assign_pointer(uverbs_dev->ib_dev, NULL) was called so the check whether
> if (!dev->ib_dev) is fully protected and can't race with HW removal flow.

The problem with RCU is not to do with instruction concurrancy, you
need to convince yourself the unlocked accesses have *data* coherency,
that is what rcu_derference and friends are all about.

So, looked too briefly yesterday (sorry, busy), but it turns out that
atomic_sub_return guarentees a full smp_mb(), so the data barrier in
kref_put *IS* strong enough for this use. Thus it is OK.

> The kref is used to manage the uverbs_dev allocation, the internal code in
> ib_uverbs_release_dev depends on the state. Usually the natural place to
> free the memory is as part of the release function as done in other kernel
> places. In case that ib_device was previously removed it can be safely freed
> here as it's called when the last client disconnected, this logic is
> introduced by this patch. In case there is a need to wait clients as the
> driver doesn't support HW device removal the free can't be done internally
> but must be done externally in ib_uverbs_remove_one when last client
> disconnected and complete should be used instead. As of I believe that we
> can stay with only one kref that manage the uverbs_dev which is safe as I
> pointed above.

Many other places in the kernel split the 'can i complete remove'
counter (ie the active count) from the kref. It just makes things
simpler and cleaner

When you changed the flow to do both things, it breaks the error
handling, ie this:

@@ -924,6 +1062,13 @@  static void ib_uverbs_add_one(struct ib_device *device)
	uverbs_dev = kzalloc(sizeof *uverbs_dev, GFP_KERNEL);
 	init_completion(&uverbs_dev->comp);
 	uverbs_dev->xrcd_tree = RB_ROOT;
 	mutex_init(&uverbs_dev->xrcd_tree_mutex);
+	mutex_init(&uverbs_dev->lists_mutex);
+	ret = init_srcu_struct(&uverbs_dev->disassociate_srcu);
+	if (ret)
+		goto err_init;

+err_init:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
 	wait_for_completion(&uverbs_dev->comp);
 	kfree(uverbs_dev);

Is now a double kfree.

So, to fix this, we need to have two different uses of kput, one that
is protected by the implicit locking of add_one/remove_one, and one
that is usable otherwise.

The former should always be the same, and wrapped in a function:

// ONLY callable from remove_one/add_one
static void free_uverbs_dev(..)
{
	bool need_wait = uverbs_dev->ib_dev;
	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
	if (need_wait) {
		wait_for_completion(&uverbs_dev->comp);
 		cleanup_srcu_struct(&uverbs_dev->disassociate_srcu);
		kfree(uverbs_dev);
	}
}

Workable, but it sure makes the kref weird and ugly and abnormal.

99% of the time, seeing a dereference after a kref would be an error,
only when a kref is pretending to be an atomic does it matter. I am of
the opinion that abusing kref for something that is not memory
reference counting is wrong, it makes the code hard to audit and
understand because everyone *expects* standard rules to be followed
with kref.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
