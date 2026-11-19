Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094785;
	b=1GHiJPmKMhZAPc4faGJSEGYcmd8Vq+DTQjbeVpS2wYGojhWfcl4x6jo7oCeHt/ZiqN8V
	 cBA/jZj6EK4yfpOXw5oxOg+IABVV5bmlpUEXiymfHfhCHdNkojaH0+xGw33mNtzy02/c0
	 4eXjq+ktrdgJX9ME/3wopqy4Cq1mZO0yB65b/wlRttD9qvkYj9jjeOA13xaAoO9o3I/vE
	 6gwtEQYv6UOPWSnIexLgbMaghQvNA/RD4jn1j8UKniiML3BhQW1GvJe43B3QEhAk3T2yl
	 3i4UAI5y7hZGAFYWO4TwwGGSvyGMZ7iYnvZvsdWia9fl4mWbj+kkqfvjuRi0Ahi5Fug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094785;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Zm4EvZ4HsKyTWHuwWWAcPW+sUt6CVQEhDSKm7e6agao=;
	b=jJBOerIjzQXRazfL5K77fZ/i/MJj4ZsezoyiXEUkULjBFtXjgKlhQHpnx24mBl/UEuuM
	 67ZJG1RAK2YeaEkHXhbsxuLYinnwx+tcExD+4+DXZ5BQ6fQ9ivkDRKjWQZUeH/D5HkomV
	 C2KzoH4R+D2NdETea8Afs+PT5jzyanHlBXz1XriC9gnGoXZYwRg0fDixCg5YlE2Dn5BIJ
	 D21RxCBZHgWGwsO3Jpa3PVCXhqVH8OQRWktuaGIhz3De5l7l1EENmHJDHnE35Ysjycpej
	 ngoi72KGdmJA2uAsp2l7BazTrDPAf9FXlKG8QxPQIX9ZPlkgzxE7WtbC025IUQHpBxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ad9g66Mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D76606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ad9g66Mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34621F000C6;
	Thu, 19 Nov 2026 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094784;
	bh=Zm4EvZ4HsKyTWHuwWWAcPW+sUt6CVQEhDSKm7e6agao=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ad9g66MjEhBY/hro5EDzXUMGB6fUqWZUCqDbW4+gFU/F+u98TK9sIUq5yEXTzzCNT
	 BjLuiXH/dmcpXOgEegrznz96dtId8Jh8F8HOpX0APkth1eowXRlii74CwwYW1G03XB
	 tlEfa7o4C6D6SF3fisg7vXDZmIl6JkoafcfcscG4/fMEemEqHhHx8Au4gP1pLEEIQb
	 pFA8KoWXYR6x0ty8csrNXeOqHafSPBY4XpO941icQo4XcIpBg4EoP2J7tiVpIIgEhv
	 9Q7o9ZNWpngzi96j/FXV8ZLumbgtojRgL5v+OwSP7y1sR+o2QhkjA8MnNqw2ePq4Bz
	 yDFEUSBBX5FYQ==
Message-ID: <sashiko-outbox-223172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/4] scsi: target: iscsi: do not arm the nopin timer
 on an iSER connection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119131700.2722108-3-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
 <20261119131700.2722108-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:26:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iscsi_post_login_start_timers() does not arm the nopin timer for
> ISCSI_INFINIBAND, under a FIXME that says unsolicited NOP-In is not
> supported there.  It is the only place that looks at the transport, and it
> runs once, at login.  Two other sites arm the same timer for a connection
> that is already logged in: iscsit_process_nop_out() after a NOP-Out
> response, and iscsit_na_nopin_timeout() for every logged-in connection of
> an ACL whose nopin_timeout is written from 0 to a non-zero value.
>=20
> So an iSER connection does get unsolicited NOP-Ins, and iscsit_add_nopin()
> builds them from a command of its own.  Writing nopin_timeout 0 and then 3
> on the ACL of a logged-in iSER session kills the target on unmodified
> mainline: struct isert_cmd is all zero for such a command, and
> isert_put_nopin() hands the NULL receive descriptor to isert_post_recv(),
> which dereferences it.  That part is a bug in isert and is fixed two
> patches on.
> [ ... ]
>=20
> Link: https://lore.kernel.org/all/20220311175713.2344960-1-djeffery@redha=
t.com/
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) t=
arget driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119131700.2722=
108-1-yhlee@isslab.korea.ac.kr?part=3D2

