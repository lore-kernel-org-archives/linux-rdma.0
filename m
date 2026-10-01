Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EB14A4830;
	Thu,  1 Oct 2026 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856274; cv=none; b=u+4mhxNPEXCvodDpkeIdGXV1rEMUCk8pKLAOrzpcuyjdegRvjPfpDACMGXioIPjShhE862QwKwIKYX5djiXOBIl+d5a4siVlncxjzTd8Pe0JBLkxFR2x4rcPyLMJfEMibXPQJ0tG/6PJxdx9BAM0Bjoy3jovkxsS0XGKSSGeuQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856274; c=relaxed/simple;
	bh=xDiNFuFOqyey5xi/WZeUPxoa/ahinOqXzQ/IRInWIMA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WOV5W86bFwctnO8cABkKFgb5b3MgNV1I5tAEZR7JfhUnIgTTwr3+RhImzOG2Y2bouq7xt9YbROOBypCnyy/Wf5SdkLq7FbUCclCslXf3NrWJifZKf/5bcgyil6Khe42nFbdDWgZjB2ITdG4i1EovLC7V3RKSLedZX3aL9aCAw70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvsgQNjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvsgQNjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BD1F00898;
	Thu,  1 Oct 2026 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856272;
	bh=xDiNFuFOqyey5xi/WZeUPxoa/ahinOqXzQ/IRInWIMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SvsgQNjZnJJEHJIEs4ApGFW3Fz7GAXtC7Ty+Td9ax1Yv/wxy0/CdgiXCSKk3zRnHV
	 N+moTRZQaDpf8BmbqUNPVMlJwIlTscRlZ7WMNvDI2T284bzPQ/0JEwTK06Mwf+ga+K
	 NA4+SmFj3MYLMAid58j+JSZH495hS9K05zYW8OQ+H2ShjegnaY7nCOyGmxRqfzsRIx
	 ZmBy00WUHGm+q2s/O1BTn5KKByKLIKuNv1EjniURpa0cV/LiGDo7v3irDI9tOjdVv0
	 iI+bcABhfKwAACxnZ68pZB2FbBnBLZ+Wa/KXPVFUdSh6FwldPN/GUYCC6U3uYtrMAf
	 pfDO5FH174xFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/18] PCI/P2PDMA: Reject Translated Requests blocked
 by Translation Blocking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: media-ci@linuxtv.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-9-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-9-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:04:32 +0000
Message-Id: <20261001120432.688BD1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A Downstream Port with ACS Translation Blocking enabled treats every
> Upstream Memory Request whose Address Type is not Untranslated as an ACS
> Violation, ahead of "any applicable ACS P2P control mechanisms" per PCIe
> r7.0 sec 6.12.1.1. P2PDMA never looks at that bit, so it reports a
> bus-addressable path where an ATS client's Requests would be rejected.
>=20
> Add PCI_ACS_P2PDMA_BLOCKED, and because blocking is not a routing control,
> scan the path for it rather than the divergence port alone. A blocked
> Request has no host bridge fallback, since the Address Type is rejected
> wherever the Request is addressed.
>=20
> The two routes do not pass the same ports, so scan them separately. A
> direct route turns around at the divergence and only passes the ports
> below it, while the host bridge route keeps climbing and passes that port
> and everything above it as well.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D9

