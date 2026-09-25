Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7679E25A640
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 09:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329618; cv=none; b=P3hvJo0vKOxhE249XvxHIlUZ7MV4/NQVQtukm4kX+UKuVS3OmQd3djATAY6OQgSUdMXDg1hcJ7my2u2Q/Pd/DL3mkNAT/zYbtcNK7+N8AITCQpAn0kMxYLrKwlbjhjrCLTeTmU+OF3D5XGPQhlHjsbF8gwAtHPcjB987UU2BPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329618; c=relaxed/simple;
	bh=2CwEiLJRKlGG8n196XngF6ufXRdcu3dn5m7uz3lCf5M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AVdlF3cIevRHk26X5VAIxIl8CVGeV71zAWQjBvd6/Ur16/q6fZKZOJoRQW2AcVRdnrRR3ZTBy88JSpzzmw1L2smbjcjMeuho1JaRaHnX6IwEkf7A+Fsqj5zRX3SQm70Khy+GrIoe9TTV1W0GqfhMKbUxuO94WFx0V3KN7tsZ4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eH8BxmOK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eH8BxmOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288A1F000FF;
	Fri, 25 Sep 2026 09:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790329617;
	bh=2CwEiLJRKlGG8n196XngF6ufXRdcu3dn5m7uz3lCf5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eH8BxmOK2qBx8SHi3qQ3ZVygZ7SxfYg0yQhk165mjk5gob3mLkkn6kuCo2yWbxOlu
	 9bFWSTtulS5q3cWJeIbz6tgCbR5aXQZlepAmgB5zagbYAwRouZSREAP5xY7ABQPFoI
	 X99RDrcyNXVJKodzqfNbWiNnbuX0fIq9IfBjhq9D7fjUedlqWSQBq2GNYCIpjn+mKc
	 TFnSuiVe5nAVmX4qY/T90otjrtPtY9pc6Gn/3ZmxBN+Zg/Ld9t4aJOmNMWhWaTIT/n
	 86L7HmN24f7TwUJEnKL7i3Jzn34NCIauNMCLKLykRaRMyu7K9s3dup7DzwPk4av5yX
	 8s/V/ed6qgfQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] RDMA/ionic: Fix double removal of CMB mmap entries
 in create QP error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925093638.3032149-2-abhijit.gangurde@amd.com>
References: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
 <20260925093638.3032149-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 09:46:56 +0000
Message-Id: <20260925094656.F288A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The error unwind in ionic_create_qp() removes the SQ and RQ CMB mmap
> entries explicitly, and then falls through to ionic_qp_rq_destroy() and
> ionic_qp_sq_destroy(), whose ionic_qp_{rq,sq}_destroy_cmb() helpers
> remove the very same entries a second time.
>=20
> Drop the explicit removals and leave ionic_qp_{rq,sq}_destroy_cmb() as
> the single owner on the ionic_destroy_qp() path.
>=20
> Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925093638.3032=
149-1-abhijit.gangurde@amd.com?part=3D2

