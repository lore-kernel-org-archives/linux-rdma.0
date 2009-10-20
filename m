From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH libibrdmacm] Return errors from the library consistently
Date: Tue, 20 Oct 2009 12:41:57 -0600
Message-ID: <20091020184157.GG14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the return of -errno and always return codes via errno.
As documented in librdmacm, these libraries are already documented
to return -1 to indicate the code is in errno.

Update rping to show a correct error reporting methodology.

Also fix an errant return of 0 if the read/write syscalls return 0.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 examples/rping.c |   22 ++++++-------
 man/rdma_cm.7    |   16 ++++----
 src/cma.c        |   94 ++++++++++++++++++++++++++++-------------------------
 3 files changed, 68 insertions(+), 64 deletions(-)

I think the changes to rping show why the old approach is so
dangerous, only 2 error reports in rping were actually able to show
errno from the kernel.

I haven't been able to do more than compile test this one though..

diff --git a/examples/rping.c b/examples/rping.c
index e45cfb6..91952e7 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -174,7 +174,7 @@ static int rping_cma_event_handler(struct rdma_cm_id *cma_id,
 		ret = rdma_resolve_route(cma_id, 2000);
 		if (ret) {
 			cb->state = ERROR;
-			fprintf(stderr, "rdma_resolve_route error %d\n", ret);
+			perror("rdma_resolve_route");
 			sem_post(&cb->sem);
 		}
 		break;
@@ -352,7 +352,7 @@ static int rping_accept(struct rping_cb *cb)
 
 	ret = rdma_accept(cb->child_cm_id, &conn_param);
 	if (ret) {
-		fprintf(stderr, "rdma_accept error: %d\n", ret);
+		perror("rdma_accept");
 		return ret;
 	}
 
@@ -546,7 +546,7 @@ static int rping_setup_qp(struct rping_cb *cb, struct rdma_cm_id *cm_id)
 
 	ret = rping_create_qp(cb);
 	if (ret) {
-		fprintf(stderr, "rping_create_qp failed: %d\n", ret);
+		perror("rdma_create_qp");
 		goto err3;
 	}
 	DEBUG_LOG("created qp %p\n", cb->qp);
@@ -570,7 +570,7 @@ static void *cm_thread(void *arg)
 	while (1) {
 		ret = rdma_get_cm_event(cb->cm_channel, &event);
 		if (ret) {
-			fprintf(stderr, "rdma_get_cm_event err %d\n", ret);
+			perror("rdma_get_cm_event");
 			exit(ret);
 		}
 		ret = rping_cma_event_handler(event->id, event);
@@ -736,7 +736,7 @@ static int rping_bind_server(struct rping_cb *cb)
 
 	ret = rdma_bind_addr(cb->cm_id, (struct sockaddr *) &cb->sin);
 	if (ret) {
-		fprintf(stderr, "rdma_bind_addr error %d\n", ret);
+		perror("rdma_bind_addr");
 		return ret;
 	}
 	DEBUG_LOG("rdma_bind_addr successful\n");
@@ -744,7 +744,7 @@ static int rping_bind_server(struct rping_cb *cb)
 	DEBUG_LOG("rdma_listen\n");
 	ret = rdma_listen(cb->cm_id, 3);
 	if (ret) {
-		fprintf(stderr, "rdma_listen failed: %d\n", ret);
+		perror("rdma_listen");
 		return ret;
 	}
 
@@ -978,7 +978,7 @@ static int rping_connect_client(struct rping_cb *cb)
 
 	ret = rdma_connect(cb->cm_id, &conn_param);
 	if (ret) {
-		fprintf(stderr, "rdma_connect error %d\n", ret);
+		perror("rdma_connect");
 		return ret;
 	}
 
@@ -1003,7 +1003,7 @@ static int rping_bind_client(struct rping_cb *cb)
 
 	ret = rdma_resolve_addr(cb->cm_id, NULL, (struct sockaddr *) &cb->sin, 2000);
 	if (ret) {
-		fprintf(stderr, "rdma_resolve_addr error %d\n", ret);
+		perror("rdma_resolve_addr");
 		return ret;
 	}
 
@@ -1191,15 +1191,13 @@ int main(int argc, char *argv[])
 
 	cb->cm_channel = rdma_create_event_channel();
 	if (!cb->cm_channel) {
-		ret = errno;
-		fprintf(stderr, "rdma_create_event_channel error %d\n", ret);
+		perror("rdma_create_event_channel");
 		goto out;
 	}
 
 	ret = rdma_create_id(cb->cm_channel, &cb->cm_id, cb, RDMA_PS_TCP);
 	if (ret) {
-		ret = errno;
-		fprintf(stderr, "rdma_create_id error %d\n", ret);
+		perror("rdma_create_id");
 		goto out2;
 	}
 	DEBUG_LOG("created cm_id %p\n", cb->cm_id);
diff --git a/man/rdma_cm.7 b/man/rdma_cm.7
index 23571b2..fd04959 100644
--- a/man/rdma_cm.7
+++ b/man/rdma_cm.7
@@ -108,18 +108,18 @@ release the event channel
 success
 .IP "= -1"
 error - see errno for more details
-.IP "< -1"
-error - see include/asm-generic/errno*.h for more details
 .P
-Librdmacm functions return 0 to indicate success, and a negative return value
+Librdmacm functions return 0 to indicate success, and a -1 return value
 to indicate failure.  If a function operates asynchronously, a return value of 0
 means that the operation was successfully started.  The operation could still
 complete in error; users should check the status of the related event.  If the
-return value is -1, then errno can be examined for additional information
-regarding the reason for the failure.  If the return value is < -1, then
-additional error reasons can be obtained by comparing the returned value with
-the values listed in include/asm-generic/errno-base.h and
-include/asm-generic/errno.h.
+return value is -1, then errno will contain additional information
+regarding the reason for the failure.
+.P
+Prior versions of the library would return -errno and not set errno for some cases
+related to ENOMEM, ENODEV, ENODATA, EINVAL, and EADDRNOTAVAIL codes. Applications
+that want to check these codes and have compatability with prior library versions
+must manually set errno to the negative of the return code if it is < -1.
 .SH "SEE ALSO"
 rdma_create_event_channel(3), rdma_get_cm_event(3), rdma_create_id(3),
 rdma_resolve_addr(3), rdma_bind_addr(3), rdma_create_qp(3),
diff --git a/src/cma.c b/src/cma.c
index 70dbe1c..9fe2599 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -76,6 +76,12 @@ static inline uint64_t htonll(uint64_t x) { return x; }
 static inline uint64_t ntohll(uint64_t x) { return x; }
 #endif
 
+static inline int ERR(int err)
+{
+	errno = err;
+	return -1;
+}
+
 #define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
 do {                                        \
 	struct ucma_abi_cmd_hdr *hdr;         \
@@ -83,7 +89,7 @@ do {                                        \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
 	if (!msg)                           \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	hdr = msg;                          \
 	cmd = msg + sizeof(*hdr);           \
 	hdr->cmd = type;                    \
@@ -92,18 +98,18 @@ do {                                        \
 	memset(cmd, 0, sizeof(*cmd));       \
 	resp = alloca(sizeof(*resp));       \
 	if (!resp)                          \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	cmd->response = (uintptr_t)resp;\
 } while (0)
 
 #define CMA_CREATE_MSG_CMD(msg, cmd, type, size) \
 do {                                        \
-	struct ucma_abi_cmd_hdr *hdr;         \
+	struct ucma_abi_cmd_hdr *hdr;       \
                                             \
 	size = sizeof(*hdr) + sizeof(*cmd); \
 	msg = alloca(size);                 \
 	if (!msg)                           \
-		return -ENOMEM;             \
+		return ERR(ENOMEM);         \
 	hdr = msg;                          \
 	cmd = msg + sizeof(*hdr);           \
 	hdr->cmd = type;                    \
@@ -218,13 +224,13 @@ static int ucma_init(void)
 	dev_list = ibv_get_device_list(&cma_dev_cnt);
 	if (!dev_list) {
 		printf("CMA: unable to get RDMA device list\n");
-		ret = -ENODEV;
+		ret = ERR(ENODEV);
 		goto err;
 	}
 
 	cma_dev_array = malloc(sizeof *cma_dev * cma_dev_cnt);
 	if (!cma_dev_array) {
-		ret = -ENOMEM;
+		ret = ERR(ENOMEM);
 		goto err;
 	}
 
@@ -235,7 +241,7 @@ static int ucma_init(void)
 		cma_dev->verbs = ibv_open_device(dev_list[i]);
 		if (!cma_dev->verbs) {
 			printf("CMA: unable to open RDMA device\n");
-			ret = -ENODEV;
+			ret = ERR(ENODEV);
 			goto err;
 		}
 
@@ -334,7 +340,7 @@ static int ucma_get_device(struct cma_id_private *id_priv, uint64_t guid)
 		}
 	}
 
-	return -ENODEV;
+	return ERR(ENODEV);
 }
 
 static void ucma_free_id(struct cma_id_private *id_priv)
@@ -386,7 +392,7 @@ int rdma_create_id(struct rdma_event_channel *channel,
 
 	id_priv = ucma_alloc_id(channel, context, ps);
 	if (!id_priv)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_CREATE_ID, size);
 	cmd->uid = (uintptr_t) id_priv;
@@ -418,7 +424,7 @@ static int ucma_destroy_kern_id(int fd, uint32_t handle)
 
 	ret = write(fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -473,7 +479,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -481,7 +487,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
 		id->route.path_rec = malloc(sizeof *id->route.path_rec *
 					    resp->num_paths);
 		if (!id->route.path_rec)
-			return -ENOMEM;
+			return ERR(ENOMEM);
 
 		id->route.num_paths = resp->num_paths;
 		for (i = 0; i < resp->num_paths; i++)
@@ -518,7 +524,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	
 	addrlen = ucma_addrlen(addr);
 	if (!addrlen)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND_ADDR, size);
 	id_priv = container_of(id, struct cma_id_private, id);
@@ -527,7 +533,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return ucma_query_route(id);
 }
@@ -542,7 +548,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	
 	daddrlen = ucma_addrlen(dst_addr);
 	if (!daddrlen)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ADDR, size);
 	id_priv = container_of(id, struct cma_id_private, id);
