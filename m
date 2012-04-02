From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] libmlx4: Fix a compiler warning
Date: Mon, 02 Apr 2012 15:56:55 +0000
Message-ID: <4F79CC47.5020203@acm.org>
References: <201110101947.34035.bvanassche@acm.org> <CAL1RGDVNoh1Fdm5pvDaeB9YykRpfXMe-s+P_iHs=8Z_r5_DpBQ@mail.gmail.com> <4F78A7F2.7020903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F78A7F2.7020903-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/01/12 19:09, Bart Van Assche wrote:

> On 10/11/11 00:41, Roland Dreier wrote:
>> On Mon, Oct 10, 2011 at 10:47 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>>> -       uint32_t hi = *(uint32_t *)(gid->raw);
>>> -       uint32_t lo = *(uint32_t *)(gid->raw + 4);
>>> -       if (hi == htonl(0xfe800000) && lo == 0)
>>> -               return 1;
>>> +       uint32_t hi = gid->u32[0];
>>> +       uint32_t lo = gid->u32[1];
>>
>> Thanks, however I like to keep libmlx4 backwards compatible
>> if possible.  So we can't do this unconditionally.
> 
> How about the patch below ?


Sorry, but the patch I sent yesterday was wrong. Please replace by the patch below:

[PATCH] libmlx4: Fix a compiler warning

Avoid that link_local_gid() triggers the following compiler warning:
dereferencing type-punned pointer will break strict-aliasing rules

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 configure.in |    9 +++++++++
 src/verbs.c  |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 8aad5ff..eeb4430 100644
--- a/configure.in
+++ b/configure.in
@@ -63,6 +63,15 @@ AM_CONDITIONAL(HAVE_IBV_DEVICE_LIBRARY_EXTENSION,
     test $IBV_DEVICE_LIBRARY_EXTENSION != IBV_DEVICE_LIBRARY_EXTENSION)
 AC_SUBST(IBV_DEVICE_LIBRARY_EXTENSION)
 
+# Check whether ibv_gid has a member called u32.
+
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <infiniband/verbs.h>]],
+                                   [[union ibv_gid g; return sizeof(g.u32);]])],
+                  [AC_DEFINE([HAVE_IBV_GID_U32],
+                             [1],
+                             [Define to 1 if ibv_gid has a member called u32.])
+                  ])
+
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     [if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
         ac_cv_version_script=yes
diff --git a/src/verbs.c b/src/verbs.c
index 408fc6d..b52f799 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -624,8 +624,13 @@ int mlx4_destroy_qp(struct ibv_qp *ibqp)
 
 static int link_local_gid(const union ibv_gid *gid)
 {
+#ifdef HAVE_IBV_GID_U32
+	uint32_t hi = gid->u32[0];
+	uint32_t lo = gid->u32[1];
+#else
 	uint32_t hi = *(uint32_t *)(gid->raw);
 	uint32_t lo = *(uint32_t *)(gid->raw + 4);
+#endif
 	if (hi == htonl(0xfe800000) && lo == 0)
 		return 1;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
