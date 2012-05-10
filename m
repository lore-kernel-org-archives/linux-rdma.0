From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/8] infiniband-diags: convert documentation from nroff to
 rst
Date: Wed, 9 May 2012 18:44:39 -0700
Message-ID: <20120509184439.766a95f6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




    Having documentation in ReStructured Text has the following benefits

    1) The addition of common functionality (options, config files, etc.) can be
       documented once and then included in documents for multiple tools.

       1a) Documentation source is more straight forward and writers can
           concentrate on the features which are unique to each tool.

    2) Documentation can be generated into multiple formats (man, html) not just
       man pages.

    3) Documentation for any individual tool is complete within that page.  (There
       is no referencing of other documents and guessing which "common" options
       apply.)

    Included as part of this patch is a complete audit of the options for these
    tools.

    Included in this initial patch are 4 tool which covered most of the options
    and the main infiniband-diags man page.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                               |   17 ++-
 configure.in                              |   23 +++-
 doc/README.rst                            |  105 +++++++++++
 doc/generate                              |   27 +++
 doc/rst/common/opt_C.rst                  |    4 +
 doc/rst/common/opt_D.rst                  |   14 ++
 doc/rst/common/opt_D_with_param.rst       |   14 ++
 doc/rst/common/opt_G.rst                  |    4 +
 doc/rst/common/opt_G_with_param.rst       |    4 +
 doc/rst/common/opt_L.rst                  |    4 +
 doc/rst/common/opt_P.rst                  |    4 +
 doc/rst/common/opt_V.rst                  |    4 +
 doc/rst/common/opt_cache.rst              |    7 +
 doc/rst/common/opt_d.rst                  |    6 +
 doc/rst/common/opt_diff.rst               |    9 +
 doc/rst/common/opt_diffcheck.rst          |   13 ++
 doc/rst/common/opt_e.rst                  |    3 +
 doc/rst/common/opt_h.rst                  |    4 +
 doc/rst/common/opt_load-cache.rst         |    8 +
 doc/rst/common/opt_node_name_map.rst      |    6 +
 doc/rst/common/opt_o-outstanding_smps.rst |    7 +
 doc/rst/common/opt_s.rst                  |    4 +
 doc/rst/common/opt_t.rst                  |    4 +
 doc/rst/common/opt_v.rst                  |    6 +
 doc/rst/common/opt_z-config.rst           |    6 +
 doc/rst/common/sec_config-file.rst        |   10 +
 doc/rst/common/sec_node-name-map.rst      |   43 +++++
 doc/rst/common/sec_portselection.rst      |   24 +++
 doc/rst/common/sec_topology-file.rst      |   89 ++++++++++
 doc/rst/ibaddr.8.in.rst                   |  100 +++++++++++
 doc/rst/iblinkinfo.8.in.rst               |  131 ++++++++++++++
 doc/rst/ibnetdiscover.8.in.rst            |  114 ++++++++++++
 doc/rst/ibqueryerrors.8.in.rst            |  155 +++++++++++++++++
 doc/rst/infiniband-diags.8.in.rst         |  154 ++++++++++++++++
 man/ibaddr.8                              |  111 ------------
 man/iblinkinfo.8                          |   85 ---------
 man/ibnetdiscover.8                       |  270 -----------------------------
 man/ibqueryerrors.8.in                    |  127 --------------
 man/infiniband-diags.8.in                 |  214 -----------------------
 39 files changed, 1120 insertions(+), 814 deletions(-)
 create mode 100644 doc/README.rst
 create mode 100755 doc/generate
 create mode 100644 doc/rst/common/opt_C.rst
 create mode 100644 doc/rst/common/opt_D.rst
 create mode 100644 doc/rst/common/opt_D_with_param.rst
 create mode 100644 doc/rst/common/opt_G.rst
 create mode 100644 doc/rst/common/opt_G_with_param.rst
 create mode 100644 doc/rst/common/opt_L.rst
 create mode 100644 doc/rst/common/opt_P.rst
 create mode 100644 doc/rst/common/opt_V.rst
 create mode 100644 doc/rst/common/opt_cache.rst
 create mode 100644 doc/rst/common/opt_d.rst
 create mode 100644 doc/rst/common/opt_diff.rst
 create mode 100644 doc/rst/common/opt_diffcheck.rst
 create mode 100644 doc/rst/common/opt_e.rst
 create mode 100644 doc/rst/common/opt_h.rst
 create mode 100644 doc/rst/common/opt_load-cache.rst
 create mode 100644 doc/rst/common/opt_node_name_map.rst
 create mode 100644 doc/rst/common/opt_o-outstanding_smps.rst
 create mode 100644 doc/rst/common/opt_s.rst
 create mode 100644 doc/rst/common/opt_t.rst
 create mode 100644 doc/rst/common/opt_v.rst
 create mode 100644 doc/rst/common/opt_z-config.rst
 create mode 100644 doc/rst/common/sec_config-file.rst
 create mode 100644 doc/rst/common/sec_node-name-map.rst
 create mode 100644 doc/rst/common/sec_portselection.rst
 create mode 100644 doc/rst/common/sec_topology-file.rst
 create mode 100644 doc/rst/ibaddr.8.in.rst
 create mode 100644 doc/rst/iblinkinfo.8.in.rst
 create mode 100644 doc/rst/ibnetdiscover.8.in.rst
 create mode 100644 doc/rst/ibqueryerrors.8.in.rst
 create mode 100644 doc/rst/infiniband-diags.8.in.rst
 delete mode 100644 man/ibaddr.8
 delete mode 100644 man/iblinkinfo.8
 delete mode 100644 man/ibnetdiscover.8
 delete mode 100644 man/ibqueryerrors.8.in
 delete mode 100644 man/infiniband-diags.8.in

diff --git a/Makefile.am b/Makefile.am
index f720e21..0eedbb9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,16 +40,20 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/ibaddr.8 man/ibping.8 \
-		man/ibnodes.8 man/ibhosts.8 man/ibnetdiscover.8 \
+man_MANS = man/ibping.8 \
+		man/ibnodes.8 man/ibhosts.8 \
 		man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
 		man/ibswitches.8 man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
 		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
 		man/dump_lfts.8 man/dump_mfts.8 man/ibsysstat.8 \
-		man/iblinkinfo.8 man/ibqueryerrors.8 man/ibfindnodesusing.8 \
+		man/ibfindnodesusing.8 \
 		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
-		man/infiniband-diags.8 \
 		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8 \
+		doc/man/ibaddr.8 \
+		doc/man/iblinkinfo.8 \
+		doc/man/ibnetdiscover.8 \
+		doc/man/ibqueryerrors.8 \
+		doc/man/infiniband-diags.8 \
 		man/ibidsverify.8
 
 # define this for the dist target
@@ -111,9 +115,12 @@ ibdiag_version:
 		fi ; \
 	fi
 
