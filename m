From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] librdmacm: Fix compilation warnings
Date: Tue,  3 Oct 2017 14:05:29 +0300
Message-ID: <20171003110529.25635-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Combination of glibc 2.26-4 and gcc 7.2.0-3 produces of following
warnings at the compilation phase of rdma-core.

[24/189] Building C object librdmacm/CMakeFiles/rspreload.dir/preload.c.o
../librdmacm/preload.c:818:9: warning: no previous prototype for ‘readv’ [-Wmissing-prototypes]
 ssize_t readv(int socket, const struct iovec *iov, int iovcnt)
         ^~~~~
../librdmacm/preload.c:857:9: warning: no previous prototype for ‘writev’ [-Wmissing-prototypes]
 ssize_t writev(int socket, const struct iovec *iov, int iovcnt)

The simple addition of "sys/uio.h" proposed by Sean Hefty [1] with Jason
Gunthrope support [2] fixes it.

[1] https://marc.info/?l=linux-rdma&m=150696066510225&w=2
[2] https://marc.info/?l=linux-rdma&m=150696688111945&w=2
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 librdmacm/preload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/librdmacm/preload.c b/librdmacm/preload.c
index dfc23648..3ed0242e 100644
--- a/librdmacm/preload.c
+++ b/librdmacm/preload.c
@@ -51,6 +51,8 @@
 #include <stdlib.h>
 #include <stdio.h>

+#include <sys/uio.h>
+
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_verbs.h>
 #include <rdma/rsocket.h>
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
