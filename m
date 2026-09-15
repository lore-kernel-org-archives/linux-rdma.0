Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A3F3B5314
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482529; cv=none; b=V0xYppnvjoAxT23J9PLWS+pf2J4GqbihWJrPuZ7LwVKwZUn7BEm8rm4kP9d7qHNNQp+DWbnQcYnwyq9YY14qlsNAP2TgK3R+RsxZyaTDDpcZF3Ja48UJD56PeANVS4ksdtTbCPaqEM9BeVXnDqf7LxSoGZJOysP+NgWjQzz+eyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482529; c=relaxed/simple;
	bh=b6IuN15CHPtugacM6ikHEU8+IDq4+oGgBffHE8R3KJk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TXgIGbXrcgp5n0+zFaOM7vnKckJcSGYPcpJ/uifyEY1AjDNsMLk3pmYS0fxnV0CnrICrrrlMg6PDjAZrxtO4blehYeycnvKBemrUq5qNgNw9hVoRpWVklPV86fgAjEtYJw7e8y26xoX3apxESOLCmqRkSHmExnc1hx85pwPVHic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1A/Rd+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1A/Rd+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235FF1F00893;
	Tue, 15 Sep 2026 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482527;
	bh=b6IuN15CHPtugacM6ikHEU8+IDq4+oGgBffHE8R3KJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e1A/Rd+Ay8EjdnRP6trCs5/Od5V9jhbWcmtVYz5jinxAWfMX3sP7iB1/Honky1mX8
	 2/xbLxtDL1WVzkx1XO2xezRuHSTr6ml1eTo9Zn869q4gAXt9uskTgKEeC2U1qi62Kg
	 uIdNUeuunwxkoyC/2NntAj2FkbXjR1RguaIBOg6pUbMH6FucPJRwA7gFQl3Qn6ycm1
	 KfNt4iqnoEZ/l+VA0UOt/rm6qnlQfEjThbF5qFmd/dtZ0NesMoHi/GxKpYa7eX577t
	 R407pQZCtRFMpCwuCyZsA81Ah3PJFI0G5JDNLUXb/pqB8+WHqWTmRq3YeXNFamlipy
	 4Hsa1LNeGQh5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 07/15] RDMA/umem: Derive DMA direction from
 IB access flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-8-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-8-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:28:46 +0000
Message-Id: <20260915142847.235FF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Map non-writable user memory DMA_TO_DEVICE: when no write access is
> granted, the NIC only reads the pages and DMA_BIDIRECTIONAL is
> unnecessarily broad. Where the IOMMU enforces direction this prevents
> the device writing to read-only buffers; where it does not the mapping
> is still semantically correct.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D7

