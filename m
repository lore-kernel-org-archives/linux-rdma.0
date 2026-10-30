Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384146;
	b=kGRmjliqdrl4hLtM1wE635Z095U02gO/xHANIw9Vyd1cXRg+0eA9id8hsP6P9rrD+r7y
	 OdmwpTHuaLhwLMToc0gWmf9G0th0GYbAuSQOsFg7R8Qi3iwXdlBVzbjVTN1oc69mRdx9z
	 sizI4TCFN+xMD1zQOdMq/YJih5Dsg1GOhIuL3itev6G6y1Jrvw4T16IZ2j1Jf/+AWrqwJ
	 JQlVE9Or7cI71v2rxWFkVTV5KTk+H3WJN2yLssk0ZaNeazSqPo9Hx9JdJfSY5TNXvFwsW
	 RnJVtSVV4d5MdVtktP4rdrqUy5ZrIsBTymb8jN+EsglqeyOuqcZyOZ1o1NtfmMhQdLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nF9bQw3tAQtyXn+Lf9VhF9hLMi4KceB22RjvEpSde1s=;
	b=pJfmQPl2VMIFeSaUjvYAQxAmfNxvwKK6bYeCcza5VmGrxqUVWdd+A91SuBSc9iAI/G+w
	 kwYhbEuPa6opZZA12GvYqb63Pd5svjXCPKOOBzrVr/rS++qk4a33Ji/Yq65KF9xIeKewK
	 uBe4lWzzPiYlIQT8CKqOUIGn+4ByQDLbyiiW8noaCWCfEjZ5+VKmRD/noBZc1vOBAJ/fi
	 0CifAp+K/bec23pzTtUvoTkSJfIMZoZC2uHh6/v62bY31OXc6BvKhXcen+8aM095UoYaQ
	 r6eWW6iFT8pUQDD0hKNVQpV5s85EjJmcmLTmIE9Nsvgw89xVMe5zBZ39KCGAXt3naWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=cPgDCuw4;
	arc=none smtp.remote-ip=209.85.217.52
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAEE606A323
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CAEE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=cPgDCuw4
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-7cc0892f92cso329333137.3
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384145; x=1793988945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nF9bQw3tAQtyXn+Lf9VhF9hLMi4KceB22RjvEpSde1s=;
        b=cPgDCuw4S+88w1a4e65HGxEcO8nMD9xNx+iaSGqqULGZS5exzi9ys4cTfuAPe8Y4gt
         S+InFiyCsYfwNYl2ctScgl4SBj7W9+OntGbXVub4jYaM7ojQEWlIbR4n/mJbOkL08uu0
         FwurcLcJNVH2CZcu01ukpCEj82GuFyTI+p1d3O2lceWt3yVKicF4BgudeSVDpLeLTmtk
         365hC8CiPWkgA+7luSEzpPd+6wdCbwUhJBCN5Tp2Z3GDvl3zzrCOGAOZFpr8bp6xn+kg
         hVibNb7MZwX498XPv37cU2QO+tb70fmE4BL2tuJOxPQKCEfIZJyct42pds9ZjSSqtE1X
         mZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384145; x=1793988945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nF9bQw3tAQtyXn+Lf9VhF9hLMi4KceB22RjvEpSde1s=;
        b=XAMM+rFvC5JUn8uNz+oT/PcMHXE03mYTXANDsNAb1md2zPEPovsDA3OFzXrxarIOBb
         +EsjECwV7wU5L61dNMaJUtfG/oxAzysA5LIvfNaNUEeR8TXCe2blTmzpMN46zRIutafO
         iar1NiTFzRQCYjWS6NyW9ZDUHhUsLY7mtHC5W75R+RguobJugtAXdsYdS+l3SxyB9/q5
         kgOICkLjmnHHZs9QU77n+SdW8Qw471R6wQm1hc5bCBhTQ9Tln8Kibv7SgfoQkWQW5t/o
         4EgtQqnEfFrK7T7B61vyzzoHFwLC/C1dnN7sFf/EBZQ7x1Z59QL132AbYTQOnuDT2UdS
         1yug==
X-Forwarded-Encrypted: i=1; AKwUvBwNbU1gCCTQ+ju+c9sNM0v2oiSWO6vQk1X4B4NUVodzvk0YZxCXn2JrHK9P5feFM+JiSHEkAXTiLAaG@vger.kernel.org
X-Gm-Message-State: AFq9FYK+kzpkKxRfeQFUDePr/3Pkxn10/HeM/lurOV+Bked49QRqU01B
	dxwSN3YFQABUlciZDWFfEmepXQmeP8GqSN2ttjgCjiSNuviVvI6Cz6m8iu+i6vk0IM7r
