Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407698;
	b=bfnw4j4tcd+HYKeqMOXalA+2Wkr4XW9ycJHuBmUJpEqUvqME6XpGCPRpS6FZ2kQcIsXZ
	 2hmVmL+aBgSK+sjbJLwI3HmCMqrFXP+oEd4Lif1M0bRsQJIVKDN/+y+cCvOru5Wq+WS6d
	 3kYivUNl/zdBaoXYCesA1vQua+25jOtuqk7EznzaqYlFZwEEKr3lfx2BGwt9Lzr7ypZud
	 Vr92sIR0XP4mUtl6emTIWahOG8FztUB5nb/HK4uAHFYjt5ZR4R+nm6AZYDQCptLt+wE5+
	 588lsfXbhsTFLCeWX22i08ZGFlLmWCAFVDRm7/4Rz1ksjH2gYjH2mGlMPJNecChf1VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407698;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GudrQLkt3cIq/ydiM9APOriiD19KGFM+GAKuKvZTnVI=;
	b=Amm6gbHTwGEzEwJAIh0adv+x+z3UQJBcs4lNdYzNMp/+7CPbQL7ABc5kg1Ub6aE/pf1y
	 T5nvP7EfZZaZTjyPcIPWuD2SssUO49J4599GH1dP1oBYcP2AlUZfx7mZyGhPNjN1zBox6
	 ki+qRw/bQHY5Fuz5ABwkBBtXmgstTS3gxsvHzRz7Eiow1c18EIa1NCyQRRr6EdWJ0jjBD
	 mb7c5cMxyK0ggUAdnTirUOJha3BJmJ+MqDv4DYt9akqfLYFRkYoFRxaEZLLAey0NYmIj4
	 RFX61VgVfqQPO+ZS/AfAZwjMTO+wBxeIq57k3iioTnEY9ZZuugKAjG1bBZxHUhkdDVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVqNXlP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57CA606A31E;
	Mon, 23 Nov 2026 04:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVqNXlP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43851F000C4;
	Mon, 23 Nov 2026 04:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795407698;
	bh=GudrQLkt3cIq/ydiM9APOriiD19KGFM+GAKuKvZTnVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AVqNXlP4tnkp4eUy7vtRl5DK5pb8H8M2v6ccrfvCJ0OucWwFL+6ur9X7jrQpMNsXv
	 Jt+V0tYBo7TGM0UYs9/B01n2+rbfouFFXZy7+R4UNbwiW830Fv0jyTpbbVU28I8w4y
	 scIuiuAinOass3LL6NZ5muFGPVgH8O4WE/MZ4LGJ/glUlf7JwKwsX7uENTs0tpXECT
	 /jUimLGy/aRO27lrJ5kAzbh7zOgZZC1BWk4XxHBmALAiG+yUqvjM20/d06BvlbRNlv
	 dvpwNq0UgqAboOWJ7S2C4m/973DHOc2gMONsQqXkRyQBXxYfpCvXFAUsIDtXJ9oDZu
	 QHIllnk3MeZnA==
Message-ID: <sashiko-outbox-228652@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/smc: validate the peer's CDC cursors against
 our own buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Piyus Kedia" <piyus@iiitd.ac.in>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261122042120.2430434-1-piyus@iiitd.ac.in>
References: <20261122042120.2430434-1-piyus@iiitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:21:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Critical] net/smc: incomplete cursor window validation in
  smcr/smcd_cdc_cursors_invalid()
- [High] net/smc: missing sndbuf_desc check in
  smcd_cdc_cursors_invalid()
- [Medium] net/smc: off-by-one cursor bounds check in
  smcr/smcd_cdc_cursors_invalid()
- [Low] net/smc: missing Fixes trailers in commit message
--

commit 36bb44cca90308f9abd225ce16ee4c2f15a0b111
Author: Piyus Kedia <piyus@iiitd.ac.in>

