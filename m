Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D5647CA7A;
	Fri, 16 Oct 2026 11:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151625; cv=none; b=R6oaCSn4unRIXbOC98DOKejDx35CbPldOEGdDNWiu43o7OwlwhtPPp9oCgmJ88iy3ODDa8zcJKlcbNaZ0j0xOwFlpW5KuHTaSFVTYscSrvKQa4dk2eiAsSMLTnph1i1VFteiadG5d7oTtLFV674+NBlw4GNHHnRVS0FzUPAREd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151625; c=relaxed/simple;
	bh=szZSVUYBtaeBY6CrbZlK5dN+KP9hQElYsClGbV6Nuhs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WcOR6Cu3SPPs4k0MG1D9W0XyOHSgKBVXSNtymqT2ImcnuIvgemLV5quIAfeQ6vS/8Sm++uTx96W7F99RhjSMImKgawJMh7ezKVMnO8Rl5Fs+0oLjvfa3mGEwo92kmfbZGhiriYgoFM08RSFvXY/FNADIRh1gdAPXRdTiB+3MZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWU9g+RM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWU9g+RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A31F000C4;
	Fri, 16 Oct 2026 11:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792151623;
	bh=AFHxka7zkAQl3KbRTbZHIQML/f/qvCWgQugX1KEAthE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PWU9g+RMJmLVNN97krMPH0rp9mma/EPVbG/Q8kWFjIeCY/WbMM8dRX2UCgXlzSOsJ
	 SYxJM7323eTkGrFP0QqKSgy1q4iCxCxtLOxg7u9lWuarZol0tm1QIpMdcI0MrBjei7
	 A4qPsBOfYIzTXj/vXcL0ETLoRFX7nnu36bi30R6nqgHu114eLqZfMnNhrga8iftO34
	 QqxmLRxoFYa88MUzd9eSyVP8DRVABO+igDNCdqLimKGXupBdfy4AoaOhf5JRDoSg+b
	 lIFGgvoIKPnx1Tks9ME5Cykwp7wTAgb9CasAQP48OZnwD9GK/E3Asu3ZKA5SLrOtjJ
	 0fnKS0/wMRVlQ==
Message-ID: <sashiko-outbox-174257@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 2/2] net/smc: skip the DMB nocopy accounting
 until the send buffer is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261015-b4-disp-2a8d85ef-v5-2-6b795e8263c9@proton.me>
References: <20261015-b4-disp-2a8d85ef-v5-0-6b795e8263c9@proton.me>
 <20261015-b4-disp-2a8d85ef-v5-2-6b795e8263c9@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 11:53:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/smc: state corruption from reused DMB peer CDC messages
--

commit 9ad2bd35a07a32a00da8818fbbfd176e9bdd1557
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: skip the DMB nocopy accounting until the send buffer is set

This patch mitigates a null pointer dereference in smc-d dmb nocopy when an
old peer reusing a dmb sends a cdc message before the new connection sets
sndbuf_desc. It skips nocopy accounting while the send buffer is unset.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 7bf902ebd7ab6..d6825f48f5688 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -333,6 +333,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *=
smc,
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn =3D &smc->conn;
>  	int diff_cons, diff_prod, diff_tx;
> +	struct smc_buf_desc *sndbuf_desc;
> =20
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);

[Severity: High]
Does this code unconditionally overwrite the new connection's receive contr=
ol
block with the old peer's cursors?

Because the old peer of a reused dmb can still send cdc messages, and these
messages lack sequence numbers or token fields, old updates are blindly
processed.

Looking right after this block in smc_cdc_msg_recv_action(),
smc_cdc_msg_to_host() is called to update conn->local_rx_ctrl. Then
diff_cons is calculated from the old cursors and added to
conn->peer_rmbe_space.

Could this regression corrupt the peer's receive window space by adding a
bogus difference?

[ ... ]

> @@ -353,12 +354,19 @@ static void smc_cdc_msg_recv_action(struct smc_sock=
 *smc,
>  		 * peer RMB, then update tx_curs_fin and sndbuf_space
>  		 * here since peer has already consumed the data.
>  		 */
> +		sndbuf_desc =3D NULL;
>  		if (conn->lgr->is_smcd &&
>  		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +			/* NULL until smcd_buf_attach(), but the old peer of
> +			 * a reused DMB can already signal us.
> +			 */
> +			sndbuf_desc =3D smp_load_acquire(&conn->sndbuf_desc);
> +		}
> +		if (sndbuf_desc) {
>  			/* Calculate consumed data and
>  			 * increment free send buffer space.
>  			 */
> -			diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
> +			diff_tx =3D smc_curs_diff(sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);

[Severity: High]
If the old peer sends an update after the new connection has already set
sndbuf_desc, is this check bypassed?

If so, could diff_tx be calculated from the old peer's cursors and added
to conn->sndbuf_space, corrupting the send buffer space?

Furthermore, looking at the end of smc_cdc_msg_recv_action(), diff_prod is
calculated and added to conn->bytes_to_rcv, and the socket is woken up via
sk_data_ready(). By avoiding the null pointer dereference, does this
regression instead corrupt the available data size and trick the new
connection into reading garbage data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-b4-disp-2a=
8d85ef-v5-0-6b795e8263c9@proton.me?part=3D2
