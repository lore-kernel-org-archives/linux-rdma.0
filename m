Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE42A4E01EA
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550204; cv=none; b=s18aKCp5Om+V8T8I59WvZ8g3xzSw4qzgGPr7nKQxV34gVXy9UfuCN3MSjBDW1sOOOrjmmFUKU3wy4zKyhVvr6V/5d7APhMgmu+nx3RQUmsZ2sMY1JEMM0Onz3Hr0YeF6U3oeYP85RIK6hmxu+gGZt8ippLqO4xVaC+DNRY02Dvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550204; c=relaxed/simple;
	bh=cZDXW9uGMghu+aOT6d7KSO2/WGW/G2rZYot7VPrMTe0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mY2TgtN2Lv7CpIEzkV/sUY1ETfWitz3qGq6NBN8X82ADlK0spuLcbdp2zSxjOZqaUsCqqGjaNlmD6Cnf4EuI+8B+tPvaD4jUvvhCMe0sh1mzrAVhV4ztAbayLlixuhZmkBP/oBE2OQiAoI8/QNo4WOriQqnfsDPcSotbICQjFDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGshUx+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGshUx+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D8B1F000FF;
	Fri,  9 Oct 2026 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550198;
	bh=tmkw2B6aoaJPx5sPs4LeItTPAZQpXUdnrIUOM7n8tS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RGshUx+1ZPB86sxgKqu0ykeXUavaXvfxcfYM3nf38wVc5dgZN65HNI0jSl8/Cag6s
	 mcE5gCUC7bf63KUyflrrGnvp31WyCfCw7eNB02HkBVLVOnXvEND5EHUnSVRs6rMw38
	 1fGlNzkRAst3+5ceBRN1GI0MCUcdV7yqzSjJ3Bs3TITIQnfuCFjORCvIGhkrGn5yiP
	 I6y6l5v69gKrCDa2zNjijJ6R/xv/Wv5JqAQJ7QopZmtkd/FFvYox+/pY42sHLwSCB6
	 EI6jXEL71H37cYsaV2czQeFVtVltZN3oGFqKoS6Ydtg1iYiaQ7Sq9eBVdP9OOuVBBg
	 LbU0e1UZSSzIw==
Message-ID: <sashiko-outbox-165564@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net/rds: ib: zero the unwritten tail of a short
 receive fragment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shubham Antil" <shubham@octane.security>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008124940.13371-1-shubham@octane.security>
References: <20261008124940.13371-1-shubham@octane.security>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 12:49:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rds: ib: zeroing short non-final fragments corrupts payload and de=
synchronizes framing
- [High] net/rds: unbounded memory allocation on receive via untrusted h_len
--

commit 155e0b4d269458cc1b33d64be6029fcc1b1efa50
Author: Shubham Antil <shubham@octane.security>
Subject: net/rds: ib: zero the unwritten tail of a short receive fragment

This commit zeroes the unwritten tail of short receive fragments to prevent
stale page contents from being copied to userspace. It attempts to resolve a
KMSAN uninitialized memory warning by ensuring the tail of the fragment is
zeroed before processing.

Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks04=
24@naver.com/

> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..9695c7f24eaa7 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c

[ ... ]

> @@ -949,6 +950,19 @@ static void rds_ib_process_recv(struct rds_connectio=
n *conn,
>  		}
>  	}
> =20

[Severity: High]
Does this code allow unbounded memory allocation based on an untrusted head=
er
field?

Earlier in rds_ib_process_recv(), the receiver extracts hdr->h_len from the
network and initializes ic->i_recv_data_rem:

net/rds/ib_recv.c:rds_ib_process_recv() {
    ...
    memcpy(hdr, ihdr, sizeof(*hdr));
    ic->i_recv_data_rem =3D be32_to_cpu(hdr->h_len);
    ...
}

It doesn't appear to validate it against RDS_MAX_MSG_SIZE. Can a malicious
remote peer stream data with a massive h_len to consume gigabytes of memory
per message and cause system exhaustion (OOM), especially since the same
unbounded h_len behavior appears to exist in TCP receive via
rds_tcp_data_recv()?

net/rds/tcp_recv.c:rds_tcp_data_recv() {
    ...
    if (tc->t_tinc_hdr_rem =3D=3D 0) {
        /* could be 0 for a 0 len message */
        tc->t_tinc_data_rem =3D
            be32_to_cpu(tinc->ti_inc.i_hdr.h_len);
    ...
}

> +	/* The device wrote only data_len bytes into this recycled fragment
> +	 * page.  Zero the unwritten tail so a later rds_ib_inc_copy_to_user(),
> +	 * which copies up to the peer-declared h_len, cannot hand stale page
> +	 * contents to userspace.
> +	 */
> +	if (data_len < RDS_FRAG_SIZE) {
> +		void *frag =3D kmap_local_page(sg_page(&recv->r_frag->f_sg));
> +
> +		memset(frag + recv->r_frag->f_sg.offset + data_len, 0,
> +		       RDS_FRAG_SIZE - data_len);

[Severity: High]
Can zeroing the unwritten tail here cause silent data corruption and
desynchronize the protocol framing?

The commit message explicitly states that a zero-copy send with a small iov=
ec
segment can legitimately produce a non-final fragment shorter than
RDS_FRAG_SIZE. However, the receiver's framing logic statically assumes eve=
ry
non-final fragment contains exactly RDS_FRAG_SIZE bytes:

net/rds/ib_recv.c:rds_ib_process_recv() {
    ...
    if (ic->i_recv_data_rem > RDS_FRAG_SIZE)
        ic->i_recv_data_rem -=3D RDS_FRAG_SIZE;
    ...
}

And the copy routine blindly copies up to RDS_FRAG_SIZE bytes from each
fragment without checking the actual received data_len:

net/rds/ib_recv.c:rds_ib_inc_copy_to_user() {
    ...
    to_copy =3D min_t(unsigned long, iov_iter_count(to),
                    RDS_FRAG_SIZE - frag_off);
    to_copy =3D min_t(unsigned long, to_copy, len - copied);
    ...
}

Doesn't this mean the zeroes injected by the patch are copied to userspace =
as
valid payload bytes, shifting and truncating the actual data instead of
correctly handling short non-final fragments?

> +		kunmap_local(frag);
> +	}
> +
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008124940.1337=
1-1-shubham@octane.security?part=3D1
