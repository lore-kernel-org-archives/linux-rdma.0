From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 1/3] cbuild: allow indentation in RPM version
Date: Fri, 4 Aug 2017 18:58:58 +0200
Message-ID: <f27834a4-9265-2cda-f77e-7051d3322b71@suse.de>
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

Fix support for:
Version:      <id>
with multiple spaces

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 buildlib/cbuild | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/buildlib/cbuild b/buildlib/cbuild
index 888fae6c..efc039bf 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -407,11 +407,11 @@ def run_rpm_build(args,spec_file,env):
     with open(spec_file,"r") as F:
         for ln in F:
             if ln.startswith("Version:"):
-                ver = ln.strip().partition(' ')[2];
+                ver = ln.strip().partition(' ')[2].strip();
                 assert(ver == get_version());
 
             if ln.startswith("Source:"):
-                tarfn = ln.strip().partition(' ')[2];
+                tarfn = ln.strip().partition(' ')[2].strip();
     tarfn = tarfn.replace("%{version}",version);
 
     image_id = get_image_id(args,env.image_name());
-- 
2.14.0.rc1.4.gab083fa77.dirty


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
