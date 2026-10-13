Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45E51617A;
	Tue, 13 Oct 2026 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902449; cv=none; b=A3duRwx7zNTjEsE4gvcAfW1HyIT9ilOX7xZYkgSvxmIRhV8CHRTVQSHU/UMx87NehX97OxE0UQT5fp1H88Pqe3sTGh/iEsNuaXnWGpF1k9goDDCTpYupA7xR7ao0fLfrSmPzcZ6mpYWCXfnQ0R6A6oLPV/4hQ9Q/Cr1Do7AnklY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902449; c=relaxed/simple;
	bh=VkWueAjxrSJ5yEbOYdXUbhM62SpohS6Z7uXN+FcRRow=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BogeKqX330e2twoRaeu50MmMV1644lbcJovRz31XHOwK0UBI5nu1qC4XLUipxbS7KNpvV5RnebvIaltipWo7HBl/1SRcDZtNOY6+py5TjCFLJgNyI6AA7TIEoLZ4Ij9eXoBPvsqk1RqMsDq6NIqFSpKZr+vQgZz4iZ0S+w0SX5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8oBC2zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8oBC2zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588FE1F00893;
	Tue, 13 Oct 2026 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902448;
	bh=VkWueAjxrSJ5yEbOYdXUbhM62SpohS6Z7uXN+FcRRow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U8oBC2zzuVUmSZMA9lk9ycV5arRGuUKeWxaPNT+pjNcnJO8h/HphCqfEhrhWoyTKn
	 wsHQCuo7uddIAxl55whxU3st/kC55A7+fiaAPZDosVbhAiKPJ5w/BUE4ZRM7eI63s9
	 gDzRi1N2zzG3so1f6bg7Daew4pWmDs/oa0h8wReyCufa5K10+YneGa1hEqnC24arrk
	 nVCGtIL766QW+8OPCTPudC5gyRH9J6HPk5JCBKRVBx54N9mU9hjLS2Y69caFNkDy8t
	 fa2Tygbto17t10t+7WWdSzdS4SnZ6LJ4FF6EjxOSSf07AXDpFVhm05mm5+FZJ3wl8E
	 7DOzvjZtvnLzw==
Message-ID: <sashiko-outbox-169927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 13/19] PCI/P2PDMA: Add KUnit tests for the ACS
 routing decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-13-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-13-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:40:47 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D13

