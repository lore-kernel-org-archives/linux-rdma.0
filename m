From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 1/3] Fix compilation warnings when NDEBUG is set
Date: Mon, 13 Nov 2017 08:08:04 +0200
Message-ID: <20171113060806.27354-2-leon@kernel.org>
References: <20171113060806.27354-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113060806.27354-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When NDEBUG is set (-DCMAKE_BUILD_TYPE=Release) and CFLAGS is set to
-Werorr, we get some compilation errors as the following:

rdma-core/libibverbs/neigh.c:378:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
     ssize_t rc;

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 libibverbs/neigh.c  | 2 +-
 librdmacm/rsocket.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libibverbs/neigh.c b/libibverbs/neigh.c
index 3e9ee926..21177db0 100644
--- a/libibverbs/neigh.c
+++ b/libibverbs/neigh.c
@@ -375,7 +375,7 @@ static struct nl_addr *process_get_neigh_mac(
 
 			if (FD_ISSET(timer_fd, &fdset)) {
 				uint64_t read_val;
-				ssize_t rc;
+				ssize_t __attribute__((unused)) rc;
 
 				rc =
 				    read(timer_fd, &read_val, sizeof(read_val));
diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 693d9eb5..2ce71627 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -408,14 +408,14 @@ struct ds_udp_header {
 static void write_all(int fd, const void *msg, size_t len)
 {
 	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
-	ssize_t rc = write(fd, msg, len);
+	ssize_t __attribute__((unused)) rc = write(fd, msg, len);
 	assert(rc == len);
 }
 
 static void read_all(int fd, void *msg, size_t len)
 {
 	// FIXME: if fd is a socket this really needs to handle EINTR and other conditions.
-	ssize_t rc = read(fd, msg, len);
+	ssize_t __attribute__((unused)) rc = read(fd, msg, len);
 	assert(rc == len);
 }
 
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
