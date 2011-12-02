From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags: Update Common options in man pages.
Date: Fri, 2 Dec 2011 12:00:19 -0800
Message-ID: <20111202120019.48f27ecf.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Specifically remove duplicated "common options" sections from all man pages and
reference "infiniband-diags(8)" page for those options.

Furthermore clean up infiniband-diags common options.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/ibaddr.8              |   56 ++-----------------------------------
 man/ibccquery.8           |   42 ++--------------------------
 man/iblinkinfo.8          |    3 ++
 man/ibnetdiscover.8       |   42 ++--------------------------
 man/ibping.8              |   51 ++--------------------------------
 man/ibportstate.8         |   57 ++------------------------------------
 man/ibqueryerrors.8.in    |   24 ++--------------
 man/ibroute.8             |   56 ++-----------------------------------
 man/ibstat.8              |   57 ++------------------------------------
 man/ibsysstat.8           |   51 ++--------------------------------
 man/ibtracert.8           |   49 ++-------------------------------
 man/infiniband-diags.8.in |   67 ++++++++++++++++++++++++++++++++++-----------
 man/perfquery.8           |   50 ++-------------------------------
 man/saquery.8             |    9 ++----
 man/sminfo.8              |   56 ++-----------------------------------
 man/smpdump.8             |   56 ++-----------------------------------
 man/smpquery.8            |   61 ++---------------------------------------
 man/vendstat.8            |   50 ++-------------------------------
 18 files changed, 102 insertions(+), 735 deletions(-)

diff --git a/man/ibaddr.8 b/man/ibaddr.8
index 51f5a1c..ef693ce 100644
--- a/man/ibaddr.8
+++ b/man/ibaddr.8
@@ -19,6 +19,9 @@ Note: this utility can be used as simple address resolver.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-G\fR, \fB\-\-Guid\fR
 show lid range and gid for GUID address
@@ -32,59 +35,6 @@ show lid range (in decimal) only
 \fB\-g\fR, \fB\-\-gid_show\fR
 show gid address only
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/ibccquery.8 b/man/ibccquery.8
index f3e8149..1f10cf2 100644
--- a/man/ibccquery.8
+++ b/man/ibccquery.8
@@ -16,6 +16,9 @@ to congestion control.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 Current supported operations and their parameters:
   CongestionInfo (CI) <addr>
@@ -31,45 +34,6 @@ Current supported operations and their parameters:
 \fB\-c\-fR, \fB\-\-cckey\fR <cckey>
 Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH EXAMPLES
 
 .PP
diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
index 5fa2678..5e35b94 100644
--- a/man/iblinkinfo.8
+++ b/man/iblinkinfo.8
@@ -16,6 +16,9 @@ fabric.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-S <port_guid>\fR \fB\-G <port_guid>\fR \fB\-\-port\-guid\fR
 start partial scan at the port specified by <port_guid> (hex format)
diff --git a/man/ibnetdiscover.8 b/man/ibnetdiscover.8
index 3beb70b..4d32e2f 100644
--- a/man/ibnetdiscover.8
+++ b/man/ibnetdiscover.8
@@ -24,6 +24,9 @@ unless a topology file is specified.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-l\fR, \fB\-\-list\fR
 List of connected nodes
@@ -84,45 +87,6 @@ GUID, width, speed, and NodeDescription).
 \fB\-m\fR, \fB\-\-max_hops\fR
 Report max hops discovered.
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH TOPOLOGY FILE FORMAT
 The topology file format is human readable and largely intuitive.
diff --git a/man/ibping.8 b/man/ibping.8
index b5154af..964051a 100644
--- a/man/ibping.8
+++ b/man/ibping.8
@@ -20,6 +20,9 @@ implemented within the kernel.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-c\fR
 stop after count packets
@@ -33,54 +36,6 @@ use specified OUI number to multiplex vendor mads
 \fB\-S\fR, \fB\-\-Server\fR
 start in server mode (do not return)
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH AUTHOR
 .TP
 Hal Rosenstock
diff --git a/man/ibportstate.8 b/man/ibportstate.8
index 0537d7e..76f7da4 100644
--- a/man/ibportstate.8
+++ b/man/ibportstate.8
@@ -20,6 +20,9 @@ also allows the link speed/width enabled on any IB port to be adjusted.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 op
 Port operations allowed
@@ -51,60 +54,6 @@ Port operations allowed
   of query op requires LID routing to be functioning in the subnet.
 
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH EXAMPLES
 
 .PP
diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
index 372b0e4..a715e3a 100644
--- a/man/ibqueryerrors.8.in
+++ b/man/ibqueryerrors.8.in
@@ -19,6 +19,9 @@ remote port if available.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-s <err1,err2,...>\fR
 Suppress the errors listed in the comma separated list provided.
