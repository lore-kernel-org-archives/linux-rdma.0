From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] tests/subnet_discover: verbose node discovery printout
Date: Sat, 10 Apr 2010 02:56:52 +0300
Message-ID: <20100409235652.GG4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100218124931.4d6ef34b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Improve verbosity levels: with '-v' print nodes as they are discovered,
more 'v' - more noise.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 tests/subnet_discover.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tests/subnet_discover.c b/tests/subnet_discover.c
index 22b092a..44cd86e 100644
--- a/tests/subnet_discover.c
+++ b/tests/subnet_discover.c
@@ -52,7 +52,9 @@ static unsigned max_hops = 0;
 
 #define ERROR(fmt, ...) fprintf(stderr, "ERR: " fmt, ##__VA_ARGS__)
 #define VERBOSE(fmt, ...) if (verbose) fprintf(stderr, fmt, ##__VA_ARGS__)
-#define NOISE(fmt, ...) if (verbose > 1) fprintf(stderr, fmt, ##__VA_ARGS__)
+#define VERBOSE1(fmt, ...) if (verbose > 1) fprintf(stderr, fmt, ##__VA_ARGS__)
+#define VERBOSE2(fmt, ...) if (verbose > 2) fprintf(stderr, fmt, ##__VA_ARGS__)
+#define NOISE(fmt, ...) VERBOSE2(fmt, ##__VA_ARGS__)
 
 static const char *print_path(uint8_t path[], size_t path_cnt)
 {
@@ -116,8 +118,8 @@ static int send_request(int fd, int agent, uint64_t trid, uint8_t * path,
 		return -1;
 	}
 
-	VERBOSE("send %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
-		attr_mod, print_path(path, path_cnt));
+	VERBOSE1("send %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
+		 attr_mod, print_path(path, path_cnt));
 
 	return ret;
 }
@@ -239,8 +241,8 @@ static int send_query(int fd, int agent, unsigned node_id, uint8_t path[],
 		return -1;
 	}
 
-	VERBOSE("queue %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
-		attr_mod, print_path(path, path_cnt));
+	VERBOSE1("queue %016" PRIx64 ": attr %x, mod %x to %s\n", trid, attr_id,
+		 attr_mod, print_path(path, path_cnt));
 
 	run_request_queue(fd, agent);
 
@@ -384,8 +386,8 @@ static void connect_ports(unsigned node1_id, unsigned port1_num,
 {
 	struct port *port1 = &node_array[node1_id]->ports[port1_num];
 	struct port *port2 = &node_array[node2_id]->ports[port2_num];
-	VERBOSE("connecting %u:%u <--> %u:%u\n",
-		node1_id, port1_num, node2_id, port2_num);
+	VERBOSE1("connecting %u:%u <--> %u:%u\n",
+		 node1_id, port1_num, node2_id, port2_num);
 	port1->remote = port2;
 	port2->remote = port1;
 }
@@ -410,6 +412,11 @@ static int process_node(void *umad, unsigned remote_id, int fd, int agent,
 
 	node = node_array[id];
 
+	VERBOSE("%-5s %-6s with guid 0x%" PRIx64 " discovered at %s\n",
+		node_is_new ? "new" : "known",
+		node->is_switch ? "Switch" : "Ca", node->guid,
+		print_path(path, path_cnt));
+
 	node->ports[port_num].guid =
 	    mad_get_field64(node_info, 0, IB_NODE_PORT_GUID_F);
 
@@ -472,8 +479,8 @@ static int recv_smp_resp(int fd, int agent, uint8_t * umad, uint8_t path[])
 
 	node_id = trid & 0xffff;
 
-	VERBOSE("recv %016" PRIx64 ": attr %x, mod %x from %s\n", trid, attr_id,
-		attr_mod, print_path(path, path_cnt));
+	VERBOSE1("recv %016" PRIx64 ": attr %x, mod %x from %s\n", trid,
+		 attr_id, attr_mod, print_path(path, path_cnt));
 
 	switch (attr_id) {
 	case IB_ATTR_NODE_INFO:
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
