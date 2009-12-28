From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Mon, 28 Dec 2009 11:22:51 +0200
Message-ID: <20091228092251.GR26940@me>
References: <20090813204306.dffc3237.weiny2@llnl.gov>
 <20090816110200.GS25501@me>
 <20090817083023.da17378b.weiny2@llnl.gov>
 <20090823120609.GG9547@me>
 <20090826164026.8dcce4b2.weiny2@llnl.gov>
 <20091023234349.GK5764@me>
 <20091220121406.GF5262@me>
 <20091220182809.f7e17fae.weiny2@llnl.gov>
 <20091221073550.GB18524@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091221073550.GB18524@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 09:35 Mon 21 Dec     , Sasha Khapyorsky wrote:
> 
> An errors are response timeouts. I guess that most of them are due
> to switches' VL15 overflow (could be verified by VL15Dropped counter
> evaluation). Will look at this deeply.

I did a couple of modifications in the code (exact log is listed below).
In particular there are default limitation for number of outstanding MADs
on the wire and proper tracking for failed (timedout) MADs. I tested
this where possible. Could you re-run this? Thanks.

Sasha


commit 9e24853c30351f6ea65ffcccf184bdf7586dfe8e
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Fri Dec 25 13:01:35 2009 +0200

    tests/subnet_discover: limit possible number of hops
    
    As pointed out by Ira there was no hops limitation. Adding this.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index a577cc7..9857913 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -17,6 +17,8 @@
 #include <infiniband/umad.h>
 #include <infiniband/mad.h>
 
+#define MAX_HOPS 63
+
 struct port {
 	struct node *node;
 	uint64_t guid;
@@ -217,8 +219,9 @@ static int process_port_info(void *umad, unsigned node_id, int fd, int agent,
 	if (port_num &&
 	    mad_get_field(port_info, 0, IB_PORT_PHYS_STATE_F) == 5 &&
 	    ((node->is_switch && port_num != local_port) ||
-	     (node_id == 0 && port_num == local_port))) {
-		path[++path_cnt] = port_num;
+	     (node_id == 0 && port_num == local_port)) &&
+	    path_cnt++ < MAX_HOPS) {
+		path[path_cnt] = port_num;
 		return query_node_info(fd, agent, umad, node_id, path,
 				       path_cnt);
 	}

commit 6e7817433c17bf2b8861639852dc0e70e8d0ec5f
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Fri Dec 25 16:11:53 2009 +0200

    tests/subnet_discover: add --help option
    
    Add --help command line option. Also cosmetic improvements.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index 9857913..7f8a85c 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -70,7 +70,7 @@ DBG_DUMP_FUNC(nodedesc);
 DBG_DUMP_FUNC(portinfo);
 DBG_DUMP_FUNC(switchinfo);
 
-static void build_umad_req(void *umad, uint8_t * path, unsigned path_cnt,
+static void build_umad_req(void *umad, uint8_t path[], unsigned path_cnt,
 			   uint64_t trid, uint8_t method,
 			   uint16_t attr_id, uint32_t attr_mod, uint64_t mkey)
 {
@@ -94,7 +94,7 @@ static void build_umad_req(void *umad, uint8_t * path, unsigned path_cnt,
 }
 
 static int send_query(int fd, int agent, void *umad, unsigned node_id,
-		      uint8_t * path, size_t path_cnt, uint16_t attr_id,
+		      uint8_t path[], size_t path_cnt, uint16_t attr_id,
 		      uint32_t attr_mod)
 {
 	uint64_t trid;
@@ -138,28 +138,28 @@ static int recv_response(int fd, int agent, uint8_t * umad, size_t length)
 }
 
 static int query_node_info(int fd, int agent, void *umad, unsigned node_id,
-			   uint8_t * path, size_t path_cnt)
+			   uint8_t path[], size_t path_cnt)
 {
 	return send_query(fd, agent, umad, node_id, path, path_cnt,
 			  IB_ATTR_NODE_INFO, 0);
 }
 
 static int query_node_desc(int fd, int agent, void *umad, unsigned node_id,
-			   uint8_t * path, size_t path_cnt)
+			   uint8_t path[], size_t path_cnt)
 {
 	return send_query(fd, agent, umad, node_id, path, path_cnt,
 			  IB_ATTR_NODE_DESC, 0);
 }
 
 static int query_switch_info(int fd, int agent, void *umad, unsigned node_id,
-			     uint8_t * path, size_t path_cnt)
+			     uint8_t path[], size_t path_cnt)
 {
 	return send_query(fd, agent, umad, node_id, path, path_cnt,
 			  IB_ATTR_SWITCH_INFO, 0);
 }
 
 static int query_port_info(int fd, int agent, void *umad, unsigned node_id,
-			   uint8_t * path, size_t path_cnt, unsigned port_num)
+			   uint8_t path[], size_t path_cnt, unsigned port_num)
 {
 	return send_query(fd, agent, umad, node_id, path, path_cnt,
 			  IB_ATTR_PORT_INFO, port_num);
@@ -456,6 +456,8 @@ int main(int argc, char **argv)
 		{"Port", 1, 0, 'P'},
 		{"timeout", 1, 0, 't'},
 		{"retries", 1, 0, 'r'},
+		{"verbose", 0, 0, 'v'},
+		{"help", 0, 0, 'h'},
 		{}
 	};
 	char *card_name = NULL;
