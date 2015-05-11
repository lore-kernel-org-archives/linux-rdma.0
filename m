From: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] IB/ehca: use correct destination for memcpy
Date: Mon, 11 May 2015 16:38:02 +0200
Message-ID: <1431355082-29290-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Using an element of a struct as the address for the memcpy of the whole
struct may introduce a buffer overflow and does not help readability either
simply pass the real thing as first argument to memcpy.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
---

passing the first element of a struct as destination triggers buffer 
overflows warnings in tools like Smatch. 
./drivers/infiniband/hw/ehca/ehca_mcast.c:ehca_attach_mcast.80 WARNING:
memcpy copying entire struct to first element
./drivers/infiniband/hw/ehca/ehca_mcast.c:ehca_detach_mcast.117 WARNING:
memcpy copying entire struct to first element

Simply use the structure rather than the first element (which could change)
which also help readability.

Patch was only compile tested with ppc64_defconfig (implies
CONFIG_INFINIBAND_EHCA=m)

Patch is against 4.1-rc3 (localversion-next is -next-20150511)

 drivers/infiniband/hw/ehca/ehca_mcast.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mcast.c b/drivers/infiniband/hw/ehca/ehca_mcast.c
index 120aedf..cec1815 100644
--- a/drivers/infiniband/hw/ehca/ehca_mcast.c
+++ b/drivers/infiniband/hw/ehca/ehca_mcast.c
@@ -77,7 +77,7 @@ int ehca_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		return -EINVAL;
 	}
 
-	memcpy(&my_gid.raw, gid->raw, sizeof(union ib_gid));
+	memcpy(&my_gid, gid->raw, sizeof(union ib_gid));
 
 	subnet_prefix = be64_to_cpu(my_gid.global.subnet_prefix);
 	interface_id = be64_to_cpu(my_gid.global.interface_id);
@@ -114,7 +114,7 @@ int ehca_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		return -EINVAL;
 	}
 
-	memcpy(&my_gid.raw, gid->raw, sizeof(union ib_gid));
+	memcpy(&my_gid, gid->raw, sizeof(union ib_gid));
 
 	subnet_prefix = be64_to_cpu(my_gid.global.subnet_prefix);
 	interface_id = be64_to_cpu(my_gid.global.interface_id);
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
