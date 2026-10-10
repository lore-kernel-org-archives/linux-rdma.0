Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A95D49553A;
	Sat, 10 Oct 2026 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643324; cv=none; b=Sn81SD2LojHUGavpVYRfP9WgoZVpXZYX4BF+HIXBDw/5vvRsZFMriJ6AaMKGSGZDC21+hu2lq3XfbVq7TFTGoRNSAph2MUB7tgDdkcP+vayzR2YxNTAo7xA02TjNSPiVCIS3SAJfigTZiyziqdbUY9EQynovEBdNhKeh5Su8S2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643324; c=relaxed/simple;
	bh=O2GQtrTW3pKWjYhZYQbOLCSKPm7vcDAujp5Ed9X6x2U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jkbYmfCpN7eR0DH+55IjoIiHwOU5T4RG/qcZtx4Zfrl8dUKMoytcFTMXS9s/dG9cTL5htVsiBVf70fpdxL8Z1A1ddGSgwh2ZTA+CLCSchObJ4D262IqyK7qixgVIPoIG5wyKI3wnhQsIvVv+ZwbCMSlhEEZlUEEUw6g+Ue8Gl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7mczl5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7mczl5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDD91F00893;
	Sat, 10 Oct 2026 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643323;
	bh=O2GQtrTW3pKWjYhZYQbOLCSKPm7vcDAujp5Ed9X6x2U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n7mczl5aH3Ww1/s2Qk4PU3kRYnsbtYWL8MuqVc8KzcIJDsxiqkULx7V5LveqIUjlH
	 ltBFtp9r9ZHp7TPzC1XqaLTZxBMu2DVVqCLnNFiD0fekfeBJJRvcv5OyOIPDEXUOuf
	 n/ehK+ofykRqCzK/LfAGVVjI5WI3EFmdigAmqEJHG2anAaH9SSFFvxuyDn2fX2CNJQ
	 zl0SNAAuFxrjnx23QJGoLkwVkdjCPtUY+r0kNnpp2Qajerb6j4/pdx2ahmzq4wwPZG
	 8/JfO/3BB70SqgD2aSs4RKc2pNzptJrSaumCVnxq8kepTQHu6J/1OVK9XJnhnu6oTr
	 pKFZsiFIUUU4g==
Message-ID: <sashiko-outbox-166657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 05/13] net: mana: swap queue sets in
 mana_set_ringparam
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <a3d774b7c36a04a50a4ea9974d3bad1ed2226680.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <a3d774b7c36a04a50a4ea9974d3bad1ed2226680.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Replace detach/attach with queue-set allocation and publication. Failed
> allocation now leaves the running queues and ring sizes unchanged,
> rather than risking a detached port after attach failure.
>=20
> Skip requests whose rounded sizes already match. Keep RDMA excluded
> through failure cleanup, which can release the vport.
>=20
> This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
> RX buffers and page pools live. The port-owned EQ pool is shared,
> not doubled. Device resource limits may reject this temporary peak;
> allocation failure preserves the live queues and configuration.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D5

