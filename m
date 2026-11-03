Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698938;
	b=hRRa/J797Ry2OcVdqTdAYa/FJeUpsgFN9LaoEZnmpNSGp29th3VFaUaW8o/rZDMzBJjX
	 qeKRwO4YF26md4tinbU1GG2hGx/ufGJQOhieSY2sOCIzKV+anD9ePUyBylfiChjawrJ+v
	 NVRgnivPoD7jNpg2uL6nUeUCc9zg5BuY8bmOB2INgksphXs/IrVVxX7V6JFlMVSeCCozC
	 fdo8igZD1NU5hv3G7issUBQIi/If2wRavnPORCkD+nOucYfVh6w+bB+QlyQ7N23vPxL51
	 fdPgg+kQQmk18mIFsV81J9Tzp3ABpl/8Ek/cCWSGY0WnKyi4i8veg24P/4/0eqUHcHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=exGYOHHyJpvyX9qJHZqVV4kC2TwIojrZI+r/NMZ1IBs=;
	b=EAhGa72Yc66DxvbNGBxDYLf6/Ypro+oGvZO91Ir5Iu3XyKsflzrE5PzK2U+JnhluxHuL
	 0b2Uv9gAZ/ALdcdNwT0aJrtKGg00ss8jl0PBekbvc1SQi1A4jw10MtMJqu3WjzqIHk/nx
	 uprtWHINgPODp96aBMJwXbVQO/0WWsDfb93pCxKhk3uyX0gH6coB6/B8kd+yeJdUfKCm7
	 afeS5OKe3T7JfZwH06TqgG9QW0KEMNLHkN7g3KiMg5PPJdu8q6C9lFUQUDfz4iwh3yYdg
	 nnFA3vjTR7a1CSrMyaxG8T9QFSmyNhFqBzJOASy0o4mNFjoFcmlq2PzCuRWKJ2c9/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=beOsCXmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C475F606A331;
	Tue,  3 Nov 2026 09:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=beOsCXmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71231F0093A;
	Tue,  3 Nov 2026 09:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698937;
	bh=exGYOHHyJpvyX9qJHZqVV4kC2TwIojrZI+r/NMZ1IBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beOsCXmTkNfqrgW81gb1/M9E4Xpx6TpZUxaoKWk6TnIaUiuD5UQ6chRQ5krCJN80O
	 TSas7EVWW48QzZK3AFQQrTwvWFTozvG9KFNEzxFi2SSLMO5/iM7IK2FjR5kMpp24WC
	 Et2Ieak2wRcE9JtKw9QgnhcTHp0Mn051RTgBmzVzU5UZyh8eRt/YCW/KxWl/lbWp0U
	 S0VjHHz6cgyNiFeAXGxuSxJhP12aTBmKX2+8lz5ycm+7sgMElpNjQO91u7b1hCfyF2
	 BwcuR9+eq7jW5UIk0a47ddB/Ib5vdL1EDXmQxLaq6cy12j7eMcePP9LYO618NJXNn9
	 nRkYdfPYLP/AA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc 3/4] RDMA: Clean up the INFINIBAND subsystem entry
Date: Tue,  3 Nov 2026 11:41:59 +0200
Message-ID: <20261103-rdma-branches-v1-3-763c07cc14aa@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
References: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
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
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

The Infiniband subsystem has had a broader meaning for a long time. It
represents the entire RDMA stack rather than just the InfiniBand
transport. Reflect this in the subsystem name.

While at it, point contributors at the correct base branch for their
work, which is for-next rather than the default master branch.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d49552a59692..54df71bd7d65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13111,14 +13111,14 @@ W:	https://www.infineon.com/part/TLV493D-A1B6
 F:	Documentation/devicetree/bindings/iio/magnetometer/infineon,tlv493d-a1b6.yaml
 F:	drivers/iio/magnetometer/tlv493d.c
 
-INFINIBAND SUBSYSTEM
+RDMA (INFINIBAND) SUBSYSTEM
 M:	Jason Gunthorpe <jgg@nvidia.com>
 M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	https://github.com/linux-rdma/rdma-core
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
 F:	Documentation/devicetree/bindings/infiniband/
 F:	Documentation/infiniband/
 F:	drivers/infiniband/

-- 
2.56.0

