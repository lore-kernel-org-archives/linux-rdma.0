From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags: Add man pages for dump2psl and dump2slvl
Date: Tue, 05 Apr 2011 15:30:51 -0400
Message-ID: <4D9B6DEB.7060702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am     |    3 ++-
 man/dump2psl.8  |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 man/dump2slvl.8 |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletions(-)
 create mode 100644 man/dump2psl.8
 create mode 100644 man/dump2slvl.8

diff --git a/Makefile.am b/Makefile.am
index 43d05f6..1792e37 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -80,7 +80,8 @@ man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 	man/ibprintswitch.8 man/ibprintca.8 man/ibfindnodesusing.8 \
 	man/ibdatacounts.8 man/ibdatacounters.8 \
 	man/ibrouters.8 man/ibprintrt.8 man/ibidsverify.8 \
-	man/check_lft_balance.8 man/ibcacheedit.8
+	man/check_lft_balance.8 man/ibcacheedit.8 \
+	man/dump2psl.8 man/dump2slvl.8
 
 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
diff --git a/man/dump2psl.8 b/man/dump2psl.8
new file mode 100644
index 0000000..ced4a42
--- /dev/null
+++ b/man/dump2psl.8
@@ -0,0 +1,49 @@
+.TH DUMP2PSL.PL 8 "April 3, 2011" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+dump2psl.pl \- dump psl file based on some opensm output files used for credit loop checking
+
+.SH SYNOPSIS
+.B dump2psl.pl
+
+.SH DESCRIPTION
+.PP
+dump2psl.pl dumps a psl file based on some opensm output files. A psl file
+contains paths (including SLs) and is needed for subsequent credit loop
+checking (via ibdmchk). This conversion is needed when ibutils is not
+installed and credit loop checking is done on a different machine or later.
+Credit loop checking is especially valuable for the QoS based routing
+algorithms (e.g. torus-2QoS, lash, etc.).
+
+ibdiagnet -vlr dumps the psl (and slvl) files needed for ibdmchk -M -a -s
+(which is the credit loop check).
+
+Dumping of path records is accomplished by the PathRecord dumping plugin to the
+OpenSM. When the environment variable DUMP_FULL_PATH_RECORDS is set to 1,
+the full set of SA path records is dumped to opensm-path-records.dump in
+the dump_files_dir directory (default is /var/log).
+
+When the routing protocol is torus-2QoS, the following two files are dumped
+by the PathRecord dumping plugin: opensm-peer-paths.dump and
+opensm-sw2sw-path-records.dump. The peer paths dump file contains the CAs
+and their neighbor switch and includes the link MTU and RATE. The switch to
+switch file contains for each source switch a table of destination switches
+and the SL, RATE, and MTU to be used for MPI traffic.
+
+Note that since the PathRecord dump uses port GUIDs and the ibdmchk psl
+file uses node GUIDs, the fabric .lst file is also required as input
+(see USAGE).
+
+
+.SH USAGE
+
+.PP
+cat opensm-{subnet.lst,path-records.dump} | dump2psl.pl > opensm.psl
+
+.SH SEE ALSO
+.BR dump2slvl(8), ibdmchk(8), ibdiagnet(8)
+
+.SH AUTHOR
+.TP
+Hal Rosenstock
+.RI < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
diff --git a/man/dump2slvl.8 b/man/dump2slvl.8
new file mode 100644
index 0000000..0f70d63
--- /dev/null
+++ b/man/dump2slvl.8
@@ -0,0 +1,32 @@
+.TH DUMP2SLVL.PL 8 "April 3, 2011" "OpenIB" "OpenIB Diagnostics"
+
+.SH NAME
+dump2slvl.pl \- dump slvl file based on opensm output file used for credit loop checking
+
+.SH SYNOPSIS
+.B dump2slvl.pl
+
+.SH DESCRIPTION
+.PP
+dump2slvl.pl dumps a slvl file based on an opensm output file. A slvl file
+contains the SL to VL mappings and is needed for subsequent credit loop
+checking (via ibdmchk). This conversion is needed when ibutils is not
+installed and credit loop checking is done on a different machine or later.
+Credit loop checking is especially valuable for the QoS based routing
+algorithms (e.g. torus-2QoS, lash, etc.).
+
+ibdiagnet -vlr dumps the slvl (and psl) files needed for ibdmchk -M -a -s
+(which is the credit loop check).
+
+.SH USAGE
+
+.PP
+cat opensm-sl2vl.dump | dump2slvl.pl > opensm.slvl
+
+.SH SEE ALSO
+.BR dump2psl(8), ibdmchk(8), ibdiagnet(8)
+
+.SH AUTHOR
+.TP
+Hal Rosenstock
+.RI < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
-- 
1.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
