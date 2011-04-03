From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags: Add dump2psl and dump2slvl perl scripts
Date: Sun, 03 Apr 2011 07:47:59 -0400
Message-ID: <4D985E6F.8050503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to aid in torus-2QoS credit checking

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 configure.in         |    2 +
 scripts/dump2psl.pl  |   51
++++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/dump2slvl.pl |   24 +++++++++++++++++++++++
 3 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100755 scripts/dump2psl.pl
 create mode 100755 scripts/dump2slvl.pl

diff --git a/configure.in b/configure.in
index 003369d..eb01f9b 100644
--- a/configure.in
+++ b/configure.in
@@ -169,6 +169,8 @@ AC_CONFIG_FILES([\
 	scripts/ibrouters \
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
+	scripts/dump2psl.pl \
+	scripts/dump2slvl.pl \
    libibnetdisc/Makefile
 ])
 AC_OUTPUT
diff --git a/scripts/dump2psl.pl b/scripts/dump2psl.pl
new file mode 100755
index 0000000..29896c7
--- /dev/null
+++ b/scripts/dump2psl.pl
@@ -0,0 +1,51 @@
+#! /usr/bin/perl -w
+
+# usage:  cat file.lst opensm-path-records.dump | dump2psl.pl
+
+my $h = "([a-fA-F0-9]+)";
+my $H = "([xXa-fA-F0-9]+)";
+my $D = "([0-9]+)";
+
+my $n;
+my $p;
+my %port2node;
+
+my $ca_port = 0x0;
+
+while (<>) {
+
+    # parse .lst file, look for node GUID <-> port GUID relationship,
hash it
+
+    if (/[^C]*\{\s*CA Ports[^N]*NodeGUID:$h\s*PortGUID:$h/) {
+
+
+	$n = "0x" . $1;
+	$p = "0x" . $2;
+
+	if (defined $port2node{$p}) {
+	    if ($port2node{$p} ne $n) {
+		printf STDERR "Cowardly refusing to reassign port GUID $p\n";
+		printf STDERR "from node GUID $port2node{$p} ";
+		printf STDERR "to node GUID $n\n";
+		next;
+	    }
+	    next;
+	}
+	$port2node{$p} = $n;
+	# printf STDERR "Assigned port GUID $p to node GUID $n\n";
+    }
+
+    # parse opensm-path-records.dump, reformat for ibdmchk .psl format
+
+    if (/^Channel\s+Adapter\s+$H/) {
+	$ca_port = $1;
+    }
+
+    if (/^\s*$H\s+:\s+$D\s+:\s+$D\s+:\s+$D\s+/) {
+
+	if (!defined($port2node{$ca_port})) {
+	    next;
+	}
+	printf "%s %d %d\n", $port2node{$ca_port}, oct($1), $2;
+    }
+}
diff --git a/scripts/dump2slvl.pl b/scripts/dump2slvl.pl
new file mode 100755
index 0000000..d85bb60
--- /dev/null
+++ b/scripts/dump2slvl.pl
@@ -0,0 +1,24 @@
+#! /usr/bin/perl -w
+
+my $switch = 0x0;
+
+my $H = "([xXa-fA-F0-9]+)";
+my $D = "([0-9]+)";
+my $DD = "\\s+([0-9]+)\\s+([0-9]+)";
+
+while (<>) {
+
+    if (/^Switch\s+$H/) {
+	$switch = $1;
+    }
+
+    if (/^\s*$D\s+$D\s+:$DD$DD$DD$DD$DD$DD$DD$DD/) {
+
+	printf "%s %d %d", $switch, $1, $2;
+	printf " 0x%x%x 0x%x%x", $3, $4, $5, $6;
+	printf " 0x%x%x 0x%x%x", $7, $8, $9, $10;
+	printf " 0x%x%x 0x%x%x", $11, $12, $13, $14;
+	printf " 0x%x%x 0x%x%x", $15, $16, $17, $18;
+	printf "\n";
+    }
+}
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
