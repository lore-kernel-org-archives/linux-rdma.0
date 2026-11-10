Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322475;
	b=xe/Xp3feIcdHCUqWny1tKNpjhEgbc69TUzUlfhqgwXfQtuSjxRiWSPQf3J+huuNNXl3L
	 ujSudtKplk/5O6vRUwcJVVeq5O3P2LPvbpx//lnyPQpdU1YJgW9+fxSugfLjBtEO46BTK
	 k6SkgJG6a9F7yBy2pDdq0ERpow8K5QqWbJJUnZGD4BrvK6eSkw/I9lyAbmNbmKdzdTMhC
	 jRpvnIPHJpnDNqh+Vy1pwUoZEaDcbrc7JyGk5dZz9EikcxBsEzhsU43gzzC/O299d+tuE
	 IrPWP3ZimLsIROp8/q0KqIE9RGVkRWw7cjfXgyRVCZYTDckNeBh3k0bxr4pmOdKm8Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:From:Subject:To:Content-Language:Autocrypt:
	 Content-Type:Content-Transfer-Encoding;
	bh=E9vxJFfK8NJCEmm7us92SYrEo1nk8OOrFu+2JPwyTw8=;
	b=B5TGDxehvH0zmxxOKYOBHxLba1eaTghcwUGxrpQgUO5p37/EY8TwApYaeG7N3mLkbuh5
	 QzTiq7PyT/gwfQs0a4wuRkqU53liUKlz/3mHHfl0xm2qjHOn8tYK7voRT3rlpOcMkxa4/
	 cBVB6bOcQd6DnoZMJOi99iqiAf8lAKvsN2AXPxJrU7AJrRylSENpzATsVvcbcbcysL5bl
	 bouLHSPOESOHiZVsHJB7x8S9AIYKzbyVekBkgO7g3d5rKsi9vlx/Ju5SGhYbb1y3l3dA+
	 pEd/1ZA41yh0cS8tVcp6TUym0wkXjMjtHcTC8T4jzsd9XKerfnxMIetrd+5fYja9dRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HzrdY7iS;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CCE606A33B
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 14:54:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27CCE606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HzrdY7iS
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1bc97805eso1773195e9.2
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 06:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794322472; x=1794927272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:autocrypt:content-language
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E9vxJFfK8NJCEmm7us92SYrEo1nk8OOrFu+2JPwyTw8=;
        b=HzrdY7iSE0tY3kQKqWBojh5TUxNDC7q15jBwXntUBKzqe5qLX1NYOuT5GpSenwlN8O
         A41oa4LRyLlrvgCiF+i31kMzM0wYoxA84myrFp2gMivCCkbddCNqZgmcYSjngZ7jxVra
         aDU4jbBbACqGWuHr986gaDpc/OM2Yx6288a8Lm+kcs67MHNIaTEqOXHlZJH6et/Oj9AU
         4/t8osALhK4lra80TWijUioFF1YSOCQM1ew9y8N16h4CmRxWEWFFJ28oSOajjINvntHb
         SuI2hyuyVLfTO5z2fEn/7rR7NXTBNf/6GFHzU0qXsAq9IQ16lenf8iC+PQyJvWNnvubJ
         czhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322472; x=1794927272;
        h=content-transfer-encoding:content-type:autocrypt:content-language
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9vxJFfK8NJCEmm7us92SYrEo1nk8OOrFu+2JPwyTw8=;
        b=tTJmBxHtDMRJ+RuqybNNNBqSVbgDyunx3cYjEtJI6YlcdYx0fEZUJnXtLtab1PMEok
         GbgtI7fevUnOxVpad09Fy3TMHDjWrUpQtJyWfTN74/VDx/DxAwP6YVFoBIWeHshvKkIw
         j1xTNBIAs6pWhh74htuilmAa7BASnVQ4ZdVrzS9oT7pxKO1EuDnHFw7irxjLF459PLk7
         iz9/PNE7yyDbjGmP/JG2oobUXK0tMSZWIEOMDkrJu9nZT9RwED3bOtib6Ej1FyMw8ZT4
         O5oZl5Ak+6X6M1CmTS+MABB3wPqLjEXY2AmPT0RrRos76ODxA2trvdY2Znb3ubNBHXGG
         ZpTQ==
X-Gm-Message-State: APuU4Z8C38BDL/Pgzm236i2zWdevRBcfVGpiOYDrX/SAF7iZhtmnget+
	k6nv25Tj5IwT/1AetCGeV+G+17OLttvPvSOzaF9c42th3UiBSCSCfcXwlQDCyLIiXpTdatKONwE
	qmcG+Dng=
