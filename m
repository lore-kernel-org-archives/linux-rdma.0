Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465417;
	b=gHRe9pyQi2VuG2+q0ozEuAvC5VnhQlLQnSOic9jxS/GMvuuPQxfsOuNnPjRxVLFfEuUL
	 afPIj/7ehdgtoQ12rkNk6tEgVoaqtq9ot91tkycu64BFOuxVncmUOUPfJN5lfTLdYP7nd
	 774ddu+DQWWKwP8HRYCwzpROzsvJLQ2uRNp7tbLPa35QKG18Jl4fOY7c27iOSK1KCjJ7r
	 hrmAwOt7zM3Uab2Bf8yt6N94dls/f1TjCS3d74OZ6wb8/8sfA4mGFk0VMR3upbWn+LrOq
	 JD+SAve8kulBQBpfWo+vyf1wnQgS2GJsBDvh7h4SAKERLmKy06MThOTJ07wCwhDe5vA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465417;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iBZ+lfvZ3QPQhTZVZeUkb78SoKV0ifrsfGO8/uH2U98=;
	b=dE9GQHYBqbF7iNIBgpWDEkIKcEwnmOABjzRYGtXbW6cuQZaauG49Zr2l1i80LhesRp2A
	 C0kPQG/LYZttKp0yYSN9JAhnXnG1EH6rkggSxbS0LZju5+Oe0jcXpaCjEeo7fAbFP+vb0
	 9ataYl5EJt81BXprIviARhxmFioS9v5HO2yO0tT2SshJyHuecfI5l/Z7sPMBQYGWImDQX
	 4eLCu0b5iIYJEICylI25bLj0eTKuhHXGc4l3A3/s5TDKw5OBaLVDHVUIsu8xiqcRvJ7gj
	 0Qehj6/+SI1VByCSQhAH+7T46zp/ALeTc4Is23MKnm6OtXHGIPZ8nCC5liOgFuOp+hw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYINeVv4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4889606A31B;
	Tue, 20 Oct 2026 03:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYINeVv4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465416;
	b=jCYDXyldMbCj3oOOP0fJGlVSKl3hFJ7ZZ2CkSuGBrCTe3BRPp5o/1ECWLKh+omFNyzL/
	 RJa9mC42Fh4rk32UjKMhLJ0z62jqXg7DqdzSw7fGbSnj7TEXRDqmreNZgvxFWXwe/ZTk1
	 rLBXF7P54WUYG8+bEq2gwSGL9tuUREep8b4k/Ade3SzVEjDPt9hcpJLbf+2HT9d9UEmZz
	 dwc4nmpTUwR8opkAyd6n0pnqH415HJk9AZh6OFpJWsXDUpknVnkDtdkNWX8y03L2B5lc0
	 Hio0kewwJb0Sb/uJplv1teaInChxeUoWHjb2yd7bKI1aGuCp6DqHSW4q5k0NsU3In3Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465416;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iBZ+lfvZ3QPQhTZVZeUkb78SoKV0ifrsfGO8/uH2U98=;
	b=jD4nWmxR/4hbAMqH1Gs98kLL+jhpjszSICHtVH/5j3r2yPExACN0w70l8KN0LZw4qu4a
	 Yup4o6HO2RErLF+wLHThUkaK7TLt1MR/JMTmvBr8Dp7IIEIV8aj2iDly1JcvWY1TQLEHS
	 qnV4Z3/4PYLZ5lpbpZ8zKVGwbscqAoZ2FSEoa1ND0VQL5pKr13OYZwmW2wO8xxAioEQor
	 AO3DGruyry5Uj7uvJ46nScSjEzy/ZTZddqoeSsOTpvkupujkxu+iY/zU2okY+o1NZUDEx
	 jNR1kwyqu7NzhqhrEAcE7tbIRHurL9viJWnGLizgV5KGg3ODTZwAUOzjrkPHDsgXKRw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7CE61F000C7;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465416;
	bh=iBZ+lfvZ3QPQhTZVZeUkb78SoKV0ifrsfGO8/uH2U98=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kYINeVv4qVUAsUjP8awmXYbW78O9fsmQU6YqFF2VJO1YiBL+Q4tydIvCaJtrcazaG
	 IMb6KJ8dfldlP8o8RXbFh7+N75boicerwOMCeZTGVCUm1Wow8/zsdTVl/31JKbeeri
	 CgLYoyYP3S5LwuBX6pq4H5TzMk65u7E/vLm/AHrR8YzrZudwR+CV21x4x//7lH7RXs
	 2evghPzTUnnUJAsHhMPuuCozsWyWnvmhCCU8WL8zx7e8cG93gI2irbAVhXG30MWc1A
	 C6YptJBFhmOqzkqqcj//4YpFqwcYpVGOiV2a0OUNld9Bn9QhkrA9Y6PoySvcCpUxEi
	 hCZltAIfrBapA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1B513406F6;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:28 -0700
Subject: [PATCH rdma-next v2 01/13] RDMA/core: widen the uverbs object key
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261019-uet-ib-core-v2-1-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=803;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=1sjWpbXcpF/RMAH3lqB9kxQ2MgDBM9KHKD16FP2T8gE=;
 b=wwGhebSzQGEJE3rwfJx9Gj++6Gy6KRldlGwu3ycsbFzFf3tE84Gxk6SNLmRHoXLXlFcaS8Y0M
 vxizmp1bZJWAdPL8ynl7VaEqoz21FEP7LTZbVggRThMoX2nn+7FoizB
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Three more core objects would leave drivers nine object keys, and mlx5
alone uses ten. Add a bit to the object key.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 include/rdma/uverbs_ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 1aaaadb8daf6..f4d93bc3625a 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -144,7 +144,7 @@ enum uapi_radix_data {
 		UVERBS_API_METHOD_KEY_BITS + UVERBS_API_METHOD_KEY_SHIFT - 1,
 		UVERBS_API_METHOD_KEY_SHIFT),
 
-	UVERBS_API_OBJ_KEY_BITS = 5,
+	UVERBS_API_OBJ_KEY_BITS = 6,
 	UVERBS_API_OBJ_KEY_SHIFT =
 		UVERBS_API_METHOD_KEY_BITS + UVERBS_API_METHOD_KEY_SHIFT,
 	UVERBS_API_OBJ_KEY_NUM_CORE = 20,

-- 
2.56.0


