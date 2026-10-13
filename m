Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916CD411672;
	Tue, 13 Oct 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901964; cv=none; b=afHOvmzk0Wr4SSbQmn+qLp9XI4wBO/1gvtxRKRcTKZ1Anpj/6sKDE7Q3E5+Vt6JLnbnrSQTGgQv498QoaYdVldem153W7+12vUIqZfrVj4Q/i97bsejTG2t7OfxixsWzRETnuI6KSzjMJECoXyKFm4Mw8+6p25PpCjgIw6JXF5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901964; c=relaxed/simple;
	bh=Uj/vTRyz21cee8w/qCoHpESSWt1vFzf+tuOGLqewg5E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HkfeRjLJp1TjFZ1gHuGt1pUY5ZSuv4/7saExAQ5hT+0uyqBtBj7syEXO1pxZFNny9xr6MWcCg8DOeASWRcjHz6pmZQAC8gWR5YsBrj0oEiXFQAIPf4VAkQXdaXMjwwksG1F8yUG2PKPnuZcDF45Mm2e/cDUeeq747cx8NV+uJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c80Om3th; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c80Om3th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF331F000FF;
	Tue, 13 Oct 2026 14:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901963;
	bh=Uj/vTRyz21cee8w/qCoHpESSWt1vFzf+tuOGLqewg5E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c80Om3thZpTFQ7FjV6Rtl4HwhdimyC6AVDucBmPHm3K0f8WJYx8KC+cbpVbT9l5wn
	 +HiX/EMVTx7QDerPtvEMSFEccLYEo8v/ogJcVEyneEsj5jeeJoVVguJiDRdCv24jgM
	 n5anLNCZb8nCNnNVxjdhyUAOsZa2ENTky3Mx/Xv83tBQzLvzV/BHSbA8L/wBzzCtqE
	 IvfhTbWl0d/52rZJ6vYhlBAxuFjEfAMq3r7U7QAHIqhkLk7YRPAt/DxzFGz8dweAHZ
	 k1eGsUsKX1TG3t/W6R0NaqQxiEyyBOmPl2AYm1hCCaUYTkukcyO4QziTQu1xw/pY+x
	 h5hg3WNouUP3w==
Message-ID: <sashiko-outbox-169915@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 03/19] PCI/P2PDMA: Derive routing from directional
 ACS controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-3-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-3-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:32:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.
>=20
> Evaluate Request Redirect for the Requester's Requests and Completion
> Redirect for the Completer's read Completions. Continue treating enabled
> Egress Control conservatively as a Request redirect.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D3