X-Gm-Gg: AYBFou1Qa6fMk7WEREbiNtaASgVEoQu+mwTI46BFrmPIdSpRh89CiXcT6ic1iIKbtSP
	MF9rFlfcJutL//xObpHw0JjrSLdo0lNjJlHcbIA21v/cXKSW4YiF3FuxUcvwU5KE1B1ra1BaAXw
	BCrbYsHy0xPk45yLWdgnOn8qkjmLQOGOgEBYfKKKpXlGctpXjJAIGtuzPnxZkkLnWAbySt2AeU9
	dkCFVXlNIUfd6+R5AtiQmxZRiC6XsI8uyPaTGUpKaktJJnlRqmBesmcnLzYOu+Vuv9spsP5G3dV
	mWfqu7fUCGOJE5L7R1oaDyTtQXKSLsLEoM83TQx6mtc7jDWvowKSV4Zp4LOc3r4seRI9toP4Uqg
	1SL+lWdKMaIdnpi2s61oC4vZesZp/KST4CTzAawe9qjn+Q1fxS1g+ifQeU9osmP/CrIrpcC7wdo
	s7N3IHWYqkh+evB4F13kEPtHFG29etWCB+j8/Hyg/Sd7X2An05VG8OafRdFbshbeYYBZB1hNUHe
	rWPX0a3tyX86lm0GPlqgfgiMcSHmy3yNZPONiGlErahlX/OZLutRGPwui1qr0pOX7Hj7ub65M6Y
	FIvOu/OPwWUQmiqbjt8QyKXbar/HeIH/y+8hhYygbtY3sx1fQ/GXDrwWXAz4EBVJE02veFxp
X-Received: by 2002:a05:600c:3e88:b0:4a1:e774:370d with SMTP id 5b1f17b1804b1-4ba02323dbamr43810695e9.1.1794322472080;
        Tue, 10 Nov 2026 06:54:32 -0800 (PST)
Received: from [10.20.0.128] (lfbn-ann-1-199-252.w86-200.abo.wanadoo.fr. [86.200.161.252])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba02005946sm78105405e9.1.2026.11.10.06.54.31
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 06:54:31 -0800 (PST)
Message-ID: <6ae2dce7-54da-444c-9386-ce573ee95735@suse.com>
Date: Tue, 10 Nov 2026 15:54:30 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nicolas Morey <nmorey@suse.com>
Subject: [ANNOUNCE] rdma-core: new stable releases
To: linux-rdma@vger.kernel.org
Content-Language: fr
Autocrypt: addr=nmorey@suse.com; keydata=
 xsBNBFjZETwBCADEkoe7QWAXzd9xpSiPbQK6P2F4wKdxyTp6r0aN4I0O+4fc8xWXvmwOrCjF
 UsuoGZ3CxJaHgdB/3ueW/IhMO5Ldz7pylhKVlG/moUh4CBK2eRUdaG7mHID01GyJMtR3VQqu
 22hJhHPYy0erpYViyr+I4MzQA9QZLoQhSxn4imjZOZPcj20JE+lRfXppNv9g7vQiRLMcXjTi
 KcnrqG5owOi6Cn1sZ201YfdeztGxKA+jvjWO+6absTTlorIlZNGUf85s2+caGDsqa31u2DPs
 hVv5UUTy1g/5aP2wacSWI3Qm4n2MWl1aCnHN2h737PCXXfBk5iGJsgBUnSQULgdgEAt1ABEB
 AAHNH05pY29sYXMgTW9yZXkgPG5tb3JleUBzdXNlLmNvbT7CwI4EEwEIADgWIQRC0lOFwaHA
 K4sbHG+AG924JZiPZAUCY5G8SAIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCAG924
 JZiPZMZiB/9QkcGfH248qvFUWZig3jssK5IgijfOFDKB0YK4e844M5C8LVSuWpu7Z+lM+cql
 3mbrikW6mlZjPEusrQ/KGvT6TdfOM9VCQWjlshMzt7uiRDdzufHGtE5hhk/67UnkEVjmplpD
 k8cb1O0VsBfGym7e0nySHTlDWqr++9EcwgV3uo4psYYEqm6Aon1yKqjbmj+vfl/C5iW3V4lq
 DhBk8w21AvNS+tdEqJzhruxuXkEDZZ07wYFS7m8OxLNb4sMzn/Nz9x/NXeweBWx2ujIERtAq
 1e/hh0ZAcoPVR3CfO2QTmfTfrzVdpZrZ8F54337ze3+BUNnrFGObQhlNe26NqNYWzsBNBFjZ
 ETwBCAC9zAzCRlTgzyO9siVLQYwbRUhcL1TUJU/FiOQWQTmL3uDdBc6MgVBs+hp82RwPbbXT
 v4W4rghBYPKdmFXvRN+jvGDLq1f2hsuCSiE1ckTMzFV+sKoWRIEC12tEpw5ncEFGm+1k/rJR
 Lk9eHxuqn+yRjPryN8CK6tK4+b4tZ2urKlP29XG+T3l/mbUSoqfjqvyeKaW6xw7ku89EX2Xo
 QWP/pm92RxUd6VDU9vpVW/T7qPZRl0wtUnDnO2wePoZmvUfEr5Osh3MNvm1myG+v4EV2Hgva
 NT6pa27IptrUq06cA6dDsIKwPtMuThJQp8/xumgl5Q9A/ErQoJTrB9rclIm7ABEBAAHCwF8E
 GAECAAkFAljZETwCGwwACgkQgBvduCWYj2QwNwf/eOIpFB67cKoUJvcm3JWcvnagZOuyasCw
 xwH9a0o9jORcq+nsJoynS/DpjUKGyZagy7+F7sBrF7Xx0cXF2f5Bo42XNNiQDE5P/VLwvgn9
 62AJ3q0dp4O7oQI8UgNmdsocQhNaBHHCoOabLGrgNobDTaLBeb9zaOZqz8CBuAiZ0bVABEpg
 50hDEYTHp4jCgWpadhAsp/eCgm93Tc+Y+e1fqtE3FmoOLxyhFa6evhn0Q1iX0kCasMZwlzse
 zqLZjTM1Koqn6+UIHXE3QaULyFKD1GDhisXxyolOB6P2TXsyfvitYdIZ3CCtI7PVDxzmX2Xk
 kvEz9bMtStoMpse9qAsmHQ==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

