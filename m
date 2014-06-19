From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] rsocket: Add support for RDMA_ROUTE option in rgetsockopt
Date: Thu, 19 Jun 2014 08:48:58 -0400
Message-ID: <53A2DC3A.8050204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Create as many ibv_path_data structs from the RDMA route
ibv_sa_path_rec struct for the rsocket based on how
many fit into the supplied buffer.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/rsocket.c b/src/rsocket.c
index 0e5635f..d1d0ebf 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3500,11 +3500,38 @@ int rsetsockopt(int socket, int level, int optname,
 	return ret;
 }
 
+static void rs_convert_sa_path(struct ibv_sa_path_rec *sa_path,
+			       struct ibv_path_data *path_data)
+{
+	uint32_t fl_hop;
+
+	memset(path_data, 0, sizeof(*path_data));
+	path_data->path.dgid = sa_path->dgid;
+	path_data->path.sgid = sa_path->sgid;
+	path_data->path.dlid = sa_path->dlid;
+	path_data->path.slid = sa_path->slid;
+	fl_hop = ntohl(sa_path->flow_label) << 8;
+	path_data->path.flowlabel_hoplimit = htonl(fl_hop) | sa_path->hop_limit;
+	path_data->path.tclass = sa_path->traffic_class;
+	path_data->path.reversible_numpath = sa_path->reversible << 7 | 1;
+	path_data->path.pkey = sa_path->pkey;
+	path_data->path.qosclass_sl = sa_path->sl;
+	path_data->path.mtu = sa_path->mtu | 2 << 6;	/* exactly */
+	path_data->path.rate = sa_path->rate | 2 << 6;
+	path_data->path.packetlifetime = sa_path->packet_life_time | 2 << 6;
+	path_data->flags= sa_path->preference;
+}
+
 int rgetsockopt(int socket, int level, int optname,
 		void *optval, socklen_t *optlen)
 {
 	struct rsocket *rs;
+	void *opt;
+	struct ibv_sa_path_rec *path_rec;
+	struct ibv_path_data path_data;
+	socklen_t len;
 	int ret = 0;
+	int num_paths;
 
 	rs = idm_lookup(&idm, socket);
 	if (!rs)
@@ -3597,6 +3624,27 @@ int rgetsockopt(int socket, int level, int optname,
 			*((int *) optval) = rs->target_iomap_size;
 			*optlen = sizeof(int);
 			break;
+		case RDMA_ROUTE:
+			if (*optlen < sizeof(path_data)) {
+				ret = EINVAL;
+			} else {
+				len = 0;
+				opt = optval;
+				path_rec = rs->cm_id->route.path_rec;
+				num_paths = 0;
+				if (len + sizeof(path_data) <= *optlen &&
+				    num_paths < rs->cm_id->route.num_paths) {
+					rs_convert_sa_path(path_rec, &path_data);
+					memcpy(opt, &path_data, sizeof(path_data));
+					len += sizeof(path_data);
+					opt += sizeof(path_data);
+					path_rec++;
+					num_paths++;
+				}
+				*optlen = len;
+				ret = 0;
+			}
+			break;
 		default:
 			ret = ENOTSUP;
 			break;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
