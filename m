Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4A72E9730
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027874; cv=none; b=njyKsQqW8mnbkrY/PJCk0mA55du5U3NKdU67GRC0EYuEsLyVCd9yff5eI89tG5p2+9MQ+jLe3xRcN/a6Hztb3S9kTzrRlod27hONAKEGDa86wmZ8gnfLzAjC0ouVmMJMOr4yE/e2ESkDTMplxQsV0Ord2XWQ+9ouJ3oBSjApe98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027874; c=relaxed/simple;
	bh=8RDej/scNHLdCMxwD9NudQOO/W/fbkfBP+J7EfTsCK8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=a8tZqPUbl9hE+emumWvzTevi2qizHQm7CBSNYeUmsAJNkKEXYSaiBflzYwSUi1wP6hx+tqSgJGIpgwzKqfd7z+2X/txIoDKLzxeCPi9ud/RrnVx0+7FPiIR0arG8IPOUX5auSySCxl0QqQORRnFv99UShDPJ0JFk6K08+jzwArY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDVkPME7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDVkPME7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C278B1F000C4;
	Thu, 15 Oct 2026 01:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792027872;
	bh=8RDej/scNHLdCMxwD9NudQOO/W/fbkfBP+J7EfTsCK8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YDVkPME7m9IOOzuYMICdUZC5CDADHm6YwC5XO67j+DU7Qr04BGH0mzab0jHZ4wY7W
	 HhoL2resUQohdaNG1fz199kmwABlU9DgbXuOieCB3T329fu2al0ovzQRWjJd+1o/80
	 LAhfvW/V0mTqYhUYzGGp9Myx0gmOkw7uOd1uhLnjF4D+jhdY3VdExpx7OLwoMFhR24
	 WU0TkX30U0PRPQ0zsutrX3Vxg2/o0Qp1HC7ZcYhGLkcgc34yXdh4z7KxFKq1NbDkF/
	 83nKKTLjuV22BPDGBdCGqd3jgNPnZSp8TJNgcFbx6L1HajYhwkHW+9ySd6JRXvNNbM
	 vYPl3OliFKnSA==
Message-ID: <sashiko-outbox-172094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 1/6] RDMA/irdma: Plumb uverbs_attr_bundle
 for QP, SRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-2-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-2-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:31:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> In preparation to support modern UVERBS ioctl attributes (such
> as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
> `uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
> uAPIs provide `ib_udata`, we derive it via the helper macro,
> `rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
> `uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
> and SRQ.
>=20
> QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundl=
e`
> as a top level input. However, we think it is a future project to unify
> them.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D1

