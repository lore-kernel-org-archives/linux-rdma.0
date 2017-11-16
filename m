From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 2/5] buildlib: add script to dump ABI
Date: Thu, 16 Nov 2017 18:37:39 +0100
Message-ID: <676022a1-13da-efd7-d73c-96a2a93e1188@suse.com>
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

Builds rdma-core in -Og/Debug mode and use abi-dumper to generate 1 xml
 per .so.*.* file.
Do not use .so file directly. Providers have no symbol exported
 and cause abi-dumer to exit with an error.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
---
 buildlib/gen-abi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100755 buildlib/gen-abi

diff --git a/buildlib/gen-abi b/buildlib/gen-abi
new file mode 100755
index 00000000..f551aa96
--- /dev/null
+++ b/buildlib/gen-abi
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# Stop on error
+set -e
+# Echo all commands to Travis log
+set -x
+
+# Force submodule checkout of the needed tools
+git submodule update --init --force
+
+mkdir build-abi
+cd build-abi
+CFLAGS="-g -Og" cmake -GNinja -DCMAKE_BUILD_TYPE=Debug ..
+ninja
+
+mkdir ABI
+for FILE in $(find lib -name "*.so.*.*"); do
+	LIB=$(basename $FILE)
+	MODULE_VER=$(echo $LIB | sed -e 's/.*.so\.\(.*\)/\1/')
+	../buildlib/abi-dumper/abi-dumper.pl  -lver $MODULE_VER $FILE -o ABI/$LIB.dump
+done
-- 
2.15.0.168.g9a51f1b30.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