@@ -75,27 +78,6 @@ for information on caching ibnetdiscover output.
 .TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
-.SH COMMON OPTIONS
-.PP
-\-d      raise the IB debugging level.
-	May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-	May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
 
 .SH EXIT STATUS
 
diff --git a/man/ibroute.8 b/man/ibroute.8
index 3e93408..8d51154 100644
--- a/man/ibroute.8
+++ b/man/ibroute.8
@@ -20,6 +20,9 @@ The default range is all valid entries in the range 1...FDBTop.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-a\fR, \fB\-\-all\fR
 show all lids in range, even invalid entries
@@ -31,59 +34,6 @@ do not try to resolve destinations
 show multicast forwarding tables
 In this case, the range parameters are specifying the mlid range.
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/ibstat.8 b/man/ibstat.8
index 7d69ff3..39cabdf 100644
--- a/man/ibstat.8
+++ b/man/ibstat.8
@@ -21,6 +21,9 @@ information than ibstatus.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-l\fR, \fB\-\-list_of_cas\fR
 list all IB devices
@@ -37,60 +40,6 @@ InfiniBand device name
 portnum
 port number of InfiniBand device
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH EXAMPLES
 
 .PP
diff --git a/man/ibsysstat.8 b/man/ibsysstat.8
index 69c5f83..927e6c5 100644
--- a/man/ibsysstat.8
+++ b/man/ibsysstat.8
@@ -18,6 +18,9 @@ client/server. Default is to run as client.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 Current supported operations:
  ping \- verify connectivity to server (default)
@@ -31,54 +34,6 @@ use specified OUI number to multiplex vendor mads
 start in server mode (do not return)
 
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH AUTHOR
 .TP
 Hal Rosenstock
diff --git a/man/ibtracert.8 b/man/ibtracert.8
index 674db7e..7c21f74 100644
--- a/man/ibtracert.8
+++ b/man/ibtracert.8
@@ -21,6 +21,9 @@ and destination nodes.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-n\fR, \fB\-\-no_info\fR
 simple format; don't show additional information
@@ -34,52 +37,6 @@ user friendly names.  See
 .B ibnetdiscover(8)
 for node name map file format.
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
 .SH EXAMPLES
 
 .PP
diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
index f0671ca..a665c20 100644
--- a/man/infiniband-diags.8.in
+++ b/man/infiniband-diags.8.in
@@ -46,8 +46,10 @@ using "<util_name> -h".
 
 .TP
 \fB# Addressing Flags\fR
+
+.TP 2
 .PP
-\-D      use the directed route specified.
+\fB\-D\fR      use the directed route specified.
 .br
 		Examples:
 .br
@@ -55,51 +57,84 @@ using "<util_name> -h".
 .br
 		"0,1,2,1,4"	# out via port 1, then 2, ...
 
+.TP 2
 .PP
-\-G <guid>     use the PortGuid specified.
+\fB\-G <guid>\fR     use the PortGuid specified.
+.TP 2
 .PP
-\-s <smlid>     use 'smlid' as the target lid for SA queries.
+\fB\-s <smlid>\fR     use <smlid> as the target lid for SA queries.
 
 .TP
 \fB# Local HCA/port flags:\fR
+
+.TP 2
 .PP
-\-C <ca_name>    use the specified ca_name.
+\fB\-C <ca_name>\fR    use the specified ca_name.
+.TP 2
 .PP
-\-P <ca_port>    use the specified ca_port.
+\fB\-P <ca_port>\fR    use the specified ca_port.
+
+Multiple CA/Multiple Port Support
+
+When no IB device or port is specified, the port to use is selected
+by the following criteria:
+.TP 2
+.PP
+1. the first port that is ACTIVE.
+.TP 2
+.PP
+2. if not found, the first port that is UP (physical link up).
+
+If a port and/or CA name is specified, the user request is
+attempted to be fulfilled, and will fail if it is not possible.
 
 .TP
 \fB# Debugging flags\fR
+
+.TP 2
 .PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
+\fB\-t <timeout_ms>\fR override the default timeout for the solicited mads.
+.TP 2
 .PP
-\-d      raise the IB debugging level.
+\fB\-d\fR      raise the IB debugging level.
         May be used several times (-ddd or -d -d -d).
+.TP 2
 .PP
-\-e      show send and receive errors (timeouts and others)
+\fB\-e\fR      show send and receive errors (timeouts and others)
+.TP 2
 .PP
-\-h      show the usage message
+\fB\-h\fR      show the usage message
+.TP 2
 .PP
