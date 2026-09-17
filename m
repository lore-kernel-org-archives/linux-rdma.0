Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3023E4E2348
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647070; cv=none; b=SmC0ntghlJziK2/tCUJuNwwxYj0y7cLK/AwAVzC/9RR7t6AZIB9E5fDrJHFnHG51hAVu5WpWv3/MPx9r8Rlk9GzSdUI9Kqu46KCMCxOQc1O0v2liv6JoqTJGmrw8I0w5B3jZ7eiJD4Vh+K1zuxCq6tH1GcaAatit0Qcs9zskDsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647070; c=relaxed/simple;
	bh=P4H3Y2xDaEEabQEcIMnmROuTsu+Fr/83V/nNqCvXS7M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kBwJvr0gDyYH3pS0uOewJ2xDnfJkeuuq9PrGp0o+Aef/hSH9Z55L7uR1Nr5XbnRZVNGQWgCzkF+rBRf58mx9oPLL4vmCTPnGvQE/6zBo9OnlQ3YTOiIF+bFIefY1DQaPEWUiDRzOCt5qUpRBpf6ZdsXLe08KIM7hgpkoUmtq6A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6qYNgsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6qYNgsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B371F000FF;
	Thu, 17 Sep 2026 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647044;
	bh=P4H3Y2xDaEEabQEcIMnmROuTsu+Fr/83V/nNqCvXS7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I6qYNgscN7KS2zbs5CVpFEHW/PktzSO10frggIDHORaMCmRzrfOUvnpQVJwBVfDvf
	 9VrVJj/gVS8DUBZj2NPDcbaCPk7A3hZroqB76/KoujM/i9jn1Bq2OZ/shmlmP92sgR
	 PFHCyaYGCp78itONNsnCC7yxZSfDYVMPHoo2JYODUaAfREu0OjuxVFGGZoqySlBw8V
	 jCljTUjSPLyvd306xCeb/4VRK88opChmoT2/FAmlMnZz8uRbobw8GVe+lu5odcYh1r
	 iA10VaH9qP0rDpQ/IqLwuOMZaZkHi6FD87ZtVO8EqLdl/rDa05Z8Td9PL9y2H3aA7w
	 088c94L3Ce/sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v4 5/5] RDMA/erdma: Move kernel QP helpers
 after memory helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917120459.13286-6-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
 <20260917120459.13286-6-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:10:44 +0000
Message-Id: <20260917121044.71B371F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Move the kernel QP helpers after the shared memory helpers to remove
> forward declarations.
>=20
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917120459.1328=
6-1-chengyou@linux.alibaba.com?part=3D5

