Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766582;
	b=d2lj2nEfExIsaJWPJbjSbLZKa2qNhb2hM2ZvyUhjIx8lY7DLN68pTLTk3Gai9PMI0CGy
	 /xw/QXhmaEAby6zAcHY5SLbNlhh73XuD2SA1xZZIMiNXPmPeyzHxI9xw/BmhLVXNFMLlC
	 JweJMavcVH+E5w1voPaSPlTqlX7+AtLCjcNNvsI5m8j7BW6eB/wubcxSMV0bYd75iR4/w
	 5RwFBiLLOWMQoow7LOuGE18LSVVIe3nO0CMWuEv42Qim79/HWMfAbhT4MsP+Q2ggtINZX
	 K+r1Aa49ZxnjmmkMEXRd0/nngELE0qrJhK57Byyab76GO80BcLG2JmsRNO1izQubOWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0xGuWBmfCi4H62qrljPZ5mq3RCH5HcI4uYK1cW5kkts=;
	b=TaEpIW4fxSoQBr33pktO+k3FDrQzaPQTiHWQnripFIMrp1ZTFdXtvoq0TIRB0afl13Qn
	 SP94JwOY2oOs51sR2oG6YjY46A9FKZCall83JZvuLQkWAUcbJTtDBoo96Q9HlWVVWtUoa
	 CuP3UIyFIMcItgnNgJuUvUtNhscfJiETkRWYb5F/mqDVwqRVFDntb2DjP1/Raq4zO8DKs
	 i4/5FQMHgcWGekWBAy4v2GOTunO3OEK6LGPTc+bIVdjUXoCMvL/5I23Lu8UDgs/OfdCFw
	 cdZv8WBfDNfeE4wwvaerHp/AB3RUvejBeTCp+HkpBwtGJLbNkSjNQVUjaweLrNtmTsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5Jp4gCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E8C606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5Jp4gCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C461F000C1;
	Wed,  4 Nov 2026 04:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766581;
	bh=0xGuWBmfCi4H62qrljPZ5mq3RCH5HcI4uYK1cW5kkts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E5Jp4gCbBXIdx0Z7gXLWjdOH/XwbEUk35CsC5Wz8bVcyRs95AntFlkMRj93hgnQjj
	 dYzRi1mmM24bzkOrEK7rJBnJZO9jm6SX8+NUzOa85gqk4bzCvd0hI7+EgywQm3hJp/
	 Dz5Y57O6fq+mslnXKOm3qKV3V+R0f14lKrSvYiFZor+FSJKn69vZOwgFGNmCdrr35b
	 1TBk80Y1bDHd9+WJQY/145moMNWQ86Vqg5oe45NLhsm3AZc/xQLHWgeY4BGZ/pyEfI
	 H4Igswp/IW+p/TdBqb2zWLCmZDJtEYZbsCLNgGAOICAJt81GPRfiui0siGAqsnxXi6
	 LsKZ6897XdVnA==
Message-ID: <sashiko-outbox-196653@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/6] IB/isert: only reinstate a connection that
 reached full feature phase
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-7-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:29:41 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D6

