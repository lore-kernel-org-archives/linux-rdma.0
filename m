From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] rxe: Use default dual-license instead of PathScale
Date: Thu,  3 Nov 2016 17:49:15 +0200
Message-ID: <1478188155-24018-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the patent clauses from RXE copyright notice.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 COPYING.md          | 5 -----
 providers/rxe/rxe.c | 4 ----
 providers/rxe/rxe.h | 4 ----
 3 files changed, 13 deletions(-)

diff --git a/COPYING.md b/COPYING.md
index 3d55eb9..3d34648 100644
--- a/COPYING.md
+++ b/COPYING.md
@@ -45,11 +45,6 @@ ipathverbs
 ocrdma
 : Dual License: GPLv2 or OpenIB.org BSD (FreeBSD variant), See COPYING.BSD_FB

-rxe
-: A combination of the
-    - Default Dual License
-    - GPLv2 or PathScale BSD Patent license
-
 ## Libraries

 All library compilable source code (.c and .h files) are available under the
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 5aa77ea..d23ef3d 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -31,10 +31,6 @@
  * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
- *
- * Patent licenses, if any, provided herein do not apply to
- * combinations of this program with other software, or any other
- * product whatsoever.
  */

 #include <config.h>
diff --git a/providers/rxe/rxe.h b/providers/rxe/rxe.h
index 61383a3..0a67a81 100644
--- a/providers/rxe/rxe.h
+++ b/providers/rxe/rxe.h
@@ -31,10 +31,6 @@
  * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
- *
- * Patent licenses, if any, provided herein do not apply to
- * combinations of this program with other software, or any other
- * product whatsoever.
  */

 #ifndef RXE_H
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
