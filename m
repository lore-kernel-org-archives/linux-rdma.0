Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546317;
	b=DM24XQMmWjgzSLpjKX6Fn4ghz5kbDHTU//T2Gyvxjk3Y7WocXYhcRcnUttJudGS/7QTT
	 CcKNmzCF0eoXoFJFdufbhrDxSN76DcDQ2jlsEQqzH5oIvNfX/OhUJeoxkYTfGuPNDVh45
	 irc647yE08Hv4CjMp4FmxZB96iUYwlZDowQ0/00aiJNctdjVbfRgeez7l2ktGYcperz1G
	 siIjhmGWwDSEqe6UK6dEFCdZTU3+tDUSXMkV56l466DoJiP85HTojSZQNmv6K84MnN9Pc
	 /Fo+LHVkxdsvqEcUIKDHYR/7EpBjgZtxI57TfYic+1uuLLVeb6alsDslLpvef1FKxkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546317;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VV5NkUtKHSOKkIc9N2qJR+fEYMSQq5H0M4IhHZy5ySI=;
	b=DUVBuefkMvtJVHIcYlNEXeVQGwAxBmzkm15nhlacKaZM92P5+2RnTuxYqrTG34MDw4D0
	 KJk+ut43SK6FZCUWKFBczYroiGdhfAhjnUUZ36XZAn8JeiPsjPSWF4kVQ7L8WsAFpGBke
	 CxNCobEMTydC0Sa+L/9USnXj+6HItfnLo/5t608I6BjUG1ZkjHebgKmnRKVsIaipfk3L0
	 aLOJhcc4aZ3WU+VamFbpKv9P3V00vOv8aZiCouR7lv/9vK6PUwyRtW4nKupPiX/zshT2g
	 xPv+xRIQmZqHO2Dm1fBFq0bNrjGMSS6Ur0xH1Cs4fv3idVnha8aW/k6YJC2COqlZafA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqjN6U0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FC4606A323
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqjN6U0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704EA1F000C4;
	Fri, 13 Nov 2026 05:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546317;
	bh=VV5NkUtKHSOKkIc9N2qJR+fEYMSQq5H0M4IhHZy5ySI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jqjN6U0w1G+bIO0dI8uRPa5dWoACiyjKVaUboFZgH0tnQ1yYB9ngugwBuykS/H6/K
	 CKhuZakwwZAMFk78Uub4h/ZVda0VoOonQ07bkgUrPSBupNSwuCt/u9iaQQkgcmkM4d
	 z0THeSdV2EfN6t3LUdGlsvotVs6jBg/3JpkblZUw8duDUCT4YE497Mn8Uo8OgyPQCN
	 yc+RVj6fZCYKoEQvyTPMs0LU8CjGnmdi+N727S2dld1lSkc/NZ8upPiG+rUNVDbRxl
	 kssL3hvncb3zpFico0yHxJnSsZt1hqpOXc7qlv69ca5FoT7Tn3qD3gX7tCZDkHsk7t
	 DrPjT89S5C3YA==
Message-ID: <sashiko-outbox-212201@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 12/12] net/rds: drop rds_conn_count in
 favor of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-13-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The patch "net/rds: wait for connections to be freed on transport
> unload", earlier in this series, gave each transport its own
> connection count in t_conn_count, incremented and decremented at
> exactly the points where the global rds_conn_count is.  That leaves
> rds_conn_count with a single remaining consumer: the seed of the
> per-path workqueue names in __rds_conn_create().
>=20
> Switch the name seed to t_conn_count, as UEK does, and remove
> rds_conn_count.  The numbering becomes per-transport instead of
> global, so connections of different transports can now receive the
> same seed; workqueue names carry no uniqueness requirement, and the
> seed was already reused as the count rose and fell.  Removing the
> counter also removes the rds_conn_lock round-trip that
> rds_conn_destroy_fini() took solely to decrement it.  (The free path
> still sleeps in destroy_workqueue(), so the last reference has to be
> dropped from process context as before; only that one lock goes.)
>=20
> Based on the Oracle UEK commit "net/rds: Each RDS transport
> should keep its own connection count".
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D12

