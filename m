Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794953064;
	b=GOUiClXS9qonVSsx7HksUWPY0BzuIP13u/Y+0eUVzVNfqh7vePFg6J796Sp2kq9D5+Nz
	 XK7yrYZ3y3LWgCrDoWU4DCsJ+1KDB+FVgx8pfQAv8Yf2VkuxlyE9b2dhGPBJ0QIvrBbWl
	 3VTFjUWhqJ8l0LS7xAMqOPd+4BC2q7/BMZzJMOV7wh7Z1HvFqoPaPW51/Lxx8BRz649AY
	 w8nUNAPLrCzs3ZfHYl0CaljGiIQAUu/jOgOja0D/KNWQG+PQ1zcxlNlknxOMfjDT4zLmz
	 xpi56FO/gKGOPG+F4RhCIep8UfBXhW9iHjpxytXGq6TE1lML3fb2uf0JjQClVJPVJZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953064;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=F0h8eziyjQaKcApZn3rXwi6/D2KTrjlf79mLv/zsAlo=;
	b=D3MYKNENn05i5rVGRVQda/DQjm7G/eipZGwoR5XWeso0MYO0kqxYTUbESwxbwNDoZtea
	 zRdNr+sqJFlugMF3wJNRRkNFcb1Wn7sYSWZA9lhJtTPKdGoQCJ4NEjxIqnwt2/pNNhEAZ
	 6d4Ri8GWFL5JlpmMpKAIgsmcEs9gLuEfNVoX22lc2BYx1lVA7WFnUu0UJTssTmtT4jrIy
	 U/2zb+VSQya5OWXqCoTv0l4JmTGD7COXg+jpAgq9ogEH4cbfgxXXrgFzfx6Ylbz8i7/i5
	 yJfQeqWBdN8SQAgw9G63cE29XaNZaX8cnNx2DmUE+aMGm/3N/rJ9yAEtVk/7ZA7VLoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=l7uGjHqQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCC4606A330
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CCC4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=l7uGjHqQ
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHM1p202406540
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:04:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=F0h8eziyjQa
	KcApZn3rXwi6/D2KTrjlf79mLv/zsAlo=; b=l7uGjHqQiohs5ekfiARvjRSqonZ
	vfWTdNRDAMTgYbwgHd2DiCaSQiby1P8w8eUQPRR+TIo9nRLlBQFNdDnVag4VjV5v
	zrbZw23J8ETzA0nATXP0IVDkySa05zQZtoRlDwRuy1a2ZoxUH4Pp1yJR43RsCUgv
	tl+xcJlH6woyek733bANbYzH8HReXmgA4za22Txg6BnnOkOdLsXPCv3qcCky4PEl
	oTyV9zDt2xSDfhUpHFVmZaywQ69nMGDlbBxkhLjsgqHBVVkUhwg+7DJBMhDNzWHE
	pFQ8H/gSSYpsYTJQrKrhs1zeRTZ+DY87ItQdcFZRO3NzTPrKdYV1xdB2t8g==
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0sh5md4s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:04:23 -0800 (PST)
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48df02b91f9so766355f8f.1
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:04:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794953061; cv=none;
        d=google.com; s=arc-20260327;
        b=GFoapdOxfY1ozv10UYHxw5SSYHg+VCVErKoU0dupZ3bIC5PqMoVYMcasiYEUz0mF5S
         L/bhrtdejazua5Sw6QkkOzUzOkTSKufSO2vI7Ky/zCHHuAfo1R28GNtIjAxfQagcoZsh
         QA4mPysakEmO4O6xIpRNNgBYIE1AAoSUI4uPnrdfw9dIFQt7uNGo48E59ukWa8BqcPB+
         j/ozq+wUNpyIkqYY89DkCF19kdUpYFGECoAdyGa9UEapLhHP+DzXIdcjFZUMNE3vTtPm
         /iQemanZgHx21T7ISFbt7NqWgo9koplMO74CvodXhTNtpIrmeP3D7gpp3IlllUCe5xaK
         S9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=F0h8eziyjQaKcApZn3rXwi6/D2KTrjlf79mLv/zsAlo=;
        fh=Qxj2OSzdnaC5r3r++1nLBiHw96ylU15Oi8nb0M3iUuc=;
        b=N5Ag1pLAFRNV10JIgeILx1EcHcp9TulcCt5l33L9F52Yl/1J/Ct4fdMj/TEXRv4EjR
         Ta9vNjK9E6mU0HVwAmZk8kyTrFbC43BC2r2Nf117bY7ZnLlWQqctxswg6Fg2si4uhY+D
         xgiZJ3Ul3PDm+Zoq1d10vqP4sA4LoZ2GSH2blRla1iCzqzlOoBidKk3aER5Aly0CMf4H
         GUJbSNsAd6s+OVpI8wUEIibAWpT+yi9OkoRuJQCfiSHeQFkHOlFra/LxgxDonsV+0IaC
         sNVuySexdkYzbk6Tr1cl7unyIk5rcfkaVuo2lxQqDfBvt64FqPryrjdxm4n615/YLX+I
         1dQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794953061; x=1795557861;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=F0h8eziyjQaKcApZn3rXwi6/D2KTrjlf79mLv/zsAlo=;
        b=zAdqFNMHHfnfcVmeWiUNyKPvetHcZk9/8vs3NHMFWaN55SviV4aRX9xv/0/Wem8Y7T
         SIF34d+1b5b9gYFHhFW+EpieOc9zNiFrwut78EB4ip7lYywt67piuQAbkafHcUUJFzYj
         FTOCNWukkuuza3W1yWJsvtmNUQMo84xqKCBERByULIV7EoQGBPLavLP9W/mN/cbeMtx9
         VrDF1fDEY588UEH7Ooyo7KV/VqwEcDVkvmby2336F0ZpnShkQd7CLcda6mprDgdtv8pV
         7Cs8nCHlBgt5g3znXVhAZn/3AiwcFb4W3t+w/DgU7tFCKebifrTColTXF3ASjmyP7ISx
         Fvlw==
