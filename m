From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 2/3] cbuild: support .tar.(gz|bz|>...) extensions
Date: Fri, 4 Aug 2017 18:59:04 +0200
Message-ID: <8fac95c5-7469-e780-a167-6015a4a0e490@suse.de>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27366048-d80f-3711-c6cd-93c87809650e-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/cbuild | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index efc039bf..5228ec1b 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -420,7 +420,7 @@ def run_rpm_build(args,spec_file,env):
         os.mkdir(os.path.join(tmpdir,"tmp"));
 
         subprocess.check_call(["git","archive",
-                               "--prefix","%s/"%(os.path.splitext(tarfn)[0]),
+                               "--prefix","%s/"%(os.path.splitext(os.path.splitext(tarfn)[0])[0]),
                                "--output",os.path.join(tmpdir,"SOURCES",tarfn),
                                "HEAD"]);
 
-- 
2.14.0.rc1.4.gab083fa77.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
