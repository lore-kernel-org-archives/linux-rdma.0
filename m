Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573790;
	b=CcdFDqOahuVPpzZXiaI2ac0ib7YdPaqYoQK0B7QlTQl4ZniG7fSCplH+QVJJWXt6VZft
	 tZvwyLv3qBqjC9AykyD8R+ZxHtLCsQ8LPEwtGhW3K9+AgXJKYz0BBsrof4d6dcfbhRJFD
	 zEdg7NC/Z/spII0f/ocL1S93/ZFao7/V7g4WupOQfub79g8j7B6Uz1RSD5p/17t2PuUS4
	 xt9KWLsCjlQt/GFYhTBkJXgPu/YRIZSgIsE+t1D7WLMLv9wQaAfruG2GWOURWOUv8CDt2
	 Bj8iq9muDVtL/hD8tZXhTum4vAjDy6wfDijjb/ulmAGm8+tUFqmqYgke+/LpkkSj/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5yYpKRVT2piPSpwzX/oy6NpReWj0wAGbXHq7GXlOkoI=;
	b=TavY5mYQH+ZiSfVdMKJMQCdZ0izudRLc7R+27RHmcz4W1Ne0dCst7hlValccy6R2oaRl
	 Q/U5HDspq6Cuo64uwWxTckIo12eR8YKTxVnhA6TCzQkKQiyknfTTJjR3CSqARzEjQxoTc
	 xjdQveEopQfWC2ys/cbmXfoKHUl7MpESs+YYu9nw4ZQ7TJ6R9bOT2yFl9yKUIdm7LrxqA
	 0b6jS3qUXwy1+vhEoIP/UGNEOuoZT77IbkGHlYjevYBaRNxOFqptzSDjD0CdCJuiLYXeL
	 1ld/ntVvotCOjXMcjVQCIBmoje2zMT9SJinMDyqKjPhKeqfBHl2H0cxSPDWQcm8KR0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iu9M4RWs;
	arc=none smtp.remote-ip=74.125.82.43
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58B606A338
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 02:29:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE58B606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iu9M4RWs
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1ae58d17cd9so5515113c88.1
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 18:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795573789; x=1796178589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5yYpKRVT2piPSpwzX/oy6NpReWj0wAGbXHq7GXlOkoI=;
        b=Iu9M4RWsRk9WdnsnZHLPXIDN0e9I/69xL9VPLjYcrrWUTueEjNSjLGzetbPnAzCcOP
         Wr6wakC2pwVuxwvMkGlIOd8pu77scMmnbrBHok6AFcK1tqURh3yHIwYjqKOmXqESRUpl
         MUhjYlCn+9a3tNyTdKdiTHQqQzqlAvqyYnStIRQrtvNqgCx4yqboih9a8H2i6Ottl1kV
         I3A8XWOQ3hncfIUY8qMEDaAuvgdYuSSLCyz/ruXFEHeNSgXCisPWiVsYMeepuB1AVWvi
         OP5YMf9hV1mqeZLhKUZXO/veRRRXaRW0zgDUPc90CQFaeYgEThRs46VskTbvq6bjMG92
         bUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795573789; x=1796178589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5yYpKRVT2piPSpwzX/oy6NpReWj0wAGbXHq7GXlOkoI=;
        b=ovBuS/HWRgMuscaIBnD2mrb1it8Wa85Ez836MiQkdGokGdwkn5ENHjCNUPA0zlEmVM
         byBLVeu0rzMlG4g9pCO6GS/gLIull/b0+QmtZcrQHEjiFMV54Y/3GWPC86NxrFrSrHiK
         onpsHwJtB4CqQbxes12/DS4ghTV5IvZVz4tf7JMMB/OnVoAwojVmqkZlGbfqcbpLqH63
         2M1D+DLT0rjiLMyzxWWOAXWQmgBzfMOv64myiV3ZRQRcxCQ9rx+SglYn4gX0WQ70Dz4d
         BcYt7L6PiPDZOHK4Eoyu8gXMoFrN8z1i0DkKaFFtFtKB7kmDxs8SBocDIDu8PXueclQ1
         kvxA==