These version were tagged/released:
 * v42.14 (last stable release on this branch)
 * v43.13 (last stable release on this branch)
 * v44.13
 * v45.12
 * v46.11
 * v47.10
 * v48.9
 * v49.9
 * v50.8
 * v51.8
 * v52.7
 * v53.7
 * v54.6
 * v55.5
 * v56.5
 * v57.4
 * v58.3
 * v59.3
 * v60.3
 * v61.2
 * v62.2
 * v63.2
 * v64.1
 * v65.1

It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases

---

Here's the information from the tags:
tag v42.14
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:01 2026 +0100

rdma-core-42.14:

Updates from version 42.13
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwUbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RX
Swf/UDeAl+wcgLROQKpsF7NJjiL1J+szg9lgscj8CGXzim6EZJBw571XKuEHLzTK
28NZ0TJTbCa6DPCxDo/gLGa4Z+vbP9ZZILvFvktclPGJ+qfoCCg50LWIGE8wn8g3
WCvCBoS6kW1daojyP1EA4bb6HezCDiHhHgpuhvXNwtHiK9noDanJ7D2TqrVPqeKN
WsESLy7yf6j3CRr46treLSBc4zxd1q2L+xZIxEltKnQxGZ8mZgYuFW+cdeG+VhLH
beIBsSAIw4bTi/AHN3yeGR2pqLc66MlLjbrJG1avNsnEAjN4NbHBWpTq4ORr8ou6
Gzx9SCyho0vwIj0eEHqQ8WwcEw==
=dB3v
-----END PGP SIGNATURE-----

tag v43.13
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:06 2026 +0100

rdma-core-43.13:

Updates from version 43.12
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwobFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QG
fggAlk1SMmBlQMLat5NE4987iIGjZ/EGOFOyFfYS5+9dk9G71BCcZe2mnwTCb+2C
DTOtLQL/ndM0+X4OaQSCR6or6DNx9CVIlDWEAexVvk2VG10U0Kq/4DJb23R11d4D
KnOIWC+PhQy8tmgJIBDiz+sECCIeEVpDwhdpjycqG4omxjX3UkXIfxaHXrWeAp79
Iq2sT4CkBCUMvhqJKyPS+L7Ph0sYSgh63mkLH606YAffiAIP28xIfVXOAtra12AE
zP4VC72AjC1MAqBcv02zy1zMSZ9+pGXWyu32829rhlqTxW5iTyIPxdhBWN0VoYQ3
vPKELgguureDAOhi8E1T/us5Cg==
=LFnY
-----END PGP SIGNATURE-----

tag v44.13
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:07 2026 +0100

rdma-core-44.13:

Updates from version 44.12
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwsbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2R1
6gf/aR876JjKO4+N0bc6BwoqsF74AuJBEaL5wLZ7r69HWru/Ofo/7M0A1MRbpmrq
k/yQhgE0jiYCozjJimKhofZxKdhD9UQ13ICqY73p9AYSWhJquKYHq36rDiyyCEG8
5CqmnHPiUCfPB6poSsOgLOvrCLrh/7Plf1jkU2b2jsEEGDiNjzsfHtHsjHPtEJ/w
0SlgHWCsf3XoWC8Cu6rwUJNKT6bLmhELfphVTmiibswnoltm8ygYlUlR7A11ZB4m
rx0vpFEuRWXSSKzbiYu/foMXkAC/6oX6uuRT7Ex32k40yt5gXtRT2PikR3WRrk3B
xDOzjgqq6FL+ELq/zqlw/+uJNg==
=yWhQ
-----END PGP SIGNATURE-----

tag v45.12
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:07 2026 +0100

rdma-core-45.12:

