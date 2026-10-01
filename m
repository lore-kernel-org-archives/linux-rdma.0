Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74713499F09;
	Thu,  1 Oct 2026 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855936; cv=none; b=tNHJ1plr5oe2VP3j3HSs6W88PCYgn5HB0rmKJltLflE0TovKMlEUO7tiQNRrp9X8vFKjIi5WOdnpbhB7rnJhXuQ5RiRoihBrYJBXhHoqaYC6meJ4r2R3+drVNpazS6CF/1S+n8MSOzmDF+i0ap24FTyGaIYcDik7SgC4Ibpzp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855936; c=relaxed/simple;
	bh=3MpH6uoFnriJyB3DmdJkKxxH3NSU+c7otgP34MdTSdM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NgbjW0fJc4AY2rp1RuxvlfLdVwOPtwWS7egaF6vYYcoTJXeOuRdP9IyBuehYLXhS3ptaZdopCozoHRplEsj773WCJI6MSggu+aq+cNtI8y/ouUS+STyd0oAy/RVrDeXT9/OT/vnPtbhXr/5EgsECxspAscHKGFSjGBAfe30Vygs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YaVwbJtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YaVwbJtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744FF1F00898;
	Thu,  1 Oct 2026 11:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855931;
	bh=3MpH6uoFnriJyB3DmdJkKxxH3NSU+c7otgP34MdTSdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YaVwbJtzIvT4BPePc42jLdf6iduR3E8H24um0u4fjXxCj0akwFNKls0hLoIWvzOHV
	 J/eV6a9viIVFi4Oi52SKL2ijic8o/YDkKMeLuPRN9h/C7bfF6R24Ab8lp+FP3K9Num
	 Nq6oV79dfVOxwHnaFSfwQ28gRwtlge90phFV/pBgwyvgHfFhQeOtYEG0kJkGvpVSEn
	 6w+t513GymmlTs71qXESNzez1TVv7I4Ifxx4ZUzYtKi2sVahgdedQwtT/PWxk+oi5s
	 TQoyEr/scstpVLlL5EzlN8gRxi3Z7fO2TWuBunEnO/Z3AyYTmmDtPuy9fScFtmarB+
	 6Ko9NK3WBh8LQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 15/18] PCI/P2PDMA: Document TLP-class routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, kvm@vger.kernel.org
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-15-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
 <20261001-fix-p2p-acs-v4-0-v9-15-1a8e0f50ddd9@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 11:58:50 +0000
Message-Id: <20261001115851.744FF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The P2PDMA documentation stated that the mapping result is not defined for
> Relaxed Ordering or ATS-translated Requests. It now is.
>=20
> Replace that paragraph with what the three TLP-sensitive ACS controls do
> and the table of outcomes per class. Record that an answer relying on
> Relaxed Ordering Completions holds only for a provider that returns them,
> which the PCIe specification leaves optional.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-p2p-ac=
s-v4-0-v9-0-1a8e0f50ddd9@nvidia.com?part=3D15