X-Forwarded-Encrypted: i=1; AL+hErEkZ2Nj+nkEUkXluR4rKXpGbzsIm+iITLYvjy4+f3Zic48TDFWy6bO1CPachLKjyzeWhY0FhQg8nXMS@vger.kernel.org
X-Gm-Message-State: APuU4Z8rCtTpfPY48gp2aQtN85exuehV4BM2vy1fDMs+y66T4Z09SXZQ
	pM/LOmniPyUcHN53DBb8rrtiOAwBZ2O3yoy59lWJxg83EQkmmQPICvJE
X-Gm-Gg: AZFdTZdD/kUR5uYgtzRfPu8ZNIc+xpFqtCs1KqGLyFxfuF11rLKVH95m8JxIXF0FVkw
	AfUZkC2/6jKt6H85ZAGpZnxl+6x7Wgp7jjDM8xflrRXbuLA3PLkGYXxz5uKVTi/72+zWnIiVFj2
	JrX16l0imgnzT5XnOCS6iU2xG2vOp84+bZHamm4/HOx+kr8W7YGb+xgTgJJX+3n7Vxd1/WxEjM7
	4zWaVCuDMlNk/5uHnSaJI+ZEzsmKb6z13tkx/rvj6gJItD9G+2g/HMcsi75f6q480bMrm5WG1we
	bgNQ3GKDVzYnBt213uZowzO5WhiuMeZ6zEgdYs9UoNnZstfQ2PQqp8MXdMBYO2ZFBmSYnIeGuwD
	dYia7Uvf6VEyBnL5YQTbLEAO9EK+7QcQPVIykxMbVrNWP2i+tkIjf/pceGEqMEY39aglJMfxis9
	jeTjOHQZHsrbCUkd2gL5SPuz9Z63VYFaa0AyXIhZwOZYf5yoCgdJPkbQTpFEKG9RBz5NHDTV4iS
	u7xfBUlvCsRzEYjwV7RZ4HHjxIn8v30kDhPW8CQDcFkry4iTByWjGja+PNrxGDPpGYkLb8xModv
	Q5qGHK64i1DDC0y+XUGhI2cvBg==
X-Received: by 2002:a05:693c:69d4:b0:36c:a154:db1d with SMTP id 5a478bee46e88-3856c6b41eemr16943243eec.4.1795573788900;
        Tue, 24 Nov 2026 18:29:48 -0800 (PST)
Received: from ubuntu.. ([2405:201:8026:213e:e27a:f80:e9db:185])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e7f59sm50655698eec.6.2026.11.24.18.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 18:29:48 -0800 (PST)
From: mdshahid03@gmail.com
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] net/mlx4: fix error propagation in mlx4_load_one()
Date: Wed, 25 Nov 2026 07:59:13 +0530
Message-ID: <20261125022913.205366-1-mdshahid03@gmail.com>
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

From: Mohammad Shahid <mdshahid03@gmail.com>

The return value of mlx4_check_dev_cap() is not assigned to err at
two places in mlx4_load_one().

If the helper return an error ,execution jumps to err_fw,but err may
still contain zero from the previous successful operation.

Assigning the helper's return value to err ensures that the error is
correctly propagated.

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 036135df23bf..9d89721077c9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3505,7 +3505,8 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 				goto err_fw;
 			}
 
-			if (mlx4_check_dev_cap(dev, dev_cap, nvfs))
+			err = mlx4_check_dev_cap(dev, dev_cap, nvfs);
+			if (err)
 				goto err_fw;
 
 			if (!(dev_cap->flags2 & MLX4_DEV_CAP_FLAG2_SYS_EQS)) {
@@ -3540,7 +3541,8 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 				goto err_fw;
 			}
 
-			if (mlx4_check_dev_cap(dev, dev_cap, nvfs))
+			err = mlx4_check_dev_cap(dev, dev_cap, nvfs);
+			if (err)
 				goto err_fw;
 		}
 	}
-- 
2.43.0

