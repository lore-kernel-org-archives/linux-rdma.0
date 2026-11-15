Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794761244;
	b=2OSahuW2F8lERxx6bgo7IYwMAfKV0r04vy3+KBn3W92OrNMa7nBwvPXINmXBY6w/ayg5
	 RQd8YpYZEh9gqdqvOEWtW7m/sZoLgsahV6ML0K7XSk022LpDo7GuolrY9JpIjhIB3tuai
	 ApUy5rARIlP3qCCTMu/yXV6zyCEZ7JpYy52+hFepYdwTEN6UYDXtCoyfk3Ut+J4Hw7jFs
	 nC2WKafKig4cwiAOkcq/3KjGaKUVsNXBPaQbAMagv4MShWWAyV3GyS1NqbWo3UFpxGXTp
	 buPx/K6e7G4qdwdx6cESkN0SpzROdqqR5QxRLg7KUR5dQCpmWNR2XMxFGyUAjrrkkDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794761244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sa7ofRAujCmwkCPwzRLEPHK2kOv8QrCjBkvDTrY3Wwc=;
	b=Fm4Az3HZDIw48dPTfe+XtvEMwOSsXp6ZpwYi8YznLomNDV5nCoc/m+4cqu0mmyMEwqFj
	 UoUFYUAGEGfjaaoA+y64Gf69YOYBpSqFUW/cNWelQDp60P82mZOFv70MpDblRoxxJZDbz
	 19KyFqg1nPQyzQfJWKW8TVHvRfp9XyqV4Or1Q5r73q4TSBzhWL2WmvPWfMXD7rvcXrlFf
	 u5pKox/KXMp3xHuVYdDjm/Q2Uc4rccrpnK1soo8ifu9/5YvcIk9/xUfRsbWOnLxniahJP
	 qKyPHFppzNSf/TXjShq8oldG+E1PE/Fzc5J2QyAOMIZmvlhovMKmHDYaA7Da19MlmBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Ru/f4A8U";
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6832606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 16:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6832606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ru/f4A8U
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1156713eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 08:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794761243; x=1795366043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sa7ofRAujCmwkCPwzRLEPHK2kOv8QrCjBkvDTrY3Wwc=;
        b=Ru/f4A8UOeS+sfUS5tlNKNFUHguHL1PmYkm+9IfXA9k2Fnb7cKVEH1wBVSbQJ/ppmd
         vhooAD3KjBTJ7fWzwyEyV/HhgvPiTHe7pfWy1+RVX4ZS00UJA9m5XrfZgEar6pfBigqF
         f8QRTtcODnJTHAtFuzJipOTamL1Gtg8V/EilqjkM2mkTORl0OCVbkbn8POClh765JcPX
         FlRsATRUOtCJUatUbgvMn4peMF0T5uBwIN8y+ByMfCn7QM+wZaLvCuAbGLOrefdq9n/S
         4cAKmorw6jQBjczzATKEy8isy50PRTeVXbGnacPyAGtuWb92fSAiZjEF9nmbK1m//Cm5
         hb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794761243; x=1795366043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sa7ofRAujCmwkCPwzRLEPHK2kOv8QrCjBkvDTrY3Wwc=;
        b=QgFXm9UXBDltQuAUyp9TsLRCxINQ9auYi/4RZGys/3r4zAWpvB2++Ap1icVDkTl09h
         BhnMwER+KoS/+qgGFkgJOJS5u3GFLis9YciIjm2pfx2+PF8uKaFqUPRLgFqQrW2hguCr
         VtS1K2Go2LXZ8fyYSCjlA/PPjo3FWJ+USsewQhcW2Ganpl4N4mwA+hgp7GQjIaWZnaNN
         1tvhSRUnwaq6v+ljzYb3ZgvT7Tm7vWK3zfkjzQzlVnDGUVzxRFwaJWQ47rHcU5AqaEvo
         YdAttTicxx3JHXupwR7EtPWLhqwBog4Bzz7btIfTN3yxyz9sdRWaqCKsQQYxXQKk+KDM
         ZCog==
