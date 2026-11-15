Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794716091;
	b=MKsMq4Im1lLSjfoSmq7pB+bXvz6n/cRSsYP1lNAvbzmWQ/AwzYDFSycqvwfwMkBwMfT6
	 Gmjl6gXiC9CaXcnyXfxiJFKnRNH7pG0YSfpiKi4VLhABvwalSLG3WL9k84f87sewklFif
	 +eN1tCToI5AKjMDtDwuMq+KWPnx09lvxeJ8s0mV3PysPb9D6hFq1ABsBljoXoZFXRW/me
	 wOqzcdp7aZBX/yqOITPvgWhzk2giTOgUYQYuP3noXpmC0+72VhshMWnw1gggegJyilKFz
	 MPBmnY3mb72mLSZoe8vtZx/dQ50AspB13psqXV9op1XQQoWZhCjP6JmkFuzbtbwRKlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794716091;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8fw2rn7LuYvDeshIS0IQuo1JB+BlXWszsn/QPcC+KmQ=;
	b=WGQP6YqgCL/fm0hSPYAWM96KrQ68ypgQFYpz4D3JfW99OmpouJL46he1CV+b1YLMyblm
	 uMSCKhzaZMUeQg24PYCwR9JdgIdQ8+L/v91qyzqiG4XZWmCi/OB3tbBpCMGuyOL4bFJaJ
	 p4UG/BWR9PeDtMkXfgnZH4328iawudNBqpJZ8v0eFHLfV150bO5C4jTCNgW4EYrp1EcWG
	 rTIrvqrv4rq1apa+UG3Tg4fTvkohWN7GceBdMxghOdyQ8LCHtWkVzVVQzCVX80eZ8kjxW
	 ZVL8KseZETgS8IZhrPJb/yd3jWRntjaLkN8wc2QbXS8hcfkQ7J9HfuyU52bHmLZGYqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfNZJY3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD04606A339;
	Sun, 15 Nov 2026 04:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfNZJY3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14571F000C4;
	Sun, 15 Nov 2026 04:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794716091;
	bh=8fw2rn7LuYvDeshIS0IQuo1JB+BlXWszsn/QPcC+KmQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jfNZJY3Z2cJ5Rb6u3xY9kdCkP2eiGOkXW/i/sCoZVd6luRn/cdMXixwMgyNx/uv2x
	 wdtjwqgGTL2T/xQOGc+3z2SnoEMnKqxq1d611WLfHAq/jvj/3oCTow+lzb5hVj3PBx
	 wmKHTm1hzUsvAU2/aKwbVqLaOsFi/rBa62lK+ACR9UNKzZ+r4zIGvTy0pgn5jlUUND
	 VS0WzcHXLOFMoKFN2mYR/yvmfAMFN6sKubATBST6O5Cu0IjQJntlrcXbGbAzavi8+a
	 d3m5hmkey5HR2uWtTKljuTGZ+72y7xMmp3/+KBgKT9FCIyuiR6q7G4mHUfzyWiOwf4
	 oLobFAF8Zt4Pg==
Message-ID: <sashiko-outbox-215220@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 4/4] net/smc: order the urgent mark across the
 cursor wrap rollover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-4-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-4-4a7c8d85d849@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 04:14:50 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] net/smc: TOCTOU race in smc_rx_recv_urg() [1]
--

commit 474a1c81553cc3992c5253fbaae536390326e390
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: order the urgent mark across the cursor wrap rollover

This commit replaces smc_curs_comp() with smc_curs_sdiff() in
smc_rx_update_consumer() so that consumer and urgent cursors are ordered
correctly across the 16-bit wrap rollover, and removes the unused
smc_curs_comp() helper.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 63c178c10bf1a..0345167cdc0dc 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -68,8 +68,8 @@ static int smc_rx_update_consumer(struct smc_sock *smc,
> =20
>  	/* did we process urgent data? */
>  	if (conn->urg_state =3D=3D SMC_URG_VALID || conn->urg_rx_skip_pend) {
> -		diff =3D smc_curs_comp(conn->rmb_desc->len, &cons,
> -				     &conn->urg_curs);
> +		diff =3D smc_curs_sdiff(conn->rmb_desc->len, &cons,
> +				      &conn->urg_curs);
>  		if (sock_flag(sk, SOCK_URGINLINE)) {
>  			if (diff =3D=3D 0) {
>  				force =3D true;

[Severity: Medium]
This problem wasn't introduced by this patch, but can smc_rx_recv_urg()
race [1] with incoming CDC messages and duplicate an urgent byte?

net/smc/smc_rx.c:smc_rx_recv_urg() {
	...
	if (conn->urg_state =3D=3D SMC_URG_VALID) {
		if (!(flags & MSG_PEEK))
			smc->conn.urg_state =3D SMC_URG_READ;
		msg->msg_flags |=3D MSG_OOB;
		if (len > 0) {
			if (!(flags & MSG_TRUNC))
				rc =3D memcpy_to_msg(msg, &conn->urg_rx_byte, 1);
	...
}

Although smc_rx_recv_urg() runs under lock_sock(), smc_cdc_msg_recv() in
softirq context only takes bh_lock_sock() without checking
sock_owned_by_user():

CPU0                                  CPU1 (softirq)
smc_rx_recv_urg()
  smc->conn.urg_state =3D SMC_URG_READ;
                                      smc_cdc_msg_recv()
                                        bh_lock_sock(&smc->sk)
                                        smc_cdc_handle_urg_data_arrival()
                                          conn->urg_rx_byte =3D new_byte;
                                          conn->urg_state =3D SMC_URG_VALID;
                                        bh_unlock_sock(&smc->sk)
  memcpy_to_msg(..., &conn->urg_rx_byte, 1)  <-- copies new_byte

The first urgent byte is lost, the current recv(MSG_OOB) returns the new
urgent byte, and because conn->urg_state was reset to SMC_URG_VALID, the
next recv(MSG_OOB) reads the same new byte a second time.

[1] https://sashiko.dev/#/bug/linux-fba17bf0-1137-4667-8969-554d43e1d736

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-1a=
9ab9b0-v1-0-4a7c8d85d849@proton.me?part=3D4
