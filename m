From: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Subject: [PATCH rdma-core 2/2] rsockets: fix segfaults when rs is not found in the index
Date: Tue, 22 Aug 2017 15:59:42 -0600
Message-ID: <84854B07-B6A2-4C89-8AAC-EFFF2754B19A@lanl.gov>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 0b6aff4 "librdmacm: Define streaming over RDMA interface (rsockets)"
Fixes: bb9fcba "rsocket: Add APIs for direct data placement"

Signed-off-by: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
---
 librdmacm/rsocket.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/librdmacm/rsocket.c b/librdmacm/rsocket.c
index 77a6df4..ca0b9bf 100644
--- a/librdmacm/rsocket.c
+++ b/librdmacm/rsocket.c
@@ -2420,6 +2420,8 @@ ssize_t rrecv(int socket, void *buf, size_t len, int flags)
 	int ret = 0;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (rs->type == SOCK_DGRAM) {
 		fastlock_acquire(&rs->rlock);
 		ret = ds_recvfrom(rs, buf, len, flags, NULL, NULL);
@@ -2488,6 +2490,8 @@ ssize_t rrecvfrom(int socket, void *buf, size_t len, int flags,
 	int ret;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (rs->type == SOCK_DGRAM) {
 		fastlock_acquire(&rs->rlock);
 		ret = ds_recvfrom(rs, buf, len, flags, src_addr, addrlen);
@@ -2691,6 +2695,8 @@ ssize_t rsend(int socket, const void *buf, size_t len, int flags)
 	int ret = 0;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (rs->type == SOCK_DGRAM) {
 		fastlock_acquire(&rs->slock);
 		ret = dsend(rs, buf, len, flags);
@@ -2776,6 +2782,8 @@ ssize_t rsendto(int socket, const void *buf, size_t len, int flags,
 	int ret;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (rs->type == SOCK_STREAM) {
 		if (dest_addr || addrlen)
 			return ERR(EISCONN);
@@ -2831,6 +2839,8 @@ static ssize_t rsendv(int socket, const struct iovec *iov, int iovcnt, int flags
 	int i, ret = 0;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (rs->state & rs_opening) {
 		ret = rs_do_connect(rs);
 		if (ret) {
@@ -3773,6 +3783,8 @@ off_t riomap(int socket, void *buf, size_t len, int prot, int flags, off_t offse
 	int access = IBV_ACCESS_LOCAL_WRITE;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	if (!rs->cm_id->pd || (prot & ~(PROT_WRITE | PROT_NONE)))
 		return ERR(EINVAL);
 
@@ -3821,6 +3833,8 @@ int riounmap(int socket, void *buf, size_t len)
 	int ret = 0;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	fastlock_acquire(&rs->map_lock);
 
 	for (entry = rs->iomap_list.next; entry != &rs->iomap_list;
@@ -3868,6 +3882,8 @@ size_t riowrite(int socket, const void *buf, size_t count, off_t offset, int fla
 	int ret = 0;
 
 	rs = idm_at(&idm, socket);
+	if (!rs)
+		return ERR(EBADF);
 	fastlock_acquire(&rs->slock);
 	if (rs->iomap_pending) {
 		ret = rs_send_iomaps(rs, flags);
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
