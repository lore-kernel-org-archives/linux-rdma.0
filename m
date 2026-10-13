Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66FA4078D1;
	Tue, 13 Oct 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902198; cv=none; b=aZVrbktuWVBBdZ8Vq5qfRVgHgwPfpy+F/Uw5J0xVsXFPmsgvj8GSU/mjmpG9C7RTyATqf06HIwq34+bmo5hJmqs3mSjaNeKjKayqE/g5ipD8ZUNqOrv+xd8Qh3ztr+OvKHggw9x3XPFlRbBhkENTKHqVLZvYQ/VzvdWCBmpCQ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902198; c=relaxed/simple;
	bh=vwUn6kUN+1oj3/ThSVuU67Jc6GiDa+qSvtGghxbp2+M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=f0mBMfUbp1xC7Cxssu5UFCt9i8clfGl4yrMMu2bdSioFVmcFzhVl8EHUAFCJ57JbHhJ+egcVi8/e0AqA+ulOMkPRoB8ow2OaIrpfJEakj9rBXwEZBbIz1j4QkSz2emneCKYZOCX6B6SdGtTZwxKZWokMcOSjdFFz/DT4x6zAsXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TV6qtdBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TV6qtdBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B86F1F000FF;
	Tue, 13 Oct 2026 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902197;
	bh=vwUn6kUN+1oj3/ThSVuU67Jc6GiDa+qSvtGghxbp2+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TV6qtdBSsJax5XXBMFK1qXs/E0qL/50KY3qOetPSInYaHWM+Sk8BfvJKcwJv+Icaw
	 bum/fLQ383hSKoDYLMld6U1+c7TVaY4Af4cC5msQreJ08M+Jmoz3ecyw1H4IYnYERf
	 416MSiFS6bsAZ4BskLm9mrB/HvDh0oshbpMx4Btk14jhXKDha0ZAUdVQgdJwiB8EsD
	 4E7kqoe9zIv9WJe6stEglta73lHZCzHNxvwL6NrVaIQRZ8iBSaFBcpgpLnoeEynadS
	 381msRKVatTZ6eo8dIHKclx5/bB+Wqzh+QEUuSTW174OMlQJXejWO5JxCzFjSq88vM
	 MmJEtzra4zX/Q==
Message-ID: <sashiko-outbox-169921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 11/19] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-11-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-11-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:36:36 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A Downstream Port with ACS Direct Translated P2P enabled routes a Request
> whose Address Type is Translated "to the peer Egress Port without
> redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
> Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries =
an
> Untranslated address, so it sends an ATS client through the host bridge
> even where the fabric would route it straight to the peer.
>=20
> Consult Direct Translated P2P for the PCI_P2PDMA_TLP_TRANSLATED classes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D11

