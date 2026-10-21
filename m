Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.13.80.246
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792561479;
	b=D7iFkDk+zWDzJYwPyHMwQgzXqeG6Og5cdpVseCORWt8aHvpFirP3CQF6pbZbGzn+WgCS
	 Yc8hLs3Wj0f8GuNv1RtxAufIh6A96zQZua9s+zDjZ9Mys+ZeqIXWScmX6Lm4q1r11L4sy
	 Uo8tQSjv1CXHmIyCoC+3lfZGSSIEBiSL0Bh0QL/Kss52dLXtmmv6sCMlXjXxCduFBXwDC
	 6WUuZMQwajJKLj52WfzpiE32av2RimAcOkrbkXFuV7EA6WIYd2KsKKXUePXuPPicO5CwV
	 VZt8VOsLySbT6sq1PvlpERZ2tkHDxMDa92mbevfxoOhfTSH54o+aVmaXKaGUD05YKFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792561479;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:CC:Subject:
	 User-Agent:In-Reply-To:References:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Last-TLS-Session-Version;
	bh=gjp0o7E7Pa+upNg0P/AiNTH4X61fq2ZotWdk2WRNMco=;
	b=XUf7Z0r+CwFx9CNLQX1B8KhF1MzCjh+yD5+yhgwq0vCjI9BPll5K0fItr9VhujA2z7C9
	 Ww8ZdLnbebHgy/cnK4IrKEZQz7XEmNcvzFTalx58Vf6ISd98tKzAkmhYFoslttgIsdpRy
	 MnVQ+oEmpFkGpigL9gHFrIOWl7MjJxa27AfzrAk4wQPZdWr03Qcyp1kjf18KOSV/E9iNJ
	 PjAIJ6jn1OK9EgWB4l9jRlyMPAjdf3rbNcEKoWFhYXrH6oGqsdISU7kyAVRL9tbgz0nvr
	 UaaTvIpIMVMFsDWYFzefHRRVjUI38yTd2D/S5upYvxa4UmJJeo1MJTQ8cipbgtp16ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=tipi-net.de;
	spf=pass smtp.mailfrom=tipi-net.de;
	dkim=pass header.d=tipi-net.de header.i=@tipi-net.de header.a=rsa-sha256 header.s=dkim header.b=V3ciHOJJ;
	arc=none smtp.remote-ip=194.13.80.246
Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D070606A319;
	Wed, 21 Oct 2026 05:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D070606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tipi-net.de header.i=@tipi-net.de header.a=rsa-sha256 header.s=dkim header.b=V3ciHOJJ
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0ADC4A1626;
	Wed, 21 Oct 2026 07:44:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1792561474; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=gjp0o7E7Pa+upNg0P/AiNTH4X61fq2ZotWdk2WRNMco=;
	b=V3ciHOJJORHb1sccJArRGx++x1e5/i6Ztv8x2QIkL1Z4LVY1dYxuqWIcMjbuH/Uo3SZoEb
	gsMWA4feDIY3fwmSyjzNBrg4/NCAIf27ulqePqypWotjBok8iIFfl40Wrs6QhsO4PgCLWj
	amNn/YD/sA8l/F0QVHOrs8dTQpbcDpTKfBE0NJaNXHpmddGbUbxxqw2LluLZM/07DQwOzA
	6NR23olpR/k1zNPJwriNnaeay0LyGfPwgcC6JgFeU84MwD6r8OdAGaD4PwvXl/npRo3fXm
	v9CwokaNSiEzb4JS0L2wyb3SK094g6S4POZR9zvqU5SfITXAzdtlQjbpGuDzaw==
Date: Wed, 21 Oct 2026 07:44:28 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: dust.li@linux.alibaba.com, Dust Li <dust.li@linux.alibaba.com>,
 Jakub Kicinski <kuba@kernel.org>, alibuda@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com
CC: Chengfeng Ye <nicoyip.dev@gmail.com>, davem@davemloft.net,
 edumazet@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, horms@kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net_v3_0/3=5D_net/smc=3A_fix_link_gro?=
 =?US-ASCII?Q?up_scheduling=2C_registration_and_work_lifetime?=
User-Agent: Thunderbird for Android
In-Reply-To: <atgBD0t0xHnMlwjX@linux.alibaba.com>
References: <20261013091716.1210420-1-nicoyip.dev@gmail.com> <20261020125849.67c40566@kernel.org> <atgBD0t0xHnMlwjX@linux.alibaba.com>
Message-ID: <1F2D6162-5113-41DE-B649-0E67F037E8CD@tipi-net.de>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: TLSv1.3



On October 21, 2026 2:02:23 AM GMT+02:00, Dust Li <dust=2Eli@linux=2Ealiba=
ba=2Ecom> wrote:

> [=2E=2E=2E]

>Are there any guidelines or mechanisms that can help with this?

You can use suie and filter (funnel icon) for your driver(s)=2E The filter=
 is AFAIK populated from MAINTAINERS file=2E

For me this helps a lot, to keep an eye on patches and their state=2E

[1] https://netdev=2Ebots=2Elinux=2Edev/suie=2Ehtml?delegate=3Dnetdev

>
>Best regards,
>Dust
>

Regards,
Nicolai
