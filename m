Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003267;
	b=yVyveGyWLC5JNLE1YtiqOcB/t10SugZkSm/HL7dMMjCXDELitSTcHeQAkLHH0NN/mA9G
	 vTZX8j+N3MlpXRlstyMf/Vze9KUsa10ElmB96g5YHbripfKYWlt84ynNHrq18goxE1X2g
	 8AKDj9kVdYBSj+NEbFbfsJsL4H5G4xj/36ixXadVnpMloJblR5i14ZnUIsqS3cECX4v3G
	 YRFrAU7TpUyiy0fAZrVIu6L5b67scNCxUr0OOn+Z6RU3beMfI73gZpjnPF4SCI2b6z93R
	 7dbCREfTF+x7NmT+uGdkUIF6OpwtylpWF17Y5xhmFbBC0OEOCvJtlbRVYCiIUsFuVww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003267;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ERVmm4ZleV0l9gH+LPg3fjie2cW9y1X5M59OhuKHmDc=;
	b=xDcCeoV8nr8XlGe89OgEYuO1X+O0nd7oGFIVgeM1zP35pV/oAz4FsXmhRomuYL6ZP9dZ
	 iMjjsunkCcMnZ2zF5mydj5guV72cbxQkIJx7xxPchw9EbYaotizECR2yjai25XX6Qb+mS
	 DMciMa+9bej3XrpWtTSvD4wzYsJwJtwAKVg0Kh/Dl4qUT1wWVECCAZMqi4Dj9ImfzGkze
	 lZfWARBqeKRLc8PuFptScfivTj+PvtD/kSmBcqpe10SQI2VRTWXvBfvncicp5hRuAeYr5
	 jh/6F/eAsDQvV3oM6YbmiflrWq+brysOQxxOK3hnsGcd5RVA06FK6vgZSJrDI3EiwmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V6BGTPkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B1606A331
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 12:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V6BGTPkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526A41F000C4;
	Wed, 18 Nov 2026 12:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003266;
	bh=ERVmm4ZleV0l9gH+LPg3fjie2cW9y1X5M59OhuKHmDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V6BGTPkXMG3q52r9/pXJYfkXJN2YC9H9+elTgDTWx3M0byQUJv7+WLuRMkbQgSvUk
	 d1PkcolmXWKFHrOku4KXJp7GateIhC0RzNWD1EeBOL5/sliWx9prbfF/Vx8qdWNYrV
	 gUZXsGL8ibuzoQ5+5B936No0U6bpmqbZ0v8rwFIIUKrJJW/u18HaFERdnBzimPqD9B
	 9+GJ1zEtExJJOEUUCB7B1J/bXUibCVWVrRt7FwHEu88yW/upsGtSlct4c078Ip3X/2
	 ytQ2EpYY8TXaW+rlxPkBL9OB4EaxpAJ03nHw5D87tFUWVNu/TWvjIGG5RKlRpH8JBy
	 oox/s1wWMw+2Q==
Message-ID: <sashiko-outbox-220868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] scsi: target: iscsi: do not arm the nopin timer
 on an iSER connection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118113905.2361969-3-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
 <20261118113905.2361969-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 12:01:05 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118113905.2361=
969-1-yhlee@isslab.korea.ac.kr?part=3D2

