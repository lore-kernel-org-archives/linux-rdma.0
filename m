Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D2A4FD786;
	Tue, 13 Oct 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902244; cv=none; b=UCJrq/E6dHWPBop0lt3AuTS+gQgUlKU/ji2SOx/fbQ/Ev9P0PeEZ+YC8ZQd9xtTqCxTAox+twy0Jvn/gMNzAplBa7THxaSiyjze+GV0r/iCrvtaXmldnC/VgDZ5VUW0thGpMf93YKmnJqszuIQ7cQiIhKPmb2H3T7rKP7JM4soI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902244; c=relaxed/simple;
	bh=srwRfKAoR6YpkflcEpZLczSLvongqpS5is8g/Xy2fwM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DfYzEhydO8ing+L6OqSghwXM8Jjnq//rITnvg632cOqz0RiDyUhGn3ZOTwHAsYX/1HjfeVHaj2g2T5N0ujUfaBVxkttlbpLTsubunZoQMYTzi8KoVPMAhO1V+Nsim1nazPIEPDsRbg0TQlyCFkMBn9q38+PKglzLFgJKR0GgYjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ES7jc5Jc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ES7jc5Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AD11F000FF;
	Tue, 13 Oct 2026 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902243;
	bh=srwRfKAoR6YpkflcEpZLczSLvongqpS5is8g/Xy2fwM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ES7jc5JcFJZgInlk70TyvoHyzHfWSIUbnm6K7MFcG+u0Blb0XmEBHBgNHOD4JRJ3u
	 gUSuVSjReNesaWzrNXvI/4/oWSIzcsaEViC2DaEACCFjUoSSA6WngVVNPw8VuK6gHi
	 ANEuGbUgE3jsbpiPcg9jcHc6THWiTfNe0kf6fI/6A3ryJWAxq1TjzrSr2fegdIcNwk
	 Jvx7Uo8nxeYbndPzbB5S3qx5oksK8iod0aHW7/K6FYnoILKMjHrZpXVRBBBQY4UEky
	 O6LNIgqTK3w8H5bDBwwXPnl+tbS5M1IESiQN7tGsVzs0B+0uzF67/ewao68qgL9+Mq
	 Uwy4P/2TS5zEw==
Message-ID: <sashiko-outbox-169922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 04/19] PCI: Reject unreadable ACS controls in
 isolation checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-4-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
 <20261013-fix-p2p-acs-v4-0-v11-4-72cf8c96e617@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:37:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls. So can a read that returns all ones with a successful status,
> which is what a device that does not answer usually produces.
>=20
> Return false when either ACS capability or control state cannot be read
> or reads as all ones, which neither register can legitimately hold. An
> unknown state cannot prove isolation.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-fix-p2p-ac=
s-v4-0-v11-0-72cf8c96e617@nvidia.com?part=3D4