Updates from version 45.11
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwsbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Te
ogf+JRcH3/E3Vgk+3JJwnuoXXjHfrDv+7ZUMsPjTbhsGvJlyxJHdnuCdoyercGlU
CuY9rOplQ+lkbydI4EXHVkG2HCVaWeHJpQO/bGKQbsw9GeGJvMLwqohItUN721zp
a2rXLxE45spPzBum/RZwuhdFMGyyfDGNe98//o0AnVU8XSeldBZ/0yhpIfmHGbfb
KKsjutKxtyrhwR9UTdD8PiODsNBBcpmb8DLo+M8brhFlQfDS9Q3BYv+zDOIwCP/H
tnsr5oCAh+7lC/siyEg4uqLf2Gg/nZw3BRBGMDwT7Dt/+FeXAgTAcvFte+jIrl/Y
im+mVu+65OfVVfaU2vJwOLDm9A==
=hXXq
-----END PGP SIGNATURE-----

tag v46.11
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:08 2026 +0100

rdma-core-46.11:

Updates from version 46.10
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwwbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Tt
cAgAmz2/4eSLN0tV4xlQVKyrWGVWGTJNwvWlNL6gAg5xvq5Q3RyHBvU4eDgFfTon
YePVbqNQ1VdyYddbwtKojjk9VrRWT3Y5QMDam2ya8/BzqkBl4hG0FytCrg7WJly7
OA19/UUCnr1Zc4Cmv0OVvPp0Y8HHjqSaaCDreqSTkOayPJzDpumyMiBnqHVGfOe6
IAupdEFcWjIpDkc92al/uyw9+Sl3c26qKpEJguWu0jMJ3qWIbSdDoRpO8+6imXgy
0JSXIFP3S9zB8oHpn0Set6b+3kFYmW/4G41sMd59q4/J6Av018nem8I5nILbcf5B
l4th2q2QDWCin3t+LYW4v14MpQ==
=Yq7o
-----END PGP SIGNATURE-----

tag v47.10
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:08 2026 +0100

rdma-core-47.10:

Updates from version 47.9
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFwwbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QB
UQf/YWEZpA3jg6ZWM7z0omOgdaAP2GhoJZB9BKD9+WBKb5RLd2af8pORJVDbwL/b
fLQIojIXD75lTkmrG4VqXK/HzdsJjKdVfTZWInKpUzfsjc5RZC8vpwow52POXobZ
icn6esbY0b81s6lazpiD9GnJKT4rUcbqa8kSvj6bpE/wC++EhMGjvUjnf5JeNBOn
kND884SYZ5ENBWNM1S5s0TpHssx3+7N+YPKbi6zb4dXh5bgfY9kO1/ajMCNAmfya
dMhMUqZlZ90SAQvAxr4PmxuVJrvyVcujeDf3e1HksUUsOVHZ8BHQgJ01jIWvjSyp
HzpMdlQ4UZkh2rTjwoQqqWcHyA==
=zpmP
-----END PGP SIGNATURE-----

tag v48.9
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:09 2026 +0100

rdma-core-48.9:

Updates from version 48.8
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw0bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RG
9Af+Me0x8OlBP95ZKDpTj8oPhSZttB69dqbvHcz1Oh43YQJa0O3yavJZIaRiHCzo
4B/mQWdCQfIu5FMGa+g3YkQ6F6x7SWf+qZz6CzTjyiNuhqFoxL1d6xCy30BkqNwD
29EsHjtZb1S5g56nFKRCkhNq4IIg+DYi7dTUWNuCQ+6+3p0ouG9lIVbgESDHHh2W
aLG8hPyqYBsM1TYgSx5LtxCt/75BOhTmqYLcNNk9qLyL+OAYFj9pP+/fMcHNA5nk
L7uU65tLE5c3D6u8tv6SfpBDEUC2QA4vwBB4LqTU+7PW6Oi3WgHnmICAcO5HqWzs
qeeU9eHGVtqrjnS5+uebamchOg==
=m51/
-----END PGP SIGNATURE-----

tag v49.9
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:09 2026 +0100

rdma-core-49.9:

Updates from version 49.8
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw0bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QC
tggAnIonP0AIUQ1ItqY5SXwYIAoB9zofP8F6jzDCq3J45v33hOKpKBBGYpMDTdhw
qhHSdH2AJ5a8kfodWwryUy+LUIQjp0RAPtDxAHriR6c7UPYxXn5nqPigIPI/6LO7
92pxa7okupXr76BCc2ibdPz0gBFx3AX7ytMHH8FP7qQiH9y3kpw+u6moVDXngy2f
bRha5bMjV/Lzur4sVncYFrN7cCRaBTc3L95CGKakFTkoS3ZpS3gFi8nl2ezSbvQG
jmbJEH+fFFaZdSfCEL/jM/ktYE9aYeFm4CtTCfW+ihKMKnBTDfkWmAC9iTRuhvsG
JAHACbUx96DNSkIha/qza689SA==
=l5w0
-----END PGP SIGNATURE-----

