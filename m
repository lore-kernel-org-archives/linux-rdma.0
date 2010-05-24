From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/vendstat: add config space access options
Date: Tue, 25 May 2010 00:07:35 +0300
Message-ID: <20100524210735.GK28549@me>
References: <20100524205611.GJ28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100524205611.GJ28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add Mellanox vendor class config space records access options (-R for
read and -W for write). Example of usage:

  vendstat -R 0x12345,0xffff <lid> - will read low 16 bits of config
                                     space record at address 0x12345

  vendstat -W 0x12345,0,0xfff <lid> - will zero low 12 bits of config
                                      space record at address 0x12345

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/vendstat.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/src/vendstat.c b/infiniband-diags/src/vendstat.c
index 0de5722..0add06c 100644
--- a/infiniband-diags/src/vendstat.c
+++ b/infiniband-diags/src/vendstat.c
@@ -144,6 +144,27 @@ static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
 	return 0;
 }
 
+static unsigned int conf_addr, conf_val, conf_mask;
+
+static void do_config_space_record(ib_portid_t *portid, unsigned set)
+{
+	is3_config_space_t cs;
+
+	memset(&cs, 0, sizeof(cs));
+	cs.record[0].address = htonl(conf_addr);
+	cs.record[0].data = htonl(conf_val);
+	cs.record[0].mask = htonl(conf_mask);
+
+	if (do_vendor(portid, srcport, IB_MLX_VENDOR_CLASS,
+		      set ? IB_MAD_METHOD_SET : IB_MAD_METHOD_GET,
+		      IB_MLX_IS3_CONFIG_SPACE_ACCESS, 2 << 22 | 1 << 16, &cs))
+		IBERROR("cannot %s config space record", set ? "set" : "get");
+
+	printf("Config space record at 0x%x: 0x%x\n",
+	       ntohl(cs.record[0].address),
+	       ntohl(cs.record[0].data & cs.record[0].mask));
+}
+
 static void counter_groups_info(ib_portid_t * portid, int port)
 {
 	char buf[1024];
@@ -203,6 +224,7 @@ static void config_counter_groups(ib_portid_t * portid, int port)
 }
 
 static int general_info, xmit_wait, counter_group_info, config_counter_group;
+static unsigned int config_space_read, config_space_write;
 
 static int process_opt(void *context, int ch, char *optarg)
 {
@@ -223,6 +245,22 @@ static int process_opt(void *context, int ch, char *optarg)
 		if (ret != 2)
 			return -1;
 		break;
+	case 'R':
+		config_space_read = 1;
+		ret = sscanf(optarg, "%x,%x", &conf_addr, &conf_mask);
+		if (ret < 1)
+			return -1;
+		else if (ret == 1)
+			conf_mask = 0xffffffff;
+		break;
+	case 'W':
+		config_space_write = 1;
+		ret = sscanf(optarg, "%x,%x,%x", &conf_addr, &conf_val, &conf_mask);
+		if (ret < 2)
+			return -1;
+		else if (ret == 2)
+			conf_mask = 0xffffffff;
+		break;
 	default:
 		return -1;
 	}
@@ -244,6 +282,8 @@ int main(int argc, char **argv)
 		{"w", 'w', 0, NULL, "show IS3 port xmit wait counters"},
 		{"i", 'i', 0, NULL, "show IS4 counter group info"},
 		{"c", 'c', 1, "<num,num>", "configure IS4 counter groups"},
+		{"Read", 'R', 1, "<addr,mask>", "Read configuration space record at addr"},
+		{"Write", 'W', 1, "<addr,val,mask>", "Write configuration space record at addr"},
 		{0}
 	};
 
@@ -289,6 +329,11 @@ int main(int argc, char **argv)
 		exit(0);
 	}
 
+	if (config_space_read || config_space_write) {
+		do_config_space_record(&portid, config_space_write);
+		exit(0);
+	}
+
 	/* These are Mellanox specific vendor MADs */
 	/* but vendors change the VendorId so how know for sure ? */
 	/* Only General Info and Port Xmit Wait Counters */
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
