Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809B40B6D4
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851105; cv=none; b=NVRQObvvYPMZPj3GxcQtYJXZRCSotVurwwxQugB8J5gP6CKoeXn2eF9kdC7aJ8XB4KEaNkrubpBlwmbhIVaYfa2yK6EXIznYOiyB+4SxXRZI6nu0i+BMEF3V0j/S79wbAc2yqvbicM5DQfwXMQ2NUlDssKRwIBdoPabfEqAB5DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851105; c=relaxed/simple;
	bh=LsMiDXjkerVTOWQnAF0ofr+ci1u/rnEmYltIw6dBU/4=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=gVzxduX3sjT9/3/ClAa1xp0lOg0fKaDb6Q8q8Bur9h1qaRvWAW82/9LTL532P1Mkwern8r/1bZI1uR3Qy/akVxPP3m2SnUBt4VpWmJbg/4RjxmaY6isElKOHRHW3LqS+htFg6okZcY744qbLdrpPrjbyh0a/3GFFlguMYhRtMaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com; spf=pass smtp.mailfrom=doyensec.com; dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b=MZcGyA0B; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=doyensec.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=doyensec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=doyensec.com header.i=@doyensec.com header.b="MZcGyA0B"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49557167508so10170665e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 10:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=doyensec.com; s=google; t=1787851100; x=1788455900; darn=vger.kernel.org;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5i/oaHxuX43NHIxwgv4BaP7ocJk+hI4zJpfLWe3Zp/c=;
        b=MZcGyA0Bk70iAdZ+Hluzt+Jf4U4KuS9oqqh05/bLOItmNbHKJ0LTcBXVrmOuwfOaeg
         /UVogKeJ+CM32vCC/gB3xKW2hl8G+6JpnPPxt4FImNn03KwxFj77Ca9eou/yqBgJwsHP
         NSGBdxKKJGz4L9Ayw2a9/25LDQ6spRfqSDTXDGgbikMlV9jyGBlTe87EfVMI2P4ZRBMj
         sjY2V6mvkdWoS+mQWqF/yhlBGRTVrNHF7jt8NzN847oaruoTR9yGoQdDFmf6U6Eb+lOr
         8D27B8c5TWKoKASKPJg4bdoIEd7vEkQib0PToKQlQghSRC0QNT7iu/tyDEVAoTOEmjJ0
         4YzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851100; x=1788455900;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5i/oaHxuX43NHIxwgv4BaP7ocJk+hI4zJpfLWe3Zp/c=;
        b=baRv3JL2XO+7p0bIClpeugye8G2Q/aEbUtABK/93EHQ+dJIyiT5e/F/22t7HIL9Von
         c2imlaNB4OFGnx140F6yAQ64Hz7mYsVrIyihjLyxj9AZU5Obd0ZWwYtMYxDosn54/N+Y
         opdsVwhvWKU/dNC610Pl7ZOAqcAyIBoF+7pk+IEP7QmUtQTIdi9sfVUHbbrabR9rp0HW
         elxFqYI5MXI2pnRO/4+PVAn6ZQOD/Bu750w9f51km0f7yNTvVPCr+ptr2hyi78/CbLrf
         F5k2YqVBUO66BrKG8cDdKhISgStRowYbZU6uuk1Ou3sdkmdibrNwVXpJIOkB11PTsE/O
         dWgg==
X-Gm-Message-State: AFuF++n+Y2El57n+/RMolD3JHMG37IUiFpyHts1mIiWFT69F9cj8caJQ
	/RG0B7nycXkH0f9O3AbJv1f/Uq+H9vVKJL2hFbT+IFdvsA7H3umvp8RTlGogf2dfN/WQj1+YaLy
	pL+nAnJE=
X-Gm-Gg: AR+sD11ZjS6D2v1IXPqV1cPEBW7n73JfMjGEZXt/QIg6pmj3JeaGmKMMl5CXR44tFKC
	Et8FBqW4vuBgqYtzVTtth5bnvPwX20A0XaY6p0XxS6bWTX3YbJQLIKrsVzNdZENXdyrFCHgxCzb
	AnGxS+2+WSrLFYzkLRJ+oPs+UrtK43Jtr7V2yQVW/swQMXPWD2oiLNW/1zv2XB6/jU0RNn2w/OC
	tNvJB9P2rdRpqaQTzY3r2gG+SOirdq4FxqS/iHHxkRVH+pXBitStzOhZH3EELlq82hL7qBVgcxW
	SCszC8HuAspbdySCyKApLqInP40pZr3lfDwWi3QrT3vrVjLSjph32Of2CSUM5s6ioemyFB+gz89
	R7LzbCP5Hf5l7uclXPkSzO3Gl6TfSaaND9hjiehy0NK2GdRk5AmfzhnG//CW2HE8FgsDLN0Xj6w
	EUuL64hZ4genmJMWpHOCulUkgnLkVSfTifHpINAfUzQyi64ZIAl4NjkiUAMAF/6+ESqw8MBgVkQ
	Vee/OWCfM0V3vV+2U8DthOrCHi6aAcHf919kEN/GkM3IZ8F/qlugGiY070kcW7saacyqoGsIdaK
	50/U+iMCcpYXqZnFCfMJuyiKo979QYvSiYbiTQ==