tag v50.8
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:10 2026 +0100

rdma-core-50.8:

Updates from version 50.7
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw4bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Q4
LggAtq6aEmetxkHzDgGtYfQXIfEbSK90dIIjw80IE2BDSDFo/OusG9m1JmeGL1/i
klqyQ+18ahf71f72llU9BJu9ry06vEiebUvTGwTH8C8DOmwqg9euulTSNzUHNcq4
hmKGzEYYM1zt++A9/UnM1XP+EWJfKB28C0B+dYM0/mZDdqN3gGKtC/6g61n1HBKR
2UbIFuHoMXZTh4M7grATG/i0vLFaRHlQruitvlyeId0twR9ijRRQnAlYVkXDzPEp
G0M02UhlJT6WXSq1UeGkioBgXfDCaih8P3MMptfekPblimMybXmBxM2pmhDKY5gB
tVNfAlK1A04dA2fvZHGmIkkkqQ==
=jP3s
-----END PGP SIGNATURE-----

tag v51.8
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:10 2026 +0100

rdma-core-51.8:

Updates from version 51.7
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw4bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Tn
Kwf+IMWcxHMLDJClpXcGpFbZbkq0IO5gh1S8+yduRf523v30Bl6otIRuFsewrS0t
fL47QX2hdjLbqyB/jIkCNkifK4q67sySXdHHXxkALlMuwQ3Tg8vwwvxtavEojCbt
dNAlO3FGfZcRM9raW5KBgy/IG4lu96RRwiWv9FJOVUhXHok44mtSMQgvOEhUrhPD
E0v5QU8zRop6+NeYZ1Wb6y/QUZGy6C8bOr/b+828TzJrW4qbiUTTgOvGP+GhMaTZ
gc525Tg14X3zN1C9gUFNGU55bbrWRXEuCC8znd521NYGtnOl2ndkAio041Io801C
L5utO0JcPEj17SBzbu58RH9XWg==
=JblE
-----END PGP SIGNATURE-----

tag v52.7
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:11 2026 +0100

rdma-core-52.7:

Updates from version 52.6
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw8bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Rz
jwf/bHj5TWv1KwersjgCnWWOmJKhIe+MA4tiDzhJGUscdF6gOpEWat1ZXQK9DUaL
AUsViuw8S/ntAD8JPF+K0KPuuQx7RJfjZ5NArf/DaXix8JvAEmxydtvTgUJQ2p0I
z4ohYCyicichZWTZhXiO4DpCXV8tEZRMf4F2gx9Ju85P/qVqcz+R2uFkd8cpj0A8
sDGwa9r5+p2FKiTlIxfySVLC3ebXuzFXrLE8tqewbtezVawQYUzVbv7pIE/ssgJ6
yZk5KpqFXLbjj+t/94HQ3f2w9FRPGy7UYkIbPYgFgCo80AIDrAiXTu7WYtH+YUeV
aWsINr91cCysDEJkQlCvyJ3wvg==
=7xdP
-----END PGP SIGNATURE-----

tag v53.7
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:11 2026 +0100

rdma-core-53.7:

Updates from version 53.6
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFw8bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2SI
3Af/aELRBxSk3dKgRU1IFZsAR5JywmEQS/CjpJ5ZABAXFW9L2Y9vmw7Try6wtmU1
T9yTpYSOclnaa7YlV3LFfvxr3Kn+nQgwbfDstTWI36PFw3vjrclfM8wEGn8P2jdu
EmyZc4ltBaBBKYLf/h7Ojw+ZjE63vFoRDyXzkYBjUdphfs3sO7iZ0f9hJ4UOFaIh
o/lCfB7t4z/cp5uo7CAKhckgEezQftRYx0mX5BI7VRVCHP3wojmY8jHuE8HsqrDq
AN5c1umwZ3O4am6S3u3AIR8UF3IL6106YeV6fCPE/TuUVPg7VoSrIT1wviY7vlym
4moPcy3/QHaxJ/yCj8WPDhvPxw==
=TF87
-----END PGP SIGNATURE-----

tag v54.6
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:12 2026 +0100

rdma-core-54.6:

Updates from version 54.5
 * Backport fixes:
   * libibnetdisc: Correct argument order in calloc call to fix warning
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxAbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2S5
fAf/VDNAqSjZn0V0X4gC0sgimqQF6ALWn5jBUzlebVfJOEm8PZPHF4v1acc2Ps0J
ZsBuM5cHhd89W7WZqi9bxHifmEoTbqx7vtpCxectyuvWx6WJZgnITHMc3/qbufk7
n161u9D6fYPmQ/leBE670HAlMB0iG3oCHULj8PflufzkQU72CG+02GGchex6KJV7
LLNuvsp3UCCYO1LnGvTS72VPZ2m5x+9BdZHbjbJbvSU2feIbo1n0lmuW5jluJkLw
0KdRUTUxy6FryU0VGbXNQiko25a11HtIuekMT+F5GmtVavxv2owBERYKnZ3sQBbj
xweC9l0DvrEYcdW6N3iPUsUwUQ==
=hihd
-----END PGP SIGNATURE-----

