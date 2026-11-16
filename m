Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794869071;
	b=XWW2Gn5wJBzaTRMZHAU+2pVu9HnQ1njhCAjgi7QhlPjxKB4BLlI0ev++09rh3VHSgA6l
	 fylhkM3OJhVFQCVDTwvy60JufkrQLCqgl0OfoFbzS4XfnIQxx934aWR9eZsNJVcfIvSVH
	 I8zbHi2hvdXto98WOYcLnFOBOie7u4iD3F/CH8zzwdJffmolxYALCGK8l0DyszEo1A/Z5
	 /FR13ZIdHLFxYKkFrsNJWtDOe7XfaTFgo6NFlA/SVLdVlwSOOCPLZEeIwmEqZXa9Gf0Ki
	 TbEcxLElh0vms+9/ChUKK9OTy0R1dar+rNJv8RukBBPNf6RxbwMHQQNj0Z2+YzNYzMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869071;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=INFJK33SIHc1il9VMaSNYPCBsxVfdMkBi2pHTF9t3Rw=;
	b=EMnmwIV5zpspZjfeCPXzrFKPVo1wn5S88cscEcMbOxI2kigw4bZt227cfetghxJxDvGD
	 WjGSBvfKKCaXBnU9n0eKCKg9pGcuk3Iu1cZtcjjn/UJMkMzo8Dl4VYdYfjXFwj4xtaFx/
	 +vwxMEfeU+76mnrH18N9SxwgkAkqfjsewCRUIqSXFiJthosnsb2pzE2VENXfZdm0id84N
	 utlLQxXe3ntOaO8Y7gh9gww6aA126015JGHvGE9ERizULWeMilani7oJs0mIl92Mb9+Im
	 lNN2VAk4D5eSdlEgufd9FrITO1csQHwSngmWGtBIfQv5P8x4dG5nvjhD7gAqi0L1Oiw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=ZJmfX2kj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CFC606A323
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 22:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03CFC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=ZJmfX2kj
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGM28pe4024650
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:44:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=INFJK33SIHc
	1il9VMaSNYPCBsxVfdMkBi2pHTF9t3Rw=; b=ZJmfX2kjDA9mCjYcEWXG21PTCxY
	8pWD9UYuB9/bEG5X/xJVrB7ctZo2WbDuUjwXqZN3+bkGuZDmJv8214nAWTMtQ+dF
	EoI5wPI5PMoO98C8N04f++csqKd3F+A8ZyXCtsrvB9CX4ebP1BEIKISJ7grh/bAF
	evs5i5HpMFVgZ3xEOielhYwTCuuuvPuWvAnkRjfbFotfYsFR51PuABFfXlJNmB88
	gygC/1iFR5c5vLvxmk7JV8xiL51kXKt6U0eR2g1wtGkSGGqkxbI0OfXNP6SbH5En
	/iokbf7NAOZVM08CXbqZdAER5ibv5CdFVRdGagVtkULlPJVLeQH8rBW3ApA==
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hychyry9b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:44:30 -0800 (PST)
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4bb64c99bb8so18988465e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 14:44:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794869068; cv=none;
        d=google.com; s=arc-20260327;
        b=bNgDJmg60YI5Ep+FgEmU2W9n2Bg8iMmn6oBe/sOZt5TQSEm2ghUMDG3B5y8IuIJ8DK
         +Ki8SmeoSkYrwNag1ccIPutpaVbck40kLzuMzY8CjwcHzHk80HgdClRPIS7hiSUlx8Je
         /JlNumPuLeJZdgKvUE9+UvBeZ46bl7XB9dmrnMOwfRtrVAtcsEaXeMmlNm7LcePPvZfi
         UhU8o4Y0ibMR/KjnqrpsjphxJogs0dveEDQqBKFWHi4BwJEdqppkAiX3L9ATBBgxpaon
         xfVRT/laOmUvIZoxev5g3hZFV7pVnzi+FJaSA2rlEfALnpTyg09OC26r6Fn9phmB/xsJ
         XYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=INFJK33SIHc1il9VMaSNYPCBsxVfdMkBi2pHTF9t3Rw=;
        fh=gMHijaAedeQh6Ge7/iDPB3iaoXC9N6MRGkLF4TGx2+U=;
        b=BryQW62WQlMAxKHTDiUplYHyQYgNJ+oe/UWHH8rW4x4F3j7K8bRZwcD56ZONZxZNk3
         gKbom4Tps7DHFCTBOAM2wuS54JnaqT6NtYqxMj9gelqMzLJJkyihsZkAuZn7CSVdpQs7
         WYhOpJLoZBCCZy/M8AmaItQkmkIraJHgYZu3Bbl/8biXod+TgIswu4MWLlFjtxyAHCH/
         IAR/4o12hyprgGmUYpKX8frTKLLWDsuxNkDO+5X/+akjCMG1t8N1pIOLeI5FHGlGVTf7
         C2uhx/aq0Ep2kBrPc1bQE3hmbzzGyE3n8PVL1GG+LS43718LH9nDa5Vr2aZWmPBquzIa
         ch5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869068; x=1795473868;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=INFJK33SIHc1il9VMaSNYPCBsxVfdMkBi2pHTF9t3Rw=;
        b=GLagyrRnGOkDzTo1jwLfOBTGPzJiuu1yzAcd/mCyOhzLnARbVaoRJub37tDSIXxffe
         xZwY6OQI37WPAwjNMDzZ0owuuHmyMi9r5otV2IAMdHYi06LjPFh54EyWYN2yffT4bVWM
         SnVy5V9AEXehQ917AL4v6xHvIomI0qhAfPRfSbaNoCvhMM3tU6PJe1h2vDWeOlvFagPg
         qlQaVO6R0oJlvF7F5nOUhpdRABuljhDOkIfDFanZaMwTjZkh8O0J6ZMioqizzucRUNXM
         WG8C+Ex55HYhnhBpu/PxXMU5pWjAzoYH6LW5GAlKeYeZvGC/jI0AjfhLIKQvRG8PoFUg
         sNIQ==
