Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279694;
	b=2awWNb/XCscco1nmtsNf+yZ5HTyweBuAfj8vS7RanO6KE8o9HjGvOXUMPSmTb5J4RARj
	 OMgjn16lI6L85m2D36oPKMifx8oAQE6vfxR3imD1rglEjhFzeV2vErpFHkhjkTlsoXTKw
	 vQDrnwgJjsaTfxLeQd+sMhRnuFekcyTOVemItzJ3CrsvmeVxOratMXZI/4Sh1plHJlhuD
	 Ne8npMFhsJFRIqLOcrdiOwEShl7mdJU9ANtq1HnCp/72JCgVqX/kKkFE6usqV9Y7f3NYs
	 p3xPiE4vAJExdPb7J19pLh2dxoqNMp+76Y85HZlvIhGE8akvRBut7aUSCchA4UXIr6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279694;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TpCKN/2yh1ur457aULpCJWS16KHIeGzGnAVkxiJzJMM=;
	b=jD7jY3kaAGirqD1c/dgut2prSaaldcjMYo5s1jrqyF/vqxr3oC0MUY/Md+R9X7ulAZIY
	 oy9nz1aiU6tCbb/aWdgRyg7h84oBuoBL1ENfEDB7ArrdzNVNx0e55LPlWzmTzykWKvWTS
	 rdYVLu9qX4Rd7NmWycGNgJej7l7IOocBZ+5x/ZO7sxef56zvvmcAooW1Bqi+iCIh2eSm/
	 O9Px7nt4pCJPjPVRdU0orqri8U9iJoWB/TcVpjiHXnQ8LKU6R9qxRX+NM+pYbM4NA/OId
	 7AlH3NEchkGOKiIsk7XE8yAeTjnGfYg5Hx017UqDjL7WRhndzCeVSax6MflxK+PV88A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h09/OA7P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64321606A32A;
	Tue, 10 Nov 2026 03:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h09/OA7P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BA21F008A1;
	Tue, 10 Nov 2026 03:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279694;
	bh=TpCKN/2yh1ur457aULpCJWS16KHIeGzGnAVkxiJzJMM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h09/OA7PrY6gNIqExAeFFOP2uHXv1qgpMzrQxXerE8HKO0oU5oPaBDjXJuOqI3s/A
	 5ZVBYQ5ACsmnAp3IYBcyv4PoCYGkK505tLhI0GesctF9qNER5bM0tit5oo12mIEvuS
	 sW53mzJVQG4PQdAVxEOp8DLS4ux/Fbf/eCOojasb6fWLYQq+wKOHtkyPkOnPiq/Npd
	 KbcOf2StnoIgmp0IPKHah98xVIXqIcrwAPvITVbipjyrXBBCtb26ATeiaS7PbFvaFC
	 IsDTXXYAHhbUfLUa2tmQRTuQfJpefm/YqHxIpXJggcGRQX+8vTzFqKD0NWr/+ts0Lg
	 rFE+m9x+iWu0A==
Message-ID: <sashiko-outbox-206086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 13/14] netfilter: conntrack: annotate
 data-races around timeout and tcp sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-14-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-14-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:33 +0000
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
- [Medium] netfilter: conntrack: data race in destroy_sibling_or_exp()
  [1]
--

commit 90b17fe93bcd168d06092c32e88d6764be57b60b
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

netfilter: conntrack: annotate data-races around timeout and tcp sysctls

This commit adds READ_ONCE() annotations to packet-path readers of conntrack
timeout and TCP sysctls to avoid data races with concurrent sysctl updates.

[ ... ]

> diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_co=
nntrack_proto_gre.c
> index 616ab1e2fc5ed..d8bca1e29797b 100644
> --- a/net/netfilter/nf_conntrack_proto_gre.c
> +++ b/net/netfilter/nf_conntrack_proto_gre.c
> @@ -279,8 +279,8 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
> =20
>  		/* initialize to sane value.  Ideally a conntrack helper
>  		 * (e.g. in case of pptp) is increasing them */
> -		ct->proto.gre.stream_timeout =3D timeouts[GRE_CT_REPLIED];
> -		ct->proto.gre.timeout =3D timeouts[GRE_CT_UNREPLIED];
> +		ct->proto.gre.stream_timeout =3D READ_ONCE(timeouts[GRE_CT_REPLIED]);
> +		ct->proto.gre.timeout =3D READ_ONCE(timeouts[GRE_CT_UNREPLIED]);
>  	}
> =20
>  	status =3D READ_ONCE(ct->status);

[Severity: Medium]
This problem wasn't introduced by this patch, but can destroy_sibling_or_ex=
p()
cause a data race [1] with nf_conntrack_gre_packet() on
proto.gre.timeout and proto.gre.stream_timeout?

During PPTP teardown, gre_pptp_destroy_siblings() calls
destroy_sibling_or_exp(), which looks up the active GRE conntrack entry with
nf_conntrack_find_get() and zeroes sibling->proto.gre.timeout and
sibling->proto.gre.stream_timeout without synchronization while
nf_conntrack_gre_packet() reads them on another CPU:

CPU0                                    CPU1
gre_pptp_destroy_siblings()             nf_conntrack_gre_packet()
  destroy_sibling_or_exp()
    h =3D nf_conntrack_find_get(...)
    sibling =3D nf_ct_tuplehash_to_ctrack(h)
    sibling->proto.gre.timeout =3D 0;
                                          nf_ct_refresh_acct(...,
                                            ct->proto.gre.timeout);
                                            <-- data race

This unlocked modification can cause inconsistent timeout updates on the
GRE conntrack entry during concurrent traffic.

[1] https://sashiko.dev/#/bug/linux-414ef1d4-4293-47c0-80d0-e03e321aacc5

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D13