tag v55.5
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:12 2026 +0100

rdma-core-55.5:

Updates from version 55.4
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxAbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2SN
nwgAu3BWpBLgOJ7rhO9VeK5r4M4ahmhgRJFJW/1AMHBSVX9zOKos8t6THA8A4b/K
58lf31oPzr75OZjFeFFWsMjTs1NLWOtJAUWlFAnNptCEFOU0rFQTP2j/LikLRjOZ
wviOO61Cj3G6zGCku5fB1/r7ZrLSKKrpyw8MncGEmZnqFakwIosgyzpYCm6WSpc3
GEJXETzhM2DUhm/iTMLjcDLtA3G+JZRbe+6/k+UbDTcB2X+LcvTUMQu6eNNKGuEy
DslwP7JKhwVijzPMg2vC1U0kE0Yfz0tFbOsITZ79zBNWi/oiePg5FqSKXDs5jPgJ
G3Fk2IM6RQGLtYMcNa9a0nv1JQ==
=nTTc
-----END PGP SIGNATURE-----

tag v56.5
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:13 2026 +0100

rdma-core-56.5:

Updates from version 56.4
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * libibumad: Skip Zero GUIDs local port interfaces
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxEbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QI
igf/YcKlsDvNoPmlB4cZQVVBY40mqMVxdKIEmH9Cx5VhQvhMUGxEDcpAHeQkm7ti
l1RG6KoNwpxTR10A1utIG9otV/VAa8d61wjOq9HvR4r5CyJH2wC/+SM/qrZLeSAh
CLZOSCg63cgMlFE5PIwKoScBq4QFo7vpsiRET9IWGo270VIv0+EjSzGtJEwULTL9
ViKKL+wm5ezv+DqCHwyav7JCF6Sf6BmkXoqpGyFPMn5vah1SqJnsSSM2xLvFN91b
13CLkT9hnOqjiqYVXrAnErfLtI8BPLTNyppvm3ioN9DBUwxh5anvh4hcpHoW+4VX
lUwwD+vnGItK3hmagsweiT4i7w==
=os04
-----END PGP SIGNATURE-----

tag v57.4
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:14 2026 +0100

rdma-core-57.4:

Updates from version 57.3
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * libibumad: Skip Zero GUIDs local port interfaces
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxIbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RO
aAf9EUZPX7xWl9PJpuIQ2dRbxyZJWNg1UA4gKg+ecczZe+DIIej9UUt8uykatye3
Gy61aMiaY+Km0SD5opqvUR3kHdSKcHauf2dnLluqD2XlxuKNYlTSaWOqk/grK15T
FiWAfDhk0QblRwpsom5ylK+tU9UQN+7tXSi9+5h+Jc5yv7mJbR7gYJCti+LN9NZb
j/kMDAV//MlqH05CtTb/L2X6Mpf6rkjef/S4Y2Fy92OV7D/GtBQbH6ThPTevf/qa
oiOVXj1Jjh9suOjTlHQQtFajQAJYa/1Yd8ylM+A3kNsnzFWYX9HkBNk9MY3kxnuH
SYfGFCgjE9RH9t4N6Kbp0w5VPA==
=vnWM
-----END PGP SIGNATURE-----

tag v58.3
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:14 2026 +0100

rdma-core-58.3:

Updates from version 58.2
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxIbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RA
rQf9G32k57H8AV2gCGQ90xkbdRWOKwYV5R6IWzsh55NmtMhUUk3EMeC7i1NtrNUU
tk1t0HiuBoaNlUJefYLgeNvdRUMvbDWOzDL3cb7F0nshRvRdoHoE1kYNHEWiJvf7
35/UQsLl7v2/OzmP0UxrMgqcGchNKyRB4Bi3sYGiCdac2JhpPe38Vt5WGpnyy7Oy
Oxs/cyMzHxDlhtikg72wvbQ7Q3LRtwMkVsFTzOEiGDY/WeHl1whyrUcYItrVIgQJ
7vHEt8XsAZkHf6hJNHYH274J8+or4W10YQT9WU5R40KDnULworaSJcfBQ7aZ2avF
Yddeikk4TH5ksh3TnUltvQXMgg==
=p5pL
-----END PGP SIGNATURE-----

tag v59.3
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:15 2026 +0100

rdma-core-59.3:

Updates from version 59.2
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
   * proviers/erdma: Fix wrong length passed to ibv_dofork_range
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxMbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2T7
AggAolYbi2aYGLoDLIUt4BJsAce/4Xll70Q6zOwzFuPwFD+jdV0HeBgk9cLKGVPB
D1x9F8YKzYKxjme2nL1OU4H9+I32CsnSy08viYYy9Z3Jq/aCOMLkARx5KRxYo2W8
vspliLmZvI6C8duL5OP9yEa1ZKSzmMXQk+C+xV6m6LB7qJaRAp5nSRs4eR/MeHzT
Fw621ONKcuu9lWT0YE2QA+TIwALWmUIrnZkUDgB/XTQcr/+SzZHXNZVPNT+UDPJZ
w9ERqZ6Jaa1kjPuegrTva/IX7OprWgsgZZMcW99xzqsyV8kZBK47GNYfkHDt46C0
mKlY1sySNi4AuH2s0keYED9ttw==
=j8GK
-----END PGP SIGNATURE-----

tag v60.3
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:16 2026 +0100

rdma-core-60.3:

Updates from version 60.2
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxQbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QR
qQf9H5jojaYHe7f2TGHYiCp1E48bmweqWavjDZMekuFi6ZdXyGeMNW8KCR29Ir4n
dQGy8aFwyBj20gvjeMR/V0nOb2iREvWM+IuHSthtGBOWzMVHYoG39huWlSXew3s+
5dr9r161kDOA49JELh3EJcaecfM3WUyRMG/7fpHuN3MpPgMWXBLf8zgf9Nm8FuXV
IrwslG5Mb8INs6NzGr8Tf3eu/RQX7kkb8AjiMQayqD+xVm5dnkepS8EypqBDVk7y
/qgTPURrZgJCr0LZMSyqLrGtMEx1Yn2xaMFoQ2bLvAyv5NsNDvVKyHwQzgQgnrbU
HeGhGfCYyDIwC3IzJeRyA82aYw==
=qFqR
-----END PGP SIGNATURE-----

tag v61.2
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:16 2026 +0100

rdma-core-61.2:

Updates from version 61.1
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * ionic: Fix have_movdir64b() cpuid max-leaf query
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxQbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QF
TAf7Blwc6Vxb5DTVhFYbAVugIBjaUPQg/3p4bWlIyfU73DvsSD4M+9xNew+bCwgm
C+ls38AmKdRFXw0DRTY1Jes5d/QAyOThd+ux3mbQoTPyhSyeEGQDLVfP/Q2JXMoO
mYzNz7JPbvOtWg1T7bZL/dZAadk4LiXFH4DSLLTqiWibCmhz8KlxzU8C0eyRwmKg
Kx+oL+CLjhhyZr6Dz9Sp4FCB+74aJiiWBnFYabx7CL0+h0SjHcx8w+SJKZ2ob6FP
ODkN3lc3nKDFWQtjUht8lYUnfKaJS8d9WFa6zPChStHQseWpI2QGlcZQVHzQ/E3S
PvJN5TIVN+lJp/QBxsiR3UfAMg==
=iRJK
-----END PGP SIGNATURE-----

tag v62.2
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:17 2026 +0100

rdma-core-62.2:

Updates from version 62.1
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * providers/mana: fix lost CQ notification when re-arming without polling
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * ionic: Fix have_movdir64b() cpuid max-leaf query
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxUbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2Qv
fQgAoU67esXGHs686x728EbTsGEzrBIXQnkMeYp8d64wuS2tjgKtuUQPZl4XOZ2O
ypQX5XQYf7bDFng4tGi5tJtACQiYeOSkKRcfQU2ItbqVLV99Cds+MZmLHoO54kG0
zZK1afRoDllW6wgo1jwQze1L2O+EgUTUpG7MhBasKucJ9/BjV+P64zor4KG24GKf
0oLLXlFp8QwmznMF1KsJORvjN95JZxEWU0/OcpCKzLI3p/cel5xxxQ97by8R1xsL
iWVz30rDmfBxN+lVrD47QBuz7X14YvFUF+4ugt1fxfeOPJadMhKBmz3H1uFl5y99
iI5Eav/Gj68YoSf/xK8F4azOSQ==
=EJR9
-----END PGP SIGNATURE-----

tag v63.2
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:18 2026 +0100

rdma-core-63.2:

Updates from version 63.1
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * providers/mana: fix lost CQ notification when re-arming without polling
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * ionic: Fix have_movdir64b() cpuid max-leaf query
   * mlx5: Fix clock update EBUSY error flow
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxYbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RG
mwf+LK1AgcvQ/Ix70mzHwgJv6XhpRl1AkhFKCunLs5Kh5O6nKMORjlHtndPsXXlH
2IBmd71yZBtZzA5SWmbPrJfVPFxxvD3rg9M97YnJ1b6/E29UBlC8VaM760mnVjQ9
BGs52DGamWUTitaktU/5BacZmo9zjQYMggXJSyMgdzhEyFRGc1ziC+hY91ttrp/z
qzZqz4qmeIZxUPF19QSu8Rzv8NlAPZk0xPlXKPHR/BQJw8Mkd57RH27wZY6eKA1l
An2qKqGnVDYFlWF/UHSPXDUKtDEePJsZnrXlWrK6KlWbmct6rHZnP1V6XQSEVUq+
ixQ5Sbp/xr5rqlnxzqs4xIgNKg==
=Wn5Y
-----END PGP SIGNATURE-----

