Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F124BAA1B;
	Thu, 24 Sep 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271793; cv=none; b=DOzs9FIXPSiGggLs8pJa1s4gVIt++yPEODkL0Ffbu6195GuGua7x/uppSd/3Yg8BeYxdMbk54yPNUUoY7POjJOwaF823IfPH3MzpHMeR39VhIlCDKpICQV/FtaSg+wi0zSlD3R673b3PhoEzzJueKe/Qvm/nvpqBT3x1bl951BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271793; c=relaxed/simple;
	bh=YLiU3f4uOq/jDFDbO/Z6w5u6clAMhILwTB3uH5L2RKE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DznCDCRpNI9WyZkgSJPpJSsl/0ps6ZivSHTCTO0/fowZyOouSTlO0D7WtxiVxrvVP68MASo7+Ru+NJYMaF7PNkmmwrr6FQ4WJfnIUnOzXLj37QAWXyCYGyO5rR5YU/J8zrHLsTp7hJzkgkQqgzqaHI5XVjH0iDgpB/kICQDLr7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve+aMQoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve+aMQoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797EB1F00899;
	Thu, 24 Sep 2026 17:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271791;
	bh=YLiU3f4uOq/jDFDbO/Z6w5u6clAMhILwTB3uH5L2RKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ve+aMQoAzrUOgFHW/yYFeZ6M6NzPPNU7v8tM6MjWbQBiSQEi+wxleRmHxeU9SyGCQ
	 Kr3qHKH4SvTFKYkMGsf5EdjK73QlRZW0tyB12u9dCZsQg75x+hrzWGIukPSOa1Jq/X
	 Ojc8Ylpy1ylCN1nAjMC3ivHAC1JZ/lD+rr4vI2++A0hdY3uA6YTE0f4MBuJ1KTzM6Y
	 +Lin9QKGsMDRazgaL7L+DscW7x4tVGr3ybaZNr8L040QDVDBuSWiC4E4PmJ1dO+WSL
	 HOE73DHiKcGMf5DIHr19OPGg7H47te2/N8f/GPWsObCh5CAn2W8zOeKpFwdEEffkmK
	 leaQ33pOArTyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/4] net: mana: Build the PCI transport as a
 separate module
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manish Awasthi" <mawasthi@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260924173054.589291-4-mawasthi@linux.microsoft.com>
References: <20260924173054.589291-1-mawasthi@linux.microsoft.com>
 <20260924173054.589291-4-mawasthi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:43:11 +0000
Message-Id: <20260924174311.797EB1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Build the shared GDMA and Ethernet code as gdma_core.ko, selected by
> MICROSOFT_GDMA_CORE. Build the PCI transport separately as mana.ko and
> export the required core symbols.
>=20
> Preserve the PCI module name, device table, and mana.eth/mana.rdma
> auxiliary-device names. Each transport registers its own bus driver.
>=20
> Signed-off-by: Manish Awasthi <mawasthi@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924173054.5892=
91-1-mawasthi@linux.microsoft.com?part=3D3