-\-v      increase the application verbosity level.
+\fB\-v\fR      increase the application verbosity level.
         May be used several times (-vv or -v -v -v)
+.TP 2
 .PP
-\-V      show the version info.
+\fB\-V\fR      show the version info.
 
 .TP
 \fB# Configuration flags\fR
+
+.TP 2
 .PP
-\-\-config \-z  <config_file>
+\fB\-\-config\fR, \fB\-z\fR  <config_file>
         Specify alternate config file.
         Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
 
-.SH FILES
+.SH COMMON FILES
+
+.TP
+\fBGLOBAL CONFIG\fR
 
-@IBDIAG_CONFIG_PATH@/ibdiag.conf
+.br
+\fB@IBDIAG_CONFIG_PATH@/ibdiag.conf\fR
 
 A global config file is provided to set some of the common options for all
 tools.  See supplied config file for details.
 
 
-.SH NODE NAME MAP FILE FORMAT
+.TP
+\fBNODE NAME MAP FILE FORMAT\fR
 Most utilities use the optional node name map file supported by libosmcomp to
 specify user friendly names for nodes in the output.  Node GUIDs are used to
 perform the lookup.
@@ -153,7 +188,7 @@ perform the lookup.
 0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
 .br
 
-.SH Utilities list
+.SH UTILITIES LIST
 
 .TP
 \fBBasic fabric conectivity\fR
diff --git a/man/perfquery.8 b/man/perfquery.8
index 8635e41..e44c3c1 100644
--- a/man/perfquery.8
+++ b/man/perfquery.8
@@ -31,6 +31,9 @@ Note: Inputting a port of 255 indicates an operation be performed on all ports.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-x\fR, \fB\-\-extended\fR
 show extended port counters rather than (basic) port counters.
@@ -110,53 +113,6 @@ reset counters after read
 \fB\-R\fR, \fB\-\-Reset_only\fR
 only reset counters
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/saquery.8 b/man/saquery.8
index 6ae7425..89f0551 100644
--- a/man/saquery.8
+++ b/man/saquery.8
@@ -20,6 +20,9 @@ saquery issues the selected SA query. Node records are queried by default.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-p\fR
 get PathRecord info
@@ -125,12 +128,6 @@ enable debugging
 \fB\-h\fR
 show help
 
-.SH FILES
-
-ib-node-name-map -- see ibnetdiscover for more information
-
-The node name map is used to specify user friendly names for nodes in the
-output.  Node GUIDs are used to perform the lookup.
 
 .SH DEPENDENCIES
 
diff --git a/man/sminfo.8 b/man/sminfo.8
index 49b7461..0fdf55e 100644
--- a/man/sminfo.8
+++ b/man/sminfo.8
@@ -21,6 +21,9 @@ dangerous, and may result in a malfunction of the target SM.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-s\fR
 set SM state
@@ -35,59 +38,6 @@ set priority (0-15)
 \fB\-a\fR
 set activity count
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/smpdump.8 b/man/smpdump.8
index e8a5bfa..34413fa 100644
--- a/man/smpdump.8
+++ b/man/smpdump.8
@@ -15,6 +15,9 @@ specified SMA. The result is dumped in hex by default.
 
 .SH OPTIONS
 
+.PP
+See infiniband-diags(8) for common options.
+
 .TP
 attr
 IBA attribute ID for SM attribute
@@ -22,59 +25,6 @@ IBA attribute ID for SM attribute
 mod
 IBA modifier for SM attribute
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/smpquery.8 b/man/smpquery.8
index c4cb8f2..494670f 100644
--- a/man/smpquery.8
+++ b/man/smpquery.8
@@ -19,6 +19,9 @@ human readable format.
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 Current supported operations and their parameters:
         nodeinfo <addr>
@@ -43,64 +46,6 @@ user friendly names.  See
 .B ibnetdiscover(8)
 for node name map file format.
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-c      use combined route address arguments. The
-        address is a combination of a LID and a direct route path.
-        The LID specified is the DLID and the local LID is used
-        as the DrSLID.
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
diff --git a/man/vendstat.8 b/man/vendstat.8
index 2a87f2b..4649e38 100644
--- a/man/vendstat.8
+++ b/man/vendstat.8
@@ -18,6 +18,9 @@ Mellanox InfiniSwitch-III (IS3) and InfiniSwitch-IV (IS4).
 .SH OPTIONS
 
 .PP
+See infiniband-diags(8) for common options.
+
+.PP
 .TP
 \fB\-N\fR
 show IS3 or IS4 general information.
@@ -46,53 +49,6 @@ Group 1 counter config values:
  2 - PortRcvDataSL0-7
  8 - PortRcvDataSL8-15
 
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
 
 .SH EXAMPLES
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
