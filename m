Return-Path: <SRS0=rwkM=WY=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191D4C3A5A1
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Aug 2019 07:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B9122CF5
	for <linux-rdma@archiver.kernel.org>; Wed, 28 Aug 2019 07:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GSjT8XvT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfH1Hmc (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 28 Aug 2019 03:42:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfH1Hmb (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 28 Aug 2019 03:42:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7S7d1ij130564;
        Wed, 28 Aug 2019 07:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=ArCRU73PllDIDfmFxhcXkjDLse/oco09lJ8r/w0jCBc=;
 b=GSjT8XvTtBMrnlV42nzijeEd2rIlX3wNyqa4GnALWqvC4aQDJqtCjxOp/Ue/eov4SiQe
 nWCr3F6ywb8UYK+D9mUZBXK+y49kPszxlOeNpmE51fPbRlLi/SZTqcVnp5Yv97LrzpuY
 UeRVv9/VXGfH3wr26W4piWjnBL34r8ZxgN8R+VrCs8XdvKf58XtVj+a0985nrJUwYnTB
 7TaY+dBRmmI9h6QbQf4WT8I2EdbF1v6/6ZfiCCMcYQpM1LP+nMfCgk01k1+l+OGReXRm
 kWcbozMBpoX9R7PKDpiqAwRKCj/RrSnNTNTh2Sq3fmMw+Gf74yj3V2Q+55AF1XeInsZa Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2unnbhg197-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 07:41:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7S7cZWD123373;
        Wed, 28 Aug 2019 07:41:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2un5rkpda8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 07:41:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7S7fngb016393;
        Wed, 28 Aug 2019 07:41:49 GMT
Received: from host5.lan (/77.138.183.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 00:41:48 -0700
From:   Yuval Shaia <yuval.shaia@oracle.com>
To:     dledford@redhat.com, jgg@ziepe.ca, oulijun@huawei.com,
        xavier.huwei@huawei.com, leon@kernel.org, majd@mellanox.com,
        markz@mellanox.com, swise@opengridcomputing.com,
        galpress@amazon.com, monis@mellanox.com, israelr@mellanox.com,
        maxg@mellanox.com, dan.carpenter@oracle.com, kamalheib1@gmail.com,
        yuval.shaia@oracle.com, denisd@mellanox.com, yuvalav@mellanox.com,
        dennis.dalessandro@intel.com, ereza@mellanox.com, will@kernel.org,
        linux-rdma@vger.kernel.org, jgg@mellanox.com, srabinov7@gmail.com,
        santosh.shilimkar@oracle.com
Subject: [PATCH 0/4] Take out ucontext from HW objects
Date:   Wed, 28 Aug 2019 10:41:30 +0300
Message-Id: <20190828074134.17042-1-yuval.shaia@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=641
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=701 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280080
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

This patch-set, originaly part of Shared PD & MR patch-set, intend to take
out the field ucontext from the HW objects ib_pd and ib_mr.

Shamir Rabinovitch (3):
  RDMA/uverbs: uobj_get_obj_read should return the ib_uobject
  RDMA/uverbs: Delete the macro uobj_put_obj_read
  IB/{core,hw}: ib_pd should not have ib_uobject pointer

Yuval Shaia (1):
  IB/core: ib_mr should not have ib_uobject pointer

 drivers/infiniband/core/uverbs_cmd.c          | 219 +++++++++++-------
 drivers/infiniband/core/uverbs_std_types_mr.c |   1 -
 drivers/infiniband/core/verbs.c               |   4 -
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c    |   1 -
 drivers/infiniband/hw/mlx5/main.c             |   1 -
 drivers/infiniband/hw/mthca/mthca_qp.c        |   3 +-
 include/rdma/ib_verbs.h                       |   2 -
 include/rdma/uverbs_std_types.h               |  11 +-
 8 files changed, 146 insertions(+), 96 deletions(-)

-- 
2.20.1

