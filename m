Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65C1A6811
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787827896; cv=none; b=YTnA8K5gUFiMr+Cc8DrUjEbiClXxnrfp91YKYVaMZId/7BNgFGtLV8GsZwLlasETnDzz97cZbac7o90o2pYAO/nhe9cIfmvs8LRcBzab9w6bN8Dq4ZgJUCSL1svtQ6rOIGNgKIX9hh0o6QOuJ+QxwhijiegrTBvA3veb5ygM2qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787827896; c=relaxed/simple;
	bh=NDQK5kwpUVD6obx/yy5Frm7uZq0lf62K9bp2v1Vc1yI=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=SCROSJoF3OFnvcdc5GC0MHCH73jPaCUirXnpdegy3ke7Q7YxlPWVtFc9RbkOoy6QCd+19TqHyXP3j6yD60gj9WxXd6Xlkqh7SwRT99P6cl5RJ6SAA8NC6jU8g0SaspaC5ivzcWskPGQfrJx47rOKZrrPdw+hSkrcQxtwZ6LvG08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=DKwuhiIg; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="DKwuhiIg"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4798bea72f9so359195f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 03:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1787827892; x=1788432692; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uSbx46qQDT+S0wnvtgnGbS9yof1KhN8VuOkEYs/TPLI=;
        b=DKwuhiIg6Phv0N9g+cw2i+PR6wpOMr1rCkjLhRr6JgisDDz6mnmEbKFF2x4m9LldHA
         Sy+Q+4wy8SgVIP11qmLM3Dfc16PbyKpng3yzQxRbiPI4l51cLXljfW/Xt37HuMO7LgLr
         3lN60d1/r59HZaNdxLE+zSDkWlFmzNN1GR8oxSFELrNb6m2VDf/dX0L+lrnR4TH70D7D
         p5g2iK63NZ+9U+Rk5F0t8rfIqTda1v4hmp3E/GYjrsElHT4MILtlFzslvKtJShzUDsbp
         5CNMaWNJg5b0gbiHhu5bO36tqXQ17caLZsXE9yAcO9oeAAhWYy041IwqZ/Adl9z5mfe+
         xTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787827892; x=1788432692;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uSbx46qQDT+S0wnvtgnGbS9yof1KhN8VuOkEYs/TPLI=;
        b=rZP/EpalR6pMfAHp3DtmjREkvEBw9fDLXVy/meoxgGVXLsZo4D8xC7kUB9tSWcBSFn
         IjnyZggGRXaVYYI0/SA9AcGWVtuAQVg4lzAmxf75bFekydXyg1JZnZIIv4RcKhrt0fDY
         qp5SLEN19h2Y0C8tTB4Zyc1PTCNmngsIZ9cdv26wkiNoXe8sVQioRZrwrynzCyPYLFJa
         N2343W/m8vSGRLaaOBhIXLtsh8/by+lJa53C1CpH7L0+3ztNyTkn4dNUf4vQ+tn0bYOS
         P1TA7nSBCaINO9lplaIlid5BXfdBK+t4fxdybZl1wqIHiRNuGw40154PgMPoRlMV1lQs
         ud4w==
X-Gm-Message-State: AFuF++mptzeGc5Qqswkid6RQo2jPV3qUXMOhsxNwHyXk6vFHGBDrbJel
	pQK6dkKRa5dckXzYZL9aUnG3nKfs1UZjgUGZ2P5d2B531AAf7zj23o5/OsvtTu1GB930XXbg2Ok
	iyxIN/P0=
