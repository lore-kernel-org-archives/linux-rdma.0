From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/10] DAPL v2.0: common: add supported collective types in
 named attributes for query
Date: Thu, 11 Aug 2011 00:42:03 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B4B@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index 5076df8..29fc12f 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -591,6 +591,26 @@ DAT_NAMED_ATTR ib_attrs[] = {
 	{
 	 DAT_IB_ATTR_IMMED_DATA, "TRUE"}
 	,
+#ifdef DAT_IB_COLLECTIVES
+	{
+	 DAT_IB_COLL_BARRIER, "TRUE"}
+	,
+	{
+	 DAT_IB_COLL_BROADCAST, "TRUE"}
+	,
+	{
+	 DAT_IB_COLL_REDUCE, "TRUE"}
+	,
+	{
+	 DAT_IB_COLL_ALLREDUCE, "TRUE"}
+	,
+	{
+	 DAT_IB_COLL_ALLGATHER, "TRUE"}
+	,
+	{
+	 DAT_IB_COLL_ALLGATHERV, "TRUE"}
+	,
+#endif /* DAT_IB_COLLECTIVES */
 #ifndef _OPENIB_CMA_
 	{
 	 DAT_IB_ATTR_UD, "TRUE"}
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
