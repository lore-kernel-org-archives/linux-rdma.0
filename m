Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132BF246762;
	Mon, 12 Oct 2026 13:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811019; cv=none; b=KjouBu7RuKjVLzanbloIxEeVGcAROYUSEJeLim5Z7M7Y063AWXu6x2f09QoYn3JSAKG+/W/ej/IEwbEK82U+D4X5dfyfiP+CyVxZKnF+lJVvDpcK0ZfzuE/aZCdFkFTjvbHxgJXwZmeiJro1KAtd9MEqK5mGSA7lol4ikq5D83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811019; c=relaxed/simple;
	bh=Fkm1iFcb2sHuFSqHNn0RIxRFaBK2HnB/BntYmcKe1vI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ot4lIuptHmuDY1oxkDnhuv/suehCZ20VRONHVzoka7IUajO13JGduz4nWl0FzT39PzXV722/8UB3BNX2y09WvEwzeurgnVdHs/BqPzYlgYmBGrRhnU3VYkcg9ogbj6Sgkh/7ypudH2zonrEAVryHdLwiStISRGEM2LDuyloNPi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3kJpwgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3kJpwgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8E1F0089B;
	Mon, 12 Oct 2026 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811017;
	bh=Fkm1iFcb2sHuFSqHNn0RIxRFaBK2HnB/BntYmcKe1vI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b3kJpwgqo/mdZZoDO07n1E1+VSq1+S8aInFO+PiG1q/ug0aOugzzcrJcfu3mVWf95
	 srBl1SBE2XJuF6iIiVlWqkhHianVvINJSAhJiwLAEtaQvLcZgTb1keajPIS1rg4Aud
	 z9JNpM28SpdrRipURUKP1imLphukrhzSrR3c3oIyO9gsB8GimUpZyJ3HTHJ3VzxVRY
	 HXx3f0dtJcVjI03HCzDD41WouvZhc4O+cXPS2VD5RfwKn5/hBfXuYAIY49xOmDqA4U
	 QYp5BsI2HvxaL2jBSlfjc0iRvFWFin3dDXCVBN3LZwlsgYglljZn5nAfVe5EjVmi2V
	 H90RuwlHpBUBQ==
Message-ID: <sashiko-outbox-168158@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 02/18] PCI/P2PDMA: Derive routing from directional
 ACS controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-2-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-2-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:16:56 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D2