-EXTRA_DIST = scripts include infiniband-diags.spec.in infiniband-diags.spec \
+EXTRA_DIST = doc scripts include infiniband-diags.spec.in infiniband-diags.spec \
 	$(man_MANS) $(compat_man_pages) autogen.sh etc/*
 
+distclean-local:
+	$(top_srcdir)/doc/generate clean
+
 dist-hook:
 	if [ -x $(top_srcdir)/gen_chlog.sh ] ; then \
 		$(top_srcdir)/gen_chlog.sh > $(distdir)/ChangeLog ; \
diff --git a/configure.in b/configure.in
index 7b051a5..ec7afac 100644
--- a/configure.in
+++ b/configure.in
@@ -167,6 +167,22 @@ fi
 AC_SUBST(ibnetdisc_api_version)
 dnl End libibnetdisc stuff
 
+dnl Generate doc/man/*.in files if possible
+DOC_DATE="`date +%Y-%m-%d`"
+AC_SUBST(BUILD_DATE)
+AC_CHECK_PROG(have_rst2man, rst2man, "yes")
+if test x$have_rst2man == xyes; then
+	doc/generate
+else
+	if test -f doc/man/infiniband-diags.8.in; then
+		echo "WARNING: 'rst2man' not found; using premade man pages"
+	else
+		echo "FAILED to find 'rst2man' required to build man pages"
+		exit 1
+	fi
+fi
+dnl
+
 AC_CONFIG_FILES([\
 	Makefile \
 	infiniband-diags.spec \
@@ -190,8 +206,11 @@ AC_CONFIG_FILES([\
 	scripts/ibrouters \
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
-	man/ibqueryerrors.8 \
-	man/infiniband-diags.8 \
+	doc/man/ibaddr.8 \
+	doc/man/iblinkinfo.8 \
+	doc/man/ibnetdiscover.8 \
+	doc/man/ibqueryerrors.8 \
+	doc/man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
diff --git a/doc/README.rst b/doc/README.rst
new file mode 100644
index 0000000..5c74eda
--- /dev/null
+++ b/doc/README.rst
@@ -0,0 +1,105 @@
+infiniband-diags ReStructured Text documentation
+================================================
+
+Having documentation in ReStructured Text has the following benefits
+
+1) The addition of common functionality (options, config files, etc.) can be
+   documented once and then included in documents for multiple tools.
+
+   1a) Documentation source is more straight forward and writers can
+       concentrate on the features which are unique to each tool.
+
+2) Documentation can be generated into multiple formats (man, html) not just
+   man pages.
+
+3) Documentation for any individual tool is complete within that page.  (There
+   is no referencing of other documents and guessing which "common" options
+   apply.)
+
+
+Instructions
+------------
+
+Place main ``rst`` files in the rst directory.  ``common include`` rst files
+should be in rst/common.
+
+"git add" should _only_ be run on the rst source files themselves.
+
+The best way to update generated documentation after changes is to [re]run
+configure.  autoconf will run the ``generate`` script if rst2man is available
+on your system.  If rst2man is not available, tarball and source rpm
+distributions contain the doc/man/\*.in files and can be built from those files
+a users system without rst2man.  Of course they will not get any changes made
+to the rst files.  Therefore developers are required to have rst2man[*] installed.
+
+[*] rst2man is available in the python-docutils package.
+
+
+Common files
+------------
+
+Common documents should be placed in the rst/common directory.  Common files should not be put
+in the 'main' rst directory.   The automated conversion script will try and
+make documents out of them.
+
+There are 2 types of common files
+
+	1) common options
+
+               The common options are text which describes a common option.
+               The naming conventions is:
+
+                        opt_<option>.rst
+
+	2) common sections
+
+                A common section contains a section header and documents a more
+                advanced feature such as a config file.  The naming convention
+                for the common section is:
+
+                        sec_<section>.rst.
+
+
+Common documents should actually document features which are intended to be
+common across multiple tools.  Within the code these features are contained in
+ibdiag_common or a sub library such as ibnetdisc or an external library such as
+the node name map feature.
+
+
+Examples
+--------
+
+The "man" page text is:
+
+::
+        <text>
+
+        .. include:: common/opt_L.rst
+
+        <text>
+
+        .. include:: common/sec_config-file.rst
+
+
+The common option "L" is:
+
+::
+        .. Define the common option -L
+
+        **-L**   The address specified is a LID
+
+
+And the common Section is:
+
+::
+        .. Common text for the config file
+
+        CONFIG FILE
+        -----------
+
+        @IBDIAG_CONFIG_PATH@/ibdiag.conf
+
+        A global config file is provided to set some of the common options for all
+        tools.  See supplied config file for details.
+
+
diff --git a/doc/generate b/doc/generate
new file mode 100755
index 0000000..924896d
--- /dev/null
+++ b/doc/generate
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+docdir=`dirname $0`
+mode=$1
+
+cd $docdir
+
+if [ "$mode" == "" ]; then
+	for file in rst/*.rst; do
+		file=`basename $file`
+		target=`echo $file | sed -e 's/\(.*\).rst/\1/'`
+		echo "   creating man/$target ..."
+		rst2man rst/$file > man/$target
+	done
+elif [ "$mode" == "clean" ]; then
+	rm -f man/*
+elif [ "$mode" == "-h" ] || [ "$mode" == "--help" ]; then
+	echo "./generate [clean]"
+	echo "   Generate the <file>.in 'man' files from rst documentation"
+	echo "   clean -- remove all files in 'man' and regenerate \"clean\""
+else
+	echo "ERROR: invalid option '$mode'"
+	exit 1
+fi
+
+exit 0
+
diff --git a/doc/rst/common/opt_C.rst b/doc/rst/common/opt_C.rst
new file mode 100644
index 0000000..223edf3
--- /dev/null
+++ b/doc/rst/common/opt_C.rst
@@ -0,0 +1,4 @@
+.. Define the common option -C
+
+**-C, --Ca <ca_name>**    use the specified ca_name.
+
diff --git a/doc/rst/common/opt_D.rst b/doc/rst/common/opt_D.rst
new file mode 100644
index 0000000..5f87a16
--- /dev/null
+++ b/doc/rst/common/opt_D.rst
@@ -0,0 +1,14 @@
+.. Define the common option -D for Directed routes
+
+**-D, --Direct**     The address specified is a directed route
+::
+
+    Examples:
+       [options] -D [options] "0"          # self port
+       [options] -D [options] "0,1,2,1,4"  # out via port 1, then 2, ...
+
+       (Note the second number in the path specified must match the port being
+       used.  This can be specified using the port selection flag '-P' or the
+       port found through the automatic selection process.)
+
+
diff --git a/doc/rst/common/opt_D_with_param.rst b/doc/rst/common/opt_D_with_param.rst
new file mode 100644
index 0000000..f040345
--- /dev/null
+++ b/doc/rst/common/opt_D_with_param.rst
@@ -0,0 +1,14 @@
+.. Define the common option -D for Directed routes
+
+**-D, --Direct <dr_path>**     The address specified is a directed route
+::
+
+    Examples:
+       -D "0"          # self port
+       -D "0,1,2,1,4"  # out via port 1, then 2, ...
+
+       (Note the second number in the path specified must match the port being
+       used.  This can be specified using the port selection flag '-P' or the
+       port found through the automatic selection process.)
+
+
diff --git a/doc/rst/common/opt_G.rst b/doc/rst/common/opt_G.rst
new file mode 100644
index 0000000..2647f88
--- /dev/null
+++ b/doc/rst/common/opt_G.rst
@@ -0,0 +1,4 @@
+.. Define the common option -G
+
+**-G, --Guid**     The address specified is a Port GUID
+
diff --git a/doc/rst/common/opt_G_with_param.rst b/doc/rst/common/opt_G_with_param.rst
new file mode 100644
index 0000000..0edb2d5
--- /dev/null
+++ b/doc/rst/common/opt_G_with_param.rst
@@ -0,0 +1,4 @@
+.. Define the common option -G
+
+**--port-guid, -G <port_guid>**  Specify a port_guid
+
diff --git a/doc/rst/common/opt_L.rst b/doc/rst/common/opt_L.rst
new file mode 100644
index 0000000..46c6b95
--- /dev/null
+++ b/doc/rst/common/opt_L.rst
@@ -0,0 +1,4 @@
+.. Define the common option -L
+
+**-L, --Lid**   The address specified is a LID
+
diff --git a/doc/rst/common/opt_P.rst b/doc/rst/common/opt_P.rst
new file mode 100644
index 0000000..bf9a191
--- /dev/null
+++ b/doc/rst/common/opt_P.rst
@@ -0,0 +1,4 @@
+.. Define the common option -P
+
+**-P, --Port <ca_port>**    use the specified ca_port.
+
diff --git a/doc/rst/common/opt_V.rst b/doc/rst/common/opt_V.rst
new file mode 100644
index 0000000..2ee7526
--- /dev/null
+++ b/doc/rst/common/opt_V.rst
@@ -0,0 +1,4 @@
+.. Define the common option -V
+
+**-V, --version**     show the version info.
+
diff --git a/doc/rst/common/opt_cache.rst b/doc/rst/common/opt_cache.rst
new file mode 100644
index 0000000..4cad3ae
--- /dev/null
+++ b/doc/rst/common/opt_cache.rst
@@ -0,0 +1,7 @@
+.. Define the common option cache
+
+**--cache <filename>**
+Cache the ibnetdiscover network data in the specified filename.  This
+cache may be used by other tools for later analysis.
+
+
diff --git a/doc/rst/common/opt_d.rst b/doc/rst/common/opt_d.rst
new file mode 100644
index 0000000..2a37ccc
--- /dev/null
+++ b/doc/rst/common/opt_d.rst
@@ -0,0 +1,6 @@
+.. Define the common option -d
+
+-d
+        raise the IB debugging level.
+        May be used several times (-ddd or -d -d -d).
+
diff --git a/doc/rst/common/opt_diff.rst b/doc/rst/common/opt_diff.rst
new file mode 100644
index 0000000..44aa1b7
--- /dev/null
+++ b/doc/rst/common/opt_diff.rst
@@ -0,0 +1,9 @@
+.. Define the common option diff
+
+**--diff <filename>**
+Load cached ibnetdiscover data and do a diff comparison to the current
+network or another cache.  A special diff output for ibnetdiscover
+output will be displayed showing differences between the old and current
+fabric.  By default, the following are compared for differences: switches,
+channel adapters, routers, and port connections.
+
diff --git a/doc/rst/common/opt_diffcheck.rst b/doc/rst/common/opt_diffcheck.rst
new file mode 100644
index 0000000..9f478c7
--- /dev/null
+++ b/doc/rst/common/opt_diffcheck.rst
@@ -0,0 +1,13 @@
+.. Define the common option diffcheck
+
+**--diffcheck <key(s)>**
+Specify what diff checks should be done in the **--diff** option above.
+Comma separate multiple diff check key(s).  The available diff checks
+are: **sw = switches**, **ca = channel adapters**, **router** = routers,
+**port** = port connections, **lid** = lids, **nodedesc** = node
+descriptions.  Note that **port**, **lid**, and **nodedesc** are
+checked only for the node types that are specified (e.g. **sw**,
+**ca**, **router**).  If **port** is specified alongside **lid**
+or **nodedesc**, remote port lids and node descriptions will also be compared.
+
+
diff --git a/doc/rst/common/opt_e.rst b/doc/rst/common/opt_e.rst
new file mode 100644
index 0000000..f0c9103
--- /dev/null
+++ b/doc/rst/common/opt_e.rst
@@ -0,0 +1,3 @@
+.. Define the common option -e
+
+-e      show send and receive errors (timeouts and others)
diff --git a/doc/rst/common/opt_h.rst b/doc/rst/common/opt_h.rst
new file mode 100644
index 0000000..2f74999
--- /dev/null
+++ b/doc/rst/common/opt_h.rst
@@ -0,0 +1,4 @@
+.. Define the common option -h
+
+**-h, --help**      show the usage message
+
diff --git a/doc/rst/common/opt_load-cache.rst b/doc/rst/common/opt_load-cache.rst
new file mode 100644
index 0000000..88dc05f
--- /dev/null
+++ b/doc/rst/common/opt_load-cache.rst
@@ -0,0 +1,8 @@
+.. Define the common option load-cache
+
+**--load-cache <filename>**
+Load and use the cached ibnetdiscover data stored in the specified
+filename.  May be useful for outputting and learning about other
+fabrics or a previous state of a fabric.
+
+
diff --git a/doc/rst/common/opt_node_name_map.rst b/doc/rst/common/opt_node_name_map.rst
new file mode 100644
index 0000000..dd2c6cf
--- /dev/null
+++ b/doc/rst/common/opt_node_name_map.rst
@@ -0,0 +1,6 @@
+.. Define the common option --node-name-map
+
+**--node-name-map <node-name-map>** Specify a node name map.
+
+        This file maps GUIDs to more user friendly names.  See FILES section.
+
diff --git a/doc/rst/common/opt_o-outstanding_smps.rst b/doc/rst/common/opt_o-outstanding_smps.rst
new file mode 100644
index 0000000..a52f09e
--- /dev/null
+++ b/doc/rst/common/opt_o-outstanding_smps.rst
@@ -0,0 +1,7 @@
+.. Define the common option -z
+
+**--outstanding_smps, -o <val>**
+        Specify the number of outstanding SMP's which should be issued during the scan
+
+        Default: 2
+
diff --git a/doc/rst/common/opt_s.rst b/doc/rst/common/opt_s.rst
new file mode 100644
index 0000000..c7ada5e
--- /dev/null
+++ b/doc/rst/common/opt_s.rst
@@ -0,0 +1,4 @@
+.. Define the common option -s
+
+**-s, --sm_port <smlid>**     use 'smlid' as the target lid for SA queries.
+
diff --git a/doc/rst/common/opt_t.rst b/doc/rst/common/opt_t.rst
new file mode 100644
index 0000000..59d3694
--- /dev/null
+++ b/doc/rst/common/opt_t.rst
@@ -0,0 +1,4 @@
+.. Define the common option -t
+
+**-t, --timeout <timeout_ms>** override the default timeout for the solicited mads.
+
diff --git a/doc/rst/common/opt_v.rst b/doc/rst/common/opt_v.rst
new file mode 100644
index 0000000..9912007
--- /dev/null
+++ b/doc/rst/common/opt_v.rst
@@ -0,0 +1,6 @@
+.. Define the common option -v
+
+**-v, --verbose**
+        increase the application verbosity level.
+        May be used several times (-vv or -v -v -v)
+
diff --git a/doc/rst/common/opt_z-config.rst b/doc/rst/common/opt_z-config.rst
new file mode 100644
index 0000000..449a6ef
--- /dev/null
+++ b/doc/rst/common/opt_z-config.rst
@@ -0,0 +1,6 @@
+.. Define the common option -z
+
+**--config, -z  <config_file>** Specify alternate config file.
+
+        Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
+
diff --git a/doc/rst/common/sec_config-file.rst b/doc/rst/common/sec_config-file.rst
new file mode 100644
index 0000000..060cf7b
--- /dev/null
+++ b/doc/rst/common/sec_config-file.rst
@@ -0,0 +1,10 @@
+.. Common text for the config file
+
+CONFIG FILE
+-----------
+
+@IBDIAG_CONFIG_PATH@/ibdiag.conf
+
+A global config file is provided to set some of the common options for all
+tools.  See supplied config file for details.
+
diff --git a/doc/rst/common/sec_node-name-map.rst b/doc/rst/common/sec_node-name-map.rst
new file mode 100644
index 0000000..3e18d1b
--- /dev/null
+++ b/doc/rst/common/sec_node-name-map.rst
@@ -0,0 +1,43 @@
+.. Common text to describe the node name map file.
+
+NODE NAME MAP FILE FORMAT
+-------------------------
+
+The node name map is used to specify user friendly names for nodes in the
+output.  GUIDs are used to perform the lookup.
+
+This functionality is provided by the opensm-libs package.  See **opensm(8)**
+for the file location for your installation.
+
+**Generically:**
+
+::
+
+   # comment
+   <guid> "<name>"
+
+**Example:**
+
+::
+
+   # IB1
+   # Line cards
+   0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
+   0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
+   0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
+   0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
+   0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB-24D"
+   
+   # Spines
+   0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+   0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+   0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
+   0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
+   0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
+   
+   # GUID   Node Name
+   0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
+   0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
+   0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
+   0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
+
diff --git a/doc/rst/common/sec_portselection.rst b/doc/rst/common/sec_portselection.rst
new file mode 100644
index 0000000..56936b6
--- /dev/null
+++ b/doc/rst/common/sec_portselection.rst
@@ -0,0 +1,24 @@
+.. Explanation of local port selection
+
+Local port Selection
+--------------------
+
+Multiple port/Multiple CA support: when no IB device or port is specified
+(see the "local umad parameters" below), the libibumad library
+selects the port to use by the following criteria:
+
+	1. the first port that is ACTIVE.
+	2. if not found, the first port that is UP (physical link up).
+
+	If a port and/or CA name is specified, the libibumad library attempts
+	to fulfill the user request, and will fail if it is not possible.
+
+	For example:
+
+        ::
+
+	    ibaddr                 # use the first port (criteria #1 above)
+	    ibaddr -C mthca1       # pick the best port from "mthca1" only.
+	    ibaddr -P 2            # use the second (active/up) port from the first available IB device.
+	    ibaddr -C mthca0 -P 2  # use the specified port only.
+
diff --git a/doc/rst/common/sec_topology-file.rst b/doc/rst/common/sec_topology-file.rst
new file mode 100644
index 0000000..8249f2d
--- /dev/null
+++ b/doc/rst/common/sec_topology-file.rst
@@ -0,0 +1,89 @@
+.. Common text to describe the Topology file.
+
+TOPOLOGY FILE FORMAT
+--------------------
+
+The topology file format is human readable and largely intuitive.
+Most identifiers are given textual names like vendor ID (vendid), device ID
+(device ID), GUIDs of various types (sysimgguid, caguid, switchguid, etc.).
+PortGUIDs are shown in parentheses ().  For switches, this is shown on the
+switchguid line.  For CA and router ports, it is shown on the connectivity
+lines.  The IB node is identified followed by the number of ports and a quoted
+the node GUID.  On the right of this line is a comment (#) followed by the
+NodeDescription in quotes.  If the node is a switch, this line also contains
+whether switch port 0 is base or enhanced, and the LID and LMC of port 0.
+Subsequent lines pertaining to this node show the connectivity.   On the
+left is the port number of the current node.  On the right is the peer node
+(node at other end of link). It is identified in quotes with nodetype
+followed by - followed by NodeGUID with the port number in square brackets.
+Further on the right is a comment (#).  What follows the comment is
+dependent on the node type.  If it it a switch node, it is followed by
+the NodeDescription in quotes and the LID of the peer node.  If it is a
+CA or router node, it is followed by the local LID and LMC and then
+followed by the NodeDescription in quotes and the LID of the peer node.
+The active link width and speed are then appended to the end of this
+output line.
+
+An example of this is:
+
+::
+
+   #
+   # Topology file: generated on Tue Jun  5 14:15:10 2007
+   #
+   # Max of 3 hops discovered
+   # Initiated from node 0008f10403960558 port 0008f10403960559
+   
+   Non-Chassis Nodes
+   
+   vendid=0x8f1
+   devid=0x5a06
+   sysimgguid=0x5442ba00003000
+   switchguid=0x5442ba00003080(5442ba00003080)
+   Switch  24 "S-005442ba00003080"         # "ISR9024 Voltaire" base port 0 lid 6 lmc 0
+   [22]    "H-0008f10403961354"[1](8f10403961355)         # "MT23108 InfiniHost Mellanox Technologies" lid 4 4xSDR
+   [10]    "S-0008f10400410015"[1]         # "SW-6IB4 Voltaire" lid 3 4xSDR
+   [8]     "H-0008f10403960558"[2](8f1040396055a)         # "MT23108 InfiniHost Mellanox Technologies" lid 14 4xSDR
+   [6]     "S-0008f10400410015"[3]         # "SW-6IB4 Voltaire" lid 3 4xSDR
+   [12]    "H-0008f10403960558"[1](8f10403960559)         # "MT23108 InfiniHost Mellanox Technologies" lid 10 4xSDR
+   
+   vendid=0x8f1
+   devid=0x5a05
+   switchguid=0x8f10400410015(8f10400410015)
+   Switch  8 "S-0008f10400410015"          # "SW-6IB4 Voltaire" base port 0 lid 3 lmc 0
+   [6]     "H-0008f10403960984"[1](8f10403960985)         # "MT23108 InfiniHost Mellanox Technologies" lid 16 4xSDR
+   [4]     "H-005442b100004900"[1](5442b100004901)        # "MT23108 InfiniHost Mellanox Technologies" lid 12 4xSDR
+   [1]     "S-005442ba00003080"[10]                # "ISR9024 Voltaire" lid 6 1xSDR
+   [3]     "S-005442ba00003080"[6]         # "ISR9024 Voltaire" lid 6 4xSDR
+   
+   vendid=0x2c9
+   devid=0x5a44
+   caguid=0x8f10403960984
+   Ca      2 "H-0008f10403960984"          # "MT23108 InfiniHost Mellanox Technologies"
+   [1](8f10403960985)     "S-0008f10400410015"[6]         # lid 16 lmc 1 "SW-6IB4 Voltaire" lid 3 4xSDR
+   
+   vendid=0x2c9
+   devid=0x5a44
+   caguid=0x5442b100004900
+   Ca      2 "H-005442b100004900"          # "MT23108 InfiniHost Mellanox Technologies"
+   [1](5442b100004901)     "S-0008f10400410015"[4]         # lid 12 lmc 1 "SW-6IB4 Voltaire" lid 3 4xSDR
+   
+   vendid=0x2c9
+   devid=0x5a44
+   caguid=0x8f10403961354
+   Ca      2 "H-0008f10403961354"          # "MT23108 InfiniHost Mellanox Technologies"
+   [1](8f10403961355)     "S-005442ba00003080"[22]                # lid 4 lmc 1 "ISR9024 Voltaire" lid 6 4xSDR
+   
+   vendid=0x2c9
+   devid=0x5a44
+   caguid=0x8f10403960558
+   Ca      2 "H-0008f10403960558"          # "MT23108 InfiniHost Mellanox Technologies"
+   [2](8f1040396055a)     "S-005442ba00003080"[8]         # lid 14 lmc 1 "ISR9024 Voltaire" lid 6 4xSDR
+   [1](8f10403960559)     "S-005442ba00003080"[12]                # lid 10 lmc 1 "ISR9024 Voltaire" lid 6 1xSDR
+
+
+When grouping is used, IB nodes are organized into chassis which are
+numbered. Nodes which cannot be determined to be in a chassis are
+displayed as "Non-Chassis Nodes".  External ports are also shown on the
+connectivity lines.
+
diff --git a/doc/rst/ibaddr.8.in.rst b/doc/rst/ibaddr.8.in.rst
new file mode 100644
index 0000000..93de897
--- /dev/null
+++ b/doc/rst/ibaddr.8.in.rst
@@ -0,0 +1,100 @@
+======
+IBADDR
+======
+
+----------------------------
+query InfiniBand address(es)
+----------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibaddr [options]
+
+
+DESCRIPTION
+===========
+
+
+Display the lid (and range) as well as the GID address of the
+port specified (by DR path, lid, or GUID) or the local port by default.
+
+Note: this utility can be used as simple address resolver.
+
+OPTIONS
+=======
+
+**--gid_show, -g**
+show gid address only
+
+**--lid_show, -l**
+show lid range only
+
+**--Lid_show, -L**
+show lid range (in decimal) only
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_D.rst
+.. include:: common/opt_G.rst
+.. include:: common/opt_s.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+EXAMPLES
+========
+
+::
+
+        ibaddr                  # local port\'s address
+        ibaddr 32               # show lid range and gid of lid 32
+        ibaddr -G 0x8f1040023   # same but using guid address
+        ibaddr -l 32            # show lid range only
+        ibaddr -L 32            # show decimal lid range only
+        ibaddr -g 32            # show gid address only
+
+SEE ALSO
+========
+
+**ibroute (8), ibtracert (8)**
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/iblinkinfo.8.in.rst b/doc/rst/iblinkinfo.8.in.rst
new file mode 100644
index 0000000..1496bfc
--- /dev/null
+++ b/doc/rst/iblinkinfo.8.in.rst
@@ -0,0 +1,131 @@
+==========
+IBLINKINFO
+==========
+
+--------------------------------------------
+report link info for all links in the fabric
+--------------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+iblinkinfo <options>
+
+DESCRIPTION
+===========
+
+iblinkinfo reports link info for each port in an IB fabric, node by node.
+Optionally, iblinkinfo can do partial scans and limit its output to parts of a
+fabric.
+
+OPTIONS
+=======
+
+**--down, -d**
+Print only nodes which have a port in the "Down" state.
+
+**--line, -l**
+Print all information for each link on one line. Default is to print a header
+with the node information and then a list for each port (useful for
+grep'ing output).
+
+
+**--additional, -p**
+Print additional port settings (<LifeTime>,<HoqLife>,<VLStallCount>)
+
+**--switches-only**
+Show only switches in output.
+
+**--cas-only**
+Show only CAs in output.
+
+
+Partial Scan flags
+------------------
+
+The node to start a partial scan can be specified with the following addresses.
+
+.. include:: common/opt_G_with_param.rst
+.. include:: common/opt_D_with_param.rst
+
+**Note:** For switches results are printed for all ports not just switch port 0.
+
+**--switch, -S <port_guid>** same as "-G". (provided only for backward compatibility)
+
+How much of the scan to be printed can be controled with the following.
+
+**--all, -a**
+Print all nodes found in a partial fabric scan.  Normally a
+partial fabric scan will return only the node specified.  This option will
+print the other nodes found as well.
+
+**--hops, -n <hops>**
+Specify the number of hops away from a specified node to scan.  This is useful
+to expand a partial fabric scan beyond the node specified.
+
+
+Cache File flags
+----------------
+
+.. include:: common/opt_load-cache.rst
+.. include:: common/opt_diff.rst
+.. include:: common/opt_diffcheck.rst
+
+**--filterdownports <filename>**
+Filter downports indicated in a ibnetdiscover cache.  If a port was previously
+indicated as down in the specified cache, and is still down, do not output it in the
+resulting output.  This option may be particularly useful for environments
+where switches are not fully populated, thus much of the default iblinkinfo
+info is considered unuseful.  See **ibnetdiscover** for information on caching
+ibnetdiscover output.
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+.. include:: common/opt_o-outstanding_smps.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_t.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+**-R** (This option is obsolete and does nothing)
+
+EXIT STATUS
+===========
+
+0 on success, -1 on failure to scan the fabric, 1 if check mode is used and
+inconsistencies are found.
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+.. include:: common/sec_node-name-map.rst
+
+
+AUTHOR
+======
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibnetdiscover.8.in.rst b/doc/rst/ibnetdiscover.8.in.rst
new file mode 100644
index 0000000..fb7c4c9
--- /dev/null
+++ b/doc/rst/ibnetdiscover.8.in.rst
@@ -0,0 +1,114 @@
+=============
+IBNETDISCOVER
+=============
+
+----------------------------
+discover InfiniBand topology
+----------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibnetdiscover [options] [<topology-file>]
+
+
+DESCRIPTION
+===========
+
+ibnetdiscover performs IB subnet discovery and outputs a human readable
+topology file. GUIDs, node types, and port numbers are displayed
+as well as port LIDs and NodeDescriptions.  All nodes (and links) are displayed
+(full topology).  Optionally, this utility can be used to list the current
+connected nodes by nodetype.  The output is printed to standard output
+unless a topology file is specified.
+
+OPTIONS
+=======
+
+**-l, --list**
+List of connected nodes
+
+**-g, --grouping**
+Show grouping.  Grouping correlates IB nodes by different vendor specific
+schemes.  It may also show the switch external ports correspondence.
+
+**-H, --Hca_list**
+List of connected CAs
+
+**-S, --Switch_list**
+List of connected switches
+
+**-R, --Router_list**
+List of connected routers
+
+**-s, --show**
+Show progress information during discovery.
+
+**-p, --ports**
+Obtain a ports report which is a
+list of connected ports with relevant information (like LID, portnum,
+GUID, width, speed, and NodeDescription).
+
+**-m, --max_hops**
+Report max hops discovered.
+
+.. include:: common/opt_o-outstanding_smps.rst
+
+
+Cache File flags
+----------------
+
+.. include:: common/opt_cache.rst
+.. include:: common/opt_load-cache.rst
+.. include:: common/opt_diff.rst
+.. include:: common/opt_diffcheck.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+.. include:: common/opt_o-outstanding_smps.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_t.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+.. include:: common/sec_topology-file.rst
+
+
+
+AUTHORS
+=======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibqueryerrors.8.in.rst b/doc/rst/ibqueryerrors.8.in.rst
new file mode 100644
index 0000000..15d488d
--- /dev/null
+++ b/doc/rst/ibqueryerrors.8.in.rst
@@ -0,0 +1,155 @@
+=============
+IBQUERYERRORS
+=============
+
+---------------------------------
+query and report IB port counters
+---------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibqueryerrors [options]
+
+DESCRIPTION
+===========
+
+The default behavior is to report the port error counters which exceed a
+threshold for each port in the fabric.  The default threshold is zero (0).
+Error fields can also be suppressed entirely.
+
+In addition to reporting errors on every port.  ibqueryerrors can report the
+port transmit and receive data as well as report full link information to the
+remote port if available.
+
+OPTIONS
+=======
+
+**-s, --suppress <err1,err2,...>**
+Suppress the errors listed in the comma separated list provided.
+
+**-c, --suppress-common**
+Suppress some of the common "side effect" counters.  These counters usually do
+not indicate an error condition and can be usually be safely ignored.
+
+**-r, --report-port**
+Report the port information.  This includes LID, port, external port (if
+applicable), link speed setting, remote GUID, remote port, remote external port
+(if applicable), and remote node description information.
+
+**--data**
+Include the optional transmit and receive data counters.
+
+**--threshold-file <filename>**
+Specify an alternate threshold file.  The default is @IBDIAG_CONFIG_PATH@/error_thresholds
+
+**--switch**  print data for switch's only
+
+**--ca**  print data for CA's only
+
+**--router**  print data for routers only
+
+**--clear-errors -k** Clear error counters after read.
+
+**--clear-counts -K** Clear data counters after read.
+
+**CAUTION** clearing data or error counters will occur regardless of if they
+are printed or not.  See **--counters** and **--data** for details on
+controling which counters are printed.
+
+**--details** include receive error and transmit discard details
+
+**--counters** print data counters only
+
+
+Partial Scan flags
+------------------
+
+The node to start a partial scan can be specified with the following addresses.
+
+.. include:: common/opt_G_with_param.rst
+.. include:: common/opt_D_with_param.rst
+
+**Note:** For switches results are printed for all ports not just switch port 0.
+
+**-S <port_guid>** same as "-G". (provided only for backward compatibility)
+
+
+Cache File flags
+----------------
+
+.. include:: common/opt_load-cache.rst
+
+
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+.. include:: common/opt_o-outstanding_smps.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_t.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+**-R**  (This option is obsolete and does nothing)
+
+EXIT STATUS
+===========
+
+**-1** if scan fails.
+
+**0** if scan succeeds without errors beyond thresholds
+
+**1** if errors are found beyond thresholds or inconsistencies are found in check mode.
+
+FILES
+=====
+
+ERROR THRESHOLD
+---------------
+
+@IBDIAG_CONFIG_PATH@/error_thresholds
+
+Define threshold values for errors.  File format is simple "name=val".
+Comments begin with '#'
+
+**Example:**
+
+::
+
+	# Define thresholds for error counters
+	SymbolErrorCounter=10
+	LinkErrorRecoveryCounter=10
+	VL15Dropped=100
+
+
+.. include:: common/sec_config-file.rst
+
+.. include:: common/sec_node-name-map.rst
+
+AUTHOR
+======
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/infiniband-diags.8.in.rst b/doc/rst/infiniband-diags.8.in.rst
new file mode 100644
index 0000000..6a86ae2
--- /dev/null
+++ b/doc/rst/infiniband-diags.8.in.rst
@@ -0,0 +1,154 @@
+================
+INFINIBAND-DIAGS
+================
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+----------------------------------
+Diagnostics for InfiniBand Fabrics
+----------------------------------
+
+
+DESCRIPTION
+===========
+
+infiniband-diags is a set of utilities designed to help configure, debug, and
+maintain infiniband fabrics.  Many tools and utilities are provided.  Some with
+similar functionality.
+
+The base utilities use directed route MAD's to perform their operations.  They
+may therefore work even in unconfigured subnets.  Other, higher level
+utilities, require LID routed MAD's and to some extent SA/SM access.
+
+
+COMMON OPTIONS
+==============
+
+Most OpenIB diagnostics take some of the following common flags. The exact list
+of supported flags per utility can be found in the documentation for those
+commands.
+
+
+Addressing Flags
+----------------
+
+The -D and -G option have two forms:
+
+.. include:: common/opt_D.rst
+.. include:: common/opt_D_with_param.rst
+.. include:: common/opt_G.rst
+.. include:: common/opt_G_with_param.rst
+
+.. include:: common/opt_L.rst
+.. include:: common/opt_s.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_o-outstanding_smps.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_z-config.rst
+
+
+
+COMMON FILES
+============
+
+The following config files are common amongst many of the utilities.
+
+.. include:: common/sec_config-file.rst
+
+.. include:: common/sec_node-name-map.rst
+.. include:: common/sec_topology-file.rst
+
+
+
+Utilities list
+==============
+
+Basic fabric conectivity
+------------------------
+
+	See: ibnetdiscover, iblinkinfo
+
+Node information
+----------------
+
+	See: ibnodes, ibswitches, ibhosts, ibrouters
+
+Port information
+----------------
+
+	See: ibportstate, ibaddr
+
+Switch Forwarding Table info
+----------------------------
+
+	See: ibtracert, ibroute, dump_lfts, dump_mfts, check_lft_balance, ibfindnodesusing
+
+Peformance counters
+-------------------
+
+	See: ibqueryerrors, perfquery
+
+Local HCA info
+--------------
+
+	See: ibstat, ibstatus
+
+Connectivity check
+------------------
+
+	See: ibping, ibsysstat
+
+Low level query tools
+---------------------
+
+	See: smpquery, smpdump, saquery, sminfo
+
+Fabric verification tools
+-------------------------
+
+        See: ibidsverify
+
+
+Backwards compatibility scripts
+===============================
+
+The following scripts have been identified as redundant and/or lower performing
+as compared to the above scripts.  They are provided as legacy scripts when
+--enable-compat-utils is specified at build time.
+
+ibcheckerrors, ibclearcounters, ibclearerrors, ibdatacounters
+ibchecknet, ibchecknode, ibcheckport, ibcheckportstate,
+ibcheckportwidth, ibcheckstate, ibcheckwidth, ibswportwatch,
+ibprintca, ibprintrt, ibprintswitch, set_nodedesc.sh
+
+
+AUTHORS
+=======
+
+Ira Weiny
+        <weiny2-i2BcT+NCU+M@public.gmane.org>
diff --git a/man/ibaddr.8 b/man/ibaddr.8
deleted file mode 100644
index 51f5a1c..0000000
--- a/man/ibaddr.8
+++ /dev/null
@@ -1,111 +0,0 @@
-.TH IBADDR 8 "June 18, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibaddr \- query InfiniBand address(es)
-
-.SH SYNOPSIS
-.B ibaddr
-[\-d(ebug)] [\-D(irect)] [\-G(uid)] [\-l(id_show)] [\-g(id_show)] [\-C ca_name] 
-[\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)] [\-h(elp)]
-[<lid | dr_path | guid>]
-
-.SH DESCRIPTION
-.PP
-Display the lid (and range) as well as the GID address of the
-port specified (by DR path, lid, or GUID) or the local port by default.
-.PP
-Note: this utility can be used as simple address resolver.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-G\fR, \fB\-\-Guid\fR
-show lid range and gid for GUID address
-.TP
-\fB\-l\fR, \fB\-\-lid_show\fR
-show lid range only
-.TP
-\fB\-L\fR, \fB\-\-Lid_show\fR
-show lid range (in decimal) only
-.TP
-\fB\-g\fR, \fB\-\-gid_show\fR
-show gid address only
-
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
-.SH EXAMPLES
-
-.PP
-ibaddr                  # local port\'s address
-.PP
-ibaddr 32               # show lid range and gid of lid 32
-.PP
-ibaddr -G 0x8f1040023   # same but using guid address
-.PP
-ibaddr -l 32            # show lid range only
-.PP
-ibaddr -L 32            # show decimal lid range only
-.PP
-ibaddr -g 32            # show gid address only
-
-.SH SEE ALSO
-.BR ibroute (8),
-.BR ibtracert (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
deleted file mode 100644
index 5fa2678..0000000
--- a/man/iblinkinfo.8
+++ /dev/null
@@ -1,85 +0,0 @@
-.TH IBLINKINFO 8 "Jan 24, 2008" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-iblinkinfo \- report link info for all links in the fabric
-
-.SH SYNOPSIS
-.B iblinkinfo
-   [-hcdl -C <ca_name> -P <ca_port> -p -S <port_guid> -G <port_guid> -D <direct_route> \-\-load\-cache <filename>]
-
-.SH DESCRIPTION
-.PP
-iblinkinfo reports link info for each port in an IB fabric, node by node.
-Optionally, iblinkinfo can do partial scans and limit its output to parts of a
-fabric.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-S <port_guid>\fR \fB\-G <port_guid>\fR \fB\-\-port\-guid\fR
-start partial scan at the port specified by <port_guid> (hex format)
-.TP
-\fB\-D <direct_route>\fR
-start partial scan at the port specified by the direct route path.
-.TP
-\fB\-l\fR
-Print all information for each link on one line. Default is to print a header
-with the node information and then a list for each port (useful for
-grep\'ing output).
-.TP
-\fB\-d\fR
-Print only nodes which have a port in the "Down" state.
-.TP
-\fB\-p\fR
-Print additional port settings (<LifeTime>,<HoqLife>,<VLStallCount>)
-.TP
-\fB\-C <ca_name>\fR    use the specified ca_name for the search.
-.TP
-\fB\-P <ca_port>\fR    use the specified ca_port for the search.
-.TP
-\fB\-R\fR (This option is obsolete and does nothing)
-.TP
-\fB\-\-load\-cache\fR <filename>
-Load and use the cached ibnetdiscover data stored in the specified
-filename.  May be useful for outputting and learning about other
-fabrics or a previous state of a fabric.  Cannot be used if user
-specifies a direct route path.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-diff\fR <filename>
-Load cached ibnetdiscover data and do a diff comparison to the current
-network or another cache.  A special diff output for iblinkinfo
-output will be displayed showing differences between the old and current
-fabric links.  Be default, the following are compared for differences:
-port connections and port state.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-diffcheck\fR <key(s)>
-Specify what diff checks should be done in the \fB\-\-diff\fR option above.
-Comma separate multiple diff check key(s).  The available diff checks
-are:\fIport\fR = port connections, \fIstate\fR = port state, \fIlid\fR = lids,
-\fInodedesc\fR = node descriptions.  If \fIport\fR is specified alongside \fIlid\fR
-or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
-.TP
-\fB\-\-filterdownports\fR <filename>
-Filter downports indicated in a ibnetdiscover cache.  If a port was previously
-indicated as down in the specified cache, and is still down, do not output it in the
-resulting output.  This option may be particularly useful for environments
-where switches are not fully populated, thus much of the default iblinkinfo
-info is considered unuseful.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-\-switches\-only\fR
-Show only switches in output.
-.TP
-\fB\-\-cas\-only\fR
-Show only CAs in output.
-
-.SH AUTHOR
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibnetdiscover.8 b/man/ibnetdiscover.8
deleted file mode 100644
index 3beb70b..0000000
--- a/man/ibnetdiscover.8
+++ /dev/null
@@ -1,270 +0,0 @@
-.TH IBNETDISCOVER 8 "May 13, 2009" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibnetdiscover \- discover InfiniBand topology
-
-.SH SYNOPSIS
-.B ibnetdiscover
-[\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-s(how)] [\-l(ist)]
-[\-g(rouping)] [\-H(ca_list)] [\-S(witch_list)] [\-R(outer_list)]
-[\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)]
-[\--node-name-map <node-name-map>] [\-\-cache <filename>]
-[\-\-load\-cache <filename>] [\-p(orts)] [\-m(ax_hops)]
-[\-h(elp)] [<topology-file>]
-
-.SH DESCRIPTION
-.PP
-ibnetdiscover performs IB subnet discovery and outputs a human readable
-topology file. GUIDs, node types, and port numbers are displayed
-as well as port LIDs and NodeDescriptions.  All nodes (and links) are displayed
-(full topology).  Optionally, this utility can be used to list the current
-connected nodes by nodetype.  The output is printed to standard output
-unless a topology file is specified.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-l\fR, \fB\-\-list\fR
-List of connected nodes
-.TP
-\fB\-g\fR, \fB\-\-grouping\fR
-Show grouping.  Grouping correlates IB nodes by different vendor specific
-schemes.  It may also show the switch external ports correspondence.
-.TP
-\fB\-H\fR, \fB\-\-Hca_list\fR
-List of connected CAs
-.TP
-\fB\-S\fR, \fB\-\-Switch_list\fR
-List of connected switches
-.TP
-\fB\-R\fR, \fB\-\-Router_list\fR
-List of connected routers
-.TP
-\fB\-s\fR, \fB\-\-show\fR
-Show progress information during discovery.
-.TP
-\fB\-\-node\-name\-map\fR <node-name-map>
-Specify a node name map.  The node name map file maps GUIDs to more user
-friendly names.  See file format below.
-.TP
-\fB\-\-cache\fR <filename>
-Cache the ibnetdiscover network data in the specified filename.  This
-cache may be used by other tools for later analysis.
-.TP
-\fB\-\-load\-cache\fR <filename>
-Load and use the cached ibnetdiscover data stored in the specified
-filename.  May be useful for outputting and learning about other
-fabrics or a previous state of a fabric.
-.TP
-\fB\-\-diff\fR <filename>
-Load cached ibnetdiscover data and do a diff comparison to the current
-network or another cache.  A special diff output for ibnetdiscover
-output will be displayed showing differences between the old and current
-fabric.  By default, the following are compared for differences: switches,
-channel adapters, routers, and port connections.
-.TP
-\fB\-\-diffcheck\fR <key(s)>
-Specify what diff checks should be done in the \fB\-\-diff\fR option above.
-Comma separate multiple diff check key(s).  The available diff checks
-are: \fIsw\fR = switches, \fIca\fR = channel adapters, \fIrouter\fR = routers,
-\fIport\fR = port connections, \fIlid\fR = lids, \fInodedesc\fR = node
-descriptions.  Note that \fIport\fR, \fIlid\fR, and \fInodedesc\fR are
-checked only for the node types that are specified (e.g. \fIsw\fR,
-\fIca\fR, \fIrouter\fR).  If \fIport\fR is specified alongside \fIlid\fR
-or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
-
-
-.TP
-\fB\-p\fR, \fB\-\-ports\fR
-Obtain a ports report which is a
-list of connected ports with relevant information (like LID, portnum,
-GUID, width, speed, and NodeDescription).
-.TP
-\fB\-m\fR, \fB\-\-max_hops\fR
-Report max hops discovered.
-
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
-
-.SH TOPOLOGY FILE FORMAT
-The topology file format is human readable and largely intuitive.
-Most identifiers are given textual names like vendor ID (vendid), device ID
-(device ID), GUIDs of various types (sysimgguid, caguid, switchguid, etc.).
-PortGUIDs are shown in parentheses ().  For switches, this is shown on the
-switchguid line.  For CA and router ports, it is shown on the connectivity
-lines.  The IB node is identified followed by the number of ports and a quoted
-the node GUID.  On the right of this line is a comment (#) followed by the
-NodeDescription in quotes.  If the node is a switch, this line also contains
-whether switch port 0 is base or enhanced, and the LID and LMC of port 0.
-Subsequent lines pertaining to this node show the connectivity.   On the
-left is the port number of the current node.  On the right is the peer node
-(node at other end of link). It is identified in quotes with nodetype
-followed by - followed by NodeGUID with the port number in square brackets.
-Further on the right is a comment (#).  What follows the comment is
-dependent on the node type.  If it it a switch node, it is followed by
-the NodeDescription in quotes and the LID of the peer node.  If it is a
-CA or router node, it is followed by the local LID and LMC and then
-followed by the NodeDescription in quotes and the LID of the peer node.
-The active link width and speed are then appended to the end of this
-output line.
-
-An example of this is:
-.nf
-#
-# Topology file: generated on Tue Jun  5 14:15:10 2007
-#
-# Max of 3 hops discovered
-# Initiated from node 0008f10403960558 port 0008f10403960559
-
-Non-Chassis Nodes
-
-vendid=0x8f1
-devid=0x5a06
-sysimgguid=0x5442ba00003000
-switchguid=0x5442ba00003080(5442ba00003080)
-Switch  24 "S-005442ba00003080"         # "ISR9024 Voltaire" base port 0 lid 6 lmc 0
-[22]    "H-0008f10403961354"[1](8f10403961355)         # "MT23108 InfiniHost Mellanox Technologies" lid 4 4xSDR
-[10]    "S-0008f10400410015"[1]         # "SW-6IB4 Voltaire" lid 3 4xSDR
-[8]     "H-0008f10403960558"[2](8f1040396055a)         # "MT23108 InfiniHost Mellanox Technologies" lid 14 4xSDR
-[6]     "S-0008f10400410015"[3]         # "SW-6IB4 Voltaire" lid 3 4xSDR
-[12]    "H-0008f10403960558"[1](8f10403960559)         # "MT23108 InfiniHost Mellanox Technologies" lid 10 4xSDR
-
-vendid=0x8f1
-devid=0x5a05
-switchguid=0x8f10400410015(8f10400410015)
-Switch  8 "S-0008f10400410015"          # "SW-6IB4 Voltaire" base port 0 lid 3 lmc 0
-[6]     "H-0008f10403960984"[1](8f10403960985)         # "MT23108 InfiniHost Mellanox Technologies" lid 16 4xSDR
-[4]     "H-005442b100004900"[1](5442b100004901)        # "MT23108 InfiniHost Mellanox Technologies" lid 12 4xSDR
-[1]     "S-005442ba00003080"[10]                # "ISR9024 Voltaire" lid 6 1xSDR
-[3]     "S-005442ba00003080"[6]         # "ISR9024 Voltaire" lid 6 4xSDR
-
-vendid=0x2c9
-devid=0x5a44
-caguid=0x8f10403960984
-Ca      2 "H-0008f10403960984"          # "MT23108 InfiniHost Mellanox Technologies"
-[1](8f10403960985)     "S-0008f10400410015"[6]         # lid 16 lmc 1 "SW-6IB4 Voltaire" lid 3 4xSDR
-
-vendid=0x2c9
-devid=0x5a44
-caguid=0x5442b100004900
-Ca      2 "H-005442b100004900"          # "MT23108 InfiniHost Mellanox Technologies"
-[1](5442b100004901)     "S-0008f10400410015"[4]         # lid 12 lmc 1 "SW-6IB4 Voltaire" lid 3 4xSDR
-
-vendid=0x2c9
-devid=0x5a44
-caguid=0x8f10403961354
-Ca      2 "H-0008f10403961354"          # "MT23108 InfiniHost Mellanox Technologies"
-[1](8f10403961355)     "S-005442ba00003080"[22]                # lid 4 lmc 1 "ISR9024 Voltaire" lid 6 4xSDR
-
-vendid=0x2c9
-devid=0x5a44
-caguid=0x8f10403960558
-Ca      2 "H-0008f10403960558"          # "MT23108 InfiniHost Mellanox Technologies"
-[2](8f1040396055a)     "S-005442ba00003080"[8]         # lid 14 lmc 1 "ISR9024 Voltaire" lid 6 4xSDR
-[1](8f10403960559)     "S-005442ba00003080"[12]                # lid 10 lmc 1 "ISR9024 Voltaire" lid 6 1xSDR
-.fi
-
-When grouping is used, IB nodes are organized into chasses which are
-numbered. Nodes which cannot be determined to be in a chassis are
-displayed as "Non-Chassis Nodes".  External ports are also shown on the
-connectivity lines.
-
-
-.SH NODE NAME MAP FILE FORMAT
-The node name map is used to specify user friendly names for nodes in the
-output.  GUIDs are used to perform the lookup.
-
-.TP
-\fBGenerically:\fR
-
-# comment
-.br
-<guid> "<name>"
-
-.TP
-\fBExample:\fR
-
-# IB1
-.br
-# Line cards
-.br
-0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-.br
-# Spines
-.br
-0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-.br
-# GUID   Node Name
-.br
-0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-
-.SH AUTHORS
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
deleted file mode 100644
index 372b0e4..0000000
--- a/man/ibqueryerrors.8.in
+++ /dev/null
@@ -1,127 +0,0 @@
-.TH IBQUERYERRORS 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibqueryerrors \- query and report non-zero IB port counters
-
-.SH SYNOPSIS
-.B ibqueryerrors [options]
-
-.SH DESCRIPTION
-.PP
-The default behavior is to report the port error counters which exceed a
-threshold for each port in the fabric.  The default threshold is zero (0).
-Error fields can also be suppressed entirely.
-
-In addition to reporting errors on every port.  ibqueryerrors can report the
-port transmit and receive data as well as report full link information to the
-remote port if available.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-s <err1,err2,...>\fR
-Suppress the errors listed in the comma separated list provided.
-.TP
-\fB\-c\fR
-Suppress some of the common "side effect" counters.  These counters usually do
-not indicate an error condition and can be usually be safely ignored.
-.TP
-\fB\-G <port_guid>\fR \fB\-S <port_guid>\fR \fB\-\-port\-guid\fR
-Report results for the port specified.  For switches results are printed for
-all ports not just switch port 0.
-.TP
-\-S same as "-G". (provided only for backward compatibility)
-.TP
-\fB\-D <direct_route>\fR
-Report results for the port specified.  For switches results are printed for
-all ports not just switch port 0.
-.TP
-\fB\-r\fR
-Report the port information.  This includes LID, port, external port (if
-applicable), link speed setting, remote GUID, remote port, remote external port
-(if applicable), and remote node description information.
-.TP
-\fB\-\-data\fR
-Include the optional transmit and receive data counters.
-.TP
-\fB\-\-threshold-file\fR
-Specify an alternate threshold file.  The default is @IBDIAG_CONFIG_PATH@/error_thresholds
-.TP
-\fB\-\-switch\fR  print data for switches only
-.TP
-\fB\-\-ca\fR  print data for CA's only
-.TP
-\fB\-\-router\fR  print data for routers only
-.TP
-\fB\-\-clear\-errors\fR \fB\-k\fR Clear error counters after read.
-\-k and \-K can be used together to clear both errors and counters.
-.TP
-\fB\-\-clear\-counts\fR \fB\-K\fR Clear data counters after read.
-\fBCAUTION\fR clearing data counters will occur regardless of if they are
-printed or not.  This is because data counters are only \fBprinted\fR on ports
-which have errors.  This means if a port has 0 errors and the \-K option is
-specified the data counters will be cleared without any printed output.
-.TP
-\fB\-\-details\fR include receive error and transmit discard details
-.TP
-\fB\-\-load\-cache\fR <filename>
-Load and use the cached ibnetdiscover data stored in the specified
-filename.  May be useful for outputting and learning about other
-fabrics or a previous state of a fabric.  Cannot be used if user
-specifies a direct route path.  See
-.B ibnetdiscover
-for information on caching ibnetdiscover output.
-.TP
-\fB\-R\fR  (This option is obsolete and does nothing)
-
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
-
-.SH EXIT STATUS
-
-If a failure to scan the fabric occurs return -1.  If the scan succeeds without
-errors beyond thresholds return 0.  If errors are found on ports beyond
-thresholds return 1.
-
-.SH FILES
-
-@IBDIAG_CONFIG_PATH@/error_thresholds
-
-Define threshold values for errors.  File format is simple "name=val".
-Comments begin with '#'
-
-Example:
-
-	# Define thresholds for error counters
-.br
-	SymbolErrorCounter=10
-.br
-	LinkErrorRecoveryCounter=10
-.br
-	VL15Dropped=100
-
-
-.SH AUTHOR
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
deleted file mode 100644
index b7059a8..0000000
--- a/man/infiniband-diags.8.in
+++ /dev/null
@@ -1,214 +0,0 @@
-.TH INFINIBAND-DIAGS 8 "Aug 15, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH SYNOPSIS
-.B infiniband-diags
-
-.SH DESCRIPTION
-.PP
-infiniband-diags is a set of utilities designed to help configure, debug, and
-maintain infiniband fabrics.  Many tools and utilities are provided.  Some with
-similar functionality.
-
-The base utilities use directed route MAD's to perform their operations.  They
-may therefore work even in unconfigured subnets.  Other, higher level
-utilities, require LID routed MAD's and to some extent SA/SM access.
-
-Multiple port/Multiple CA support: when no IB device or port is specified
-(see the "local umad parameters" below), the libibumad library
-selects the port to use by the following criteria:
-
-	1. the first port that is ACTIVE.
-.br
-	2. if not found, the first port that is UP (physical link up).
-.br
-
-.br
-	If a port and/or CA name is specified, the libibumad library attempts to fulfill the user request, and will fail if it is not possible.
-.br
-
-.br
-	For example:
-.br
-	ibaddr 			# use the 'best port'
-.br
-	ibaddr -C mthca1	# pick the best port from mthca1 only.
-.br
-	ibaddr -P 2		# use the second (active/up) port from the first available IB device.
-.br
-	ibaddr -C mthca0 -P 2	# use the specified port only.
-
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using "<util_name> -h".
-
-.TP
-\fB# Addressing Flags\fR
-.PP
-\-D      use the directed route specified.
-.br
-		Examples:
-.br
-		"0" 		# self port
-.br
-		"0,1,2,1,4"	# out via port 1, then 2, ...
-
-.PP
-\-G <guid>     use the PortGuid specified.
-.PP
-\-s <smlid>     use 'smlid' as the target lid for SA queries.
-
-.TP
-\fB# Local HCA/port flags:\fR
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-
-.TP
-\fB# Debugging flags\fR
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
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
-.TP
-\fB# Configuration flags\fR
-.PP
-\-\-config \-z  <config_file>
-        Specify alternate config file.
-        Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
-
-.SH FILES
-
-@IBDIAG_CONFIG_PATH@/ibdiag.conf
-
-A global config file is provided to set some of the common options for all
-tools.  See supplied config file for details.
-
-
-.SH NODE NAME MAP FILE FORMAT
-Most utilities use the optional node name map file supported by libosmcomp to
-specify user friendly names for nodes in the output.  Node GUIDs are used to
-perform the lookup.
-
-.TP
-\fBGenerically:\fR
-
-# comment
-.br
-<guid> "<name>"
-
-.TP
-\fBExample:\fR
-
-# IB1
-.br
-# Line cards
-.br
-0x0008f104003f125c "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f125d "IB1 (Rack 11 slot 1   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d2 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10d3 "IB1 (Rack 11 slot 2   ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-0x0008f104003f10bf "IB1 (Rack 11 slot 12  ) ISR9288/ISR9096 Voltaire sLB-24D"
-.br
-.br
-# Spines
-.br
-0x0008f10400400e2d "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2e "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e2f "IB1 (Rack 11 spine 1   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e31 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-0x0008f10400400e32 "IB1 (Rack 11 spine 2   ) ISR9288 Voltaire sFB-12D"
-.br
-.br
-# GUID   Node Name
-.br
-0x0008f10400411a08 "SW1  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a28 "SW2  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f10400411a34 "SW3  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-0x0008f104004119d0 "SW4  (Rack  3) ISR9024 Voltaire 9024D"
-.br
-
-.SH Utilities list
-
-.TP
-\fBBasic fabric conectivity\fR
-
-	See: ibnetdiscover, iblinkinfo, ibidsverify
-
-.TP
-\fBNode information\fR
-
-	See: ibnodes, ibswitches, ibhosts, ibrouters
-
-.TP
-\fBPort information\fR
-
-	See: ibportstate, ibaddr
-
-.TP
-\fBSwitch Forwarding Table info\fR
-
-	See: ibtracert, ibroute, dump_lfts, dump_mfts, check_lft_balance, ibfindnodesusing
-
-.TP
-\fBPeformance counters\fR
-
-	See: ibqueryerrors, perfquery
-
-.TP
-\fBLocal HCA info\fR
-
-	See: ibstat, ibstatus
-
-.TP
-\fBConnectivity check\fR
-
-	See: ibping, ibsysstat
-
-.TP
-\fBLow level query tools\fR
-
-	See: smpquery, smpdump, saquery, sminfo
-
-
-.SH Backwards compatibility scripts
-
-The following scripts have been identified as redundant and/or lower performing
-as compared to the above scripts.  They are provided as legacy scripts when
---enable-compat-utils is specified at build time.
-
-ibcheckerrors, ibclearcounters, ibclearerrors, ibdatacounters
-ibchecknet, ibchecknode, ibcheckport, ibcheckportstate,
-ibcheckportwidth, ibcheckstate, ibcheckwidth, ibswportwatch,
-ibprintca, ibprintrt, ibprintswitch
-
-
-.SH AUTHORS
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
