Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749563;
	b=kQjHvWdpuySN2CDZTwxJ5rjpuBtclvSzaoof1YKjgeFyhXEcQHsEk0E1VaFwLGJ/hewB
	 vFVDFWL5SQgjaMyK+XQao9375nMOiIoX2otuYFKc2CKbGSvQ1jQ4YBarTirMLoabKv8A7
	 K4+4xMmY0CSggvPA8/OZgTf2NygdYsBiR/aWCeMWefSj/voD9PuR6cWkwDDEQ4I3ba6H6
	 Tf3Buve+QeU5N59JHy/L6ae6YbjnMicW9myfRKDxh3tWw+foRDAAyS7qAWxpHpi9VuVoo
	 vgDUFUpoq4MqSm8wi59kAb8Q6c6wEh2rNkqi+LFd4ippPF8BA/FdE9tZX9Z1F6dsY4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cSHDLNbZsm3nQlQeVNh2RfgXeM1VhmNJK24/N2QiI7Y=;
	b=3vewq3P18YBlCwhcKaJAw1fycWO1m6pA0BpYVxBo9tbAPDmSko1PWjRBtS2UJCHuGU8W
	 pLz+mZ+wQtv9ZJNtO/xy+48ROj5zSVQHJw/tpGKQYrBKFgJrhy7PA2KhVQXqemu45L1Y7
	 zrDMH8BZdb9uEEuIMpquMFzE7mPHtCbQdepgZCDETRTBYEURnA93mWF5Q6+qm2T/0CIED
	 Ha1LFN6NyNQ0Z35fJob2LzWn/18pC69LeJQ6cd2CO5Np11WDRcGzZTv1CUNqbhMF99s8i
	 EAjlNFYO7vHaUxzMWeOkRcmgn7KcsDnJQx8Ffj9gG0Q8Zlu/FqsCYNhUD67BXE811BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXa2xjfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09AF606A331
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXa2xjfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7433C1F000C6;
	Sun, 15 Nov 2026 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749563;
	bh=cSHDLNbZsm3nQlQeVNh2RfgXeM1VhmNJK24/N2QiI7Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QXa2xjfl2cyGp7fm0i677wO8TuW0BmzpvatEXeqfeavepgsiaP2M/slpW3vQOF4PT
	 NI3uT2mNDBBLfV2+U5/iWH4s9Yq6BWp448KLAUxBr/EP26h7XpgfCzZhc78Xpuj/UN
	 1dmP/3+wkOSO3gp1sorIB041MSIVEm3hC3QzukdKG0mN6ug00Z+rMdzYyzKCM8M8WZ
	 Bh12jCqQjgsbK7EoiG5rkD1fMgdHtJSWjgXLdhE3iypmOYDrZh/32lCjTIdjhC7yrK
	 uMlKB8AVsECx4ZwRRM1ryTr4uWFt05nnNaA3LjtdS6vvWFAc1K9cTiFI8bmJwrFD3t
	 yI+3hfLIV6CTA==
Message-ID: <sashiko-outbox-215530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 net-next 2/5] net/rds/ib_sysctl.c: move sysctl-only
 code under CONFIG_SYSCTL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <avmyu2SQTjdC_jjd@redhat.com>
References: <avmyu2SQTjdC_jjd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:32:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Collect all code used only when CONFIG_SYSCTL=3Dy into a single block and
> wrap it in #ifdef CONFIG_SYSCTL. rds_ib_sysctl_init() no longer needs the
> IS_ENABLED() check.
>=20
> Add the corresponding init/exit stubs for the CONFIG_SYSCTL=3Dn case.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avmymGvelu00X5EH@re=
dhat.com?part=3D2