X-Received: by 2002:a05:600c:4f86:b0:496:bbce:fc with SMTP id 5b1f17b1804b1-49b91c4faa6mr5036425e9.12.1787851100141;
        Thu, 27 Aug 2026 10:18:20 -0700 (PDT)
Received: from smtpclient.apple (host-79-57-139-67.business.telecomitalia.it. [79.57.139.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b4e2c1af7sm67145705e9.15.2026.08.27.10.18.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2026 10:18:19 -0700 (PDT)
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
Subject: [PATCH] RDMA/rxe: validate access flags before swapping the MR's PD
Message-Id: <46E1D5C0-24BE-4D01-BDB3-634FE09B22C5@doyensec.com>
Date: Thu, 27 Aug 2026 19:18:07 +0200
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org
To: linux-rdma@vger.kernel.org
X-Mailer: Apple Mail (2.3826.700.81.1.4)

rxe_rereg_user_mr() reassigns mr->ibmr.pd first and only then
validates the IB_MR_REREG_ACCESS argument:

	if (flags & IB_MR_REREG_PD) {
		rxe_put(old_pd);
		rxe_get(pd);
		mr->ibmr.pd =3D ibpd;
	}

	if (flags & IB_MR_REREG_ACCESS) {
		if (access & ~RXE_ACCESS_SUPPORTED_MR)
			return ERR_PTR(-EOPNOTSUPP);
		mr->access =3D access;
	}

Both flags pass the entry check because RXE_MR_REREG_SUPPORTED is
IB_MR_REREG_PD | IB_MR_REREG_ACCESS, so a caller can reach the access
check with mr->ibmr.pd already reassigned.

mr->ibmr.pd is owned by the core, which adjusts pd->usecnt only on the
success path: ib_uverbs_rereg_mr() jumps to put_new_uobj on a driver =
error
without undoing the reassignment, so mr->pd =3D=3D new_pd while the =
usecnts
still charge the MR to orig_pd. ib_dereg_mr_user() then decrements
new_pd, whose count can reach zero while a memory window still =
references
it; uverbs_free_pd() frees the PD on that count alone and =
rxe_mw_cleanup()
writes to freed memory:

  BUG: KASAN: slab-use-after-free in __rxe_put+0x31/0xa0
  Write of size 4 at addr ffff8881301dd690 by task rxe_poc/591
   __rxe_put+0x31/0xa0
   rxe_mw_cleanup+0x42/0x200
   __rxe_cleanup+0x115/0x370
   rxe_dealloc_mw+0x4c/0x80
  Allocated by task 591:
   ib_uverbs_alloc_pd+0x258/0x540
  Freed by task 591:
   ib_dealloc_pd_user+0x174/0x210
   uverbs_free_pd+0x8d/0xc0
   ib_uverbs_dealloc_pd+0x18e/0x1d0

Validate the access flags before mutating any state so the callback =
either
applies every requested change or none.

Fixes: 544c7f62cf32 ("RDMA/rxe: Implement rereg_user_mr")
Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c =
b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 96c7716057fe..3864284522eb 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1331,19 +1331,20 @@ static struct ib_mr *rxe_rereg_user_mr(struct =
ib_mr *ibmr, int flags,
 	if (err)
 		return ERR_PTR(err);
=20
+	if ((flags & IB_MR_REREG_ACCESS) &&
+	    (access & ~RXE_ACCESS_SUPPORTED_MR)) {
+		rxe_err_mr(mr, "access =3D %#x not supported\n", =
access);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (flags & IB_MR_REREG_PD) {
 		rxe_put(old_pd);
 		rxe_get(pd);
 		mr->ibmr.pd =3D ibpd;
 	}
=20
-	if (flags & IB_MR_REREG_ACCESS) {
-		if (access & ~RXE_ACCESS_SUPPORTED_MR) {
-			rxe_err_mr(mr, "access =3D %#x not supported\n", =
access);
-			return ERR_PTR(-EOPNOTSUPP);
-		}
+	if (flags & IB_MR_REREG_ACCESS)
 		mr->access =3D access;
-	}
=20
 	return NULL;
 }
--=20
2.55.0

