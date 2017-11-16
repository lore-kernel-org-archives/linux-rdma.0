From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 3/5] buildlib: add script to check ABI
Date: Thu, 16 Nov 2017 18:37:42 +0100
Message-ID: <650efc8a-608f-016e-81b6-93e2ebdf5a4b@suse.com>
References: <551ccda1-bb8d-45bf-1c7c-22a82fc64efc@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551ccda1-bb8d-45bf-1c7c-22a82fc64efc-IBi9RG/b67k@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add travis-checkabi which generates a dump of all rdma-core libraries
ABI and checks them against a ref if they exists.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
---
 buildlib/travis-checkabi | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100755 buildlib/travis-checkabi

diff --git a/buildlib/travis-checkabi b/buildlib/travis-checkabi
new file mode 100755
index 00000000..bbd12b64
--- /dev/null
+++ b/buildlib/travis-checkabi
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# Stop on error
+set -e
+# Echo all commands to Travis log
+set -x
+
+REF_DIR=buildlib/ABI
+NEW_DIR=build-abi/ABI
+
+# No reference ABI to match against.
+if [ ! -d $REF_DIR ]; then
+	echo "INFO: Skipping ABI check. No reference available"
+	exit 0
+fi
+
+./buildlib/gen-abi
+
+# Current ABI not available !
+if [ ! -d $NEW_DIR ]; then
+	echo "ERROR: Missing ABI description files" >&2
+	exit 1
+fi
+
+for FILE in $(find $NEW_DIR -name "*.dump"); do
+	DUMP=$(basename $FILE)
+	LIBNAME=$(echo $DUMP | sed -e 's/\(.*\).so.*/\1/')
+	./buildlib/abi-compliance-checker/abi-compliance-checker.pl -l $LIBNAME -old $REF_DIR/$DUMP -new $NEW_DIR/$DUMP
+done
-- 
2.15.0.168.g9a51f1b30.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
