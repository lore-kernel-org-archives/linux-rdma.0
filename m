From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/vendstat: allow multiple config space
 records
Date: Tue, 25 May 2010 21:13:30 +0300
Message-ID: <20100525181330.GU28549@me>
References: <20100524205611.GJ28549@me>
 <20100524210735.GK28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100524210735.GK28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Allow to use -R and -W options (config space record access) multiple
number of times, so that multiple config space records will be reading
and/or writing. Using both -R and -W is allowed as well. Example:

  vendstat -R 0x12345,0xffff -R 0x12346 -W 0x12347,0,0xfff <lid>

Note that now number of records is effectively limited by 18 (so that it
fit single MAD), this could be increased with using multiple MADs.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/vendstat.c |   69 +++++++++++++++++++++++++-------------
 1 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/infiniband-diags/src/vendstat.c b/infiniband-diags/src/vendstat.c
index 0add06c..92a90c8 100644
--- a/infiniband-diags/src/vendstat.c
+++ b/infiniband-diags/src/vendstat.c
@@ -144,25 +144,30 @@ static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
 	return 0;
 }
 
-static unsigned int conf_addr, conf_val, conf_mask;
-
-static void do_config_space_record(ib_portid_t *portid, unsigned set)
+static void do_config_space_records(ib_portid_t *portid, unsigned set,
+				    is3_config_space_t *cs, unsigned records)
 {
-	is3_config_space_t cs;
-
-	memset(&cs, 0, sizeof(cs));
-	cs.record[0].address = htonl(conf_addr);
-	cs.record[0].data = htonl(conf_val);
-	cs.record[0].mask = htonl(conf_mask);
+	unsigned i;
+
+	if (records > 18)
+		records = 18;
+	for (i = 0; i < records; i++) {
+		cs->record[i].address = htonl(cs->record[i].address);
+		cs->record[i].data = htonl(cs->record[i].data);
+		cs->record[i].mask = htonl(cs->record[i].mask);
+	}
 
 	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS,
 		      set ? IB_MAD_METHOD_SET : IB_MAD_METHOD_GET,
-		      IB_MLX_IS3_CONFIG_SPACE_ACCESS, 2 << 22 | 1 << 16, &cs))
-		IBERROR("cannot %s config space record", set ? "set" : "get");
-
-	printf("Config space record at 0x%x: 0x%x\n",
-	       ntohl(cs.record[0].address),
-	       ntohl(cs.record[0].data & cs.record[0].mask));
+		      IB_MLX_IS3_CONFIG_SPACE_ACCESS, 2 << 22 | records << 16,
+		      cs))
+		IBERROR("cannot %s config space records", set ? "set" : "get");
+
+	for (i = 0; i < records; i++) {
+		printf("Config space record at 0x%x: 0x%x\n",
+		       ntohl(cs->record[i].address),
+		       ntohl(cs->record[i].data & cs->record[i].mask));
+	}
 }
 
 static void counter_groups_info(ib_portid_t * portid, int port)
@@ -224,7 +229,9 @@ static void config_counter_groups(ib_portid_t * portid, int port)
 }
 
 static int general_info, xmit_wait, counter_group_info, config_counter_group;
-static unsigned int config_space_read, config_space_write;
+static is3_config_space_t write_cs, read_cs;
+static unsigned write_cs_records, read_cs_records;
+
 
 static int process_opt(void *context, int ch, char *optarg)
 {
@@ -246,20 +253,29 @@ static int process_opt(void *context, int ch, char *optarg)
 			return -1;
 		break;
 	case 'R':
-		config_space_read = 1;
-		ret = sscanf(optarg, "%x,%x", &conf_addr, &conf_mask);
+		if (read_cs_records >= 18)
+			break;
+		ret = sscanf(optarg, "%x,%x",
+			     &read_cs.record[read_cs_records].address,
+			     &read_cs.record[read_cs_records].mask);
 		if (ret < 1)
 			return -1;
 		else if (ret == 1)
-			conf_mask = 0xffffffff;
+			read_cs.record[read_cs_records].mask = 0xffffffff;
+		read_cs_records++;
 		break;
 	case 'W':
-		config_space_write = 1;
-		ret = sscanf(optarg, "%x,%x,%x", &conf_addr, &conf_val, &conf_mask);
+		if (write_cs_records >= 18)
+			break;
+		ret = sscanf(optarg, "%x,%x,%x",
+			     &write_cs.record[write_cs_records].address,
+			     &write_cs.record[write_cs_records].data,
+			     &write_cs.record[write_cs_records].mask);
 		if (ret < 2)
 			return -1;
 		else if (ret == 2)
-			conf_mask = 0xffffffff;
+			write_cs.record[write_cs_records].mask = 0xffffffff;
+		write_cs_records++;
 		break;
 	default:
 		return -1;
@@ -329,8 +345,13 @@ int main(int argc, char **argv)
 		exit(0);
 	}
 
-	if (config_space_read || config_space_write) {
-		do_config_space_record(&portid, config_space_write);
+	if (read_cs_records || write_cs_records) {
+		if (read_cs_records)
+			do_config_space_records(&portid, 0, &read_cs,
+						read_cs_records);
+		if (write_cs_records)
+			do_config_space_records(&portid, 1, &write_cs,
+						write_cs_records);
 		exit(0);
 	}
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
