Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756279;
	b=LTfE2+LxwmvIDbme10yvQRhnrp2Ph5HLxvMFQFZCK7mvIZlwwxf/9RPHkU1KE52X2RMn
	 NUwA0jxxXqnklVctFcabf46rwos418qeGsJOOSEKxSIXNbsMKmVJ/mkBgAS2Fqj9dwVhO
	 i1cycen4sxfAQFkmoAA8MCWsJhz2lUQfIxAqWDXrUgfLRtCLnDCATUGNK6p1U2q3sEazS
	 aej8B4ob7LTAARMsks9kFcGegRg9/jkUrq4ioT7DvjCD8eCKjabR0076LbQ7Y5xU2AEPc
	 UWGGwWIeKl5AXgmIpTe4e8dssLC4wBB81GKqPsJM7ksRCqn1/nJMSGbG0Ri2XZSd8yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756279;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a3S+nzEVu4XshIX9vjMZ4TDXjruElyzLK0lvAWiq66Q=;
	b=2qAOPU7KfEGTnEpOszz2RIZmklss/b5uiS8ugzqMaTgQ+R9A0hqjzfXE/zTmOifmVT7B
	 7dcadwa+UtxvaElXsIacn14Tf1jKopL2+CT5eCxifFCDHSq38Toob/drC20Ke49gMGcC+
	 +wUz3xmlrl/OXRvOiUPgntjJ1GnZzKH9Rvqg2Y7nkl5Joa5dXRHHkrv6PPNjcA9mGK9jR
	 tBgIQ3E7TacH2JQ1/7jaOQOBUUqdyANWFI7dML/TmKkbAzfS1ZTs6hkWGR5VKoulzYTBI
	 +OSBxY8I7TKYQZXqOlsU3ioNtqfK17BnThDUu+r7kFZ3QR4dJ0hLgNGGkwgkiJri0Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAsyWZd3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08461606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAsyWZd3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E151F000C1;
	Wed,  4 Nov 2026 01:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756278;
	bh=a3S+nzEVu4XshIX9vjMZ4TDXjruElyzLK0lvAWiq66Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DAsyWZd3L5Z8k3xgh511O4l+qzyAMBYyuT/s0b4wtMmOtZYY599FlnGqh/n8SMw8u
	 eLvVoiDIFeQkSJYJwbTfKOk6tf9Ei8UnCErgPsTd8Dt0WDew9McbatHoEUh6HFQ0uS
	 43Y4ZHk6Q1yeqj7JNqPN1MD0O9I/xHp0iRpBC9OU5A7K0+L+/UD3AAF8CYtpVSSDHt
	 FRRr8aMKghSvZkh4qliBLTyoLxXdlKa0z7NuC5ZZzzQsSgD79o4zrl1UVK7nuahdbh
	 cQI65Q9p4Oa/ZJD0gZee0WVURKrVGm7SNIeG8it4jZ5iXt/JXT+Tr7SbjPHN9is8W5
	 O9Y+FNyIy62GQ==
Message-ID: <sashiko-outbox-196366@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 6/6] IB/isert: only reinstate a connection that
 reached full feature phase
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104012219.1759523-7-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:37:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_teardown_conn() and isert_connect_error() ask iscsi to reinstate the
> connection whenever it is bound, ISER_CONN_BOUND included.  A connection
> stays BOUND from isert_accept_np() until isert_get_rx_pdu(); during the
> final login response the rx thread is already running but still waits for
> its login completion.  iscsit_cause_connection_reinstatement() sends it
> SIGINT, that wait fails, and iscsi_target_rx_thread() returns without the
> connection exit path, so isert_remove_one() waits for ever.
>=20
> Ask for reinstatement only from ISER_CONN_FULL_FEATURE, read under
> isert_conn->mutex.  There the rx thread is inside isert_get_rx_pdu() and
> returns to the exit path, so the signal still helps.  In BOUND terminating
> is enough: if the login completes, isert_get_rx_pdu() sees
> ISER_CONN_TERMINATING and returns; if it fails,
> iscsi_target_login_sess_out() calls isert_wait_conn() and
> isert_free_conn().
> [ ... ]
>    </TASK>
>=20
> Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D6

