Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B4947D945
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157568; cv=none; b=goHd+Pvuc+kMZuu/+ENHUdBqtaKE4kAab6vyjPnZp4gXmTQveoB0M+VilVZHiQIftESn1c87gHctmzrLkoPYTkhsuQqRJW4cOkr1HMHF5gam9BGxcYdAhGoCj/xtyugVAMql7pEikszbDWHSTRMlFuEBtcjgKS3EB0t4YaHJuFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157568; c=relaxed/simple;
	bh=NCxIQadpnA8sT0y1g6N0HBx2UG8A25VXEZOEbh73unk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uCnBmRlycsXvQ9ABujfGUzonBI/zViJ7wExg4m+/PrPZZ2gMj7ivBX1Ga+GBfrf9IAdGYDfO1u5pigMHkLUoCgGpTPlEs/NY8mcx98/k11tFzXbFqaIkpfCSpxrZ0PqcSoPhBqAuA+y01zNu34wN8rn7yyLjgXyVakBJKjBDCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8jwHSXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8jwHSXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9FA1F00898;
	Wed, 23 Sep 2026 09:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157566;
	bh=NCxIQadpnA8sT0y1g6N0HBx2UG8A25VXEZOEbh73unk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a8jwHSXj7OUSj1YCs6vxpxH6LtsGltpG1bwU5gOxKs4bbJuENeq4CzthusXIKDZQg
	 sNJ9EbuyT139AtvWM957OX7TRezwpYkqAaQcMAGROHYh/OGnvQ4NVBa20yJ/326NlT
	 Nj6BCiryHS9PgOjvV6IhkPgfvooptuvHHVXmsRJb+230ZJ3B+cKmENOUel1ETNyY36
	 3eqUAPFrd86Iu7cH6qvq+hNVLlm1H0QRU+KnDzqOetz8w5lJ3wP7kPxatuNLa/T4co
	 13+uqaFzwxn5HTFEH7r4Fq7YDCVBgptKk2TA8cubDMfp85nOJw3Ef+MSIT1KGC+tLm
	 kM4tqmbA8az3A==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 5/5] RDMA/ionic: implement SRQ event handling
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922095724.3683011-6-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-6-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 09:59:26 +0000
Message-Id: <20260923095926.9B9FA1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> Introduce SRQ event types and associated events. Report these events
> through the SRQ event handler during event processing.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922095724.3683=
011-1-abhijit.gangurde@amd.com?part=3D5

