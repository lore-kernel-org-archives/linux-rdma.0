Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4FB48EBC1;
	Mon, 12 Oct 2026 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811144; cv=none; b=cBs5x7rhNRB9aTCfWsgqBNRq5a/rxqArLENeXexTW9b4B7O/DOAId3csWhFdycK+MPfCi8IX6Chk0QGNB2ddMqr/CLl/0va3SPhuL+fmenOuYnhF/mDTvBJETEL9LqYPdgH3HQ6CgEDRrD4iyGegWypfxHmF0tdNPR1B2H0zAYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811144; c=relaxed/simple;
	bh=kr5UNsckQO8vPzxdUZssnArdijq87Q4YdO2m70ZRuY8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=njGtFmgVc3mrd/v6FIeO3ShII60A4Yr/yVw7r7HNKcaJock/7TsoEJ9T+7wqyQOl42v2tSqDlTzWphhe1IlcUfWDV4OUEzKTZ+jDGJ96xfQomg138O+OkNno3dvn7+ZDAOKLvTTMoeCj6NQCUBRUNn0dOaMEDcn4OC+DT3x9/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2hul9Gs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2hul9Gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C121F1F0089D;
	Mon, 12 Oct 2026 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811143;
	bh=kr5UNsckQO8vPzxdUZssnArdijq87Q4YdO2m70ZRuY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a2hul9GsDtccfLBw3VYOP99EEDrEkkiJuLGbLlpGCW7MiJxwU7UpvYYSoT4MPLmS/
	 8oG2ihwiZVGAZNEuOGE5Szpo5Azf9RR45Py+nvTBgf9CSITC1q/U9vy6Md+DFfHOQP
	 GDNv5AYdmHR3Eclk9ysNJ+gx+jfkhGh36t/YxdKnZ8P44iwVODDkPtwoQIQX2ExYrj
	 pWxX2mRjuhxPMSMTOUtbGcCEWCygUPftqJYLnd9e6bhfcNYNDNJULAUsT1ahU04trA
	 oTA9MSVKlqdG5ig9Q8kV9Q3wkeMpoaKyKZvnv0+E/2XcztR9Mtm0F1PNZLFhs8yaG6
	 c+zoF3541I+hw==
Message-ID: <sashiko-outbox-168164@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 12/18] PCI/P2PDMA: Add KUnit tests for the ACS
 routing decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-12-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-12-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:19:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_p2pdma_request() and pci_acs_p2pdma_completion() turn an ACS
> Control register and a TLP class into a routing decision. Which bits apply
> to which direction and which class is easy to get wrong, and hardware that
> exposes a given combination may not be at hand.
>=20
> Drive both from a table of register values and classes, covering the
> redirect controls per direction and Translation Blocking, Direct Translat=
ed
> P2P and Relaxed Ordering. Direct Translated P2P gets a case with and
> without a redirect to override, since it changes nothing without one.
> Exposing the two helpers moves their state enum and the TLP flags into
> pci.h.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D12

