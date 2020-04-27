Return-Path: <SRS0=rh+6=6L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B80CC7C860
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48C4A2064C
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Apr 2020 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588002532;
	bh=p235Q6jGtFWNRY0Cy+Dx1Q4L/bYZNrrkkRWL/l/rctQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=keO8zrIheBpJslLu3nbyXv4IlUhNacn6rUaon80vVuNgngVJOaEOZbDDHmLC6Q7bP
	 N3y1sivQ7BEw6XbjtTjt16F9ox6ytNpuJ/pvusKM71zmwlZfMfgS8ucLTE3m8YNmrY
	 6zw+pmNjLCWrfB1iK+0SZIKXzB7uOeP8HdgWCsO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgD0Psv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgD0Psu (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 27 Apr 2020 11:48:50 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61BD6206B6;
        Mon, 27 Apr 2020 15:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588002530;
        bh=p235Q6jGtFWNRY0Cy+Dx1Q4L/bYZNrrkkRWL/l/rctQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJFbSc+63KsdxLg1ppn6mD5yMLuE+rqr/FdYRYRGrSf1GhIkdveUvVCB3Pc/a91Q6
         KQnrHzaJEbe4l6ZpeYk8kZUPJDsXKrz0FaekJmnR4lj8jkxafVUPbGAoB4yTOEL2Ba
         PFuykQkcM5Y2DxZbHfVZM3j5HW/aIztTAleieVLk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH rdma-next v1 32/36] RDMA/mlx5: Handle udate outlen checks in one place
Date:   Mon, 27 Apr 2020 18:46:32 +0300
Message-Id: <20200427154636.381474-33-leon@kernel.org>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200427154636.381474-1-leon@kernel.org>
References: <20200427154636.381474-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Place in one function all udata size checks. This will allow
us move ib_copy_to_udata() in general place and ensure that
it will be performed after call to the FW.

Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 48 ++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8daa8bc6b9c7..0d06706e6ce1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1613,6 +1613,7 @@ static void destroy_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *q
 struct mlx5_create_qp_params {
 	struct ib_udata *udata;
 	size_t inlen;
+	size_t outlen;
 	void *ucmd;
 	u8 is_rss_raw : 1;
 	struct ib_qp_init_attr *attr;
@@ -1638,15 +1639,9 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	void *hfso;
 	u32 selected_fields = 0;
 	u32 outer_l4;
-	size_t min_resp_len;
 	u32 tdn = mucontext->tdn;
 	u8 lb_flag = 0;
 
-	min_resp_len =
-		offsetof(typeof(resp), bfreg_index) + sizeof(resp.bfreg_index);
-	if (udata->outlen < min_resp_len)
-		return -EINVAL;
-
 	if (ucmd->comp_mask) {
 		mlx5_ib_dbg(dev, "invalid comp mask\n");
 		return -EOPNOTSUPP;
@@ -2780,26 +2775,43 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return (create_flags) ? -EINVAL : 0;
 }
 
-static size_t process_udata_size(struct ib_qp_init_attr *attr,
-				 struct ib_udata *udata)
+static int process_udata_size(struct mlx5_ib_dev *dev,
+			      struct mlx5_create_qp_params *params)
 {
 	size_t ucmd = sizeof(struct mlx5_ib_create_qp);
+	struct ib_qp_init_attr *attr = params->attr;
+	struct ib_udata *udata = params->udata;
+	size_t outlen = udata->outlen;
 	size_t inlen = udata->inlen;
 
-	if (attr->qp_type == IB_QPT_DRIVER)
-		return (inlen < ucmd) ? 0 : ucmd;
+	params->outlen = min(outlen, sizeof(struct mlx5_ib_create_qp_resp));
+	if (attr->qp_type == IB_QPT_DRIVER) {
+		params->inlen = (inlen < ucmd) ? 0 : ucmd;
+		goto out;
+	}
 
-	if (!attr->rwq_ind_tbl)
-		return ucmd;
+	if (!params->is_rss_raw) {
+		params->inlen = ucmd;
+		goto out;
+	}
 
+	/* RSS RAW QP */
 	if (inlen < offsetofend(struct mlx5_ib_create_qp_rss, flags))
-		return 0;
+		return -EINVAL;
+
+	if (outlen < offsetofend(struct mlx5_ib_create_qp_resp, bfreg_index))
+		return -EINVAL;
 
 	ucmd = sizeof(struct mlx5_ib_create_qp_rss);
 	if (inlen > ucmd && !ib_is_udata_cleared(udata, ucmd, inlen - ucmd))
-		return 0;
+		return -EINVAL;
+
+	params->inlen = min(ucmd, inlen);
+out:
+	if (!params->inlen)
+		mlx5_ib_dbg(dev, "udata is too small or not cleared\n");
 
-	return min(ucmd, inlen);
+	return (params->inlen) ? 0 : -EINVAL;
 }
 
 static int create_raw_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
@@ -2883,9 +2895,9 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attr,
 	params.is_rss_raw = !!attr->rwq_ind_tbl;
 
 	if (udata) {
-		params.inlen = process_udata_size(attr, udata);
-		if (!params.inlen)
-			return ERR_PTR(-EINVAL);
+		err = process_udata_size(dev, &params);
+		if (err)
+			return ERR_PTR(err);
 
 		params.ucmd = kzalloc(params.inlen, GFP_KERNEL);
 		if (!params.ucmd)
-- 
2.25.3

