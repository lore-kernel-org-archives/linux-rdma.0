From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 12:06:50 -0400
Message-ID: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IBM has found a resource that they think will be able to progress Roland's ummunotify work.

After a few discussions in Sonoma last week and some off-list emails, here's what we decided:

1. Take Roland's last code drop (Roland: can you re-send the last copy of your code?).

2. Do not convert it to the perf events kernel framework as the Linux kernel community requested.  Instead, migrate the functionality into the ibv code base.  Roland thinks that most of the code should be adaptable without too many changes.  Here's the highlights of the new functionality:

   a. Add a new flag to ibv_reg_mr() that does the same function as UMMUNOTIFY_REGISTER_REGION
   b. ibv_dereg_mr() always performs the equivalent of UMMUNOTIFY_UNREGISTER_REGION (if necessary)
   c. Make a new device somewhere (under /dev/infiniband?) that performs the same functions as /dev/ummunotify (open it to mmap the counter into user space, and read events when something "interesting" happens)

3. I will update the Open MPI prototype to use this slightly modified scheme (i.e., no longer have explicit ioctl's to UMMUNOTIFY_DE/REGISTER_REGION, but instead do it during ibv_reg_mr(), etc.).

Roland's initial goal was to have this functionality be separate from verbs because it's applicable outside of this specific use case.  The above proposals makes the ummunotify functionality tied to the ibv API, but given that Roland simply does not have the cycles to make forward progress on the generalized ummunotify mechanism, it seems like a reasonable way to make forward progress.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
