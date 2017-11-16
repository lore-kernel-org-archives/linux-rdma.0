From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 4/5] buildlib: run ABI check in travis-build
Date: Thu, 16 Nov 2017 18:37:45 +0100
Message-ID: <32023a04-4964-952e-812e-6eb9fd2a8a14@suse.com>
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

Run travis-checkabi during travis build

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
---
 buildlib/travis-build | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/buildlib/travis-build b/buildlib/travis-build
index bf86baa7..f8e5ee05 100755
--- a/buildlib/travis-build
+++ b/buildlib/travis-build
@@ -5,6 +5,10 @@ set -e
 # Echo all commands to Travis log
 set -x
 
+
+# Build in debug mode and check the ABI against the ref
+./buildlib/travis-checkabi
+
 mkdir build-clang build32 build-sparse build-aarch64
 
 # Build with latest clang first
-- 
2.15.0.168.g9a51f1b30.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
