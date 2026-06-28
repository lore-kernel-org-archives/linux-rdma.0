Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F4619539F
	for <linux-rdma@vger.kernel.org>; Sun, 28 Jun 2026 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782627924; cv=none; b=WMwTtFmAIUtGPKW340wB5uE+wIX4ys2DCXyqCZMMeSNtHStx241GzGvhfLDvwHun6HV7arPKMfq4XoWlWkZJvRjkwMsBSchr222DzlY2Wy0m4+Q3oViNF/gIlddxwZB+n4cjrdvhl/HbVmGm+12dF49vsQpXLwOkOTkxh/z4byQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782627924; c=relaxed/simple;
	bh=wx+Ihvw2j97Zi2vd35K0siuXw9YsYfc9TFRBPWgYmKw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qC50NSDU861uKIHxVJRD3OyFyxHBTBoRGgMrQMW/ccn4FDm28g+mkCs3rFzl8OzZmj7u0A9Xy8l7TyP5KwI+rpdK3MWHT3+sSgGbDXqH8ITggsXfqbJrRsqiKKZY06ikPrXS6u+Mdot+Ba2pEv7fCCVdUM4wDR+7Kwaf6ZPq6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=l7ftEBAr; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="l7ftEBAr"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4gnzt63zRqz9v1S;
	Sun, 28 Jun 2026 08:25:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782627918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wx+Ihvw2j97Zi2vd35K0siuXw9YsYfc9TFRBPWgYmKw=;
	b=l7ftEBArXQ+eTSkkUG2ukXb2/YRX+dIAGv6+A71hhQDxZQDh6k/7hNesbeCsNJZv+/leBT
	99lwd4yNBe3Z97c/L8cOw8EMmOPCdtHEXXHr3dlydYPjE06wmS5FoO8V++KYGhOCsnyGeo
	vGxB5jnUtM9YV6p0PEO0YFGWAQLnx3K/KXZ1yHY6ZyjK05ooZplaj8j6/jokYQwon6kwSE
	/0cF9q5UKbgFQT91l7dMQGBhNzMP1kpL9DproUv9QJXumSNbcz6/W5E9Ou5M45r6fsK8hj
	VoaB3q3iuwPU2/ZzsI9FlASJxk1tRl6OSI9DvHIrh16OpzZM3t06ZGmEv49+BQ==
Message-ID: <2ee49f1c24d886cec6a24a0242cf44fe529b9e28.camel@mailbox.org>
Subject: Re: [PATCH] ABI: sysfs-class-infiniband: minor cleanup
From: Manuel Ebner <manuelebner@mailbox.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org, 
 Jonathan Cameron
	 <jic23@kernel.org>
Date: Sun, 28 Jun 2026 08:25:15 +0200
In-Reply-To: <20260612142109.GA1879774@nvidia.com>
References: <20260612122611.183127-2-manuelebner@mailbox.org>
	 <20260612142109.GA1879774@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: 65075e91ab526149924
X-MBO-RS-META: u9d17r6qyedrwt4cwq94yhwnrynpq6j8

The get_maintainer script didn't return your e-mail-address for this file:
Documentation/ABI/stable/sysfs-class-infiniband
Please consider adding path(s) to file(s) or directories to your subsystem
to MAINTAINERS.
As suggested by Jonathan Cameron.

Thanks
 Manuel
=20
On Fri, 2026-06-12 at 11:21 -0300, Jason Gunthorpe wrote:
> On Fri, Jun 12, 2026 at 02:26:12PM +0200, Manuel Ebner wrote:
> > Close parenthesis with ')'.
> > Add '-': 64-bit counter.
> >=20
> > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> > ---
> > =C2=A0Documentation/ABI/stable/sysfs-class-infiniband | 8 ++++----
> > =C2=A01 file changed, 4 insertions(+), 4 deletions(-)
>=20
> Applied
>=20
> Thanks,
> Jason

