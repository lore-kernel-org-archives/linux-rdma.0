Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794286753;
	b=xHMK/UJLvjiAQOca5kQPyQpT8IFIkObnELOagCQHxzw7VbzpOyLNuLx9xkyM8Hn+SWaf
	 O+7zOb7DS3coXzAsvk6fhdp5VgKyRlOv7lYYlXCJvsrl/MOnXpp112L0ZiRUpLcquIJ7v
	 b0IalqGya82AVzCgQ8cQpJ+zCz7fI+8fTbMkG7ybMnoXl23xEv+HDgUvhx3MBbkp+7xcu
	 Ds7je9712C3s8QFtGsOcA5DEFZDhceWsGY9LbTDbsUhQOp/Kbp5CtqWUYlqtgbAGFn09F
	 Sq0NdhZ3NTLUghPmaurkj2hpDN0vGHDRtWUwFW04hfYtQDMoJiqhf/1xhHKexw9WExw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794286753;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VxKZfFgXNbmN8R+E0dJZX1324e363VKrpJySX+8KaXo=;
	b=tRfML6pCU3URGQoAT1d98aOMkEHbLDKolOp72HYf9cWevFgOWVFF0C9hi+InXtjJmDNl
	 U0RtwXQNJOmJKVWSvhEQLT8lbm8HDpgnWiUcnFKAnqmD4TYFGrSccIW95VhyymXItNgD2
	 rg0TPtw6FL7WqwvaDUref+RBmUWSWjjrI1SH+vEd11jGJlU2VWrmVUW/zILpZanNheHcX
	 or87gyuDl8joN4rDVKKTmpU+qDC5c8QmX7xBKDK5v5vHVWGugcKNlT7n0KNIkWCJh1oz0
	 1JmexMlK7LtGNPduO9DtRv6N2mCaSHR8j/qoi+qxJ/UXsrYWILLM42QVM7Z8qISEEow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5dC4YXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33476606A321
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 04:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5dC4YXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966D51F008A1;
	Tue, 10 Nov 2026 04:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794286752;
	bh=VxKZfFgXNbmN8R+E0dJZX1324e363VKrpJySX+8KaXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i5dC4YXgYcjVaoGeBAmehuQcxh0HEmwEoM/48xLSw2pAc7U2u3Pc+YQUm5y5zXTjs
	 os80WS9QxZwiE5cA96E5cEXzdKGqmxUtjJx2xP8wKEM2IAhkvebx72eTHMX67SIvsa
	 gxMm+sJNrZvKGBiHnwzQ+xikDTQZyeyjcZiauKOv6gb7uQvuDjRGTGsoadIV3kP3eE
	 nyZTHw/bemmZyYzodOrrVSCLtKz4tp4jeI0wTcpqgN2P/ENhVhuhyCCGcbvruaRrYc
	 BIB4BS380NDHFRbDPXT5YOj6phLmC/25ps5SYcgFlDn3UZ+NruPN8AVvcpgckcoQS9
	 VsbRkgzw9VY6A==
Message-ID: <sashiko-outbox-206250@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 07/13] RDMA/core: job and job key objects
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-uet-ib-core-v3-7-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-7-3e7e7ffed2e9@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 04:59:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> An unconnected transport demultiplexes incoming traffic on a JobID rather
> than on a connection. Add two objects for it: a job, which owns that ID
> and a table of peer addresses reached from its port, and a job key, which
> ties a job to a protection domain and authorizes a queue pair to act
> within it.
>=20
> A job can be exported to a file descriptor and imported elsewhere, so an
> unprivileged process can join a job that was set up for it.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-cor=
e-v3-0-3e7e7ffed2e9@broadcom.com?part=3D7