X-Forwarded-Encrypted: i=1; AL+hErHqwucZZaBGSYzlhl0ccXw/pW3hbjTC6UNuC1bIDEzqRp2gdzt+HmahtLjKpywHaUTrA9f6yPDrWD+s@vger.kernel.org
X-Gm-Message-State: APuU4Z+RuuZ7FlZh2JX1HKl6FbC1KOvoG6ne8OD4kfM2u+tf2f7GSShe
	Jgb1icLczlMdahb3qNmfJVf8bIWB3FiGofQyYO2dcetQ8hgwVF1L0gBE
X-Gm-Gg: AYBFou2mt2G/ONP9IydCzAM4JUetlEdBC8x0u4sMkbI1OImxEQZX1rbmUUJ0CSsC7IA
	wYsZCPf4RA6KVZJoE1wO/1k0uCrjKpYqRgp+l7b94VOgH6KgX50lAl7sHezfml2DqF816V88mb/
	Yzjei9m9avgAqFqeXLRFc9SUMjznDy8RDR0xiqqP1ZbEx+ZDgA9RSE1rmFKccpLXTyojIzLmdaW
	x7RNJgdrCuqpAPDaUp7N5AF86MPD8WOmImWcf5xDiVZmfd4n3wQh8TzS9zvnIlBEtqCmDVGmnxx
	pzpsARmB6d6Ukohc9R5YXYgkvuJCTRBsjAhHCWYMDMRPvO3i+VzHYUN0+jH7GS70WoSKG8X9KjF
	4q7E9+JEx8bxGCHPaHVnyStDNi2P6BzrKHrWZZMpMFGWj58nYAX2flSqaZ3JPNneyyUH5ZfyNAc
	ZmQm1UFd/1weCGMPjfZH53iKtfRLubKryqEwWeVl1rZJjK4O1iJ34tm0cA09xpIa8TjJXjROokS
	Xoehb6XzQJs2Gi1DCr12IZR13AmFSzYv+MUNGJPqnf+GYfLKmYcBrbQ8LwLRsPYHASWjCOgKYzp
	qG1l1GHEHd05xvaIeF0gEgkWYxDiRqxNQsDv/MfxgXdgbqY2aQfA7IASJDKQ0S4dDE3ZZDXHkPk
	DuD4EVGBmbNmeQZ4ctW3O5yrWIPh9xWvlcGIprsC2BoXfTsYrMHZuMG/OMtM=
X-Received: by 2002:a05:693c:638d:20b0:375:c862:31c with SMTP id 5a478bee46e88-379684b8190mr8383083eec.40.1794761242870;
        Sun, 15 Nov 2026 08:47:22 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bad134sm32279121eec.27.2026.11.15.08.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 08:47:22 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	yishaih@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] RDMA/mlx5: Validate the DEVX command length before setting umem valid bits
Date: Sun, 15 Nov 2026 16:46:58 +0000
Message-ID: <20261115164658.88420-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

devx_set_umem_valid() sets the umem valid bits in the command supplied
by user space, at offsets that depend on the opcode. The DEVX object
create and modify methods only require the command to be as long as
general_obj_in_cmd_hdr, which is 16 bytes, so when the command is
shorter than the layout of its opcode the bits are written past the end
of the command buffer. For MLX5_CMD_OP_CREATE_QP the modified words are
232 and 268 bytes into the command.

The command buffer is allocated with uverbs_alloc(), so the write lands
either past the internal buffer of the bundle, which normally lives on
the stack of ib_uverbs_cmd_verbs(), or past a separate allocation.

Fail with -EINVAL when the command does not cover the layout that is
modified, as devx_handle_mkey_create() already does for
MLX5_CMD_OP_CREATE_MKEY.

Fixes: ba1a057da2f1 ("IB/mlx5: Set valid umem bit on DEVX")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 44 ++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dcc65..5eb104994b4a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -730,7 +730,7 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 	}
 }
 
