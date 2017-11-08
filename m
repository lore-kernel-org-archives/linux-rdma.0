From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 3/4] cbuild: disable curl-mini usage for tumbleweed
 env
Date: Wed, 8 Nov 2017 15:31:27 +0100
Message-ID: <9199caee-e7a3-07dc-76b3-6e075336c725@suse.de>
References: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/cbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index eb5349de..32bb70df 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -322,6 +322,7 @@ class tumbleweed(ZypperEnvironment):
     pkgs = leap.pkgs;
     name = "tumbleweed";
     specfile = "suse/rdma-core.spec";
+    rpmbuild_options = [ "--without=curlmini" ];
 
 # -------------------------------------------------------------------------
 
-- 
2.14.1.461.g503560879


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