@@ -554,7 +560,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	memcpy(&id->route.addr.dst_addr, dst_addr, daddrlen);
 	return 0;
@@ -574,7 +580,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -600,7 +606,7 @@ static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
@@ -616,7 +622,7 @@ static int ucma_modify_qp_rtr(struct rdma_cm_id *id,
 	int qp_attr_mask, ret;
 
 	if (!id->qp)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	/* Need to update QP attributes from default values. */
 	qp_attr.qp_state = IBV_QPS_INIT;
@@ -686,7 +692,7 @@ static int ucma_find_pkey(struct cma_device *cma_dev, uint8_t port_num,
 			return 0;
 		}
 	}
-	return -EINVAL;
+	return ERR(EINVAL);
 }
 
 static int ucma_init_conn_qp3(struct cma_id_private *id_priv, struct ibv_qp *qp)
@@ -790,11 +796,11 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (id->verbs != pd->context)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	qp = ibv_create_qp(pd, qp_init_attr);
 	if (!qp)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 	if (ucma_is_ud_ps(id->ps))
 		ret = ucma_init_ud_qp(id_priv, qp);
@@ -825,7 +831,7 @@ static int ucma_valid_param(struct cma_id_private *id_priv,
 	     id_priv->cma_dev->max_responder_resources) ||
 	    (conn_param->initiator_depth >
 	     id_priv->cma_dev->max_initiator_depth))
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	return 0;
 }
