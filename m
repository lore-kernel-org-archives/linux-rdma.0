Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2EA2BEFEB
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 06:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440514; cv=none; b=lG6fOkalZFTsr9fRS2XpWgm/5BljnTQwK6GxDAtEl9R8k1HURpbrmwFpGez1AobkunT5gXQT4RQUI+3VxQrVA7pPfuaQm7ECZspZGN+1O+iEB57j9zJbRjTrAgzoXtz/Lt7rYdqdRyWzn5SUZ6wnxDeOgRXH9USg97Jnm2azVts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440514; c=relaxed/simple;
	bh=KQss2r6xkRjEu8q46kErD6REp6Vwaf0nuD2wUXN+Xh8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HK3L+Tns6q1hFeFhzm499jRBuJZI8tDE1f98/rEHUR2WP8XgKjkmyCzIuRCjWIL6txsiBDqPEpb/PeiU8TGjJ8ygEBFsrUfEPVT45Sl3h0F1ZN/GEAY0jcd7hp2xaN3l+CRokgBAYllMEKuIwPO+Parz8yqxDtrtj2r96ZjCx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eR5Ug9b/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR5Ug9b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BC51F000FF;
	Thu,  8 Oct 2026 06:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791440512;
	bh=U48mW6PqJiL2x1Q+lEjCA/XpNrHw/pEkdiwlK+Ee0HQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eR5Ug9b/FMrcBgPXyXMHRD7IaEtql0qdtp2+g8LZZzxke+Q2mTSD5OwpGxAeDeVut
	 wHjzq9ntAWr48yXsGe1MAXkm7jKHyVDZD+wRAL9/UN1UqRSFFr+o5GiGoJ0DsqJcMN
	 d4BBiYd/To2nmi0prwF8kg2CuK/3AAQqrxa2aF+IW4HW4XrOSPmGuy1o9WAI82U3Qa
	 WFQOU7jB799qh2ueTAJBkDspQmLfIK7q/7+hM2bR6YQ2/S+EC0m3NEx76RsBa+uPac
	 iBjE61AQAIzKJuktUrJWvRGXCiJ4jjcsQ3awp7jbuDDxDJ1CXEV13C9rRf/cBE2rSz
	 ZykBEWIbkyojQ==
Message-ID: <sashiko-outbox-163683@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/rds: ib: drop fragments shorter than the
 header-declared length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shubham Antil" <shubham@octane.security>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007062135.49946-1-shubham@octane.security>
References: <20261007062135.49946-1-shubham@octane.security>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 06:21:52 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rds: Denial of Service (connection drop) via fragmented ZCOPY mess=
ages
--

commit 99e06641e00267bc78ccb17feb870bd7545f3c4f
Author: Shubham Antil <shubham@octane.security>

net/rds: ib: drop fragments shorter than the header-declared length

This commit introduces a strict length check in rds_ib_process_recv() to dr=
op
incoming fragments that are shorter than the header-declared length. This is
intended to prevent uninitialized memory in the fragment page from being co=
pied
to userspace.

Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks04=
24@naver.com/

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..fee77b6d7ffb2 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connectio=
n *conn,
>  		}
>  	}
> =20
> +	/* h_len must be backed by the payload actually received (data_len),
> +	 * else the unwritten frag-page tail is copied to userspace.
> +	 */
> +	if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
> +		rds_ib_conn_error(conn,
> +			"fragment shorter than header-declared length; forcing reconnect\n");
> +		goto done;
> +	}
> +

[Severity: High]
Does this new check assume all non-final fragments are perfectly sized to
RDS_FRAG_SIZE?

When a user calls sendmsg() on an RDS socket with zero-copy enabled, passing
an iovec array where intermediate elements are smaller than RDS_FRAG_SIZE,
rds_message_zcopy_from_user() preserves these small user buffers by creating
small SG elements.

Looking at rds_ib_xmit() in net/rds/ib_send.c, the sender does not coalesce
small SG elements across RDS_FRAG_SIZE boundaries:

	len =3D min(RDS_FRAG_SIZE,
		  sg_dma_len(scat) - rm->data.op_dmaoff);
	send->s_wr.num_sge =3D 2;

	send->s_sge[1].addr =3D sg_dma_address(scat);
	send->s_sge[1].addr +=3D rm->data.op_dmaoff;
	send->s_sge[1].length =3D len;
	send->s_sge[1].lkey =3D ic->i_pd->local_dma_lkey;

	bytes_sent +=3D len;
	rm->data.op_dmaoff +=3D len;
	if (rm->data.op_dmaoff =3D=3D sg_dma_len(scat)) {
		scat++;

Because rds_ib_xmit() directly creates an IB SEND fragment bounded by the
small SG element length, the received fragment might legitimately be smaller
than RDS_FRAG_SIZE even if it is not the final fragment of the message.

Could this allow any local user with RDS access to trivially tear down acti=
ve
RDS IB connections by sending a valid zero-copy message constructed with sm=
all
iovec lengths, causing rds_ib_conn_error() to be hit on the receiver?

>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007062135.4994=
6-1-shubham@octane.security?part=3D1