X-Forwarded-Encrypted: i=1; AL+hErHeqhvW+zKjHuoAzMuGe64WnnbQmJbtVVQTkxQvfMf6YgHPkgnjACNBoKv8WAtCD3S2JdYPI3Iwvs49@vger.kernel.org
X-Gm-Message-State: APuU4Z/6sSbD7eK0dOLNXGXn6bOfZjkSnCqriNItyL+ZwDglWwFNVitm
	LWGOgLSNg7gCTiLf7sJb8gQwBmJy/7TFDSDD1Zy1qm6D6VYtn7COWXzF8hXgIdmRcXlQpNac29X
	vAcr+BttCAFq55awpaFDhsRcfpVGCvsAyqFC7QH9yr5O/RjQoaVAGLjxPsgwSzpar0jR4i2KuPM
	4KjQvwmGOc3UNjJZAE4xrMSzSeze4QHq65g+S3
X-Gm-Gg: AYBFou15UOXldiLbpD3cWaPGgScm21hHtEaYkrDRINYyOaXrwjfoqu68hbUG8+4xfIQ
	UNeEeRi7JEh5kca0YR+Wh8d4DV9iJyw8dK4cnadiuyoEXGFTzjWrHw8M8JVt36c5/Rb7GcyM+rG
	GB41ufa1jngos60iqfszoz82DT9Le+ob6yWNId45ZpvAAJvZem0U6cemOKjjKG+HmvasQ5E1ZZ/
	H1cxXjcAWzq/N7iLE9MaajBQtgQFXyKSDaJLO5V7VNXz1gjuMw=
X-Received: by 2002:a05:600c:698d:b0:4bb:5de1:e92c with SMTP id 5b1f17b1804b1-4bb5de1f262mr192032325e9.26.1794869068642;
        Mon, 16 Nov 2026 14:44:28 -0800 (PST)