@@ -875,7 +881,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -894,7 +900,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return ucma_query_route(id);
 }
@@ -932,7 +938,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {
 		ucma_modify_qp_err(id);
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
 
 	return 0;
@@ -958,7 +964,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -977,7 +983,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ibv_event_type event)
 	cmd->event = event;
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -997,7 +1003,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 		ret = ucma_modify_qp_sqd(id);
 		break;
 	default:
-		ret = -EINVAL;
+		ret = ERR(EINVAL);
 	}
 	if (ret)
 		return ret;
@@ -1008,7 +1014,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -1026,11 +1032,11 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	id_priv = container_of(id, struct cma_id_private, id);
 	addrlen = ucma_addrlen(addr);
 	if (!addrlen)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	mc = malloc(sizeof *mc);
 	if (!mc)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 	memset(mc, 0, sizeof *mc);
 	mc->context = context;
@@ -1053,7 +1059,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {
-		ret = (ret > 0) ? -ENODATA : ret;
+		ret = (ret >= 0) ? ERR(ENODATA) : -1;
 		goto err2;
 	}
 
@@ -1083,7 +1089,7 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	
 	addrlen = ucma_addrlen(addr);
 	if (!addrlen)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	pthread_mutex_lock(&id_priv->mut);
@@ -1096,7 +1102,7 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 		*pos = mc->next;
 	pthread_mutex_unlock(&id_priv->mut);
 	if (!mc)
