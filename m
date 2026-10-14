Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39304A5EB7;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016479; cv=none; b=n0sbdmd7mBEM2QolbBqC24C6OiVYpGfxH1P61/qvCVKsdzk/oInstMVR/ZqVl3V1x+Jk7IPfzpGIu9jovWhJc78iGubZiHklTn7feztJbZCL9KfNGZrkUJ2GV9hr5QOy05rOhO0AwHfnZCzxnwG25Getc8o+QVbA7OMrjXeRgPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016479; c=relaxed/simple;
	bh=mOzCdDBDlOG09lKdsuV+56dyhyabAMDSDBxmRpMKaxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T97gxi6nOxbGt3fZv7YylfJ0CssBUC1McrtmwWSYj5zB+YILHIumxx34gTdZLa9XhzE2L8vk34RA1lfu4mHDjeth2fON3s7dncyN8hwF3GGLVYh9z64D6BTSuDRSMLPuuutt3t+FoP4bVUGFExg+2TZPkhUEnsgkCDNoIGFJ1wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn4MAcw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn4MAcw2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A434C2BCFC;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792016479;
	bh=mOzCdDBDlOG09lKdsuV+56dyhyabAMDSDBxmRpMKaxo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kn4MAcw2/qaWbPfEDL4lzejT+n+M7WtgcjAoGgh647irtY2vW0epjSk4aBydJv/AO
	 ZENwSIjeMCchn3nGfazA9tYL3YxpoLxAXGTh1IIPCL9KQHsZoURxVkNLpGEWfayAg6
	 H/2x3vWeM7GWAOhBnAXjIAzivKInU9tZe/Kk5ul2qQmxBoXc+wR77bEmp0YS+ETSph
	 ZJKHXBWnsvDW//fEqwpXF10ut726/PP9SFejkdJhd3fLsAr+hB0xKL/1vIFrP8ED7j
	 rcGWRNPfKbQ5uIxjQxz3oaL4/zAqwQmtRgSCHnntKI9fdB0ORwcgGwEJ2Z85a7XFRl
	 pofD7eQFhbpGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BF3CC6B24;
	Wed, 14 Oct 2026 22:21:19 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Wed, 14 Oct 2026 15:21:10 -0700
Subject: [PATCH rdma-next 01/13] RDMA/core: widen the uverbs object key
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-uet-ib-core-v1-1-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792016478; l=816;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=0pZ/yOMME6vt8eCKBPBTLR9qDLIACpEFlGj8+/VeYZQ=;
 b=+e5IDuhfCMxm8psiTuzSGsWWiYvvQdxzVfr7TrTh500kjvPpvMCdf9S9aZuFC2botKH1B+siY
 srPfKEmxN6JDYX1imfcvuSGKQt8KMj3LNNoVlHW1O0BjNODIOhepJAR
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com

From: Eric Davis <eric.davis@broadcom.com>

Two more core objects would leave drivers no free object keys. mlx5
alone uses all ten that remain. Add a bit to the object key.

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


