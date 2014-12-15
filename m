From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] dtestx: update IB extension example test with new v2.0.9 features
Date: Mon, 15 Dec 2014 10:35:58 -0800
Message-ID: <1418668558-695-4-git-send-email-arlin.r.davis@intel.com>
References: <1418668558-695-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418668558-695-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support for new IB extensions for CM and AH resource cleanup.
Check for v2.0.9 and call dat_ib_ud_cm_free after connection
establishment and dat_ib_ud_ah_free after all data has been
transfered on UD endpoints.

Also add socket based address exchange to eliminate the need
to include lid and qpn parameters on the client side.

Change the multiple EP mode to send from EP 0 to EP[0-3] on
server side and EP[0-3] to EP[0-3] on client side.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dtest/dtestx.c |  581 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 451 insertions(+), 130 deletions(-)

diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 32ffe33..8b3294a 100755
--- a/test/dtest/dtestx.c
+++ b/test/dtest/dtestx.c
@@ -60,7 +60,7 @@
 #include <string.h>
 #include <unistd.h>
 
-#define DAPL_PROVIDER "ofa-v2-ib0"
+#define DAPL_PROVIDER "ofa-v2-mlx4_0-1u"
 #define F64x "%"PRIx64""
 #define F64u "%"PRIu64""
 
@@ -144,6 +144,7 @@ int disconnect_ep(void);
 #define SEND_BUF_INDEX		2
 #define RECV_BUF_INDEX		3
 #define MAX_EP_COUNT		8
+#define MAX_AH_COUNT		(MAX_EP_COUNT * 2)
 
 DAT_VADDR *atomic_buf;
 DAT_LMR_HANDLE lmr_atomic;
@@ -174,16 +175,22 @@ int buf_size = BUF_SIZE;
 int msg_size = sizeof(DAT_RMR_TRIPLET);
 char provider[64] = DAPL_PROVIDER;
 char hostname[256] = { 0 };
-DAT_IB_ADDR_HANDLE remote_ah[MAX_EP_COUNT];
+static DAT_IB_ADDR_HANDLE remote_ah[MAX_EP_COUNT][MAX_AH_COUNT];
 int eps = 1;
 int verbose = 0;
 int counters = 0;
 int counters_ok = 0;
 static int ucm = 0;
 static DAT_SOCK_ADDR6 remote;
+static DAT_IA_ATTR ia_attr;
+static DAT_PROVIDER_ATTR prov_attrs;
 
 #define LOGPRINTF if (verbose) printf
 
+#define CONN_PORT 15828
+#define CONN_MSG_SIZE 128
+#define CONN_MSG_FMT "%04hx:%08x:%08x:%08x:%s"
+
 void print_usage(void)
 {
 	printf("\n dtestx usage \n\n");
@@ -196,7 +203,7 @@ void print_usage(void)
 	printf("h: hostname/address of Server, client and UDP server\n");
 	printf("c: Client\n");
 	printf("s: Server, default\n");
-	printf("P: provider name (default = ofa-v2-ib0)\n");
+	printf("P: provider name (default = ofa-v2-mlx4_0-1u)\n");
 	printf("\n");
 }
 
@@ -232,6 +239,265 @@ static void print_ia_address(struct sockaddr *sa)
 	}
 }
 
