From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Date: Fri, 29 Jan 2010 14:44:57 -0700
Message-ID: <20100129214039.17745.38679.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Justin Chen discovered that Linux "only" supports 32 IB cards in
a single system when testing a larger system with 40 cards and
discovered that OFED only reported 32 HCAs.

This patchset doubles the number of HCAs allowed per system in a
backwards-compatible manner.

Why only double? Well, it keeps the implementation very simple while
also keeping the memory increase at a minimum. If the future
requires even more HCAs per system, we can do a more complicated
implementation then.

I tested this by inserting 4 IB cards into a system, and then
changing IB_UVERBS_MAX_DEVICES = 2.

	dl585g2:~ # modprobe ib_uverbs
	dl585g2:~ # ls -l /dev/uverbs*
	crw-rw---- 1 root root 231, 192 Jan 28 06:59 /dev/uverbs0
	crw-rw---- 1 root root 231, 193 Jan 28 06:59 /dev/uverbs1
	crw-rw---- 1 root root 249,   0 Jan 28 06:59 /dev/uverbs2
	crw-rw---- 1 root root 249,   1 Jan 28 06:59 /dev/uverbs3

You can see that the uverbs devices are numbered in order, as one
would expect, and that devices 2 and 3 have different major numbers
while devices 0 and 1 retain the legacy, allocated major number.

I don't have access to a huge system to really test what
happens at device 33, but it should just work, right? :)

I am also unaware of any OFED changes required (if that's even
necessary), but then again, I'm just a simple kernel guy.

The final two patches are just something I discovered while using
pahole to verify my changes in converting the *cdev pointer to an
embedded struct. They don't save all that much, but they also don't
change very much code either, so why not?

Thanks,
/ac

---

Alex Chiang (7):
      IB/uverbs: convert *cdev to cdev in struct ib_uverbs_device
      IB/uverbs: remove dev_table
      IB/uverbs: use stack variable 'devnum' in ib_uverbs_add_one
      IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
      IB/uverbs: increase maximum devices supported
      IB/uverbs: pack struct ib_uverbs_event_file tighter
      IB/core: pack struct ib_device a little tighter


 drivers/infiniband/core/uverbs.h      |   11 ++-
 drivers/infiniband/core/uverbs_main.c |  106 +++++++++++++++++++++------------
 include/rdma/ib_verbs.h               |    4 +
 3 files changed, 76 insertions(+), 45 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