> net/smc: validate the peer's CDC cursors against our own buffers
>
> A peer's CDC message carries two cursors that are offsets into buffers
> described on this side: the producer cursor counts the bytes the peer has
> written into the RMB we published to it, and the consumer cursor the bytes
> it has taken from the RMB it published to us.  Neither is checked, on eit=
her
> transport.
>
> smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() copy both into the
> connection as they arrive, and every later user treats them as trustworth=
y:
>
>  - smc_cdc_msg_recv_action() adds the producer difference to
>    conn->bytes_to_rcv under a comment asserting
>    "guarantee 0 <=3D bytes_to_rcv <=3D rmb_desc->len", which nothing enfo=
rces;
>  - smc_cdc_handle_urg_data_arrival() reads
>    *(base + conn->urg_curs.count - 1), an unbounded index into the RMB;
>  - smc_rx_recvmsg() clamps only the first of its two ring chunks
>    (rmb_desc->len - cons.count) and uses the remainder unclamped for the
>    second, so bytes_to_rcv becomes a copy length;
>  - smc_rx_splice() walks PAGE_ALIGN(len + offset) / PAGE_SIZE pages calli=
ng
>    vmalloc_to_page() without checking the result, and get_page() then
>    dereferences NULL once the walk passes the end of the RMB.
>
> A peer that reports a cursor larger than the buffer therefore makes the
> kernel read past it.  With a 64 KiB RMB and a forged cursor, KASAN on
> 7.4.0-rc3 reports a 1-byte read in the urgent-data path and a 131072-byte
> read in the receive path, the latter via _copy_to_iter() - i.e. the
> out-of-bounds bytes are delivered to userspace by recvmsg() - and splice()
> oopses on the NULL page.
>
> Validate both cursors where each transport accepts the message, so that o=
ne
> test per transport covers every consumer.  Each cursor is bounded by the
> buffer its own arithmetic uses: the producer cursor by conn->rmb_desc->len
> as in smc_cdc_msg_recv_action(), the consumer cursor by
> conn->peer_rmbe_size as in the diff_cons calculation beside it.  A cursor
> equal to the buffer length is legitimate (a full ring), so only a larger =
one
> is rejected.  An out-of-range cursor cannot occur in a correct peer, and =
the
> malformed message is dropped like any other.
>
> The SMC-R check sits next to the existing length and sequence-number tests
> in smc_cdc_rx_handler().  SMC-D needs its own, because smcd_cdc_rx_tsklet=
()
> reads the cursors straight out of the DMB the peer writes into, in host
> byte order and with no validation of any kind on that path today.
>
> How this was found: by AI-driven fuzzing built on top of syzkaller.  Its
> analysis was then checked by hand against the code, and all three faults
> were reproduced on net.git main under KASAN, with the patched kernel clean
> on the same three reproducers and ordinary SMC-R and SMC-D traffic
> unaffected.
>
> Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
> Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>

[Severity: Low]
Should this include Fixes: tags for the commits that introduced unvalidated
CDC cursor reception on SMC-R and SMC-D:

  Fixes: 5f08318f617b ("smc: connection data control (CDC)")
  Fixes: be244f28d22f ("net/smc: add SMC-D support in data transfer")

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..8d24e0c839260 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -433,6 +433,18 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, s=
truct smc_cdc_msg *cdc)
>  	sock_put(&smc->sk); /* no free sk in softirq-context */
>  }
> =20
> +static bool smcd_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smcd_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;
> +	if (cdc->prod.count > (u32)conn->rmb_desc->len)
> +		return true;
> +	if (cdc->cons.count > (u32)conn->peer_rmbe_size)
> +		return true;
> +	return false;
> +}

[Severity: High]
Does smcd_cdc_cursors_invalid() also need to validate conn->sndbuf_desc and
check cdc->cons.count against conn->sndbuf_desc->len?

On SMC-D DMB-nocopy devices, smc_cdc_msg_recv_action() uses
conn->sndbuf_desc->len when diff_cons is non-zero:

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
    ...
		if (conn->lgr->is_smcd &&
		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
			/* Calculate consumed data and
			 * increment free send buffer space.
			 */
			diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
						&conn->tx_curs_fin,
						&conn->local_rx_ctrl.cons);
    ...
}

During handshake setup in smc_listen_work() and smc_connect_ism(),
__smc_buf_create() registers conn in smcd->conn[] with conn->sndbuf_desc
still NULL, and smc_conn_save_peer_info() sets conn->peer_rmbe_size before
smcd_buf_attach() attaches conn->sndbuf_desc:

kworker                           <softirq>
smc_listen_work()
  smc_buf_create()
    smc_ism_set_conn(conn)
  smc_conn_save_peer_info()
    conn->peer_rmbe_size =3D ...
                                  smcd_cdc_rx_tsklet()
                                    smc_cdc_msg_recv_action()
                                      conn->sndbuf_desc->len
                                        <-- NULL pointer dereference
  smcd_buf_attach()

Even after smcd_buf_attach() succeeds, conn->peer_rmbe_size comes from the
peer's CLC message while conn->sndbuf_desc->len is the attached DMB length.
If the peer advertises peer_rmbe_size > sndbuf_desc->len and sends
cdc.cons.count between the two, smc_cdc_msg_recv_action() credits
conn->sndbuf_space beyond conn->sndbuf_desc->len, allowing smc_tx_sendmsg()
to write past the end of conn->sndbuf_desc->cpu_addr.

> @@ -452,6 +464,15 @@ static void smcd_cdc_rx_tsklet(struct tasklet_struct=
 *t)
