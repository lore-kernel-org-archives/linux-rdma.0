From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/4] crd_read_line(): Rework code to suppress a compiler
 warning
Date: Sun, 29 Nov 2015 11:45:09 -0800
Message-ID: <565B55C5.9040006@sandisk.com>
References: <565B553C.6020005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565B553C.6020005-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that gcc prints a warning about not checking the result of fgets().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 mstdump/crd_lib/crdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mstdump/crd_lib/crdump.c b/mstdump/crd_lib/crdump.c
index 451a944..3e3c4bc 100755
--- a/mstdump/crd_lib/crdump.c
+++ b/mstdump/crd_lib/crdump.c
@@ -504,8 +504,8 @@ static int crd_read_line(IN FILE *fd, OUT char *tmp) {
         if (!feof(fd)) {
             int c = fgetc(fd);
             if (c == '#') {
-                char* _ptr=fgets (tmp, 300, fd);
-                (void)_ptr;//avoid warning
+                if (fgets(tmp, 300, fd)) {
+                }
                 tmp[0] = 0;
                 continue;
             }
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
