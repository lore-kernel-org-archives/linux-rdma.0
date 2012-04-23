From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/15] uDAPL v2.0 config: clean up help option displays with
 ext-type options
Date: Mon, 23 Apr 2012 20:01:16 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F9481202C5@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use AS_HELP_STRING to format help text

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.in |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/configure.in b/configure.in
index d577525..832574f 100644
--- a/configure.in
+++ b/configure.in
@@ -116,8 +116,8 @@ AC_ARG_ENABLE([counters],
 AM_CONDITIONAL(DEFINE_COUNTERS, test x$counters = xtrue)
 
 dnl Support ib_extension build - if enable-ext-type == ib 
-AC_ARG_ENABLE(ext-type,
-[  --enable-ext-type Enable extensions support for library: ib, none, default=ib],
+AC_ARG_ENABLE([ext-type],
+ AS_HELP_STRING([--enable-ext-type],[enable extensions support for library: ib, none, default=ib]),
  [ if   test "x$enableval" = "xib" ; then
       ext_type=ib
    elif test "x$enableval" = "xnone" ; then
@@ -132,8 +132,8 @@ AC_ARG_ENABLE(ext-type,
 AM_CONDITIONAL(EXT_TYPE_IB, test "$ext_type" = "ib")
 
 dnl Support IB MPI collective extension build - if enable-coll-type == vendor_name 
-AC_ARG_ENABLE(coll-type,
-[  --enable-coll-type Enable IB collective support: fca, none, default=fca],
+AC_ARG_ENABLE([coll-type],
+ AS_HELP_STRING([--enable-coll-type],[enable IB collective support: fca, none, default=fca]),
  [ if   test "x$enableval" = "xfca" ; then
       coll_type=fca
       AC_CHECK_HEADER(fca/fca_api.h, [],
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