+int conn_client_connect(const char *servername, int port)
+{
+
+	struct addrinfo *res, *t;
+	struct addrinfo hints = {
+		.ai_family   = AF_UNSPEC,
+		.ai_socktype = SOCK_STREAM
+	};
+	char *service;
+	int n;
+	int sockfd = -1;
+
+	if (asprintf(&service, "%d", port) < 0)
+		return -1;
+
+	n = getaddrinfo(servername, service, &hints, &res);
+
+	if (n < 0) {
+		fprintf(stderr, "%s for %s:%d\n",
+			gai_strerror(n), servername, port);
+		return n;
+	}
+
+	for (t = res; t; t = t->ai_next) {
+		sockfd = socket(t->ai_family, t->ai_socktype, t->ai_protocol);
+		if (sockfd >= 0) {
+			if (!connect(sockfd, t->ai_addr, t->ai_addrlen))
+				break;
+			close(sockfd);
+			sockfd = -1;
+		}
+	}
+
+	freeaddrinfo(res);
+
+	if (sockfd < 0) {
+		fprintf(stderr, "Couldn't connect to %s:%d\n",
+			servername, port);
+		return sockfd;
+	}
+	return sockfd;
+}
+
+int conn_server_connect(int port)
+{
+	struct addrinfo *res, *t;
+	struct addrinfo hints = {
+		.ai_flags    = AI_PASSIVE,
+		.ai_family   = AF_UNSPEC,
+		.ai_socktype = SOCK_STREAM
+	};
+	char *service;
+	int sockfd = -1, connfd;
+	int n;
+
+	if (asprintf(&service, "%d", port) < 0)
+		return -1;
+
+	n = getaddrinfo(NULL, service, &hints, &res);
+
+	if (n < 0) {
+		fprintf(stderr, "%s for port %d\n", gai_strerror(n), port);
+		return n;
+	}
+
+	for (t = res; t; t = t->ai_next) {
+		sockfd = socket(t->ai_family, t->ai_socktype, t->ai_protocol);
+		if (sockfd >= 0) {
+			n = 1;
+
+			setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &n,
+				   sizeof n);
+
+			if (!bind(sockfd, t->ai_addr, t->ai_addrlen))
+				break;
+
+			close(sockfd);
+			sockfd = -1;
+		}
+	}
+
+	freeaddrinfo(res);
+
+	if (sockfd < 0) {
+		fprintf(stderr, "Couldn't listen to port %d\n", port);
+		return sockfd;
+	}
+
+	listen(sockfd, 1);
+	connfd = accept(sockfd, NULL, 0);
+	if (connfd < 0) {
+		perror("server accept");
+		fprintf(stderr, "accept() failed\n");
+		close(sockfd);
+		return connfd;
+	}
+
+	close(sockfd);
+	return connfd;
+}
+
+static int get_server_params(struct sockaddr *my_sa)
+{
+	int connfd, parsed;
+	in_port_t ser_lid = 0;
+	uint32_t scope_id = 0, ser_qpn = 0, ser_scope_id = 0, ser_sin_addr = 0;
+	struct in_addr sin_addr;	/* Internet address.  */
+	char msg[CONN_MSG_SIZE];
+
+	connfd = conn_client_connect(hostname, CONN_PORT);
+	if (connfd < 0) {
+		fprintf(stderr, "%d Could not connect to %s\n",
+			getpid(), hostname);
+		return -1;
+	}
+
+	if (read(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "%d Couldn't read remote address\n", getpid());
+		return -1;
+	}
+
+	parsed = sscanf(msg, CONN_MSG_FMT, &ser_lid, &ser_qpn, &ser_scope_id,
+			&ser_sin_addr, provider);
+
+	if (parsed != 5) {
+		fprintf(stderr, "%d Couldn't parse line <%.*s>\n",
+			getpid(), (int)sizeof msg, msg);
+		return -1;
+	}
+
+	if (ser_sin_addr) {
+		sin_addr.s_addr = ser_sin_addr;
+		inet_ntop(AF_INET, &sin_addr, hostname, INET6_ADDRSTRLEN);
+		LOGPRINTF("%d remote data: provider %s hostname %s\n",
+			  getpid(), provider, hostname);
+	} else if (ser_lid && ser_qpn) {
+		remote.sin6_family = AF_INET6;
+		remote.sin6_port = ser_lid;
+		remote.sin6_flowinfo = ser_qpn;
+		remote.sin6_scope_id = ntohl(ser_scope_id);
+		ucm = 1;
+		LOGPRINTF("%d remote data: provider %s Client QPN 0x%x,"
+			  " LID = 0x%x, scope_id 0x%x\n",
+			  getpid(), provider, ntohl(ser_qpn), ntohs(ser_lid),
+			  ntohl(ser_scope_id));
+	} else {
+		fprintf(stderr, "%d No valid data was received"
+			" from the server\n",
+			getpid());
+		return -1;
+	}
+
+	/* send client addr back to server */
+	if (my_sa->sa_family == AF_INET6) {
+		ser_qpn = ((struct sockaddr_in6 *)my_sa)->sin6_flowinfo;
+		ser_lid = ((struct sockaddr_in6 *)my_sa)->sin6_port;
+		scope_id = htonl(((struct sockaddr_in6 *)my_sa)->sin6_scope_id);
+		LOGPRINTF("%d Client data to server: provider %s QPN 0x%x LID"
+			  " = 0x%x SCCOPE_ID 0x%x\n",
+			  getpid(), provider, ntohl(ser_qpn), ntohs(ser_lid),
+			  ntohl(scope_id));
+	} else if (my_sa->sa_family == AF_INET) {
+		ser_sin_addr = ((struct sockaddr_in *)my_sa)->sin_addr.s_addr;
+		LOGPRINTF("%d Server data to client: provider %s SIN_ADDR"
+			  " 0x%x\n", getpid(), provider, ser_sin_addr);
+	}
+
+	sprintf(msg, CONN_MSG_FMT, ser_lid, ser_qpn, scope_id,
+		ser_sin_addr, provider);
+	if (write(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "%d Couldn't send data", getpid());
+		return -1;
+	}
+	return 0;
+}
+
+static int send_server_params(struct sockaddr *ser_sa)
+{
+	in_port_t ser_lid = 0;
+	uint32_t scope_id = 0, ser_qpn = 0, ser_scope_id = 0, ser_sin_addr = 0;
+	int parsed, connfd;
+	struct in_addr sin_addr;	/* Internet address.  */
+	char msg[CONN_MSG_SIZE];
+
+	if (!ser_sa) {
+		printf("%d no address\n", getpid());
+		return -1;
+	}
+
+	if (ser_sa->sa_family == AF_INET6) {
+		ser_qpn = ((struct sockaddr_in6 *)ser_sa)->sin6_flowinfo;
+		ser_lid = ((struct sockaddr_in6 *)ser_sa)->sin6_port;
+		scope_id =
+			htonl(((struct sockaddr_in6 *)ser_sa)->sin6_scope_id);
+		LOGPRINTF("%d Server data to client: provider %s QPN 0x%x LID"
+			  " = 0x%x SCCOPE_ID 0x%x\n",
+			  getpid(), provider, ntohl(ser_qpn), ntohs(ser_lid),
+			  ntohl(scope_id));
+	} else if (ser_sa->sa_family == AF_INET) {
+		ser_sin_addr = ((struct sockaddr_in *)ser_sa)->sin_addr.s_addr;
+		LOGPRINTF("%d Server data to client: provider %s SIN_ADDR"
+			  " 0x%x\n",
+			  getpid(), provider, ser_sin_addr);
+	}
+
+	connfd = conn_server_connect(CONN_PORT);
+	if (connfd < 0) {
+		fprintf(stderr, "%d Failed to connect to client\n", getpid());
+		return -1;
+	}
+
+	sprintf(msg, CONN_MSG_FMT, ser_lid, ser_qpn, scope_id,
+		ser_sin_addr, provider);
+	if (write(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "%d Couldn't send data", getpid());
+		return -1;
+	}
+
+	ser_lid = ser_qpn = ser_scope_id = ser_sin_addr = 0;
+
+	/* get remote address from Client */
+	if (read(connfd, msg, sizeof msg) != sizeof msg) {
+		fprintf(stderr, "%d Couldn't read remote address\n", getpid());
+		return -1;
+	}
+
+	parsed = sscanf(msg, CONN_MSG_FMT, &ser_lid, &ser_qpn, &ser_scope_id,
+			&ser_sin_addr, provider);
+
+	if (parsed != 5) {
+		fprintf(stderr, "%d Couldn't parse line <%.*s>\n",
+			getpid(), (int)sizeof msg, msg);
+		return -1;
+	}
+
+	if (ser_sin_addr) {
+		sin_addr.s_addr = ser_sin_addr;
+		inet_ntop(AF_INET, &sin_addr, hostname, INET6_ADDRSTRLEN);
+		LOGPRINTF("%d remote data: provider %s hostname %s\n",
+			  getpid(), provider, hostname);
+	} else if (ser_lid && ser_qpn) {
+		remote.sin6_family = AF_INET6;
+		remote.sin6_port = ser_lid;
+		remote.sin6_flowinfo = ser_qpn;
+		remote.sin6_scope_id = ntohl(ser_scope_id);
+		ucm = 1;
+		LOGPRINTF("%d remote data: provider %s Client QPN 0x%x,"
+			  " LID = 0x%x, scope_id 0x%x\n",
+			  getpid(), provider, ntohl(ser_qpn), ntohs(ser_lid),
+			  ntohl(ser_scope_id));
+	} else {
+		fprintf(stderr, "%d No valid data was received"
+			" from the server\n",
+			getpid());
+		return -1;
+	}
+	return 0;
+}
+
 void
 send_msg(void *data,
 	 DAT_COUNT size,
@@ -253,27 +519,28 @@ send_msg(void *data,
 	for (i = 0; i < eps; i++) {
 		if (ud_test) {
 			/* 
-			 * Client and Server: ep[0] and ah[0] on single 
-			 * and ep[i] on multiple (-m) endpoint options. 
+			 * single QP - ep[0] and ah[0] for client and server
+			 * multi QP  - ep[i]->ah[i] for client, to 0
+			 *             ep[0]->ah[i] for server, to all
 			 */
 			if (multi_eps) {
-				ep_idx = i;
-				ah_idx = server ? 0 : i;
+				ah_idx = i;
+				if (!server)
+					ep_idx = i;
 			}
-			printf("%s sending on ep=%p to remote_ah: ah=%p"
-			       " qpn=0x%x addr=%s\n",
-			       server ? "Server" : "Client", ep[ep_idx],
-			       remote_ah[ah_idx].ah,
-			       remote_ah[ah_idx].qpn,
-			       inet_ntoa(((struct sockaddr_in *)
-					  &remote_ah[ah_idx].ia_addr)->
-					 sin_addr));
+
+			printf("%s send on ep=%p -> remote_ah[%d][%d]: ah=%p"
+			       " qpn=0x%x\n",
+			       server ? "Server" : "Client",
+			       ep[ep_idx], ep_idx, ah_idx,
+			       remote_ah[ep_idx][ah_idx].ah,
+			       remote_ah[ep_idx][ah_idx].qpn);
 
 			/* client expects all data in on first EP */
 			status = dat_ib_post_send_ud(ep[ep_idx],
 						     1,
 						     &iov,
-						     &remote_ah[ah_idx],
+						     &remote_ah[ep_idx][ah_idx],
 						     cookie, flags);
 
 		} else {
@@ -356,9 +623,9 @@ void process_conn(int idx)
 	DAT_EVENT event;
 	DAT_COUNT nmore;
 	DAT_RETURN status;
-	int pdata, exp_event;
+	int i, ep_r = 0, ep_l = 0, exp_event;
 	DAT_IB_EXTENSION_EVENT_DATA *ext_event = (DAT_IB_EXTENSION_EVENT_DATA *)
-	    & event.event_extension_data[0];
+	    &event.event_extension_data[0];
 	DAT_CONNECTION_EVENT_DATA *conn_event =
 	    &event.event_data.connect_event_data;
 
@@ -379,9 +646,7 @@ void process_conn(int idx)
 		exp_event = DAT_CONNECTION_EVENT_ESTABLISHED;
 
 	/* Waiting on CR's or CONN_EST */
-	if (event.event_number != exp_event ||  
-	    (ud_test && event.event_number !=
-		DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED)) {
+	if (event.event_number != exp_event) {
 		printf("unexpected event, !conn established: 0x%x\n",
 		event.event_number);
 		exit(1);
@@ -391,39 +656,64 @@ void process_conn(int idx)
 	if (!ud_test)
 		return;
 
-	/* store each remote_ah according to remote EP index */
-	pdata = ntoh32(*((int *)conn_event->private_data));
-	LOGPRINTF(" Client got private data=0x%x\n", pdata);
+	/* Initialize local EP index */
+	for (i=0;i<eps;i++) {
+		if (ep[i] == conn_event->ep_handle) {
+			ep_l = i;
+			break;
+		}
+	}
+
+	LOGPRINTF(" Client got private data: ep_idx = %d\n", ep_r);
 
-	/* UD, get AH for sends. 
+	/* UD, save AH for sends, active side only
 	 * NOTE: bi-directional AH resolution results in a CONN_EST
 	 * for both outbound connect and inbound CR.
-	 * Use Active CONN_EST which includes server's CR
-	 * pdata for remote_ah idx to send on and ignore PASSIVE CONN_EST.
+	 * Active pdata includes remote_ah EP idx.
 	 *
 	 * DAT_IB_UD_PASSIVE_REMOTE_AH == passive side CONN_EST
 	 * DAT_IB_UD_REMOTE_AH == active side CONN_EST
 	 */
 	if (ext_event->type == DAT_IB_UD_REMOTE_AH) {
-		remote_ah[pdata] = ext_event->remote_ah;
-		printf("remote_ah[%d]: ah=%p, qpn=0x%x "
-		       "addr=%s\n",
-		       pdata, remote_ah[pdata].ah,
-		       remote_ah[pdata].qpn, inet_ntoa(((struct sockaddr_in *)
-							&remote_ah[pdata].
-							ia_addr)->sin_addr));
-
-	} else if (ext_event->type != DAT_IB_UD_PASSIVE_REMOTE_AH) {
-		printf("unexpected UD ext_event type: 0x%x\n", ext_event->type);
+		ep_r = ntoh32(*((int *)conn_event->private_data));
+
+		/* AH exists for this remote EP, FREE if provider supports */
+		if (remote_ah[ep_l][ep_r].ah &&
+		    ia_attr.extension_version >= 209)
+			dat_ib_ud_ah_free(ep[ep_l], &ext_event->remote_ah);
+		else
+			remote_ah[ep_l][ep_r] = ext_event->remote_ah;
+
+		printf("CONNECT EP_L[%d]=%p (%p) -> remote_ah[%d][%d]: ah=%p,"
+		       "qpn=0x%x cm_ctx %p %lu\n",
+		       ep_l, ep[ep_l], conn_event->ep_handle, ep_l, ep_r,
+		       remote_ah[ep_l][ep_r].ah, remote_ah[ep_l][ep_r].qpn,
+		       ext_event->context.as_ptr, sizeof(*ext_event));
+
+	} else if (ext_event->type == DAT_IB_UD_PASSIVE_REMOTE_AH) {
+		if (ia_attr.extension_version >= 209) {
+			LOGPRINTF("PASSIVE EP_L[%d]=%p -> remote_ah %p qpn %d"
+				  " AH_FREE\n",
+				  ep_l, ep[ep_l], ext_event->remote_ah.ah,
+				  ext_event->remote_ah.qpn);
+			dat_ib_ud_ah_free(ep[ep_l], &ext_event->remote_ah);
+		}
+	} else {
+		printf("wrong UD ext_event type: 0x%x\n", ext_event->type);
 		exit(1);
 	}
+
+	if (ia_attr.extension_version >= 209) {
+		/* Destroy CM resources for AH resolution */
+		dat_ib_ud_cm_free(ep[ep_l], ext_event->context.as_ptr);
+	}
+
 }
 
-int connect_ep(char *hostname)
+int connect_ep(char *hostname, struct sockaddr *ser_sa)
 {
 	DAT_IA_ADDRESS_PTR remote_addr = (DAT_IA_ADDRESS_PTR)&remote;
 	DAT_EP_ATTR ep_attr;
-	DAT_IA_ATTR ia_attr;
 	DAT_RETURN status;
 	DAT_REGION_DESCRIPTION region;
 	DAT_EVENT event;
@@ -434,40 +724,9 @@ int connect_ep(char *hostname)
 	DAT_CONN_QUAL conn_qual;
 	DAT_BOOLEAN in, out;
 	int i, ii, pdata, ctx;
-	DAT_PROVIDER_ATTR prov_attrs;
 	DAT_DTO_COMPLETION_EVENT_DATA *dto_event =
 	    &event.event_data.dto_completion_event_data;
 
-	status = dat_ia_open(provider, 8, &async_evd, &ia);
-	_OK(status, "dat_ia_open");
-
-	memset(&prov_attrs, 0, sizeof(prov_attrs));
-	status = dat_ia_query(ia, NULL, 
-			      DAT_IA_FIELD_ALL, &ia_attr,
-			      DAT_PROVIDER_FIELD_ALL, &prov_attrs);
-	_OK(status, "dat_ia_query");
-
-	print_ia_address(ia_attr.ia_address_ptr);
-
-	if (ucm && ud_test) {
-		printf("%d UD test over UCM provider not supported\n",
-			getpid());
-		exit(1);
-	}
-
-	/* Print provider specific attributes */
-	for (i = 0; i < prov_attrs.num_provider_specific_attr; i++) {
-		LOGPRINTF(" Provider Specific Attribute[%d] %s=%s\n",
-			  i, prov_attrs.provider_specific_attr[i].name,
-			  prov_attrs.provider_specific_attr[i].value);
-
-		/* check for counter support */
-		status = strcmp(prov_attrs.provider_specific_attr[i].name,
-				"DAT_COUNTERS");
-		if (!status)
-			counters_ok = 1;
-	}
-
 	/* make sure provider supports counters */
 	if ((counters) && (!counters_ok)) {
 		printf("Disable dat_query_counters:"
@@ -561,13 +820,13 @@ int connect_ep(char *hostname)
 			cookie.as_64 = (ii * REG_MEM_COUNT) + i;
 			iov.lmr_context = lmr_context[(ii * REG_MEM_COUNT) + i];
 			iov.virtual_address =
-			    (DAT_VADDR) (uintptr_t) buf[(ii * REG_MEM_COUNT) +
-							i];
+				(DAT_VADDR) (uintptr_t) buf[(ii * REG_MEM_COUNT) + i];
 			iov.segment_length = buf_size;
-			LOGPRINTF(" post_recv (%p) on ep[%d]=%p\n",
-				  buf[(ii * REG_MEM_COUNT) + i], ii, ep[ii]);
-			/* ep[0], unless testing Server and multi EP's */
-			if (server && multi_eps) {
+			LOGPRINTF(" post_recv buf[%d]=(%p) on ep[%d]=%p\n",
+				(ii * REG_MEM_COUNT) + i,
+				buf[(ii * REG_MEM_COUNT) + i], ii, ep[ii]);
+			/* ep[0], unless multi EP's */
+			if (multi_eps) {
 				ep_idx = ii;
 				cookie.as_64 = i;
 			}
@@ -582,6 +841,15 @@ int connect_ep(char *hostname)
 	/* setup receive buffer to initial string to be overwritten */
 	strcpy((char *)buf[RCV_RDMA_BUF_INDEX], "blah, blah, blah\n");
 
+	if (server) {
+		/* Exchange info with client */
+		printf("%d Server - Client: waiting to snd addr\n", getpid());
+		if (send_server_params(ser_sa)) {
+			printf("%d Failed to send server params\n", getpid());
+			return -1;
+		}
+	}
+
 	/* ud can resolve_ah and connect both ways, same EP */
 	if (server || (!server && ud_test)) {
 		if (server) {
@@ -630,21 +898,31 @@ no_resolution:
 		 * use private data to select EP on Server 
 		 */
 		for (i = 0; i < eps; i++) {
+			int ep_l = 0;
+
 			/* pdata selects Server EP, 
 			 * support both muliple Server and single EP's 
 			 */
-			if (multi_eps)
+			if (multi_eps) {
+				if (!server)
+					ep_l = i;
 				pdata = hton32(i);
-			else
+			} else
 				pdata = 0;	/* just use first EP */
 
-			status = dat_ep_connect(ep[0],
+			status = dat_ep_connect(ep[ep_l],
 						remote_addr,
 						(server ? CLIENT_ID :
 						 SERVER_ID), CONN_TIMEOUT, 4,
-						(DAT_PVOID) & pdata, 0,
+						(DAT_PVOID) &pdata, 0,
 						DAT_CONNECT_DEFAULT_FLAG);
 			_OK(status, "dat_ep_connect");
+
+			printf("%s EP_L[%d]=%p connect to EP_R[%d]\n",
+				  server ? "Server" : "Client",
+				  ep_l, ep[ep_l],
+				  ntoh32(pdata));
+
 		}
 
 		if (!ucm)
@@ -700,7 +978,7 @@ no_resolution:
 		LOGPRINTF("Waiting for remote to send RMR data\n");
 
 		status = dat_evd_wait(dto_evd, DTO_TIMEOUT, 1, &event, &nmore);
-		_OK(status, "dat_evd_wait after dat_ep_post_send");
+		_OK(status, "dat_evd_wait for receive message");
 
 		if ((event.event_number != DAT_DTO_COMPLETION_EVENT) &&
 		    (ud_test && event.event_number != DAT_IB_DTO_EVENT)) {
@@ -710,11 +988,11 @@ no_resolution:
 		}
 		_OK(dto_event->status, "event status for post_recv");
 
-		/* careful when checking cookies:
-		 * Client - receiving multi messages on a single EP 
-		 * Server - not receiving on multiple EP's
+		/*
+		 *  multi_eps - receive multi messages on single EP
+		 * !mutli_eps - receive one message across multiple EPs
 		 */
-		if (!server || (server && !multi_eps)) {
+		if (!multi_eps) {
 			if (dto_event->transfered_length != msg_size ||
 			    dto_event->user_cookie.as_64 != ctx) {
 				printf("unexpected event data on recv: len=%d"
@@ -724,12 +1002,11 @@ no_resolution:
 				       msg_size, ctx);
 				exit(1);
 			}
-			/* Server - receiving one message each across many EP's */
 		} else {
 			if (dto_event->transfered_length != msg_size ||
 			    dto_event->user_cookie.as_64 != RECV_BUF_INDEX) {
 				printf("unexpected event data on recv: len=%d"
-				       "cookie=" F64x " expected %d/%d\n",
+				       " cookie=" F64x " expected %d/%d\n",
 				       (int)dto_event->transfered_length,
 				       dto_event->user_cookie.as_64,
 				       msg_size, RECV_BUF_INDEX);
@@ -738,12 +1015,10 @@ no_resolution:
 		}
 
 		/* swap RMR,address info to host order */
-		if (!server || (server && !multi_eps))
+		if (!multi_eps)
 			r_iov = (DAT_RMR_TRIPLET *) buf[ctx];
 		else
-			r_iov =
-			    (DAT_RMR_TRIPLET *) buf[(i * REG_MEM_COUNT) +
-						    RECV_BUF_INDEX];
+			r_iov = (DAT_RMR_TRIPLET *) buf[((i * REG_MEM_COUNT) + RECV_BUF_INDEX)];
 
 		if (ud_test)
 			r_iov = (DAT_RMR_TRIPLET *) ((char *)r_iov + 40);
@@ -752,11 +1027,14 @@ no_resolution:
 		r_iov->virtual_address = ntoh64(r_iov->virtual_address);
 		r_iov->segment_length = ntoh32(r_iov->segment_length);
 
-		printf("Recv RMR message: r_iov(%p):"
-		       " r_key_ctx=%x,va=" F64x ",len=0x%x on EP=%p\n",
+		printf("Recv RMR message: buf[%d] r_iov(%p):"
+		       " r_key_ctx=%x,va=" F64x ","
+		       " len=0x%x on EP=%p ck=" F64x " \n",
+		       multi_eps ? ((i * REG_MEM_COUNT) + RECV_BUF_INDEX):ctx,
 		       r_iov, r_iov->rmr_context,
 		       r_iov->virtual_address,
-		       r_iov->segment_length, dto_event->ep_handle);
+		       r_iov->segment_length, dto_event->ep_handle,
+		       dto_event->user_cookie.as_64);
 	}
 	return (0);
 }
@@ -766,7 +1044,7 @@ int disconnect_ep(void)
 	DAT_RETURN status;
 	DAT_EVENT event;
 	DAT_COUNT nmore;
-	int i;
+	int i, ii;
 	
 	if (counters) {		/* examples of query and print */
 		int ii;
@@ -788,6 +1066,7 @@ int disconnect_ep(void)
 				      &event, &nmore);
 		_OK(status, "dat_evd_wait");
 	}
+
 	if (psp) {
 		status = dat_psp_free(psp);
 		_OK2(status, "dat_psp_free");
@@ -813,6 +1092,22 @@ int disconnect_ep(void)
 			printf("\n");
 			dat_print_counters(ep[i], DCNT_EP_ALL_COUNTERS, 0);
 		}
+
+		/* free UD AH resources */
+		if (ia_attr.extension_version >= 209) {
+			for (ii = 0; ii < MAX_AH_COUNT; ii++) {
+				if (remote_ah[i][ii].ah) {
+					printf( "UD_AH_FREE on EP %p, AH EP[%d][%d]"
+					        "ib_ah = %p\n",
+						ep[i], i, ii,
+						remote_ah[i][ii].ah);
+					dat_ib_ud_ah_free(ep[i],
+							  &remote_ah[i][ii]);
+				}
+				remote_ah[i][ii].ah = NULL;
+			}
+		}
+
 		status = dat_ep_free(ep[i]);
 		_OK2(status, "dat_ep_free");
 	}
@@ -1242,12 +1537,14 @@ int do_fetch_add()
 	return (0);
 }
 
+
 int main(int argc, char **argv)
 {
-	int rc;
+	int i, rc;
+	DAT_RETURN status;
 
 	/* parse arguments */
-	while ((rc = getopt(argc, argv, "csvumpU:h:b:P:q:l:")) != -1) {
+	while ((rc = getopt(argc, argv, "csvumpU:h:b:P:")) != -1) {
 		switch (rc) {
 		case 'u':
 			ud_test = 1;
@@ -1282,20 +1579,6 @@ int main(int argc, char **argv)
 		case 'v':
 			verbose = 1;
 			break;
-		case 'q':
-			/* map UCM qpn into AF_INET6 sin6_flowinfo */
-			remote.sin6_family = AF_INET6;
-			remote.sin6_flowinfo = htonl(strtol(optarg,NULL,0));
-			ucm = 1;
-			server = 0;
-			break;
-		case 'l':
-			/* map UCM lid into AF_INET6 sin6_port */
-			remote.sin6_family = AF_INET6;
-			remote.sin6_port = htons(strtol(optarg,NULL,0));
-			ucm = 1;
-			server = 0;
-			break;
 		default:
 			print_usage();
 			exit(-12);
@@ -1315,42 +1598,80 @@ int main(int argc, char **argv)
 		}
 	}
 #endif
+	status = dat_ia_open(provider, 8, &async_evd, &ia);
+	_OK(status, "dat_ia_open");
+
+	memset(&prov_attrs, 0, sizeof(prov_attrs));
+	status = dat_ia_query(ia, NULL,
+			      DAT_IA_FIELD_ALL, &ia_attr,
+			      DAT_PROVIDER_FIELD_ALL, &prov_attrs);
+	_OK(status, "dat_ia_query");
+
+	if (ia_attr.extension_supported != DAT_EXTENSION_IB) {
+		printf("%d ERROR: IB extension not supported\n", getpid());
+		exit(1);
+	}
+
+	print_ia_address(ia_attr.ia_address_ptr);
+
+	/* Print provider specific attributes */
+	for (i = 0; i < prov_attrs.num_provider_specific_attr; i++) {
+		LOGPRINTF(" Provider Specific Attribute[%d] %s=%s\n",
+			  i, prov_attrs.provider_specific_attr[i].name,
+			  prov_attrs.provider_specific_attr[i].value);
+
+		rc = strcmp(prov_attrs.provider_specific_attr[i].name,
+				"DAT_COUNTERS");
+		if (!rc)
+			counters_ok = 1;
+	}
+
+
 	/* for non UD tests, -h is always client */
 	if (remote_host && !ud_test)
 		server = 0;
 
 	if (!server) {
-		printf("\nRunning as Client - %s %s %d endpoint(s)\n",
-		       provider, ud_test ? "UD test" : "", eps);
+		printf("%d Client: waiting for server input\n", getpid());
+		if (get_server_params(ia_attr.ia_address_ptr)) {
+			printf("%d Failed to get server parameters\n",
+				getpid());
+			exit(1);
+		}
+		printf("\nRunning as Client - %s %s %d endpoint(s) v%d\n",
+		       provider, ud_test ? "UD test" : "", eps,
+		       ia_attr.extension_version);
 	} else {
-		printf("\nRunning as Server - %s %s %d endpoint(s)\n",
-		       provider, ud_test ? "UD test" : "", eps);
+		printf("\nRunning as Server - %s %s %d endpoint(s) v%d\n",
+		       provider, ud_test ? "UD test" : "", eps,
+		       ia_attr.extension_version);
 	}
 
 	/*
 	 * connect
 	 */
-	if (connect_ep(hostname)) {
+	if (connect_ep(hostname, ia_attr.ia_address_ptr)) {
 		_WSACleanup();
 		exit(1);
 	}
-	if (ud_test)
-		goto bail;
 
-	if (do_immediate()) {
-		_WSACleanup();
-		exit(1);
-	}
-	if (do_cmp_swap()) {
-		_WSACleanup();
-		exit(1);
-	}
-	if (do_fetch_add()) {
-		_WSACleanup();
-		exit(1);
+	if (!ud_test) {
+		if (do_immediate()) {
+			_WSACleanup();
+			exit(1);
+		}
+		if (do_cmp_swap()) {
+			_WSACleanup();
+			exit(1);
+		}
+		if (do_fetch_add()) {
+			_WSACleanup();
+			exit(1);
+		}
 	}
-      bail:
+
 	rc = disconnect_ep();
+	dat_ia_close(ia, DAT_CLOSE_DEFAULT);
 	_WSACleanup();
 
 	if (!rc)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