X-Forwarded-Encrypted: i=1; AL+hErHTbTq7CcFDxJQjBdEBWzP80G9hqOOjkZLV2BUscR0foLAnXHAwkL9lpOB3K6a27kWqAPjjMXH7++oz@vger.kernel.org
X-Gm-Message-State: APuU4Z9ghHsfSNaZpP37m4ChO85aXPkaXRjud9R+UfrIu+QrTBqaLcn3
	9RxMfKoIh9ZMRtG9EAYphidzfcBU5507zsTKHsYAsUbMoOwGa8gaXuWt/D5KvtxIdAuO+6Heh33
	QbRSTnPvyCO7J2DkvVEgWNtnQtrBCADZXYNylFPkym+qywKJejzsDBtJEwjzecjN1/PDnJHWbbb
	eIrUHhQlCKVF4GU/MLJ4FnFN17lD14LZU+c/dP
X-Gm-Gg: AZFdTZdQAJLECwfgaG1E7ks2ilRa7gS7hRSv87XZddmHlQhFBLBzzmr1hoJg8UmoehL
	o0iIuRJOPF/OYDNNdzGj4iVK0W0KsS3Ic3zZ7HHmV8MrVtAXqL9ZxGkOuBhI6DzrJ9A61Xab3O+
	4CQOMbE07LZJgZpKFdVUDgsVT2znGMKoUvCAD19GtpG+A3c2eteXOVTGSzjF5yL3h/kjGqek/3c
	wyVThMGn/xBY6DqjBvjPGxouhzzAhbB/oloiT/ugHpOlTdiMmA=
X-Received: by 2002:a05:6000:4213:b0:49a:94e6:378d with SMTP id ffacd0b85a97d-4a377f4f68bmr8136028f8f.30.1794953061546;
        Tue, 17 Nov 2026 14:04:21 -0800 (PST)
X-Received: by 2002:a05:6000:4213:b0:49a:94e6:378d with SMTP id
 ffacd0b85a97d-4a377f4f68bmr8135992f8f.30.1794953061161; Tue, 17 Nov 2026
 14:04:21 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-9-toddfreed@meta.com> <179471270271.2199510.4403404984222798506@kernel.org>
In-Reply-To: <179471270271.2199510.4403404984222798506@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:04:09 -0800
X-Gm-Features: Aa3M54r8wXLJNYnHzeKDYLuWuEkGFgDFBdsvsZ-D9Jbgov-qnF9vSIAxOghmZf8
Message-ID: <CADh2yMyL_SSJqD4=H4zkzmUCJCL4OwxeY+iPq5FQrBZyCb8+tg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 08/15] psp: only give time-wait sockets of psp
 connections a validator
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
        bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        john.fastabend@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, martin.lau@linux.dev, pabeni@redhat.com,
        saeedm@nvidia.com, horms@kernel.org, tariqt@nvidia.com,
        weiwan@google.com, willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: jml_13IQkRybVo5VA0GLXERwDRqkI7pb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4NyBTYWx0ZWRfX+3h+6BXVBrMy
 eIyRVEe7sme95esvQaP2hioHoaS7tfObb5FK6xuT1OkO2vXhgeaMwsnvOghu51mnW0HXVOjmAce
 7e+afukSr0lYQzeHUrbe0sB+C8x7C8k=
X-Authority-Analysis: v=2.4 cv=A+H5rKWG c=1 sm=1 tr=0 ts=6afccf67 cx=c_pps
 a=C8Sa+zVB7PeSwznsLr31Mw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=kH2YsCX8xyqK-3fOXDQA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=eYhU8IiCvE_ms1W8Tcak:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4NyBTYWx0ZWRfX0EcoXSFeBWQC
 WE3lbmaPBIXSAlkqVusWf7t6wxVbmiFX4KHZ1k9Ve9tUR5kYDPjToTZkCGDRiiwftfC2uG2FTFt
 2zYIwBZLeThmhc0FdeiQWBMZNS0WjNHhxk34JjV56njKYjtZnOW6ZzWnYLGK8tfL/cBwjosq3Nm
 tDwfV8cOT8dm+2wgxm5CCmjXd7E5NK9jvqzvs+8ExO1Hy0QssYdf15+JMXR9Wo/FpWRJf/cSdmw
 dzsNqKIAjOEtKkltITNbHhpFKGt8qkpnqjbFbTjrWRcF3gGAOuKg1iFBmdJIuGagZk44IhinaqY
 4OCOBfyED0pwXM1eq6EqAN4p++VyA+n3PmUj67Insy71dWkZYdfcqgT4iFNCW8wj4930qtUEypY
 5Gmj6H6Msw7wkUnjRY7IfSI0UUTvQS2HONxf4fkCLVo+f0gK8XS+ySsRpk0pAppyjGJ3/tkYmN+
 LbXrm2CCkETXmsr7/Fg==
X-Proofpoint-GUID: jml_13IQkRybVo5VA0GLXERwDRqkI7pb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> [Severity: High]
> Should this also check pas->tx.spi? As written, an Rx-only association
> (pas->tx.spi == 0) also gets the validator here.

This patch has been re-posted to net, as patch 3 in the series "net: don't
redirect decrypted skbs to ingress, psp time-wait validator".

It is now checking pas->tx.spi, as suggested here.

-Todd
