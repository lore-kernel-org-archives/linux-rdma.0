Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525CA2DC791
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846661; cv=none; b=Nmm1v8P2hdtr+aW42DeNXUSNLlMIWdFx9Q/uM592sJFn87TdrobHrkvmn5haacvhyeB4SFLTMrGgtFTrYZwPCpUg+b+Cc6oJDOrtHG9nQEg5xxUqk+uZb0sllRlmimAYWRmzSIlSUbEcQf6rg4WAFuBooW6wym7CdKFL7ZvhtE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846661; c=relaxed/simple;
	bh=D3KS9IgmkkVLKoSLmiU1ocr9orCLYhWagCZrAro3pUA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ey+2rqooyVz9QFqi0xYIXcOvTi9vZDRJhfrKwQKvD47uM1Y7KGbVrZeoTA/DKfrLKlE7juTsvQ586zL3DwyaXQB1rdH3+nmSuDSbl92XQxdKXIb59ORsJEsYUuBXxe/i/f/WttU1wWHMwFAJtyvdORMaolPf8pmiVfIz2Tg1wmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NImvN/8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NImvN/8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9387C1F000FF;
	Thu,  1 Oct 2026 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790846657;
	bh=D3KS9IgmkkVLKoSLmiU1ocr9orCLYhWagCZrAro3pUA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NImvN/8VY+tP6dniwmXD7yWkJyYMbXVFOxv7b+KMykCV41sG8PXlTFr2VJhzqRURv
	 g+kYo0qTfg76EAFF6fB90HlM12adU8LJW1TeCnmDzAXEuranIucG+unAiiPcGwbpM4
	 sM5mJH4Jo/zW+jCExEPTEBvaW4FKBl90q/ZgYYIvafsIEWMP4HqjuAsWUaB0IrWAAu
	 7VUhVicQdJwNRA8csk5TVnEQxEkA5Ymsi9DU2ODjbMODvqGpBMBvQ75PiIDn9wAbVi
	 nhz2J/Tm0lf+RBIw248pY3UneNaPTmNjUf0St+3Q2uGL4bcpvR/roWJCMNbRRsVIbX
	 so21t/sAQp0iw==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v4 3/5] RDMA/ionic: segregate rq related fields from
 ionic_qp into a new ionic_rq struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930092111.3176738-4-abhijit.gangurde@amd.com>
References: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
 <20260930092111.3176738-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:24:17 +0000
Message-Id: <20261001092417.9387C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> In preparation for SRQ support, segregate rq related fields from ionic_qp
> into a new ionic_rq struct. This refactoring enables both non-SRQ and
> future SRQ code to leverage the common rq init/destroy infrastructure
> around ionic_qp_rq_init/_destroy with no functional changes.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930092111.3176=
738-1-abhijit.gangurde@amd.com?part=3D3

