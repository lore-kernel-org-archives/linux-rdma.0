Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795247416;
	b=r12SF2pz7MsjdolDUIPoe9RJ9yiVwhNBo746x0rj2vfe51NB+KcCtdY+rS05GMOz7PL2
	 fRlzfKx0PdmoMMyn6c3gx9ALWuzKcSnBn+WWjcH5+vQyD04vY9Jh4PexZDuYGvMRo6YAc
	 HW9hnRwkgjaAkOiRuDmso0JGa5bglGUlmSwoOv7Ib3mH4BJLPr6cn19LK5Cxz/kdD1ecB
	 Oj7D/2M2RTcldqWlAAq6bgyBBfiQHCngiiMkGGzlsOdBifTfwir5n7ilTtm6Wa7Won2uL
	 /3vNVMriRCOA/pl/0AaoMA3ePIL2lftJUk+rh5dyF1N+c/8pj0Tj41oyvg2WUC4d8aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795247416;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cVThjUJQOp88C61jxCexjIZFLEUKPPDIqGgeLLwNiMc=;
	b=IFsj+SXSiEMtffd2FG7+Ev8gpQX8C1JMXek+O5n26yAsgOhO4Vtih31r2qh6pltXSymt
	 S2lDpatUHe2P7Gg4zwY2OJSDdvYFBPeJpoUX4sLVw5uzI9upg1hIAb8uCWVoIObQzauLy
	 5bWXk3hZewFqMDTiiNOGa3b8w1pWzzO6s/bImM4Vg0fHC2MPmVGdlu315sZxAAeKJSL6M
	 3VhVHAbepHKf7LOP4azawqxc6pZbw7J8VnJOSwHSSbEdXfSWvtHI4YNTakyqmfJxZpjCk
	 VbQO3smDKQF76WEhmXRB8JVs9aaQkYqT9cy50jW4yhEh//RYmQl3Aa3GKuhEB/fqAGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeeXAoFt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFF2606A325
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 07:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CeeXAoFt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4121F000C4;
	Sat, 21 Nov 2026 07:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795247415;
	bh=cVThjUJQOp88C61jxCexjIZFLEUKPPDIqGgeLLwNiMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CeeXAoFt97fD7AGTP5OhkMoel+L0hJJ46hQvUSv4VRBNzQk0jnShb+t3Rf+Y4nHn1
	 fa6iOBYiRiE93P5fAtPfMYTOJQGB2aGXhiRc/KxlUkbRrqezFbRkL68EQtVP1n5RWM
	 30jeBVG7gGTiojlEPwLDvI3nVk3sfNAioxxIv5EC5wHckM9Q9nmHXjE6BPGI7DXLEF
	 j4pqNyS1dschlIwq63thj6UoUgjY9264LVBPGFu+asL2Pdqcwl3nfz28/YxsPuuXkC
	 7Y6xvr+Mvub/CItP7ZYXAEP4fccxdJeXXn/WtVpVS/A/5JIjbKY7P4HElbyO0SHj4/
	 jywbr65NhUlGg==
Message-ID: <sashiko-outbox-226804@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: fix a stack over-read in the QP debugfs
 files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aibing Chen" <chenaibing@cmss.chinamobile.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120075005.843-1-chenaibing@cmss.chinamobile.com>
References: <20261120075005.843-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 07:50:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/mlx5: missing Fixes trailer for dbg_read() stack over-read
  fix
--

commit c7738a815f7b3e2a3b05f4aa38b531b12c7020f2
Author: Aibing Chen <chenaibing@cmss.chinamobile.com>

> net/mlx5: fix a stack over-read in the QP debugfs files
>
> dbg_read() formats the field into char tbuf[18] and passes the return
> value of snprintf() to simple_read_from_buffer() as the number of
> available bytes.  snprintf() returns the length the output would have
> had, not the number of bytes written, so when the string does not fit
> that value is larger than the buffer: the longest QP transport string is
> "Invalid transport type" (22 characters), so with the trailing newline
> the function returns 23 while only 18 bytes were written.
>
> simple_read_from_buffer() uses that length to bound the copy to
> userspace, so reading .../qp/<qpn>/transport copies up to 23 bytes out of
> the 18 byte stack array, leaking 5 bytes of stack.
>
> Enlarge the buffer so the longest string fits and use scnprintf(), which
> returns the number of bytes actually written.
>
> Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>

[Severity: Low]
This fixes the stack over-read when formatting QP string fields into tbuf.
Should this include:

  Fixes: db81a5c374b5 ("mlx5_core: Improve debugfs readability")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120075005.843-=
1-chenaibing@cmss.chinamobile.com?part=3D1
