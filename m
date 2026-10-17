Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D7135AC0C
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 06:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792220054; cv=none; b=SyWASQfzaCoayaH6u7TvaS0bA4Rc1nTXUX8VhG0LGYgV+3Ol5Yg1aYmdYDFJ2tH4YX3uV/37+4+BlwVX3D/TKrBfQ2xoOoncrPIEyV1ItdcKamU60A6T/QTjfoZfUX56aMu3IQCy28lyDFluvMp4hrfCRf/dnVsW31GmnpOJ2wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792220054; c=relaxed/simple;
	bh=YyIBSRpAEe6NURYL3WiBgxx4aYTZobNptzvSMAPOhCo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ba4eHJw1E4fJ5GBY9d/oIs3o+HkP7DhGOjMJPuZ9K4lkyPG11b/jht26WiVuvFml3eCKagilq+P+uYIjhA5JogSwN3rfSZ0EC6tINltmGtZtUIG+RSYH6zcvWG7plHZMkQdT+oySm+N44DCHVKXVnp88T5UNsuk4AL5aSqj3bHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnnzn71F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnnzn71F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00681F000C4;
	Sat, 17 Oct 2026 06:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792220052;
	bh=YyIBSRpAEe6NURYL3WiBgxx4aYTZobNptzvSMAPOhCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hnnzn71FBrgm15NuMcBr8UIYd+DPPSEBipIMb/jnfr2HNg+MK1ZBoT5Ojnq3WNqVH
	 10Dt5WPdIEyYvVnI/EZFU6t+/fZEoFUY2B/i5H+Q98RGRzYHBRr2kFH5JryJp2nDJG
	 Qux+ba25bLiozHJp5krVn72nDEiWEZHWiiNjDbuNCMy320s0p/inqoIH0bHf8mTvVP
	 CEBWQ3DEc3bIu4yoo+DjN8xqkO7We7Hw2a9XuTve4f9m4f+y8Aht/lVQMLToO8wEtt
	 Ob/KfXRF1YtAw2Tafda+p22Cpv6l6XzrHsef2gaCMnm0uAI8iXxe5LJogndIAifqVs
	 MWNwfajmtfsdA==
Message-ID: <sashiko-outbox-175354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 03/10] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-4-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 06:54:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D3

