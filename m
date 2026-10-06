Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F311439656E;
	Tue,  6 Oct 2026 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330078; cv=none; b=kYmKxwcgqyoFm5ikxdQmts9lEL7fuhs1plMpQAoOJlDJjV0b3dNCTlcLBCc7pKD+ng4k6DL7yyyM0SYBiH1CC6alnyqZb7hwRaFUaDMBpiXkYXCfV+c13cDuUzEof7VqZmRvw3ZUwOmM/DXuRTf0iICJuvD682W1Ckhej/5klwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330078; c=relaxed/simple;
	bh=/ivcxli8unFVt8T67VuVBe0y+8I8CDVd6zVqstWb8Z8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pPmrATxApkvRvjItfQ4eC2pjT87LMAvcKrJDBsyekKH1+cnM14ie+GqT1kJoG6wIx9hAF8Xkhk8zr9MSFPgoKQNHWlm/7PYakyf7OBXgvTZvAHqAMbSuPV6/vNHo/UdIGvqGOPgLlyYHHSDtK08ZrVB+PBS4KqKT9eCCp7S38+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDKB9OdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDKB9OdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F921F0089B;
	Tue,  6 Oct 2026 23:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330077;
	bh=/ivcxli8unFVt8T67VuVBe0y+8I8CDVd6zVqstWb8Z8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oDKB9OdT+2CmT5uAG+36GgEuQ2ascu2HbqAeN1BGgezH34jhWF2tFkgYuMI3gRIUv
	 Og6CXM4zIQNKYykshAxzmrMHkFkmyWc9Nd7Opee30fnkBUFL/cqfr04/LK+uGEmDll
	 /xqJIE8pQmnrN+hIExtV8L7LNrAn6kSx9rQsR13WLVP7rFvwtOzciv0/Mk6SpYuyyk
	 npIjqVspY6w7V7CxtaeTQKwGcO96VHW83EPxjgAy1NYgabZWfcbALOzssDyHf46Qw/
	 qQc3t7otmz+VbDXiABkJl6UsF4RWLOYJtym8od4R64dcN2UERl6IWS2l9+PcZgwwY4
	 KhT7Ejn1m1NzA==
Message-ID: <sashiko-outbox-162516@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 1/8] sunrpc: introduce XDRBUF_P2PDMA flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pranjal Shrivastava" <praan@google.com>
Cc: linux-pci@vger.kernel.org, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261006233248.705086-2-praan@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-2-praan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 23:41:17 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The NFS client will soon pass PCI peer-to-peer DMA (P2PDMA) pages
> to the transport as READ or WRITE payload. Only a transport that
> can DMA directly to and from that memory may move it.
>=20
> Introduce XDRBUF_P2PDMA and a helper, xprt_rqst_has_p2pdma(), to
> mark and detect requests whose pages are P2PDMA memory. The TCP
> (including TLS), UDP and AF_LOCAL transports return -EREMOTEIO for
> such a request before touching the socket. iov_iter_extract_pages()
> returns the same error today for P2PDMA pages the caller did not allow.
> Thus, users see no new error code.
>=20
> Signed-off-by: Pranjal Shrivastava <praan@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006233248.7050=
86-1-praan@google.com?part=3D1

