From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 29/37] librdmacm: use sockaddr_ib addressing if IB ACM is in use
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <AFC921A6B56D41DCB9CE8F9447225860@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If IB ACM route resolution succeeds, provide the user with
AF_IB addresses, rather than AF_INET or AF_INET6 addressing.
AF_IB identifies the local and remote devices directly,
eliminating the need to perform address resolution a second
time via rdma_resolve_addr.

AF_IB addresses are returned using sockaddr_ib as part of
rdma_getaddrinfo.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/acm.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/cma.h |    1 +
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 34fdf3c..5dd8899 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -83,9 +83,69 @@ void ucma_ib_cleanup(void)
 	}
 }
 
+static void ucma_set_sid(enum rdma_port_space ps, struct sockaddr *addr,
+			 struct sockaddr_ib *sib)
+{
+	uint16_t port;
+
+	if (addr->sa_family == AF_INET)
+		port = ((struct sockaddr_in *) addr)->sin_port;
+	else
+		port = ((struct sockaddr_in6 *) addr)->sin6_port;
+
+	sib->sib_sid = htonll(((uint64_t) ps << 16) + ntohs(port));
+	if (port)
+		sib->sib_sid_mask = ~0ULL;
+	else
+		sib->sib_sid_mask = htonll(RDMA_IB_IP_PS_MASK);
+}
+
+static void ucma_ib_convert_addr(struct rdma_addrinfo *rai,
+				 struct ib_path_record *path)
+{
+	struct sockaddr_ib *src, *dst;
+
+	if (!path)
+		return;
+
+	src = zalloc(sizeof *src);
+	if (!src)
+		return;
+
+	dst = zalloc(sizeof *dst);
+	if (!dst) {
+		free(src);
+		return;
+	}
+
+	src->sib_family = AF_IB;
+	src->sib_pkey = path->pkey;
+	src->sib_flowinfo = htonl(ntohl(path->flowlabel_hoplimit) >> 8);
+	memcpy(&src->sib_addr, &path->sgid, 16);
+	ucma_set_sid(rai->ai_port_space, rai->ai_src_addr, src);
+
+	dst->sib_family = AF_IB;
+	dst->sib_pkey = path->pkey;
+	dst->sib_flowinfo = htonl(ntohl(path->flowlabel_hoplimit) >> 8);
+	memcpy(&dst->sib_addr, &path->dgid, 16);
+	ucma_set_sid(rai->ai_port_space, rai->ai_dst_addr, dst);
+
+	free(rai->ai_src_addr);
+	rai->ai_src_addr = (struct sockaddr *) src;
+	rai->ai_src_len = sizeof(*src);
+
+	free(rai->ai_dst_addr);
+	rai->ai_dst_addr = (struct sockaddr *) dst;
+	rai->ai_dst_len = sizeof(*dst);
+
+	rai->ai_family = AF_IB;
+	rai->ai_port_space = RDMA_PS_IB;
+}
+
 static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg *msg)
 {
 	struct ib_path_data *path_data = NULL;
+	struct ib_path_record *pri_path;
 	int len, i, cnt;
 
 	len = msg->hdr.length - ACM_MSG_HDR_LENGTH;
@@ -98,11 +158,16 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg
 	for (i = 0; i < cnt; i++) {
 		if (msg->data[i].type != ACM_EP_INFO_PATH)
 			goto err;
+		if (path_data[i].flags |
+		    (IB_PATH_FLAG_PRIMARY | IB_PATH_FLAG_OUTBOUND))
+			pri_path = &path_data[i].path;
 		path_data[i].reserved = 0;
 	}
 
 	rai->ai_route = path_data;
 	rai->ai_route_len = len;
+	if (af_ib_support)
+		ucma_ib_convert_addr(rai, pri_path);
 	return;
 err:
 	free(path_data);
diff --git a/src/cma.h b/src/cma.h
index 62785de..1e0c571 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -85,6 +85,7 @@ static inline void *zalloc(size_t size)
 }
 
 int ucma_init();
+extern int af_ib_support;
 
 #ifdef USE_IB_ACM
 void ucma_ib_init();



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