X-Gm-Gg: AYBFou0mkls7lw/EnURZAZ2sZwkCJLZBWkJ3Z9J32AfP0FdyWzeGs0jIwzNqEoRPYhl
	9qOConaMoSaNlRd8rJ+4HTeYXmcHte45ZDWiwWDk3sqmL7Yf1pw5aHU0+FpGa2nt/KkcXBNjknW
	YcuBFSlk36BZiPRMVAgg40i5kWgsPsLwC0H1NsNBo7cQf3pGQaMkRTH9gUS84mwFO6YV06Tk99x
	7EOhRucmmXRvvNambCeHtXZMsXSkP8RKSnF28lk2LKlPTQPve8W5Z7eJT0DYo2O3tQ5Z7UOUnf/
	WYr5kEdSrpYRQlhuHPF9vWH7WKQOH9FRd98MJvU1oOmO2Gm4ABy6p0vKjw+MLTIPyuCf9oC9K9k
	JoYxNSk1legw8gK7uJERjQxB/6mnxr3+ZHh8adqZX3qIN7VGS0ykTQf5RRCqUuN4tHVyZDkSPUK
	iFjOwqMNQu3equCUu4wV3ZfFw9GW9bomb22iwP1oehdB41NDe9PcFrZdSI0Gl0wzgXm991PifIw
	KVZAEZKByfemy/Zcpsly8RoCdrceVCWWkAxNYkXCbQevPSFmYJ0xSTP0tCVvBMoxSEXDVhWPGrr
	sFrngK2xI8QJ1/r9XKcp8r7PzOP/0v09zwGPKUGu8QEwejcxhUu+RcbkBLIKxMk7yFvMJL0sIAf
	karI+YGTavndMVHsTi9zj7SZMZ8SCyePsmVb3+BpeGgM=
X-Received: by 2002:a05:6102:14a3:b0:7cc:232b:f5a9 with SMTP id ada2fe7eead31-7d07272efedmr1462792137.24.1793384145522;
        Fri, 30 Oct 2026 11:15:45 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:45 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v4 1/6] RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
Date: Fri, 30 Oct 2026 18:15:07 +0000
Message-ID: <20261030181512.2056056-2-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

In preparation to support modern UVERBS ioctl attributes (such
as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
`uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
uAPIs provide `ib_udata`, we derive it via the helper macro,
`rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
`uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
and SRQ.

QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundle`
as a top level input. However, we think it is a future project to unify
them.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c91c55917de9..811b1d532599 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -637,13 +637,15 @@ static void irdma_setup_virt_qp(struct irdma_device *iwdev,
  * @iwqp: qp ptr (user or kernel)
  * @info: initialize info to return
  * @init_attr: Initial QP create attributes
+ * @attrs: uverbs attribute bundle
  */
 static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
 				struct irdma_create_qp_req *req,
 				struct irdma_device *iwdev,
 				struct irdma_qp *iwqp,
 				struct irdma_qp_init_info *info,
-				struct ib_qp_init_attr *init_attr)
+				struct ib_qp_init_attr *init_attr,
+				struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_qp_uk_init_info *ukinfo = &info->qp_uk_init_info;
 	unsigned long flags;
@@ -981,10 +983,14 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	struct irdma_qp_init_info init_info = {};
 	struct irdma_qp_host_ctx_info *ctx_info;
 	struct irdma_create_qp_req ureq = {};
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq *iwsrq;
 	bool srq_valid = false;
 	u32 srq_id = 0;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	if (init_attr->srq) {
 		iwsrq = to_iwsrq(init_attr->srq);
 		srq_valid = true;
@@ -1071,7 +1077,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 
 		init_info.qp_uk_init_info.abi_ver = iwpd->sc_pd.abi_ver;
 		err_code = irdma_setup_umode_qp(ucontext, &ureq, iwdev, iwqp,
-						&init_info, init_attr);
+						&init_info, init_attr, attrs);
 	} else {
 		INIT_DELAYED_WORK(&iwqp->dwork_flush, irdma_flush_worker);
 		init_info.qp_uk_init_info.abi_ver = IRDMA_ABI_VER;
@@ -2337,7 +2343,8 @@ static int irdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct irdma_srq *iwsrq,
 				 struct irdma_srq_init_info *info,
-				 struct ib_udata *udata)
+				 struct ib_udata *udata,
+				 struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
@@ -2420,6 +2427,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	struct ib_srq_attr *attr = &initattrs->attr;
 	struct irdma_pd *iwpd = to_iwpd(ibsrq->pd);
 	struct irdma_srq *iwsrq = to_iwsrq(ibsrq);
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq_uk_init_info *ukinfo;
 	struct irdma_cqp_request *cqp_request;
 	struct irdma_srq_init_info info = {};
@@ -2430,6 +2438,9 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	u32 depth;
 	u8 shift;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	uk_attrs = &rf->sc_dev.hw_attrs.uk_attrs;
 	ukinfo = &info.srq_uk_init_info;
 
@@ -2470,7 +2481,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	attr->max_wr = iwsrq->max_wr;
 
 	if (udata)
-		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata);
+		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata, attrs);
 	else
 		err_code = irdma_setup_kmode_srq(iwdev, iwsrq, &info, depth,
 						 shift);
-- 
2.56.0.317.g454f8302e1-goog

