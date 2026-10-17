Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B484C346FBC
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792219943; cv=none; b=JT758v+8oSi6EbxQTvKW0eW6LfI/WAyjaIec/NcBupN+Ro2+gtSdPf1gZilkIsrECLdMgR9aRfnhEAJBxfA1UD3RVMlLrHN++F3TScky7XXH0GAxoKlDNhNm3f2znj8FYs6PxCzTJYyauc3U6ld6viBWppXhn0w24xEtc6W/4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792219943; c=relaxed/simple;
	bh=Kybexu66lqI9YRIf7b+Zoa2dvGRGmZFqJ8SVbgdSrJw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=skV0tTsem7zkrm29nQ6dflhHTAE5yXK8DYxzvJU42hj3/K+ai6R4ryJskBsNfrGEo8AxdIe/iOINwnOCkvh8WocIjRYSEh/z52Fxp89V4tia+D+o4GF9KKJrid3/s60CSP6kk2jmgbzkjaIFBkRwxtKZgKnf8ahwAa0WiL4WmP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QH7BQGr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QH7BQGr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B771F000C4;
	Sat, 17 Oct 2026 06:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792219942;
	bh=Kybexu66lqI9YRIf7b+Zoa2dvGRGmZFqJ8SVbgdSrJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QH7BQGr5DjDygYFXH9QLsh+f2iFvZQCOqtzUwWUJKMCGLkdeQ8+NOZFRJInT4MTUt
	 ZdM/ZhtCFGc4zJOEOo/8AgxuS7iK2acjqTe4zEvjIbCK7sLReBXeN4IERLEHMyE20f
	 p+M8RLIxGC8pRpjTAbpkQ/g6g2BGzjfYl+aD/EEBu64IyEDra5Fqz6Qo5+KYkDdWVi
	 /JQCZ5pCYVZ95N6+lL37qh4jeJlQKD3XfDclIsRMvWqfGZH+m9rq8mq9p81ssUoS88
	 +LtzqlQkAjyg/OTt1O16OWNSEfSiFDoRHd3ZnKbRYAVf1x/oCp7GbuGGZuF/9Rn+pX
	 OEgc7s8ZdJ3Fw==
Message-ID: <sashiko-outbox-175353@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 02/10] RDMA/mana: Create and destroy kernel
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-3-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:52:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement kernel RC QP creation and destruction. This feature requires
> extended-WQE and power-of-two-SQ support from the HW.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D2

