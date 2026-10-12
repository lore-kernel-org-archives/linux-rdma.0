Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78831F990;
	Mon, 12 Oct 2026 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810664; cv=none; b=QNQDT4B0Cju+AIbdzEsHzRgeK9E6PSKQ4NK/viGCxOqT4C8lNYYvVKiDMI2OSiPcQupCsGsQREJeHzITdZZng4f0Vtsywk/PHhUWCz87EFodVylkYyCYn+ccUfC5rKq+ytRyfZpln6gCOimBzSsgUfbGalkFZt/Jtd2APAHAVFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810664; c=relaxed/simple;
	bh=OurCOLfCiEt+Kpm0SrAHWEr04uzDPUF7IJOz8rahb6Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=D/f6nL4Gl512FnJ8VuSBaXEL1Y2AJ13WcCfLGnsNgkea1Ey8zsjKCEd+JaQPHp1t+iod0FWj6rG4Yu2AGHOQXgeyFM+6vKWXrhCpBWD/a25OPbGaQS7RCffNUm7AMokNUG8u4/XwUeoJNToY5sy9kTD8LxXTKYdc2e2Ve+plrxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEY/At3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEY/At3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F3F1F0089B;
	Mon, 12 Oct 2026 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810662;
	bh=OurCOLfCiEt+Kpm0SrAHWEr04uzDPUF7IJOz8rahb6Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oEY/At3T0sliAaJFb+UeYNCwV108mu5w7z/CL0///bw4lIcBCPQZkTYkRJeNvQTNt
	 hbFQkfHSFxg73S4aGbnmqvPGPA+m4cYXzZ1hKIwQQdo9D+RW0NbT7YYRMMexIulyWs
	 v7eH1667tMVWt9H+Ef2Y3vWe6cfv8woex1tNq1D5dHsBDudSQVUqWlGjhjVlDDkNxx
	 hyGzrL0cGU+BQBmaGI8OAhaCK9RQxFFobSruAAbDtrN57HoqH94CNitzL/jBysBKg5
	 UHwMeirLLTdz3ti1MzUip2HEm9wdrGqOEy7U6o2Tu0S1k0de7XPlacvdbDQWlRZFDY
	 /HyAxjl9LXA9w==
Message-ID: <sashiko-outbox-168145@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 01/18] PCI/P2PDMA: Document the TLP attribute
 assumptions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-1-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-1-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:11:02 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D1

