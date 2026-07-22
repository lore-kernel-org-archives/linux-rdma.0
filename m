Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E67476CF3;
	Wed, 22 Jul 2026 11:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720483; cv=none; b=qB3sOowJoyuGEPPgkMj2GePYsWg+6qDvAo//mPM4jFdelobY+noiLWlDfQj++irNW1oFHP8dJBh9Q5CzE6pPfhCVIO1bYHR86CyuFDqjArlwnk3YinuICu+60/LOiTNwTZObrz+RBedIo4x0QIgGbEdXiVR1BKti7GTsWTNICOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720483; c=relaxed/simple;
	bh=0ftvktwqXd4AEIzv8ZYm6+pqNLGaFQ42ISsKWfg/iQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cqZlb2YZC+gg+7u0NaXQJ9e5vZGoKdEC/aXwTY5VqL6ae+HZ8AZXjNWqbpVEui4IHunc0yukV8OlgFpiaaSGM+PgUPU8x3sYBjVqGRtL4ciGjoWba0SZOMalzjX/DjnGNC4AU5ViW+LmSnCCD2jLrZAR2eKoa1jWAyh0+ZRccBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fz9OCQEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fz9OCQEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EDD1F000E9;
	Wed, 22 Jul 2026 11:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784720481;
	bh=guKLbL2WNEO2Bt7eXQkLJQUnQbT5pC7a1gkKMg/9oh0=;
	h=From:To:Cc:Subject:Date;
	b=Fz9OCQEHyEtFS1RnPNcsCEZlduXM+YkG2BZhb8iq1uOom4Ps1HaluGcmlbJYuMlWv
	 q/YIFjBVwh9K2YK5CaUe2Lzu8BxUGDrd8FlWBXKtc42vGSOEuEpolYlz9Ma5rhWxDv
	 KNdZosUN2bgKqB38DBEyGsOkXwah7kcHJmm3NKlt9lNrFV7gzdIRr3Wwbw4bJre0vf
	 sukuwb3gXkYVB5bLrkBLGmaRaOihQJCyj1b5h9XCUqIx2eqhGXkVScjesviDh5cRi9
	 gMXlZezbth7WBJcVHz4L+rmXft6wiv15SLgOOniZlqXYO27V1Fo1PrGbzsJp6JJmkw
	 DVKcKVCOXSgHQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mlx5: Make sure that UMR page is aligned to PAGE_SIZE
Date: Wed, 22 Jul 2026 14:41:13 +0300
Message-ID: <20260722-fix-get-order-alignment-v1-1-ece212ddb5dc@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260722-fix-get-order-alignment-b35d7958832d
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: quoted-printable

From: Leon Romanovsky <leonro@nvidia.com>=0D
=0D
The UMR XLT buffer needs to be aligned to PAGE_SIZE.=0D
=0D
Fixes: b2022068dea0 ("RDMA/mlx5: use kmalloc() for UMR translation buffers"=
)=0D
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0D
---=0D
 drivers/infiniband/hw/mlx5/umr.c | 2 +-=0D
 1 file changed, 1 insertion(+), 1 deletion(-)=0D
=0D
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/=
umr.c=0D
index 80d0d190b26c..951de1d85632 100644=0D
--- a/drivers/infiniband/hw/mlx5/umr.c=0D
+++ b/drivers/infiniband/hw/mlx5/umr.c=0D
@@ -518,7 +518,7 @@ static void *mlx5r_umr_alloc_xlt(size_t *nents, size_t =
ent_size, gfp_t gfp_mask)=0D
 	size =3D min_t(size_t, ent_size * ALIGN(*nents, xlt_chunk_align),=0D
 		     MLX5_MAX_UMR_CHUNK);=0D
 	*nents =3D size / ent_size;=0D
-	res =3D kmalloc(size, gfp_mask | __GFP_NOWARN);=0D
+	res =3D kmalloc(PAGE_ALIGN(size), gfp_mask | __GFP_NOWARN);=0D
 	if (res)=0D
 		return res;=0D
 =0D
=0D
---=0D
base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90=0D
change-id: 20260722-fix-get-order-alignment-b35d7958832d=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D
