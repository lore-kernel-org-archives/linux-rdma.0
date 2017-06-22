From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 1/3] Support 2x link widths
Date: Thu, 22 Jun 2017 10:36:43 -0400
Message-ID: <ad5d5b85-55e2-8106-8ced-c04f958ffa5d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Per MgtWG errata #9306-9309

2x is indicated by bit 4 in link width fields in PortInfo

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibmad/src/dump.c | 14 ++++++++++++--
 src/ibdiag_common.c | 20 +++++++++++++++++++-
 src/ibnetdiscover.c |  3 +++
 src/ibportstate.c   |  7 ++++++-
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index b491bc2..8e1f5d1 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -183,6 +183,9 @@ void mad_dump_linkwidth(char *buf, int bufsz, void *val, int valsz)
 	case 8:
 		snprintf(buf, bufsz, "12X");
 		break;
+	case 16:
+		snprintf(buf, bufsz, "2X");
+		break;
 	default:
 		IBWARN("bad width %d", width);
 		snprintf(buf, bufsz, "undefined (%d)", width);
@@ -202,10 +205,12 @@ static void dump_linkwidth(char *buf, int bufsz, int width)
 		n += snprintf(buf + n, bufsz - n, "8X or ");
 	if (n < bufsz && (width & 0x8))
 		n += snprintf(buf + n, bufsz - n, "12X or ");
+	if (n < bufsz && (width & 0x10))
+		n += snprintf(buf + n, bufsz - n, "2X or ");
 
 	if (n >= bufsz)
 		return;
-	else if (width == 0 || (width >> 4))
+	else if (width == 0 || (width >> 5))
 		snprintf(buf + n, bufsz - n, "undefined (%d)", width);
 	else if (bufsz > 3)
 		buf[n - 4] = '\0';
@@ -223,10 +228,15 @@ void mad_dump_linkwidthsup(char *buf, int bufsz, void *val, int valsz)
 	case 7:
 	case 11:
 	case 15:
+	case 17:
+	case 19:
+	case 23:
+	case 27:
+	case 31:
 		break;
 
 	default:
-		if (!(width >> 4))
+		if (!(width >> 5))
 			snprintf(buf + strlen(buf), bufsz - strlen(buf),
 				 " (IBA extension)");
 		break;
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 1f91269..cd8f707 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -737,6 +737,24 @@ int resolve_portid_str(char *ca_name, uint8_t ca_port, ib_portid_t * portid,
 	return -1;
 }
 
+static unsigned int get_max_width(unsigned int num)
+{
+	unsigned r = 0;			/* 1x */
+
+	if (num & 8)
+		r = 3;			/* 12x */
+	else {
+		if (num & 4)
+			r = 2;		/* 8x */
+		else if (num & 2)
+			r = 1;		/* 4x */
+		else if (num & 0x10)
+			r = 4;		/* 2x */
+	}
+
+        return (1 << r);
+}
+
 static unsigned int get_max(unsigned int num)
 {
 	unsigned r = 0;		// r will be lg(num)
@@ -754,7 +772,7 @@ void get_max_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * p
 	uint32_t cap_mask, rem_cap_mask, fdr10;
 	uint8_t *info = NULL;
 
-	uint32_t max_width = get_max(mad_get_field(port->info, 0,
+	uint32_t max_width = get_max_width(mad_get_field(port->info, 0,
 						   IB_PORT_LINK_WIDTH_SUPPORTED_F)
 				     & mad_get_field(port->remoteport->info, 0,
 						     IB_PORT_LINK_WIDTH_SUPPORTED_F));
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 0ad5e31..68374a2 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -134,6 +134,9 @@ char *dump_linkwidth_compat(uint32_t width)
 	case 8:
 		return ("12x");
 		break;
+	case 16:
+		return ("2x");
+		break;
 	}
 	return ("??");
 }
diff --git a/src/ibportstate.c b/src/ibportstate.c
index fe8be25..06bd5d2 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -321,6 +321,11 @@ static void validate_width(int width, int peerwidth, int lwa)
 			IBWARN
 			    ("Peer ports operating at active width %d rather than 2 (4x)",
 			     lwa);
+	} else if ((width & peerwidth & 0x10)) {
+		if (lwa != 16)
+			IBWARN
+			    ("Peer ports operating at active width %d rather than 16 (2x)",
+			      lwa);
 	} else if ((width & peerwidth & 0x1)) {
 		if (lwa != 1)
 			IBWARN
@@ -461,7 +466,7 @@ int main(int argc, char **argv)
 					IBEXIT("invalid fdr10 speed value %ld", val);
 				break;
 			case WIDTH:
-				if ((val > 15 && val != 255))
+				if ((val > 31 && val != 255))
 					IBEXIT("invalid width value %ld", val);
 				break;
 			case VLS:
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
