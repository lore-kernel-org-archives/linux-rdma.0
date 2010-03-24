From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB core: Fix locking on device numbers allocation
Date: Wed, 24 Mar 2010 10:39:18 -0700
Message-ID: <adaiq8l1uwp.fsf@roland-alpha.cisco.com>
References: <20100323191317.GA14496@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100323191317.GA14496-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Tue, 23 Mar 2010 21:13:17 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > When the driver needs to dynamically allocate char device numbers in systems
 > with more than IB_UVERBS_MAX_DEVICES, it releases map lock, allocates a new
 > range and a new device number from that range, and only then re-acquires the
 > lock. This must be protected for the same reasoning that the map_lock spinlock
 > is used. Without protecting we could also end up calling alloc_chrdev_region()
 > a nubmer of times and cause a leakage. Fix this by replacing map_lock with a
 > mutex and apply on the all the allocation code.

Looks like a good catch.  I assume you found this through inspection and
not hitting it practice?  Also it seems user_mad.c would need the same fix.

Although looking at this I wonder if we do need that lock... we don't
seem to do any locking when we do the clear_bit in the dev_map, and all
of this is done through the device add/remove callback, which seems to
be serialized by the device_mutex in device.c.  But we probably don't
want to make that a requirement in case we parallelize in the future.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
