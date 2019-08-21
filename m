Return-Path: <SRS0=E+a+=WR=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3EAC3A5A0
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 14:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21AEA233A2
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Aug 2019 14:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/zvsYF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfHUOWp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:22:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHUOWp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 21 Aug 2019 10:22:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LEEGqM063028;
        Wed, 21 Aug 2019 14:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ybhLgSGVLJ67m4QDxTOeSAqQDsQJq+m/uygR3hR2iRA=;
 b=Z/zvsYF2RdvlbLwWUmW/hMr4V4beXwEWTm/2Pg/cYIhJ9tbya0mIZdN8vwrAUW7xxtxg
 EGcfgfqkL4j/+k14ReoCNqx1gJOVFWB9HWSqN5ogZ9CWFrYJQhya454ofWYK8Dnbzuz6
 /m5lZV5G76Sf8USjh1ksKtVZuGclIBVts0hZs3363C5zxQHCyBD8Zi0kGcomIUOw/7sm
 wnXZ8mrs/2LP9RaIhO1Rdwxhsvtido+06bIqvP4akRyho8h2XMMpz+QS9nVCASc4JOxs
 OWxmoE5c+stpjMy5mS26Qx6tihnlTohDWMRW8ZvFutL9n4nCF77UtqjbmbfwBx1pKqro jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ue90tp3tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 14:22:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7LEIaa2094365;
        Wed, 21 Aug 2019 14:22:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ugj7py818-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 14:22:17 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7LEMFLT014800;
        Wed, 21 Aug 2019 14:22:15 GMT
Received: from host5.lan (/77.138.183.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Aug 2019 07:22:15 -0700
From:   Yuval Shaia <yuval.shaia@oracle.com>
To:     dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        monis@mellanox.com, parav@mellanox.com, danielj@mellanox.com,
        kamalheib1@gmail.com, markz@mellanox.com,
        swise@opengridcomputing.com, shamir.rabinovitch@oracle.com,
        johannes.berg@intel.com, willy@infradead.org,
        michaelgur@mellanox.com, markb@mellanox.com,
        yuval.shaia@oracle.com, dan.carpenter@oracle.com,
        bvanassche@acm.org, maxg@mellanox.com, israelr@mellanox.com,
        galpress@amazon.com, denisd@mellanox.com, yuvalav@mellanox.com,
        dennis.dalessandro@intel.com, will@kernel.org, ereza@mellanox.com,
        jgg@mellanox.com, linux-rdma@vger.kernel.org
Cc:     Shamir Rabinovitch <srabinov7@gmail.com>
Subject: [PATCH v1 06/24] IB/uverbs: Helper function to initialize ufile member of uverbs_attr_bundle
Date:   Wed, 21 Aug 2019 17:21:07 +0300
Message-Id: <20190821142125.5706-7-yuval.shaia@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190821142125.5706-1-yuval.shaia@oracle.com>
References: <20190821142125.5706-1-yuval.shaia@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908210157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908210157
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>

Helper function to initialize ufile member of structure uverbs_attr_bundle.

This helper produce structure uverbs_attr_bundle that is safe for the below
operations on the given ufile:

- uobj_get_[read|write]
- uobj_alloc_commit
- uobj_alloc_abort

The last 2 ops are more complicated. Abort for example triggers the
below which pass the uverbs_attr_bundle driver_udata down to the
drivers level:

uobj_alloc_abort
 rdma_alloc_abort_uobject
  uverbs_destroy_uobject
   uobj->uapi_object->type_class->destroy_hw
    destroy_hw_idr_uobject
     idr_type->destroy_object
      uverbs_free_pd
       ib_dealloc_pd_user
        pd->device->ops.dealloc_pd
	 mlx4_ib_dealloc_pd

For more information about the potential issues, please see
commit f89adedaf3fe ("RDMA/uverbs: Initialize udata struct
on destroy flows")

Cc: Gal Pressman <galpress@amazon.com>
Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Signed-off-by: Shamir Rabinovitch <srabinov7@gmail.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d1f0c04f0ae8..4f42f9732dca 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3773,6 +3773,24 @@ static int ib_uverbs_ex_modify_cq(struct uverbs_attr_bundle *attrs)
 	return ret;
 }
 
+/**
+ * uverbs_init_attrs_ufile - Helper function to create minimal
+ * uverbs_attr_bundle out of ib_uverbs_file that is suitable
+ * for the below operations:
+ *
+ * - uobj_get_[read|write]
+ * - uobj_alloc_commit
+ * - uobj_alloc_abort
+ */
+static void uverbs_init_attrs_ufile(struct uverbs_attr_bundle *attrs_bundle,
+				    struct ib_uverbs_file *ufile)
+{
+	*attrs_bundle = (struct uverbs_attr_bundle) {
+		.ufile = ufile,
+		.context = ufile->ucontext,
+	};
+}
+
 /*
  * Describe the input structs for write(). Some write methods have an input
  * only struct, most have an input and output. If the struct has an output then
-- 
2.20.1