-static void devx_set_umem_valid(const void *in)
+static int devx_set_umem_valid(const void *in, int in_len)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 
@@ -742,6 +742,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *cqc;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_cq_in))
+			return -EINVAL;
+
 		MLX5_SET(create_cq_in, in, cq_umem_valid, 1);
 		cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
 		MLX5_SET(cqc, cqc, dbr_umem_valid, 1);
@@ -751,6 +754,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *qpc;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_qp_in))
+			return -EINVAL;
+
 		qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 		MLX5_SET(qpc, qpc, dbr_umem_valid, 1);
 		MLX5_SET(create_qp_in, in, wq_umem_valid, 1);
@@ -761,6 +767,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *rqc, *wq;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_rq_in))
+			return -EINVAL;
+
 		rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 		wq  = MLX5_ADDR_OF(rqc, rqc, wq);
 		MLX5_SET(wq, wq, dbr_umem_valid, 1);
@@ -772,6 +781,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *sqc, *wq;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_sq_in))
+			return -EINVAL;
+
 		sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 		wq = MLX5_ADDR_OF(sqc, sqc, wq);
 		MLX5_SET(wq, wq, dbr_umem_valid, 1);
@@ -780,6 +792,9 @@ static void devx_set_umem_valid(const void *in)
 	}
 
 	case MLX5_CMD_OP_MODIFY_CQ:
+		if (in_len < MLX5_ST_SZ_BYTES(modify_cq_in))
+			return -EINVAL;
+
 		MLX5_SET(modify_cq_in, in, cq_umem_valid, 1);
 		break;
 
@@ -787,6 +802,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *rmpc, *wq;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_rmp_in))
+			return -EINVAL;
+
 		rmpc = MLX5_ADDR_OF(create_rmp_in, in, ctx);
 		wq = MLX5_ADDR_OF(rmpc, rmpc, wq);
 		MLX5_SET(wq, wq, dbr_umem_valid, 1);
@@ -798,6 +816,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *xrqc, *wq;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_xrq_in))
+			return -EINVAL;
+
 		xrqc = MLX5_ADDR_OF(create_xrq_in, in, xrq_context);
 		wq = MLX5_ADDR_OF(xrqc, xrqc, wq);
 		MLX5_SET(wq, wq, dbr_umem_valid, 1);
@@ -809,6 +830,9 @@ static void devx_set_umem_valid(const void *in)
 	{
 		void *xrc_srqc;
 
+		if (in_len < MLX5_ST_SZ_BYTES(create_xrc_srq_in))
+			return -EINVAL;
+
 		MLX5_SET(create_xrc_srq_in, in, xrc_srq_umem_valid, 1);
 		xrc_srqc = MLX5_ADDR_OF(create_xrc_srq_in, in,
 					xrc_srq_context_entry);
@@ -817,8 +841,10 @@ static void devx_set_umem_valid(const void *in)
 	}
 
 	default:
-		return;
+		break;
 	}
+
+	return 0;
 }
 
 static bool devx_is_obj_create_cmd(const void *in, u16 *opcode)
@@ -1567,7 +1593,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		if (err)
 			goto obj_free;
 	} else {
-		devx_set_umem_valid(cmd_in);
+		err = devx_set_umem_valid(cmd_in, cmd_in_len);
+		if (err)
+			goto obj_free;
 	}
 
 	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
@@ -1646,6 +1674,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	struct uverbs_attr_bundle *attrs)
 {
 	void *cmd_in = uverbs_attr_get_alloced_ptr(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN);
+	int cmd_in_len = uverbs_attr_get_len(attrs,
+					MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN);
 	int cmd_out_len = uverbs_attr_get_len(attrs,
 					MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_OUT);
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
@@ -1675,11 +1705,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	devx_set_umem_valid(cmd_in);
+	err = devx_set_umem_valid(cmd_in, cmd_in_len);
+	if (err)
+		return err;
 
-	err = mlx5_cmd_do(mdev->mdev, cmd_in,
-			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
-			  cmd_out, cmd_out_len);
+	err = mlx5_cmd_do(mdev->mdev, cmd_in, cmd_in_len, cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
 		return err;
 
-- 
2.43.0