-		return -EADDRNOTAVAIL;
+		return ERR(EADDRNOTAVAIL);
 
 	if (id->qp)
 		ibv_detach_mcast(id->qp, &mc->mgid, mc->mlid);
@@ -1106,7 +1112,7 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {
-		ret = (ret > 0) ? -ENODATA : ret;
+		ret = (ret >= 0) ? ERR(ENODATA) : -1;
 		goto free;
 	}
 
@@ -1146,7 +1152,7 @@ int rdma_ack_cm_event(struct rdma_cm_event *event)
 	struct cma_event *evt;
 
 	if (!event)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	evt = container_of(event, struct cma_event, event);
 
@@ -1168,7 +1174,7 @@ static int ucma_process_conn_req(struct cma_event *evt,
 				evt->id_priv->id.context, evt->id_priv->id.ps);
 	if (!id_priv) {
 		ucma_destroy_kern_id(evt->id_priv->id.channel->fd, handle);
-		ret = -ENOMEM;
+		ret = ERR(ENOMEM);
 		goto err;
 	}
 
@@ -1207,7 +1213,7 @@ static int ucma_process_conn_resp(struct cma_id_private *id_priv)
 
 	ret = write(id_priv->id.channel->fd, msg, size);
 	if (ret != size) {
-		ret = (ret > 0) ? -ENODATA : ret;
+		ret = (ret >= 0) ? ERR(ENODATA) : -1;
 		goto err;
 	}
 
@@ -1292,11 +1298,11 @@ int rdma_get_cm_event(struct rdma_event_channel *channel,
 		return ret;
 
 	if (!event)
-		return -EINVAL;
+		return ERR(EINVAL);
 
 	evt = malloc(sizeof *evt);
 	if (!evt)
-		return -ENOMEM;
+		return ERR(ENOMEM);
 
 retry:
 	memset(evt, 0, sizeof *evt);
@@ -1304,7 +1310,7 @@ retry:
 	ret = write(channel->fd, msg, size);
 	if (ret != size) {
 		free(evt);
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
 	
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
@@ -1463,7 +1469,7 @@ int rdma_set_option(struct rdma_cm_id *id, int level, int optname,
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
 }
@@ -1483,7 +1489,7 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 
 	ret = write(channel->fd, msg, size);
 	if (ret != size)
-		return (ret > 0) ? -ENODATA : ret;
+		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
-- 
1.6.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