@@ -463,7 +465,7 @@ int main(int argc, char **argv)
 	int ch, ret;
 
 	while (1) {
-		ch = getopt_long(argc, argv, "C:P:t:r:v", long_opts, NULL);
+		ch = getopt_long(argc, argv, "C:P:t:r:vh", long_opts, NULL);
 		if (ch == -1)
 			break;
 		switch (ch) {
@@ -482,6 +484,7 @@ int main(int argc, char **argv)
 		case 'v':
 			verbose++;
 			break;
+		case 'h':
 		default:
 			printf("usage: %s [-C card_name] [-P port_num]"
 			       " [-t timeout] [-r retries] [-v[v]]\n", argv[0]);

commit da6aa19840cb2d37e8cd3daa3874b87657a76ddc
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Fri Dec 25 16:24:13 2009 +0200

    tests/subnet_discover: --maxsmps (-n) option
    
    This implements the limitation of outstanding SMPs on a wire at any
    one time. --maxsmps=0 means - no limit.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index 7f8a85c..42e7aee 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -40,6 +40,7 @@ static struct node *node_array[32 * 1024];
 static unsigned node_count = 0;
 static unsigned trid_cnt = 0;
 static unsigned outstanding = 0;
+static unsigned max_outstanding = 8;
 static unsigned timeout = 100;
 static unsigned retries = 3;
 static unsigned verbose = 0;
@@ -93,14 +94,12 @@ static void build_umad_req(void *umad, uint8_t path[], unsigned path_cnt,
 	mad_set_field64(mad, 0, IB_MAD_MKEY_F, mkey);
 }
 
-static int send_query(int fd, int agent, void *umad, unsigned node_id,
-		      uint8_t path[], size_t path_cnt, uint16_t attr_id,
-		      uint32_t attr_mod)
+static int send_request(int fd, int agent, uint64_t trid, uint8_t * path,
+			size_t path_cnt, uint16_t attr_id, uint32_t attr_mod)
 {
-	uint64_t trid;
+	uint8_t umad[IB_MAD_SIZE + umad_size()];
 	int ret;
 
-	trid = (trid_cnt++ << 16) | (node_id & 0xffff);
 	build_umad_req(umad, path, path_cnt, trid, IB_MAD_METHOD_GET, attr_id,
 		       attr_mod, 0);
 
@@ -112,14 +111,85 @@ static int send_query(int fd, int agent, void *umad, unsigned node_id,
 		return -1;
 	}
 
-	outstanding++;
-
 	VERBOSE("send %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
 		attr_mod, print_path(path, path_cnt));
 
 	return ret;
 }
 
+static struct request_queue {
+	struct request_queue *next;
+	uint64_t trid;
+	uint16_t attr_id;
+	uint32_t attr_mod;
+	size_t path_cnt;
+	uint8_t path[0];
+} request_queue;
+
+static struct request_queue *request_last = &request_queue;
+
+static void run_request_queue(int fd, int agent)
+{
+	struct request_queue *prev, *q = request_queue.next;
+
+	while (q) {
+		if (outstanding > max_outstanding)
+			break;
+		if (send_request(fd, agent, q->trid, q->path, q->path_cnt,
+				 q->attr_id, q->attr_mod) < 0)
+			break;
+		prev = q;
+		q = q->next;
+		free(prev);
+		outstanding++;
+	}
+	request_queue.next = q;
+	if (!q)
+		request_last = &request_queue;
+}
+
+static int queue_request(uint64_t trid, uint8_t * path, size_t path_cnt,
+			 uint16_t attr_id, uint32_t attr_mod)
+{
+	struct request_queue *q = malloc(sizeof(*q) + path_cnt + 1);
+	if (!q)
+		return -1;
+	q->next = NULL;
+	q->trid = trid;
+	q->attr_id = attr_id;
+	q->attr_mod = attr_mod;
+	memcpy(q->path, path, path_cnt + 1);
+	q->path_cnt = path_cnt;
+
+	request_last->next = q;
+	request_last = q;
+
+	return 0;
+}
+
+static int send_query(int fd, int agent, unsigned node_id, uint8_t path[],
+		      size_t path_cnt, uint16_t attr_id, uint32_t attr_mod)
+{
+	uint64_t trid;
+	int ret;
+
+	trid = (trid_cnt++ << 16) | (node_id & 0xffff);
+
+	ret = queue_request(trid, path, path_cnt, attr_id, attr_mod);
+	if (ret < 0) {
+		ERROR("queue failed: trid 0x%016" PRIx64 ", attr_id %x,"
+		      " attr_mod %x\n", trid, attr_id, attr_mod);
+		return -1;
+	}
+
+	VERBOSE("queue %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
+		attr_mod, print_path(path, path_cnt));
+
+	run_request_queue(fd, agent);
+
+	return ret;
+}
+
 static int recv_response(int fd, int agent, uint8_t * umad, size_t length)
 {
 	int len = length, ret;
@@ -137,31 +207,31 @@ static int recv_response(int fd, int agent, uint8_t * umad, size_t length)
 	return ret;
 }
 
-static int query_node_info(int fd, int agent, void *umad, unsigned node_id,
+static int query_node_info(int fd, int agent, unsigned node_id,
 			   uint8_t path[], size_t path_cnt)
 {
-	return send_query(fd, agent, umad, node_id, path, path_cnt,
+	return send_query(fd, agent, node_id, path, path_cnt,
 			  IB_ATTR_NODE_INFO, 0);
 }
 
-static int query_node_desc(int fd, int agent, void *umad, unsigned node_id,
+static int query_node_desc(int fd, int agent, unsigned node_id,
 			   uint8_t path[], size_t path_cnt)
 {
-	return send_query(fd, agent, umad, node_id, path, path_cnt,
+	return send_query(fd, agent, node_id, path, path_cnt,
 			  IB_ATTR_NODE_DESC, 0);
 }
 
-static int query_switch_info(int fd, int agent, void *umad, unsigned node_id,
+static int query_switch_info(int fd, int agent, unsigned node_id,
 			     uint8_t path[], size_t path_cnt)
 {
-	return send_query(fd, agent, umad, node_id, path, path_cnt,
+	return send_query(fd, agent, node_id, path, path_cnt,
 			  IB_ATTR_SWITCH_INFO, 0);
 }
 
-static int query_port_info(int fd, int agent, void *umad, unsigned node_id,
+static int query_port_info(int fd, int agent, unsigned node_id,
 			   uint8_t path[], size_t path_cnt, unsigned port_num)
 {
-	return send_query(fd, agent, umad, node_id, path, path_cnt,
+	return send_query(fd, agent, node_id, path, path_cnt,
 			  IB_ATTR_PORT_INFO, port_num);
 }
 
@@ -222,8 +292,7 @@ static int process_port_info(void *umad, unsigned node_id, int fd, int agent,
 	     (node_id == 0 && port_num == local_port)) &&
 	    path_cnt++ < MAX_HOPS) {
 		path[path_cnt] = port_num;
-		return query_node_info(fd, agent, umad, node_id, path,
-				       path_cnt);
+		return query_node_info(fd, agent, node_id, path, path_cnt);
 	}
 
 	return 0;
@@ -289,13 +358,13 @@ static int process_node(void *umad, unsigned remote_id, int fd, int agent,
 	if (!node_is_new)
 		return 0;
 
-	query_node_desc(fd, agent, umad, id, path, path_cnt);
+	query_node_desc(fd, agent, id, path, path_cnt);
 
 	if (node->is_switch)
-		query_switch_info(fd, agent, umad, id, path, path_cnt);
+		query_switch_info(fd, agent, id, path, path_cnt);
 
 	for (i = !node->is_switch; i <= node->num_ports; i++)
-		query_port_info(fd, agent, umad, id, path, path_cnt, i);
+		query_port_info(fd, agent, id, path, path_cnt, i);
 
 	return 0;
 }
@@ -327,6 +396,7 @@ static int recv_smp_resp(int fd, int agent, uint8_t * umad, uint8_t path[])
 		return 0;
 
 	outstanding--;
+	run_request_queue(fd, agent);
 
 	if (ret < 0 || status) {
 		ERROR("error response 0x%016" PRIx64 ": attr_id %x"
@@ -362,17 +432,13 @@ static int recv_smp_resp(int fd, int agent, uint8_t * umad, uint8_t path[])
 	return ret;
 }
 
-static int discovery(int fd, int agent)
+static int discover(int fd, int agent)
 {
+	uint8_t umad[IB_MAD_SIZE + umad_size()];
 	uint8_t path[64] = { 0 };
-	void *umad;
 	int ret;
 
-	umad = malloc(IB_MAD_SIZE + umad_size());
-	if (!umad)
-		return -ENOMEM;
-
-	ret = query_node_info(fd, agent, umad, 0, path, 0);
+	ret = query_node_info(fd, agent, 0, path, 0);
 	if (ret < 0)
 		return ret;
 
@@ -380,12 +446,10 @@ static int discovery(int fd, int agent)
 		if (recv_smp_resp(fd, agent, umad, path))
 			ret = 1;
 
-	free(umad);
-
 	return ret;
 }
 
-static int umad_discovery(char *card_name, unsigned int port_num)
+static int umad_discover(char *card_name, unsigned int port_num)
 {
 	int fd, agent, ret;
 
@@ -411,7 +475,7 @@ static int umad_discovery(char *card_name, unsigned int port_num)
 		return -1;
 	}
 
-	ret = discovery(fd, agent);
+	ret = discover(fd, agent);
 	if (ret)
 		ERROR("Failed to discover.\n");
 
@@ -454,6 +518,7 @@ int main(int argc, char **argv)
 	const struct option long_opts[] = {
 		{"Card", 1, 0, 'C'},
 		{"Port", 1, 0, 'P'},
+		{"maxsmps", 1, 0, 'n'},
 		{"timeout", 1, 0, 't'},
 		{"retries", 1, 0, 'r'},
 		{"verbose", 0, 0, 'v'},
@@ -465,7 +530,7 @@ int main(int argc, char **argv)
 	int ch, ret;
 
 	while (1) {
-		ch = getopt_long(argc, argv, "C:P:t:r:vh", long_opts, NULL);
+		ch = getopt_long(argc, argv, "C:P:n:t:r:vh", long_opts, NULL);
 		if (ch == -1)
 			break;
 		switch (ch) {
@@ -475,6 +540,11 @@ int main(int argc, char **argv)
 		case 'P':
 			port_num = strtoul(optarg, NULL, 0);
 			break;
+		case 'n':
+			max_outstanding = strtoul(optarg, NULL, 0);
+			if (!max_outstanding)
+				max_outstanding = -1;
+			break;
 		case 't':
 			timeout = strtoul(optarg, NULL, 0);
 			break;
@@ -487,13 +557,14 @@ int main(int argc, char **argv)
 		case 'h':
 		default:
 			printf("usage: %s [-C card_name] [-P port_num]"
-			       " [-t timeout] [-r retries] [-v[v]]\n", argv[0]);
+			       " [-n maxsmps] [-t timeout] [-r retries]"
+			       " [-v[v]]\n", argv[0]);
 			exit(2);
 			break;
 		}
 	}
 
-	ret = umad_discovery(card_name, port_num);
+	ret = umad_discover(card_name, port_num);
 
 	print_subnet();
 

commit a422ea90334441144f2a1212de40085bbe36cf7e
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Dec 27 18:55:35 2009 +0200

    tests/subnet_discover.c: print useful information
    
    Print additional useful information about a subnet and discovery
    process: such as number of MADs used, number of hops reached, direct
    paths for nodes as it was discovered. Better error messages (in
    particular - don't print MAD content in error message when returned
    valid data from umad_recv() is only umad header).
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index 42e7aee..b6aada9 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -30,6 +30,8 @@ struct node {
 	uint64_t guid;
 	unsigned num_ports;
 	unsigned is_switch;
+	size_t path_size;
+	uint8_t path[64];
 	uint8_t node_info[IB_SMP_DATA_SIZE];
 	uint8_t node_desc[IB_SMP_DATA_SIZE];
 	uint8_t switch_info[IB_SMP_DATA_SIZE];
@@ -45,6 +47,9 @@ static unsigned timeout = 100;
 static unsigned retries = 3;
 static unsigned verbose = 0;
 
+static unsigned total_mads = 0;
+static unsigned max_hops = 0;
+
 #define ERROR(fmt, ...) fprintf(stderr, "ERR: " fmt, ##__VA_ARGS__)
 #define VERBOSE(fmt, ...) if (verbose) fprintf(stderr, fmt, ##__VA_ARGS__)
 #define NOISE(fmt, ...) if (verbose > 1) fprintf(stderr, fmt, ##__VA_ARGS__)
@@ -142,6 +147,7 @@ static void run_request_queue(int fd, int agent)
 		q = q->next;
 		free(prev);
 		outstanding++;
+		total_mads++;
 	}
 	request_queue.next = q;
 	if (!q)
@@ -201,10 +207,10 @@ static int recv_response(int fd, int agent, uint8_t * umad, size_t length)
 	if (ret < 0 || umad_status(umad)) {
 		ERROR("umad_recv failed: umad status %x: %s\n",
 		      umad_status(umad), strerror(errno));
-		return -1;
+		return len > umad_size() ? 1 : -1;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int query_node_info(int fd, int agent, unsigned node_id,
@@ -235,7 +241,7 @@ static int query_port_info(int fd, int agent, unsigned node_id,
 			  IB_ATTR_PORT_INFO, port_num);
 }
 
-static int add_node(uint8_t * node_info)
+static int add_node(uint8_t * node_info, uint8_t path[], size_t path_size)
 {
 	struct node *node;
 	unsigned i, num_ports = mad_get_field(node_info, 0, IB_NODE_NPORTS_F);
@@ -250,6 +256,8 @@ static int add_node(uint8_t * node_info)
 	node->guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
 	node->is_switch = ((mad_get_field(node_info, 0, IB_NODE_TYPE_F)) ==
 			   IB_NODE_SWITCH);
+	memcpy(node->path, path, path_size + 1);
+	node->path_size = path_size;
 	memcpy(node->node_info, node_info, sizeof(node->node_info));
 	for (i = 0; i <= num_ports; i++)
 		node->ports[i].node = node;
@@ -291,6 +299,8 @@ static int process_port_info(void *umad, unsigned node_id, int fd, int agent,
 	    ((node->is_switch && port_num != local_port) ||
 	     (node_id == 0 && port_num == local_port)) &&
 	    path_cnt++ < MAX_HOPS) {
+		if (path_cnt > max_hops)
+			max_hops = path_cnt;
 		path[path_cnt] = port_num;
 		return query_node_info(fd, agent, node_id, path, path_cnt);
 	}
@@ -341,7 +351,7 @@ static int process_node(void *umad, unsigned remote_id, int fd, int agent,
 	dbg_dump_nodeinfo(node_info);
 
 	if ((id = find_node(node_info)) < 0) {
-		id = add_node(node_info);
+		id = add_node(node_info, path, path_cnt);
 		if (id < 0)
 			return -1;
 		node_is_new = 1;
@@ -398,7 +408,9 @@ static int recv_smp_resp(int fd, int agent, uint8_t * umad, uint8_t path[])
 	outstanding--;
 	run_request_queue(fd, agent);
 
-	if (ret < 0 || status) {
+	if (ret < 0)
+		return ret;
+	else if (ret || status) {
 		ERROR("error response 0x%016" PRIx64 ": attr_id %x"
 		      ", attr_mod %x from %s with status %x\n", trid,
 		      attr_id, attr_mod, print_path(path, path_cnt), status);
@@ -477,7 +489,7 @@ static int umad_discover(char *card_name, unsigned int port_num)
 
 	ret = discover(fd, agent);
 	if (ret)
-		ERROR("Failed to discover.\n");
+		fprintf(stderr, "\nThere are problems during discovery.\n");
 
 	umad_unregister(fd, agent);
 	umad_close_port(fd);
@@ -493,12 +505,15 @@ static void print_subnet()
 	struct port *local, *remote;
 	unsigned i, j;
 
+	printf("\n# The subnet discovered using %u mads, reaching %d hops\n\n",
+	       total_mads, max_hops);
+
 	for (i = 0; i < node_count; i++) {
 		node = node_array[i];
-		printf("%s %u \"%s-%016" PRIx64 "\" \t# %s\n",
+		printf("%s %u \"%s-%016" PRIx64 "\" \t# %s %s\n",
 		       node->is_switch ? "Switch" : "Ca", node->num_ports,
 		       node->is_switch ? "S" : "H", node->guid,
-		       node->node_desc);
+		       print_path(node->path, node->path_size), node->node_desc);
 		for (j = 1; j <= node->num_ports; j++) {
 			local = &node->ports[j];
 			remote = local->remote;

commit 4a23f9e7f339e93f2a77f213d4ce80e4bc7d7b9f
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Dec 27 21:19:30 2009 +0200

    tests/subnet_discover: report unresponded transactions
    
    Report unresponded transactions (requests) in case of MAD failures.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index b6aada9..acc8c23 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -133,9 +133,60 @@ static struct request_queue {
 
 static struct request_queue *request_last = &request_queue;
 
+static unsigned tr_table_size;
+static struct request_queue **tr_table;
+
+static void add_to_tr_table(struct request_queue *q, uint64_t trid)
+{
+	unsigned n = trid >> 16;
+	if (n >= tr_table_size) {
+		unsigned new_size = tr_table_size ? tr_table_size * 2 : 4096;
+		if (n > new_size)
+			new_size = n + 1;
+		tr_table = realloc(tr_table, new_size * sizeof(tr_table[0]));
+		if (!tr_table) {
+			ERROR("cannot realloc request table\n");
+			tr_table_size = 0;
+			return;
+		}
+		memset(tr_table + tr_table_size, 0,
+		       (new_size - tr_table_size) * sizeof(tr_table[0]));
+		tr_table_size = new_size;
+	}
+
+	tr_table[n] = q;
+}
+
+static void clean_from_tr_table(uint64_t trid)
+{
+	unsigned n = (trid >> 16) & 0xffff;
+	if (n >= tr_table_size) {
+		ERROR("invalid request table index %u\n", n);
+		return;
+	}
+	free(tr_table[n]);
+	tr_table[n] = NULL;
+}
+
+static void free_unresponded()
+{
+	struct request_queue *q;
+	unsigned i;
+
+	for (i = 0 ; i < tr_table_size; i++) {
+		if (!(q = tr_table[i]))
+			continue;
+		fprintf(stderr, "Unresponded transaction %016" PRIx64 ": %s "
+			"attr_id %x, attr_mod %x\n", q->trid,
+			print_path(q->path, q->path_cnt), q->attr_id,
+			q->attr_mod);
+		free(q);
+	}
+}
+
 static void run_request_queue(int fd, int agent)
 {
-	struct request_queue *prev, *q = request_queue.next;
+	struct request_queue *q = request_queue.next;
 
 	while (q) {
 		if (outstanding > max_outstanding)
@@ -143,9 +194,7 @@ static void run_request_queue(int fd, int agent)
 		if (send_request(fd, agent, q->trid, q->path, q->path_cnt,
 				 q->attr_id, q->attr_mod) < 0)
 			break;
-		prev = q;
 		q = q->next;
-		free(prev);
 		outstanding++;
 		total_mads++;
 	}
@@ -170,6 +219,8 @@ static int queue_request(uint64_t trid, uint8_t * path, size_t path_cnt,
 	request_last->next = q;
 	request_last = q;
 
+	add_to_tr_table(q, trid);
+
 	return 0;
 }
 
@@ -417,6 +468,8 @@ static int recv_smp_resp(int fd, int agent, uint8_t * umad, uint8_t path[])
 		return -1;
 	}
 
+	clean_from_tr_table(trid);
+
 	node_id = trid & 0xffff;
 
 	VERBOSE("recv %016" PRIx64 ": attr %x, mod %x from %s\n", trid, attr_id,
@@ -458,6 +511,8 @@ static int discover(int fd, int agent)
 		if (recv_smp_resp(fd, agent, umad, path))
 			ret = 1;
 
+	free_unresponded();
+
 	return ret;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
