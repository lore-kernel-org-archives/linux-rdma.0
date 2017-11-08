From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 2/4] cbuild: allow envs to pass custom options to
 rpmbuild
Date: Wed, 8 Nov 2017 15:31:24 +0100
Message-ID: <1ab960a4-a747-6e3e-17f3-a5f5c41b3669@suse.de>
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
 buildlib/cbuild | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index e6a64e8a..eb5349de 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -474,7 +474,8 @@ os.symlink({tarfn!r},os.path.join("SOURCES",tarfn));
            tarfn=tarfn,
            tspec_file=tspec_file);
 
-            bopts = ["-bb",tspec_file];
+            extra_opts = getattr(env,"rpmbuild_options", [])
+            bopts = ["-bb",tspec_file] + extra_opts;
 
             print >> F,'os.execlp("rpmbuild","rpmbuild",%s)'%(
                 ",".join(repr(I) for I in bopts));
-- 
2.14.1.461.g503560879


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
