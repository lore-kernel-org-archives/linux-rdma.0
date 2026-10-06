Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92273E63AC
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791291993; cv=none; b=lNAsT4FTQBZcQQepoGtqxogHBLMM1kiekDWpmOeurY25QW9tIz6BZJRgE/uNS4wFhEVEihPfXuNQ/IZ3dU8JXnMn5wvNZw3MYTcNt8hMX0D9qoFoXSuH5Y3pUz9jggkBLqw74DvGIQC90nC5KrNZI4HOCUzHkw9gIrw/Pfr4M4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791291993; c=relaxed/simple;
	bh=gihrtFBH+QGeM1ALPaCZEwNU9Niwh3v3zPVOaJoGKxQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y47l65oVYBU1QRSc6z/9KWbQyF1+MmYRY9onZ+ydanYJIXd+fJyHfAFU7X8EU6iXSxX7mH+5irS4TC/jqIE1BIqXB+z/7tREDOEvIMzP2bY+czhQ0rFTkQ3BW8cd4HH0lgU6k5jYccrswtL79mpK/ON9AIhf57ai4CfJJF6M38o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8vnc7Da; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8vnc7Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642871F000FF;
	Tue,  6 Oct 2026 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791291991;
	bh=i6EUmGNBnSz+J0nitR9um+NRm9rBI+pVWaoF1yhdeQs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m8vnc7DaDLxOqBFqcT7xt9T4K6WfYWNeyqvscfrFGYIUKTPy5atEWPzRpYxBcdUAW
	 KvCSDETAcV5uk7f9Ys7m7tLL79cJOkwOS04sD/euF3kI92WWhCIKfMWJEJWxYvIwvL
	 waWYxdvETRHxlwIrhBZOvXNJKKFi+Q2l63g14DmpXg738vmU4AZcHkmjrQxEm/rZPa
	 7jEHqMozd3ZIPe/p47hbk/D2HViWZIgZQKw6lc1UWnZju1X1clIsWj8RSR9+8KP/l7
	 HCbCP89SrmY9uDTHrnDueMP/BXXNLfA+9Cb+oqkifTD/z/iriJNIzMrms8r7fjjjBR
	 eFvpEj9N3QHhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/rds: ib: drop fragments shorter than the
 header-declared length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shubham Antil" <shubham@octane.security>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006125720.81227-1-shubham@octane.security>
References: <20261006125720.81227-1-shubham@octane.security>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 13:06:31 +0000
Message-Id: <20261006130631.642871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006125720.8122=
7-1-shubham@octane.security?part=3D1

