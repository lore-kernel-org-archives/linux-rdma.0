Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873767;
	b=O7lZFAS7TaQah6Ey9a6oSknDfbKviNj1WhKJSQ+hc5C4cFmbzo4bGKhWq7v5jOLm3dW1
	 ePI8OO/3UVPMWzJT6dF9WRF5a53IKpnDL7Mr2x+ktzlqqt+B/holY/otvDCJoFQLyt7VU
	 XdHxhDMDlEZ5iELycf2499VJsgQFozOinXrMeK8s0+Prz1iF9S8iny7KOhzYXxgtQcetn
	 K3Kg7jTQuMvE41rC8JVwgLL213lTe+7gDLtwRkiKVfOEUUnHA5OztSmOz0AJlaveHUhc1
	 RAZVxUhIEIa5Z1+9c0ZMkTFS00+DBwA7E+IOerSKfn+BZAr3rM4YtUX+stLGl9tfTHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873767;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xxtFIWpAyXz/iryYeBs0RhM5+0IXLpklg37uLbJGTVs=;
	b=FEJ0Ac+PUcBqQkwlKpuSwhgKrUYYJ0rk6YSq8BRVzSBmnjj3s4vJHSn7hyGbKQqQiZzb
	 i/P7oZWI+ikbA3yrcyc3YzDAHapSGMz4VVEx2K8Ke6Yy2CRLvbgE1u5fHKVSMHcRLnwY5
	 osMhY7oOhgUG4Duq1JvfirgHsQTDmAuML0rTZrA20NXo+rdxVM5Ha9uNRFH1VXx6iR6mT
	 C+fwo+EiJpX96Ozyki99UT0LOjox0rplblaNm8s28OOZWb6qGqtAomF8sNAAOWnYBSzUT
	 6H/1Dt9blajIqGiQdGqv4qTSw41FdGx4Mpj44Mp7cg8Yrz0LG7V5IxclES+AYm97QPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNaqtGDy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EF9606A331;
	Thu,  5 Nov 2026 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNaqtGDy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC8B1F00A18;
	Thu,  5 Nov 2026 10:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873766;
	bh=xxtFIWpAyXz/iryYeBs0RhM5+0IXLpklg37uLbJGTVs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VNaqtGDyv0YPpyT39SA+0EpLmPSi7djij/CVZXm4IsXcHaST1n99UrqzLfnONzJm/
	 zbJcZLTaP3TLpPcQ8Z0Knnfhfn53ckbABI2rfShKcPd1t5uOIpr87GIzfI0JIS2P8j
	 yLTk8FDoJJAE85f9gWkGZwE1vN4dJQ7POnLh3pkp5UyCq9rTI0RYqulSGMkIFGlge6
	 Mu6A16FWkqCASr66ggl90k6gHTpL5VUU56GVFRjxkXyCK9SBjDVPOoe1R4tTKkAHCd
	 k8bp4X7rIpmUyngZeFaNl/BvPr9+VWivMsVSaF4TJFX1MdBOgJGz65zlmsYDcxvXfe
	 Jqha8XKMHfZlg==
Message-ID: <sashiko-outbox-198830@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 13/19] PCI/P2PDMA: Add KUnit tests for the ACS
 routing decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-13-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-13-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:16:06 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

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

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D13

