Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F173E1CED
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790093265; cv=none; b=eymGRyLKLqfb7btwhiXk469xjp+unyhwSe4zWMXQClsh4/1EaoAXD9prOYBgH92b++2Hc0ye56gjiPZh4P57RF84D8YGoRhXB7bHSsJZ+nXpMNppuz97YC3kpmZujo41nativHJ0t0vGq597fTZMmEYrPbCbA8s/izBV9udw5l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790093265; c=relaxed/simple;
	bh=2f4wsAavbulhjPF+UFaXHOUy3ORbD9FmeRVTUn2qnHU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FmbANCYJfFsENCWwcsOX8ZsIo/3tOuZgzhoTH2TZo2rMHOfWZP0L9dgnNwbwmzhIEuYwHXK6NlRL8FVZoDn74VqBeCT5UVccd2OQpqyHf0+b6alEYlV2KGlB0rBOZKWvFH32Lwy3s3x7Ro1B/t5TipbMcb6j9m3sQjPJiowMwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fD2VyXRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fD2VyXRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C741F000FF;
	Tue, 22 Sep 2026 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790093264;
	bh=2f4wsAavbulhjPF+UFaXHOUy3ORbD9FmeRVTUn2qnHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fD2VyXRd240zY98G483rWi1t/0gQDWxAT1OSIcjjGHFqNpLBpWNf+MeY23jlq9s6j
	 vEMNCaWWg0wdrDZDiDN+Kyi6Bp4D/SK0vj8u9whLirV8aoTQ0VveOkSyYrG4GE2Sor
	 KFQV0/geA/h4mvtB0nf00uf5skQ42Urrf1Hf196nWMjdFz4Z/VseNARTueUcQY+GyI
	 h1BkiSuxgXzgCFR45xta2FfwPIe5dntMprqKgVFh8Bi1G61b+T+5WOcFQ49+V+f2mL
	 a2lMc7iNtL9Fse151iVdyZGbMf+G+uDCsTE+GTc5VQcvJIwpoGLPU2wi8hh6nCBjBu
	 M4mrt4RpDpiXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v3 1/2] RDMA/efa: Use device ABI MR permissions
 instead of verbs flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Margolin" <mrgolin@amazon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922160118.990-2-mrgolin@amazon.com>
References: <20260922160118.990-1-mrgolin@amazon.com>
 <20260922160118.990-2-mrgolin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 16:07:43 +0000
Message-Id: <20260922160744.05C741F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dana Malachi <danamala@amazon.com>
>=20
> Set MR permissions explicitly using device interface
> definitions rather than copying raw verbs access flags.
> This is needed for the next commit, to allow access flag bits
> that are not in the permissions field.
>=20
> Reviewed-by: Chen Brasch <cbrasch@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Dana Malachi <danamala@amazon.com>
> Signed-off-by: Michael Margolin <mrgolin@amazon.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922160118.990-=
1-mrgolin@amazon.com?part=3D1

