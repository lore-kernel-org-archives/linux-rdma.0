From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 08:50:05 +0200
Message-ID: <20170731065016.2947796-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A sockaddr_in structure on the stack getting passed into rdma_ip2gid
triggers this warning, since we memcpy into a larger sockaddr_in6
structure:

In function 'memcpy',
    inlined from 'rdma_ip2gid' at include/rdma/ib_addr.h:175:3,
    inlined from 'addr_event.isra.4.constprop' at drivers/infiniband/core/roce_gid_mgmt.c:693:2,
    inlined from 'inetaddr_event' at drivers/infiniband/core/roce_gid_mgmt.c:716:9:
include/linux/string.h:305:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter

The warning seems appropriate here, but the code is also clearly
correct, so we really just want to shut up this instance of the
output.

The best way I found so far is to avoid the memcpy() call and instead
replace it with a struct assignment.

Fixes: 6974f0c4555e ("include/linux/string.h: add the option of fortified string.h functions")
Cc: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 include/rdma/ib_addr.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 7aca12188ef3..ec5008cf5d51 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -172,7 +172,8 @@ static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
 				       (struct in6_addr *)gid);
 		break;
 	case AF_INET6:
-		memcpy(gid->raw, &((struct sockaddr_in6 *)addr)->sin6_addr, 16);
+		*(struct in6_addr *)&gid->raw =
+			((struct sockaddr_in6 *)addr)->sin6_addr;
 		break;
 	default:
 		return -EINVAL;
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
