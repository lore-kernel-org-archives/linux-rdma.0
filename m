Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F949365C;
	Thu,  1 Oct 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856252; cv=none; b=hkt7gsmznb/uk2/lQJYSz9nn8ouDd2PmqGLESNSrRxVtAl+31Fq1JwDlqu0TB4zdWHAGv+bbSPjbOPtIjgSueAGihxzeVOaJD8G5gBL5KSHVZu+Ybg8LXwXKNCZvWSBDZWvnj+KC7Gcm4l7heRrPEZZRiNNRMhU0wfSvRJKO7GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856252; c=relaxed/simple;
	bh=KZ+9knHWFZ60Z1hvetFWx4nv/zUuLcYYrzjsKCKJ/jU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Un8Kx7nbZSdrVwfO/BE6CUlgd07cqUPOPrSMx4bWX4ZF74oEurb9qyDTQd5sUNXv3nc9a8HIwCSdwxFd1a7TpmE5z3a9jhjw7gOl191nqi41t27q8nL2b7FsTC43tvU2HdqxEExov8kAbqZuot9a7iVvxBlOKIUGu8BLGiLWZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+uVEg0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+uVEg0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735081F000FF;
	Thu,  1 Oct 2026 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856250;
	bh=KZ+9knHWFZ60Z1hvetFWx4nv/zUuLcYYrzjsKCKJ/jU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d+uVEg0I5f3F0pAxAao4gd4rY4iC3cQYxufbdd+NcmPspG+OVSZtJiW3Duvfy+3S9
	 vGwB9CPqfe86KMqWvfyGCRAbhD8eoDanRjJV0sFxkvexo/xBQZaRGBPP20wnFCZzn4
	 XVhBgG8O9UcPtM8aJd3tpGoQqWGyAOatMwc2Qgqq1eXvn+mRMnEph8kC/j+GsUs7QU
	 4Idxlaer50+Pv9P5l/ByqbxlPfUK4he2F2KY1jA4qfMAr7exIW3I1hjJUxO4W70kJ9
	 9ymGATUWPbXfk+JSxSTeqV8phSYbHNOwaAcjF7+Wmqw4BOOg+kjofvFhQCMbHJ6KQy
	 ao5BSOMczt9Wg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/18] PCI/P2PDMA: Route Relaxed Ordering Completions
 directly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-8-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-8-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:04:10 +0000
Message-Id: <20261001120410.735081F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> ACS P2P Completion Redirect leaves Completions carrying the Relaxed
> Ordering attribute alone. PCIe r7.0 sec 6.12.1.1 redirects only those "th=
at
> do not have the Relaxed Ordering Attribute bit set", and sec 7.7.12.5
> describes the enable bit as "applicable only to Completions whose Relaxed
> Ordering Attribute is clear". P2PDMA reports one answer for every kind of
> TLP, so a client whose provider returns such Completions is sent through
> the host bridge for a redirect that never happens to it.
>=20
> Add enum pci_p2pdma_tlp_flags and let a caller state that property.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D8

