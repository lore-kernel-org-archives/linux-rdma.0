Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CDE335564;
	Wed,  7 Oct 2026 01:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335611; cv=none; b=gjXwIw2BKGvP3PLGXIqXllcKVlEUPl8TGtS3KNowEtIUcdXlkjnJqldS2lzCOCsxTOMCeAuWXRllx65dgbeJ3/UAUEt4gwUMJq+Cm+nTIPJMzqNSamwztcSUzPRrFGx7DvzceyQwTV26urLOBMaMXse7HxK9WG7TKBtPf/lNp/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335611; c=relaxed/simple;
	bh=5LE030dETA5TkWeVQ5A61CyYEuK0E201J0RsXvWQn8o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EvfSFyAiEI9B1OGtq2tfcBwckv71v9edeT2gdCN2yYbZlesLdIRGGG6kSzJbPJCCaoOIswcxGBfoLBmyNAxFsngc51O2pozxdphZkkoOA+r7EyGw1y/O6a3a0E+POIxoDUlmTm6YFXfE2EH5kHjgHjE4iQq1jBVcsNfpxPB2g7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEtGnLJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEtGnLJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC761F0089B;
	Wed,  7 Oct 2026 01:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335610;
	bh=sdBJccuOm1EfEsP5aXIPMxQG/B3g2rtoCS73T15p9Oo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WEtGnLJZgHikZ2uaLHyY1UOzilXTJQeuI0vuWhlc+rLUCsO3pE4IyUiSDuIGvy9Io
	 EYeM4rOs4wSyFmCXhbPsPHouJ3sGtX0GqQ/YcML+a16a9ESw9qjYWd1ewF9KbBDeqU
	 B/tnKhNnuiWgKTbkNBQMy1ZlNU7ouVhPx35rwYTZKfQmNjuvjXxAhsvwRFRxTdXcyv
	 6Mu3b2AW/G6MGlEx4sXCGpdLJ8rAspCTiWDPNtv3Ht69+RVBoRzZvQ3wHh5rTGjCeu
	 ot5J+Np0GAk2BxQS8G0iHnp7KanEYyFX+wk46/UIy3dWk1wPXzJM+0aTXhF/XKdiNr
	 b/6KAg6O+mz5w==
Message-ID: <661e8b900c97d701382af26462bead7277eaa41f.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: ib: drop fragments shorter than the
 header-declared length
From: Allison Henderson <achender@kernel.org>
To: Shubham Antil <shubham@octane.security>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, Giovanni Vignone <gio@octane.security>
Date: Tue, 06 Oct 2026 18:13:29 -0700
In-Reply-To: <20261006125720.81227-1-shubham@octane.security>
References: <20261006125720.81227-1-shubham@octane.security>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-10-06 at 18:27 +0530, Shubham Antil wrote:
> rds_ib_process_recv() accepts an incoming RDS/IB fragment once the
> receive completion reports at least an RDS header
> (data_len >=3D sizeof(struct rds_header)).  It then trusts the
> header-declared total message length h_len: for the first fragment of
> a message it stores be32_to_cpu(hdr->h_len) in ic->i_recv_data_rem,
> and rds_ib_inc_copy_to_user() later copies up to h_len bytes from the
> fragment pages to userspace on recvmsg().
>=20
> The number of payload bytes actually received into the fragment page is
> data_len (after subtracting the header), but it is never checked against
> the amount the fragment is accounted to contribute to the message,
> min(i_recv_data_rem, RDS_FRAG_SIZE).  A fragment whose header advertises
> a larger h_len than the payload it delivers is still linked onto the
> reassembly list.  The fragment page comes from the per-CPU receive cache
> and is not zeroed, so rds_ib_inc_copy_to_user() then copies up to h_len
> bytes to the PF_RDS reader, including the uninitialized tail the receive
> never wrote.
>=20
> Reject a fragment that carries fewer payload bytes than it is accounted
> to contribute before linking it onto the reassembly list.
>=20
> The issue is reproducible under KMSAN with two hosts over rdma_rxe
> (Soft-RoCE); the same reproducer confirms the fix stops it.
>=20
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Shubham Antil <shubham@octane.security>

Hi Shubham,

Thanks for working on this.  This patch looks good to me, you can add my rv=
b:
Reviewed-by: Allison Henderson <achender@kernel.org>

Also, this bug was found and reported privately by another contributor, who=
m I had
counseled to send a patch publicly before I had noticed this one. =20
https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks0424@naver=
.com/

I find that patches equivalent, and this patch was posted first. But I woul=
d like to apply
the reported by tag since sungbyeongchan was the first to report it.
Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>

Thank you both for working on this bug!
Allison

> ---
>  net/rds/ib_recv.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffa..fee77b6d7 100644
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
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
> =20

