Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588603C2788;
	Tue, 13 Oct 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901685; cv=none; b=l7zGXYyBGq8pxYPu2v8nV3MFo0b2eKFJ2Z31k3SrIk5hqlHfKaUvSVLC8emB0fFq32JSLkOEDSAA+tOK0OHPP/4WQb3uDEMHsCNZPLjcBBXrZWPMJPQVKqQjs8k4DJp4kPsiy8bE2L0kDFlt8yctsm4cQ22hU6+K4syebnZUuaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901685; c=relaxed/simple;
	bh=ktORTITAXflXVTRlTj5U7VyBWbMXCqFcL8xW/jGpFfU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mizlP+NMC7BfGV4p22fPJpIV9FeTR/vepyT8CVqe7257XfKleabOdguk1w3Fl09qjfj0M/V0SxIsx0Dc7Jn4ZgnGJNL0H8HW4uV4MXlEIuvxUtCi+GxG8kn7m9npHCrYhNXEKZ5JX2FlX3SXpfN6oFFPHLIQo8LDLnmtn+8fIFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO/JoTn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO/JoTn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BC11F000FF;
	Tue, 13 Oct 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901683;
	bh=ktORTITAXflXVTRlTj5U7VyBWbMXCqFcL8xW/jGpFfU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iO/JoTn81ld9Ib+vdIvtFD7bDdwa4A9egF7wLk8o9QxB6+TN5UTMIwtDIjgo6ROBh
	 G+mJoOy/B9eFRtgAjYsNiL42WJ8YGM0Bvesi1ZUr+Chxc2yve+lZFeJsEmiIKGdzRi
	 p9nBLQmUWxbSe/zP9Voe3uUAygRgYpCENKzRO1Cqj4MBivzTe11qeQWaCtBuWWzZrg
	 qz9jxzE5ys44P25WYKpOuKSxjouV+VLANciS1NEKaajlPfPOnjp2ADvDRm2ZbrgLnD
	 xRPdIy/ellNAAlKYoiGHBqR/cIdrp2OTRzwKRIBt46NtMM5qP7B5LAQ+AX3HgsL99E
	 AyDO/errpssJw==
Message-ID: <sashiko-outbox-169906@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 02/19] PCI/P2PDMA: Document the TLP attribute
 assumptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-2-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-2-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:28:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA selects a mapping without receiving the Request's ordering or
> Address Type attributes. Its ACS handles only strictly ordered Requests
> carrying an Untranslated address.
>=20
> Document that the result is not defined for Relaxed Ordering or
> ATS-translated Requests because those TLP attributes can select different
> routes through the fabric.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D2

