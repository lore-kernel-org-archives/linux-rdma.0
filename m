From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/vendstat: Indicate general info for IS4
	as well as IS3
Date: Wed, 10 Feb 2010 09:32:05 -0500
Message-ID: <20100210143205.GA11779@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Update both tool and man page for this
Also, updated email address

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/man/vendstat.8 b/infiniband-diags/man/vendstat.8
index 76d0cfb..2a87f2b 100644
--- a/infiniband-diags/man/vendstat.8
+++ b/infiniband-diags/man/vendstat.8
@@ -1,4 +1,4 @@
-.TH VENDSTAT 8 "April 16, 2009" "OpenIB" "OpenIB Diagnostics"
+.TH VENDSTAT 8 "February 10, 2010" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 vendstat \- query InfiniBand vendor specific functions
@@ -20,7 +20,7 @@ Mellanox InfiniSwitch-III (IS3) and InfiniSwitch-IV (IS4).
 .PP
 .TP
 \fB\-N\fR
-show IS3 general information.
+show IS3 or IS4 general information.
 .TP
 \fB\-w\fR
 show IS3 port xmit wait counters.
@@ -97,7 +97,7 @@ attempted to be fulfilled, and will fail if it is not possible.
 .SH EXAMPLES
 
 .PP
-vendstat -N 6		# read IS3 general information
+vendstat -N 6		# read IS3 or IS4 general information
 .PP
 vendstat -w 6		# read IS3 port xmit wait counters
 .PP
@@ -110,4 +110,4 @@ vendstat -c 2,8 6 12	# configure IS4 port 12 counter groups for PortRcvDataSL
 .SH AUTHOR
 .TP
 Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/infiniband-diags/src/vendstat.c b/infiniband-diags/src/vendstat.c
index aeb7b66..abff83a 100644
--- a/infiniband-diags/src/vendstat.c
+++ b/infiniband-diags/src/vendstat.c
@@ -240,7 +240,7 @@ int main(int argc, char **argv)
 	int i;
 
 	const struct ibdiag_opt opts[] = {
-		{"N", 'N', 0, NULL, "show IS3 general information"},
+		{"N", 'N', 0, NULL, "show IS3 or IS4 general information"},
 		{"w", 'w', 0, NULL, "show IS3 port xmit wait counters"},
 		{"i", 'i', 0, NULL, "show IS4 counter group info"},
 		{"c", 'c', 1, "<num,num>", "configure IS4 counter groups"},
@@ -249,7 +249,7 @@ int main(int argc, char **argv)
 
 	char usage_args[] = "<lid|guid> [port]";
 	const char *usage_examples[] = {
-		"-N 6\t\t# read IS3 general information",
+		"-N 6\t\t# read IS3 or IS4 general information",
 		"-w 6\t\t# read IS3 port xmit wait counters",
 		"-i 6 12\t# read IS4 port 12 counter group info",
 		"-c 0,1 6 12\t# configure IS4 port 12 counter groups for PortXmitDataSL",
@@ -317,7 +317,7 @@ int main(int argc, char **argv)
 	gi = (is3_general_info_t *) & buf;
 
 	if (general_info) {
-		/* dump IS3 general info here */
+		/* dump IS3 or IS4 general info here */
 		printf("hw_dev_rev:  0x%04x\n", ntohs(gi->hw_info.hw_revision));
 		printf("hw_dev_id:   0x%04x\n", ntohs(gi->hw_info.device_id));
 		printf("hw_uptime:   0x%08x\n", ntohl(gi->hw_info.uptime));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