>  	data_cdc =3D (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
>  	smcd_curs_copy(&cdc.prod, &data_cdc->prod, conn);
>  	smcd_curs_copy(&cdc.cons, &data_cdc->cons, conn);
> +	/* This CDC was written by the peer into the DMB we published to it, so
> +	 * both cursors are peer-supplied and index buffers described on this
> +	 * side.  Nothing else checks them, and smc_cdc_msg_recv_action() uses
> +	 * the producer cursor as a receive length and the consumer cursor to
> +	 * credit sndbuf_space - which under DMB-nocopy is the memory the peer
> +	 * itself owns.  Unlike the SMC-R path these values are host order.
> +	 */
> +	if (smcd_cdc_cursors_invalid(conn, &cdc))
> +		return;
>  	smc =3D container_of(conn, struct smc_sock, conn);
>  	smc_cdc_msg_recv(smc, (struct smc_cdc_msg *)&cdc);
>  }
> @@ -466,6 +487,26 @@ void smcd_cdc_rx_init(struct smc_connection *conn)
> =20
>  /***************************** init, exit, misc ************************=
******/
> =20
> +/* A peer's cursors are offsets into OUR buffers: the producer cursor co=
unts the
> + * bytes it has written into the RMB we gave it, the consumer cursor the=
 bytes it
> + * has taken from the RMB it published to us.  Nothing else checks them.=
  smcr_cdc_msg_to_host()
> + * copies both into the connection, and from there smc_cdc_msg_recv_acti=
on() adds the
> + * producer difference to conn->bytes_to_rcv and the receive path uses t=
hat as a
> + * length - so a peer that reports more than the buffer holds makes the =
kernel read
> + * past it.
> + */
> +static bool smcr_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smc_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;
> +	if (ntohl(cdc->prod.count) > (u32)conn->rmb_desc->len)
> +		return true;
> +	if (ntohl(cdc->cons.count) > conn->peer_rmbe_size)
> +		return true;
> +	return false;
> +}

[Severity: Critical]
Can a peer still inflate conn->bytes_to_rcv past conn->rmb_desc->len (and
conn->peer_rmbe_space or conn->sndbuf_space past the send buffer size) by
advancing the cursor's wrap counter while keeping count within the buffer
length?

smcd_cdc_cursors_invalid() and smcr_cdc_cursors_invalid() only bound the raw
count fields in isolation.  In smc_cdc_msg_recv_action(), diff_prod is
computed with smc_curs_diff():

net/smc/smc_cdc.h:smc_curs_diff() {
	if (old->wrap !=3D new->wrap)
		return max_t(int, 0,
			     ((size - old->count) + new->count));

	return max_t(int, 0, (new->count - old->count));
}

If a peer sends a single CDC message with prod.wrap !=3D prod_old.wrap and
prod_old.count < prod.count <=3D conn->rmb_desc->len (for example, from
initial {wrap =3D 0, count =3D 0} to {wrap =3D 1, count =3D len - 1}), both=
 helpers
accept the cursor, and smc_curs_diff() returns (len - 0) + (len - 1) =3D
2 * len - 1.  The peer can also advance prod across multiple CDC messages
faster than userspace drains conn->bytes_to_rcv.  In either case,
atomic_add(diff_prod, &conn->bytes_to_rcv) pushes conn->bytes_to_rcv past
conn->rmb_desc->len, triggering the same out-of-bounds read in
smc_rx_recvmsg() and NULL page dereference in smc_rx_splice() described in
the commit message.  The same applies to cdc->cons, where advancing
cons.wrap or moving cons ahead of transmitted data inflates
conn->peer_rmbe_space and (on SMC-D DMB-nocopy or SMC-R failover)
conn->sndbuf_space past conn->sndbuf_desc->len, causing smc_tx_sendmsg() to
write past the end of the send buffer.

[Severity: Medium]
Should the cursor count checks in smcd_cdc_cursors_invalid() and
smcr_cdc_cursors_invalid() use >=3D instead of >?

Every SMC ring cursor is advanced by smc_curs_add(), which wraps count back
to 0 as soon as it reaches size:

net/smc/smc_cdc.h:smc_curs_add() {
	curs->count +=3D value;
	if (curs->count >=3D size) {
		curs->wrap++;
		curs->count -=3D size;
	}
}

A full ring starting at {wrap =3D W, count =3D 0} is represented as
{wrap =3D W + 1, count =3D 0}, so count =3D=3D size is never produced by a =
compliant
peer.  If {wrap =3D W, count =3D len} is accepted for cdc->prod, consuming =
those
len bytes in smc_rx_update_consumer() advances conn->rx_curs_confirmed via
smc_curs_add() to {wrap =3D W + 1, count =3D 0} while conn->local_rx_ctrl.p=
rod
remains {wrap =3D W, count =3D len}.  In smc_tx_consumer_update(),
smc_curs_diff_large(len, &cfed, &prod) then sees old->wrap > new->wrap,
takes the 0xffff wrap-around branch, and treats an empty receive buffer as
full.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122042120.2430=
434-1-piyus@iiitd.ac.in?part=3D1
