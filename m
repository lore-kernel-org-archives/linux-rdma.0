From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/infiniband-diags] The shell scripts use bashism, so use
 bash directly.
Date: Mon, 14 Feb 2011 11:36:13 -0700
Message-ID: <20110214183613.GA21158@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Otherwise it blows up on distributions that don't use bash as /bin/sh,
like Debian and Ubuntu. One could probably just remove the bashisms, but
that is much harder.

An example error is:
ibswitches: 5: Syntax error: "(" unexpected

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 scripts/dump_lfts.sh        |    2 +-
 scripts/dump_mfts.sh        |    2 +-
 scripts/ibcheckerrors.in    |    2 +-
 scripts/ibcheckerrs.in      |    2 +-
 scripts/ibchecknet.in       |    2 +-
 scripts/ibchecknode.in      |    2 +-
 scripts/ibcheckport.in      |    2 +-
 scripts/ibcheckportstate.in |    2 +-
 scripts/ibcheckportwidth.in |    2 +-
 scripts/ibcheckstate.in     |    2 +-
 scripts/ibcheckwidth.in     |    2 +-
 scripts/ibclearcounters.in  |    2 +-
 scripts/ibclearerrors.in    |    2 +-
 scripts/ibdatacounters.in   |    2 +-
 scripts/ibdatacounts.in     |    2 +-
 scripts/ibhosts.in          |    2 +-
 scripts/ibnodes.in          |    2 +-
 scripts/ibrouters.in        |    2 +-
 scripts/ibstatus            |    2 +-
 scripts/ibswitches.in       |    2 +-
 scripts/set_nodedesc.sh     |    2 +-
 21 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/scripts/dump_lfts.sh b/scripts/dump_lfts.sh
index a07c211..0bf334d 100755
--- a/scripts/dump_lfts.sh
+++ b/scripts/dump_lfts.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # This simple script will collect outputs of ibroute for all switches
 # on the subnet and drop it on stdout. It can be used for LFTs dump
diff --git a/scripts/dump_mfts.sh b/scripts/dump_mfts.sh
index cdadba2..d6c2359 100755
--- a/scripts/dump_mfts.sh
+++ b/scripts/dump_mfts.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # This simple script will collect outputs of ibroute for all switches
 # on the subnet and drop it on stdout. It can be used for MFTs dump
diff --git a/scripts/ibcheckerrors.in b/scripts/ibcheckerrors.in
index a45bd63..fef503c 100644
--- a/scripts/ibcheckerrors.in
+++ b/scripts/ibcheckerrors.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckerrs.in b/scripts/ibcheckerrs.in
index 6052ff8..4db0929 100644
--- a/scripts/ibcheckerrs.in
+++ b/scripts/ibcheckerrs.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibchecknet.in b/scripts/ibchecknet.in
index 6447835..a6d5b1a 100644
--- a/scripts/ibchecknet.in
+++ b/scripts/ibchecknet.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibchecknode.in b/scripts/ibchecknode.in
index 5eea7b5..d105430 100644
--- a/scripts/ibchecknode.in
+++ b/scripts/ibchecknode.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckport.in b/scripts/ibcheckport.in
index fa5e81e..a786e9f 100644
--- a/scripts/ibcheckport.in
+++ b/scripts/ibcheckport.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckportstate.in b/scripts/ibcheckportstate.in
index dc4fb14..549d427 100644
--- a/scripts/ibcheckportstate.in
+++ b/scripts/ibcheckportstate.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckportwidth.in b/scripts/ibcheckportwidth.in
index 60a0892..3b387be 100644
--- a/scripts/ibcheckportwidth.in
+++ b/scripts/ibcheckportwidth.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckstate.in b/scripts/ibcheckstate.in
index 63551d5..78359d8 100644
--- a/scripts/ibcheckstate.in
+++ b/scripts/ibcheckstate.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibcheckwidth.in b/scripts/ibcheckwidth.in
index cbb154c..49e8d1d 100644
--- a/scripts/ibcheckwidth.in
+++ b/scripts/ibcheckwidth.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibclearcounters.in b/scripts/ibclearcounters.in
index 86a5528..429018a 100644
--- a/scripts/ibclearcounters.in
+++ b/scripts/ibclearcounters.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibclearerrors.in b/scripts/ibclearerrors.in
index 3dfb96b..f7f1ccc 100644
--- a/scripts/ibclearerrors.in
+++ b/scripts/ibclearerrors.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibdatacounters.in b/scripts/ibdatacounters.in
index 5967406..1abaaf2 100644
--- a/scripts/ibdatacounters.in
+++ b/scripts/ibdatacounters.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibdatacounts.in b/scripts/ibdatacounts.in
index 3dbc56a..a9e94c0 100644
--- a/scripts/ibdatacounts.in
+++ b/scripts/ibdatacounts.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibhosts.in b/scripts/ibhosts.in
index baba105..08b2f83 100644
--- a/scripts/ibhosts.in
+++ b/scripts/ibhosts.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibnodes.in b/scripts/ibnodes.in
index 5871da8..0726efc 100644
--- a/scripts/ibnodes.in
+++ b/scripts/ibnodes.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibrouters.in b/scripts/ibrouters.in
index 6404aca..97769db 100644
--- a/scripts/ibrouters.in
+++ b/scripts/ibrouters.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/ibstatus b/scripts/ibstatus
index f7fbbc2..6f01be0 100755
--- a/scripts/ibstatus
+++ b/scripts/ibstatus
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # Usage ibstatus [devname[:port]]
 
diff --git a/scripts/ibswitches.in b/scripts/ibswitches.in
index 163620a..fff4468 100644
--- a/scripts/ibswitches.in
+++ b/scripts/ibswitches.in
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 IBPATH=${IBPATH:-@IBSCRIPTPATH@}
 
diff --git a/scripts/set_nodedesc.sh b/scripts/set_nodedesc.sh
index 855ced7..4ec0c43 100755
--- a/scripts/set_nodedesc.sh
+++ b/scripts/set_nodedesc.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 if [ -f /etc/sysconfig/network ]; then
 . /etc/sysconfig/network
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
