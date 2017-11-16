From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 1/5] buidlib: import abi checking tools
Date: Thu, 16 Nov 2017 18:37:35 +0100
Message-ID: <a5f1ce1a-aa0d-e0ec-2701-97325bedca6b@suse.com>
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

Add submodules for abi-dumper  v1.1 and abi-compliance-checker v2.2

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 .gitmodules                     | 6 ++++++
 buildlib/abi-compliance-checker | 1 +
 buildlib/abi-dumper             | 1 +
 3 files changed, 8 insertions(+)
 create mode 100644 .gitmodules
 create mode 160000 buildlib/abi-compliance-checker
 create mode 160000 buildlib/abi-dumper

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 00000000..b195afc3
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,6 @@
+[submodule "buildlib/abi-dumper"]
+	path = buildlib/abi-dumper
+	url = https://github.com/lvc/abi-dumper.git
+[submodule "buildlib/abi-compliance-checker"]
+	path = buildlib/abi-compliance-checker
+	url = https://github.com/lvc/abi-compliance-checker.git
diff --git a/buildlib/abi-compliance-checker b/buildlib/abi-compliance-checker
new file mode 160000
index 00000000..e3db9ec3
--- /dev/null
+++ b/buildlib/abi-compliance-checker
@@ -0,0 +1 @@
+Subproject commit e3db9ec34127d0a4f109cc4923e191b0822a0e51
diff --git a/buildlib/abi-dumper b/buildlib/abi-dumper
new file mode 160000
index 00000000..000c4cf9
--- /dev/null
+++ b/buildlib/abi-dumper
@@ -0,0 +1 @@
+Subproject commit 000c4cf9d20f4f671c4099bcba8ebe3052fe3e1a
-- 
2.15.0.168.g9a51f1b30.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
