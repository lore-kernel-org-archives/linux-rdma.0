Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30133A75A6
	for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781190759; cv=none; b=OwSsDNhzRXMU7LrS8X3kK1OYK0qpGK3RAjSw/KaJ6BYAf+tXYy4jFsXDgc8GVRacj5q8Y9/09UI9oap/oStGd2zD/RzQyzYQmlIPGpEQ1cH4s2daTFORN9yg9zRqLtCVxkAIjCDJTMF5hOgJ1gSwR9fwQq1EeHJgO1iOOMyFwlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781190759; c=relaxed/simple;
	bh=Rn/ufL0hqyC5Vey8BQji5BJZm+oRSTxXo98e6B2TtVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5zY2P4CC2DcJfG33GaYGxYsrYxbUVhKM5VuGUbevAsBoBUKCiPAmGLFTjaHVR7TpmS6g6Jgrx+5CQPHXiaHNbP4+vvrxUaWzu377Nh2WZ4Qp1/YyD6dcuNP+yt7omktEDhv13346ZMvjViiGS/vBKAJM5eD17qEGRN71leHIcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=q7nr0rxW; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="q7nr0rxW"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b8a97b11so90798305e9.0
        for <linux-rdma@vger.kernel.org>; Thu, 11 Jun 2026 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1781190756; x=1781795556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjquPjnSxlH1NouQC11hdL93bCB5PiSU+rHY36k2irI=;
        b=q7nr0rxW/pdN9nIRUJsZrPWCgxadhZup1kYLbdZUpXcKQKaFjT6KADP6YRjp5jJJzh
         8XtG8McwB2ldZx7rhwvNaRW3uimvnRaBc2EGUu8CKPZIqHSSrO++p1QkNJbp3+SkbY6o
         ZX3coH1fR1zP4zw9bk/YufPzhc1JnabqGKE9X8zsgTzWyniflx8B+bbR2D9C9Ew6dumk
         qUdODaSFNOphJJUIDMS1QcK04IjXlWvWTZgqjO4b8Efuj0CXii3gjW8ukn29hVTuBZi2
         +N7z2KzhG4SH9tiXagv47Q8WYxVAAsZGbCi12/OMr+tKso2bHuuPyA/Ze6LElD5qIHW2
         orDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781190756; x=1781795556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EjquPjnSxlH1NouQC11hdL93bCB5PiSU+rHY36k2irI=;
        b=lb6lcNnuyzHihO5E21L8PyiUo4Y24wvQzq0A3P0LO5EIXj4XmyZv39Hrqgb9+rxzNz
         T8Tv5y5EM7P5SSgsxTcd2WbByQyG3I97k6xur+ordnmCkX4mCWwvzn2FzdVAL6giIH4A
         f+hVsKhCMvN36TDEt5o6oNpZTJ3n+Ctw6G1viBtrIW75ZuHSralb6oEw8UInykyEkAfM
         rUdDTc+fiToBQMnNcCAz13gSD6452bmJSKeeXdx2GWOQm1KvTxuWvxrl+qdXWEYTGyLI
         PqUO2EDNfNm2Yyxz2o+SF8ouGsLlLoyWVqWCHJu1kw37WOnbmoW8sZfgIrV+DUDFYGGj
         x9Jw==
X-Gm-Message-State: AOJu0YyBFwBGbdSq+J/DZUv7cnAA2KoERFMgtXSqNvpO5lkHrsQvZfz2
	d/4xESINALRIUlWSWJVmFA/AF/qWzhMtFNGpPs578whErzos8Tv0XnsXsEHxF5HoNYLgW+oTq81
	HtIoCFEihSQ==
X-Gm-Gg: Acq92OGJRGiSktmpbm9AiOX2IjQ2QYtpCz2DNOm2nbs+PJ2d9Z7RzXX8DcfhKiFFcUH
	WsvmTiAAUOkKQVrEN+hoUomPOBSvaV/BH6HjFYiue4uIWbwahbpwMC2HJ/p7/rre03SmLhB1U4I
	9NMGt8YZiKlkxrXKtxaO/4Q/+CunKReS3FEi8XTvN9c11HRQqLFb+6a5M6LypnHp5GaAV2pEbE5
	UMXieXsPyfJ8kC/Hsjyb6gj2uCSgTPN6LikluJeyQynDkbffYz276c0Jry9WLiaTtOfErUp16j1
	8t3Az5dieJYyV9YsLvtpWY3IgMcRUFMAVJVbiY8nbQNcmP+tUkryLc/P1iqOnga56xqqyF+FwD/
	1pAj0GpdpJNyzIy4kNskmXu7Z9Gd6nspQCsDklxnqn/tsiNC1tUqG2CC1H7uArDbTMbC8tmBo8v
	B8jzUFPsR5dxOaqxjmeDWr/6pA42m4w+7OlUysKD6qA10=
X-Received: by 2002:a05:600c:83ca:b0:490:d946:47cf with SMTP id 5b1f17b1804b1-490e55d0d61mr44114705e9.4.1781190756254;
        Thu, 11 Jun 2026 08:12:36 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35fd33sm88269494f8f.35.2026.06.11.08.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 08:12:35 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	mrgolin@amazon.com,
	sfual@cse.ust.hk
Subject: [PATCH rdma-next 1/6] RDMA/uverbs: Add SRQ buffer UMEM attribute
Date: Thu, 11 Jun 2026 17:12:24 +0200
Message-ID: <20260611151229.879514-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611151229.879514-1-jiri@resnulli.us>
References: <20260611151229.879514-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Apply the per-attribute UMEM model to the SRQ create method. Add an
optional UMEM attribute that backs the SRQ WQE buffer, so userspace can
supply it as either a VA or a dma-buf through a single descriptor,
consistent with the CQ and QP create methods.

mlx5 is the only driver that pins an SRQ WQE buffer via umem; it maps a
single ucmd->buf_addr region through this attribute. No other driver
implements a user SRQ buffer, so none of them use the attribute.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_srq.c | 2 ++
 include/uapi/rdma/ib_user_ioctl_cmds.h         | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_srq.c b/drivers/infiniband/core/uverbs_std_types_srq.c
index e5513f828bdc..0421bdd225df 100644
--- a/drivers/infiniband/core/uverbs_std_types_srq.c
+++ b/drivers/infiniband/core/uverbs_std_types_srq.c
@@ -192,6 +192,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_CREATE_SRQ_RESP_SRQ_NUM,
 			   UVERBS_ATTR_TYPE(u32),
 			   UA_OPTIONAL),
+	UVERBS_ATTR_UMEM(UVERBS_ATTR_CREATE_SRQ_BUF_UMEM,
+			 UA_OPTIONAL),
 	UVERBS_ATTR_UHW());
 
 static int UVERBS_HANDLER(UVERBS_METHOD_SRQ_DESTROY)(
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 839835bd4b23..1fef1e86b302 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -189,6 +189,7 @@ enum uverbs_attrs_create_srq_cmd_attr_ids {
 	UVERBS_ATTR_CREATE_SRQ_RESP_MAX_WR,
 	UVERBS_ATTR_CREATE_SRQ_RESP_MAX_SGE,
 	UVERBS_ATTR_CREATE_SRQ_RESP_SRQ_NUM,
+	UVERBS_ATTR_CREATE_SRQ_BUF_UMEM,
 };
 
 enum uverbs_attrs_destroy_srq_cmd_attr_ids {
-- 
2.54.0