tag v64.1
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:18 2026 +0100

rdma-core-64.1:

Updates from version 64.0
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Set internal QP type on GEN3+ QP creation
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * providers/mana: fix lost CQ notification when re-arming without polling
   * mthca: Fix signed-overflow UB in __mthca_cq_clean() sweep condition
   * mlx4: Fix signed-overflow UB in mlx4_cq_clean() sweep condition
   * libibumad: exclude Ethernet ports from SMI/GSI pairs
   * mlx5: Fix signed-overflow UB in __mlx5_cq_clean() sweep condition
   * mlx5: Fix dbrec alloc returning garbage pointer on failure
   * bnxt_re/lib: Fix slot count accumulation in WR API inline data path
   * bnxt_re/lib: Fix for larger WR post_list sizes
   * bnxt_re/lib: Fix issues in WR API callbacks
   * rdma_topo: Overhaul error handling to avoid tracebacks
   * providers/erdma: Initialize CQ doorbell record
   * providers/erdma: Allocate CQ buffer with mmap
   * ionic: Fix have_movdir64b() cpuid max-leaf query
   * mlx5: Fix clock update EBUSY error flow
   * stable branch creation
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFxYbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2QD
QwgAtfnFvKOpSak8azsrSkjFjsznc4dUab32TWOk+2/hS5oGLpDlS3YAkYAurK5N
vfYlY7FN7VxEz9+EMsZW4QKx4v2HFxZn+q2ysnfPvDEXDerRy7TW7W8ILASGpRwo
LM/dMCswl/sfaqbKZ8lQA8g5KQGuZEsju5WxQQTFlzuWzs9aA6T0Lxgi0fs1snXs
cObgCIGJUY1BCdbdNex0AIRo7nKH4IzdQpACcqrtwJL/XQBYW/JRyLUIyf7Qtj5Q
SSeT1UDPj8vdFf5R4gpvOdpaPlxnme/TwsoQnqEdeIOqwlVsVHXb/DL45vY8c1tx
rzpAYTh4RSHChsQLaNV+q8RfZg==
=ReWk
-----END PGP SIGNATURE-----

tag v65.1
Tagger: Nicolas Morey <nmorey@suse.com>
Date:   Mon Nov 9 19:55:26 2026 +0100

rdma-core-65.1:

Updates from version 65.0
 * Backport fixes:
   * util: Fix the constant length check in the aarch64 mmio_memcpy_x64()
   * libhns: Write all 64 bytes of a direct WQE explicitly
   * providers/irdma: Discard unsignaled non-error completions
   * providers/irdma: Use mmio_write32 for doorbell writes
   * providers/irdma: Set internal QP type on GEN3+ QP creation
   * providers/irdma: Reject zero-based addressing for type 1 MW bind
   * providers/irdma: Fix MW bind flush completion status
   * providers/irdma: Add missing load-load barrier in CQ clean loop
   * providers/irdma: Expand IRDMAQPSQ_AHID mask to 25 bits
   * mlx5: Fix underflow and stale data in dr_ste_copy_param()
   * mlx5: Fix inline SGE length wrap in set_data_inl_seg()
   * util: Only fall back in open_cdev() when the node is not found
   * kernel-boot: Remove Wants=network-pre.target from initrd
   * debian: fix version for newly added symbols
   * stable branch creation
-----BEGIN PGP SIGNATURE-----

iQFgBAABCABKFiEEQtJThcGhwCuLGxxvgBvduCWYj2QFAmryFx4bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEBxubW9yZXlAc3VzZS5jb20ACgkQgBvduCWYj2RL
pgf+J7wZi1rBeyBUVlwwYJcTPaofQqiNRc0nRmdIfIb6RCrp4GjMFw0N1v01UBYS
glByrdc4co2jbyWfCWv3yTZnk2euCzh8uua5K2xDfzm4LzBkwrImZ2EUkSlty7Lf
BpbUlzVkeQ1lzrcypFRIB0g4Mw8npZg1Kb+n/yWCRKcCW33xAtZ97TBcFFNS2+UJ
4i+FN7M/KYrSJ5uPJ/r4J1mstH8ofdUyKGj8Q3Sg+g9h7ARQMmYl6+9WUUHzyNQR
jUrdPH7tq0qpYmgvYsrcLQEdudrzSBNW2YddtWq23pLuhQUflMMy/oZYfvPQwUG+
njdjdiTdZ0pxI69/RiZT3zeBOw==
=JUcP
-----END PGP SIGNATURE-----