X-Received: by 2002:a05:600c:698d:b0:4bb:5de1:e92c with SMTP id
 5b1f17b1804b1-4bb5de1f262mr192031935e9.26.1794869068266; Mon, 16 Nov 2026
 14:44:28 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111001831.3710881-1-toddfreed@meta.com> <DMWNI97J4UZH.QK9260QE63ZJ@gmail.com>
In-Reply-To: <DMWNI97J4UZH.QK9260QE63ZJ@gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 16 Nov 2026 14:44:16 -0800
X-Gm-Features: Aa3M54rDJg770IRtFuGEuQTK9_ahFKlOSCDnmFon8USiCtNTDEcNPoAY-z-nWxY
Message-ID: <CADh2yMyLkoDMQL4pQphobvbBcjtojArW8URXz-7qtr68UvjQ+w@mail.gmail.com>
Subject: Re: [PATCH net v5 0/8] psp, tls: don't send offloaded contents in cleartext
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
        David Ahern <dsahern@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet <edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfX5DeQpuO+W66u
 8KvEhn0PN/X4+JxP9TaNZzIsVVsTFloyVo8NsjV8e6Lcwtsj6z70US11aoFAZgfxlpAlmrFV4/B
 wmpHKYViCohdlUUWFZutRLZZ/+RwAfjllRXB1dY6vJC0oG7+E5weLcsNRTAJxnVmoMENX5pAbAy
 VYEYn4G072f0Pl+/CvLA3XqXlbE/xTAgSZ4OEuJ1vuNpwQunSwa3l5CqVo2zQROouLko9MOKchO
 Fxs5uGcMFFhQRcMGJPF+Ufy0vL5zitkWuP/0Kfoqw58rIBC+eXyyt0q8fwbvKeaJmUUxmJPpGGy
 s86Oqd1G179Up6qg9CBhhiviRHSodCAUgmZ0IPEmY0xoEGv3p2CQiES/GJnGwsfDQCYFAt+QXm9
 U9PFiTyiJDVWR5yD9ap2gBEEmLtsFaUeTqX9Bmh6OrWCtOkVaa7f6qcm9Fc0Xu0LQXg9lAtzPlh
 QtbrufMWpcZgGhXyDlw==
X-Proofpoint-GUID: Nm56Htn_G7yMbxOu6UPkCtfZ2cK18lbi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfX0PFtc2TqjfBc
 AF5qrIJLe0tNwH8XINFUu9cN4fmHCJLUD/BaORXIz44iqYe5m8LEZCpuSZb4YfaeNKpyhN5a/wi
 RbHOKCSCp7xMtH6FJ7R3xTMzs7J+eGg=
X-Authority-Analysis: v=2.4 cv=Q5NHcI2a c=1 sm=1 tr=0 ts=6afb874e cx=c_pps
 a=ocXdEHcuFBd2kx0v6vcWqw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=eugDcP6XFwV9FTUBbroA:9 a=QEXdDO2ut3YA:10 a=XRP02QYyWapGEjE7oHHB:22
X-Proofpoint-ORIG-GUID: Nm56Htn_G7yMbxOu6UPkCtfZ2cK18lbi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_06,2026-11-16_01,2025-10-01_01

> > v5:
> >  - ipv6 extension headers: drop them in psp_dev_encapsulate() again,
> >    instead of in mlx5e. it's the helper which can't encapsulate them,
> >    for every driver (netdevsim sent them malformed). unlike the routing
> >    header rejection in v2, this isn't a device limitation
>
> Can you elaborate on this? You're saying encapsulating with the
> extension headers present was working for mlx5, but not netdevsim?

With ipv6 extension headers, both netdevsim and mlx5 send a
malformed packet. mlx5 also sends that packet unencrypted.

In v4, I had moved the drop from the helper into mlx5, because
"sends the packet unencrypted" pertains to that driver specifically.

Sashiko pointed out (High finding) that the "crafts a malformed packet"
behavior is in the shared helper. So I moved the fix back into the
helper for v5.

The routing header limitation I mentioned there (which was limited to the
mlx5 driver) is fixed by patch 8 in v5 ("net/mlx5e: psp: tso: replace only
the length in checksum seed")

-Todd
