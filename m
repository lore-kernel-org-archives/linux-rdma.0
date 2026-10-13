Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C832A25A640
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879731; cv=none; b=Skl5kTpt6vJW9PNGDtvTocNv9pUE7P6Rc5JDbvDdY6otw8WJ317SaUQ3wiOei186CrUTArgFJe+6lVovXhY/GHaTnsj31vrZ/Sb3B7pmtZoCoZBLYqC6q0hxF5QSBFSYkgasiAeN8zHAxa9rTT4AfV7SkVRZqZ1R79oeaqtF8Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879731; c=relaxed/simple;
	bh=YHNvoKkyH57CtuKCZ3mpJTn4PCDhXAYthGgCxDGnELM=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=hHND0yW74QbCZ8IERP3wzBbaUxBvzc+Ncj87MzFx4OlS2dR2HEnuDUTULsIbHAURu+4dD4za397Xs4dTsSMoD4cfNvEHjunZPC3OHlOIJHjfztcpZSW8hGrQcJwURdboyG2inVMjXvDAXk0dqR38LSwJg1jQUeWnIy11u7uwJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxsJqtG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxsJqtG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357F61F000FF;
	Tue, 13 Oct 2026 08:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791879730;
	bh=YHNvoKkyH57CtuKCZ3mpJTn4PCDhXAYthGgCxDGnELM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=SxsJqtG2L+LD1afiYalTXPHEISko3PL8tKNO54TtU4EYH4ie6EazQacnRtvP5zpaT
	 uG+E9nLE9Na2RTti3r1EDB9jrBqxvtjElGpSpCR6VUaCcxExLEO2kJNtwpO2q/vXfx
	 NnXNyIbVDSwgKirw4cduP7+A45Qe6vXmfbY/t/BBIMkumT3CjytjUXJNCM866mxDyO
	 9BNLAvGwt3doPG9XHhReO/r9gKgGXntfOqXOZZhkajQTBgZJioUwbxmN7lSrE45CsA
	 zxn7x1qDv6oX/WihGNdhQfepFJ5zvEwLGPD8NKRie6q6UVSPdEriLNLxYrb8SzWucQ
	 41ey1wB1jqylw==
Message-ID: <sashiko-outbox-169233@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/6] netmem: rename __get/__put_netmem() to
 get/put_net_iov()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261012082148.1698596-2-almasrymina@google.com>
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:22:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> netmems carry both a non-pp backing refcount and a page_pool
> pp_ref_count. Make the non-pp layer explicit and symmetric across both
> netmem types: get/put_netmem() dispatches to get/put_page() for pages
> and get/put_net_iov() for net_iovs, always acquiring or releasing a
> non-pp reference regardless of page_pool membership.
>=20
> Warn via DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support
> non-pp references.
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012082148.1698=
596-1-almasrymina@google.com?part=3D1