X-Gm-Gg: AR+sD13lS4GZYjMIDS/x5jn8YMWMXQtXMbEzz23nEsAlTsdcQCbta+kBWnS2oznFdIS
	X0HdisOxbjxUiviFAvPlCPSXKAbx0esqihogxttFXq+vSYkTlYr/rpz+SdcpDFBhKtPAASkX4aS
	oV8fzfGEG8o7GDv8h1yORF7omeKkium+pzr7rjVdxFNz5j9/kZzTH1vW6gCpz6uwxIbE3lwHts8
	phJNZnETe8bkOmcIY7u91yvz3K9K/wh7xQuvgzXfJ/4a4OftLQEu4/G+T4eH6QAp7PqYm+Zb70Y
	Lops0XUpxXTjQ4BK61zMK3zSpr3o8WsiNOcfM0IlPncR9V3B0LzPjEm7bRQGsE8xCcREPGx8kRe
	J0luZJP7wAPbO9rjPS598i3UtVHm4PejeN9Tcs3jg2euyli4V97phubuisgyKUvJGNfdYNCOmH6
	avKzmb2eNjn/8bIYdT+YareQkKiWOuorjXT8c9kRLmdZGaT+J2fMKLLXZl1LKCOhCxTOsoo1lHA
	JC7HGKARqQc+jHtByLfDpG/jcSbnw7eUCBMfrti/cYlYWlWWeXZED2Y8FU0EvTXA6rHfYRejfm/
	OO71izYr0buxp2hhdTiNUdrW695aD8CSw6wcqw==
X-Received: by 2002:a05:6000:645:b0:481:5b58:c589 with SMTP id ffacd0b85a97d-482e26b380amr15868293f8f.10.1787827892118;
        Thu, 27 Aug 2026 03:51:32 -0700 (PDT)
Received: from smtpclient.apple (host-79-57-139-67.business.telecomitalia.it. [79.57.139.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28fe2ecsm8191582f8f.37.2026.08.27.03.51.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2026 03:51:31 -0700 (PDT)
From: Norbert Szetei <norbert@doyensec.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: [PATCH] RDMA/rxe: Reject prefetch of a non-ODP MR
Message-Id: <521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com>
Date: Thu, 27 Aug 2026 12:51:20 +0200
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org
To: linux-rdma@vger.kernel.org
X-Mailer: Apple Mail (2.3826.700.81.1.4)

rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
so the container_of() in to_ib_umem_odp() lands past the end of the
object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
out of bounds.

lookup_mr() validates the lkey, PD, access and state but not the MR
type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.

  BUG: KASAN: slab-out-of-bounds in =
ib_umem_odp_map_dma_and_lock+0x884/0x8a0
  Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
   ib_umem_odp_map_dma_and_lock+0x884/0x8a0
   rxe_ib_advise_mr+0x543/0xad0
   ib_uverbs_handler_UVERBS_METHOD_ADVISE_MR+0x446/0x530
   ib_uverbs_cmd_verbs+0x2b3c/0x3b20
   ib_uverbs_ioctl+0x1e3/0x310
  Allocated by task 921:
   __ib_umem_get_va+0x13e/0xae0
   rxe_mr_init_user+0x2ae/0xb00
   rxe_reg_user_mr+0x337/0x510
  The buggy address belongs to the object at ffff88810a3ebc80
   which belongs to the cache kmalloc-96 of size 96

Reject a non-ODP MR after lookup_mr() in both the synchronous and
asynchronous prefetch arms.

Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP =
MRs")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c =
b/drivers/infiniband/sw/rxe/rxe_odp.c
index e870efa7a0a3..5c9dde3501a0 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -472,6 +472,11 @@ static int rxe_ib_prefetch_sg_list(struct ib_pd =
*ibpd,
 			return -EINVAL;
 		}
=20
+		if (unlikely(!is_odp_mr(mr))) {
+			rxe_put(mr);
+			return -EOPNOTSUPP;
+		}
+
 		if (advice =3D=3D =
IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE &&
 		    !mr->umem->writable) {
 			rxe_dbg_mr(mr, "missing write permission\n");
@@ -536,6 +541,12 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd =
*ibpd,
 			goto err;
 		}
=20
+		if (unlikely(!is_odp_mr(mr))) {
+			rxe_put(mr);
+			mr =3D ERR_PTR(-EOPNOTSUPP);
+			goto err;
+		}
+
 		work->frags[i].io_virt =3D sg_list[i].addr;
 		work->frags[i].length =3D sg_list[i].length;
 		work->frags[i].mr =3D mr;
--=20
2.55.0

