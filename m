Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794954607;
	b=oDeHKF2XZHqxtXfqWxTXrOi5bDELOu6tU3oN00SBURORwnVTJm/7oYFqis42dVxlOLDM
	 /KE4LqMJ6/nICamIqnsESMrScY4bDttZanLy08b71XaYk2xpNJfqTAGDbQNVhXtExvHdK
	 qRqSNvMj7QG+IFr57gGvY7HQyZxvtJ95xIdrygW61uYfoIwbHzFvWoHCQn1F/NvwSGtDW
	 JjcoppOLcQAI7WseQq+c4AC7626wesSSlaN+J+kw7L17WgF6QiRHdgCb0FDq0HcpCVfWw
	 +75UB15NZrR1wexeCB+kRBNIRPzn6jZ62HsG2F6x8igyJeMm780HEwV6baLVwxG2Vnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954607;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=KyDWO0/aXgj9Rt69ltOENPsFV1jksEPL0QStiZFNoLw=;
	b=3PVGFDw8rfWkCv1VnmULgeQrFgMcYaCzLd7HwS/XCJFuVwyArHECkhAq6Fwt+y+uuGW+
	 g8clIbpqk36Gd/MoT8xOEnmy6P7GWBKRlGDh5CSdmwBttzt1Z2xctF07tVKFRCPxldDCE
	 ouu86U0ohxjhGwDfqwDJlCzU/wKhAj5/3oAOrBzf2EGB1CdMrJhryRHekT6vskq78xd9W
	 fBLQySnavT9OKFo2iVq/piVkxkCMZr2eaoIaFeFqgUktou90Vo6/++vjOiW2wmC/80FEi
	 ME8fxZdWS+sSuol27d2T4xUEQA+AiW3d6FTGADsT473I3PWl11WfdvYrMF6gpVWNFCw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bOfEnIBU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5580606A334
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5580606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bOfEnIBU
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHM20Rb1750235
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:30:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=KyDWO0/aXgj
	9Rt69ltOENPsFV1jksEPL0QStiZFNoLw=; b=bOfEnIBUXJ7bXz2NrfMubG5jwGR
	6jN9LTRddaVvweRF6J6poXO1rNj6AwMta2gKHOV3hwyI88N0Ig55OW1IcebZwrtv
	mc6yE82eh5XbzOd8B2PGTR28CGWx1oj9Ay/mzcEzSVSMkGfaG4LYgl+dpJWjuvvD
	V1ZmON0tX1Osf2Lm0wPDir0fCLzcZuRoYUsO1Iy4vMbA9POOA+6JH40mOWi3TCsm
	dRTW56gk4loflTT37NNmVrKcvR2hIuxQKe3hfu01wDEigH9osq5WP3LFJMTv0UCJ
	vUJBimgVSMDyiDFY/PodREJjfSxqnIOleJ/qCq82tGOD/cfLXNpVqmZmpEg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0rk6nfkr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:30:05 -0800 (PST)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdb8e8bccdeso157979a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:30:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794954604; cv=none;
        d=google.com; s=arc-20260327;
        b=TNZjwm2rNtkEJ7oVrZsNN1rrtykq4zCHq7+YsEtdC5nLNG29eHbbsHAHpbqZsQ3Ce7
         Y+cOZI2IkkV19G8N7rgG/x3E2Lf5DQS8dF/5XVbMOzUCg4/i+8y60qWhm7DVyeHrb9Dq
         gH/8BlKE7O/U72IEH+wh67OjDuZ16k6kSOnqvwxuuD51kAZnSyQBqrC2SbzVtN6JHpEo
         IhRcIt38SUX65cwpWeoolvgSsrzxsp6EwFz4yNmWJwYGHiL6vgdclODNfyWijhBZWtp5
         diODDGQj8egOg4Lq6TzI4DGvvEKuVpwXOgqsZ0wZhyLuskiFHWPIfZ0jS5nuQernKPF9
         ftBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=KyDWO0/aXgj9Rt69ltOENPsFV1jksEPL0QStiZFNoLw=;
        fh=DfDVD7QARqZAQXUZ97QL0OW4SWFC6eUJCntNHHBmdTY=;
        b=atYf9HZ8K3ptbqz9M1uLIcpteapS++mkXip7EbTnC35BMraAkDoEhNkSg1WVX4oy8x
         vm0xvjgk/OuoPR/lVjmKs8zGEQqLEnreWn8iwNu+3ImnIPzZAcZ2o6KUvIh2ZHTEEGgt
         Q8a5y+GcnuchTuQxY4KTkBDdg7/fCXUlINM07bW+148B4RwQW6C6tBEbtI2jgBTVe/R8
         bxA/8xnmzxBwQPl+/ksexgG61jMNhgIpgDxsyONzB8b3uRyBe5sRYgX6pfbpeoLnJNkE
         5T5WEEM9OkA81/3M6E3G6XKpG51jHE3nuImo4+97MtZwmVYIGMna8QH35lCWEoDToKWq
         CsCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794954604; x=1795559404;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KyDWO0/aXgj9Rt69ltOENPsFV1jksEPL0QStiZFNoLw=;
        b=RrkiRYWnWS35t3ncgUpzxuMhZc9ElNm7sK59eZTMeAN2gg09FwkzbMPHktIBYFqwdQ
         OucA1fRuMaLF6SfTfwVcuUQrRb+W5tr1EnDO49J9lChX5yGK30v45u96eiqbWwB/SmXv
         2cdrTE6KKonrj9xoEwY2HUvvZALsCdxwXCfpTWWFIlMMN03gn9EPvNy/I7SHpnQ9xC3u
         GRqrHne6qRl+bCEMDGE3wmDxqFdl8vmMKSsiQp/sJeOOqAvQ6mo1ZnrJzIdOfIYg52S2
         barW328NzeYByeZPvRy683oj0KQmOR+kSKEaatPRGMA1Rvw9S3G/c94V4fEZt5W03Ces
         gm3Q==
X-Forwarded-Encrypted: i=1; AL+hErGDAJ1KbY9qUDKb0Ur/YXgld8WDiEj3PQ+0h62zqNECG9oIsjeFjVHIsTuz6UlUcdN1X78a7EDeAEqc@vger.kernel.org
X-Gm-Message-State: APuU4Z/kucWgmahoE8YBu/lOGsNnvYzxreWsvQoutd6U0EtnqEKG533u
	BJO/xkPtxENW+fm6qRavtGmvB10cKffa53XeKUvyK7JBf3uCXYwnhK9r19i2zXRwIaFeNAkYNCO
	pKeqezY/HicGEzdkw1UryWD1M2OnSx+cGUZRlkCgNgwxZV60lyCrqfUepjBL4ywHa/5RkddgeUp
	DbyoEKjKRKpNrtow8YJmOiXV38D6p9J+Ag5UKB
X-Gm-Gg: AZFdTZeY75H6lXD5VKIxhxvd/i7PpvXDXEFeNweXNCTRJFy2pZZzwBuvoApG/+xQxuA
	vmsY0Tf7yZjx6CUWY/AzDX3aHlL/UxuSJQ61e4vmCdzffBX3Eh8sJCi7FyR8g0I/eQasg0YxQKK
	no33JWtGZF64rt3uC8r6iR+K0b7+VvcLfwzbUW9P73YNiI7sxuqGcOYLgeaHhgNi6+3GtridXgX
	Gav5VJX2WpQAkcHKuXqynlvB2c6z5GqwQWJiRPQ+FrTk82+81Y=
X-Received: by 2002:a17:90b:2fcc:b0:3b0:b64e:1e34 with SMTP id 98e67ed59e1d1-3b3d07d93eemr814948a91.51.1794954604503;
        Tue, 17 Nov 2026 14:30:04 -0800 (PST)
X-Received: by 2002:a17:90b:2fcc:b0:3b0:b64e:1e34 with SMTP id
 98e67ed59e1d1-3b3d07d93eemr814926a91.51.1794954604046; Tue, 17 Nov 2026
 14:30:04 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-8-toddfreed@meta.com> <179471270091.2199510.4320994626979041884@kernel.org>
In-Reply-To: <179471270091.2199510.4320994626979041884@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:29:53 -0800
X-Gm-Features: AclHuK8ozq1AL-AsYPXNzCLCrFAtXWz49sr600reWw55cTUb-tnGMH92_LvEb0k
Message-ID: <CADh2yMwoR3ZJUwCSbUuY85qPN=c-TKqb6BZeB87q=B24tTTaRw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from
 egress to ingress
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
X-Proofpoint-ORIG-GUID: vymqJ7wNy8maFbGedVsngZRJ38Y-q03m
X-Authority-Analysis: v=2.4 cv=Q7xHcI2a c=1 sm=1 tr=0 ts=6afcd56d cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=JnKecZnUtZousrUlYMGU:22
 a=DLdrzcY1xBZ9M_96H7gA:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: vymqJ7wNy8maFbGedVsngZRJ38Y-q03m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4OSBTYWx0ZWRfX6sEURjRyzwEj
 +WVS0TsUBUyZvxfYRivs7Rzm73YjiGJO9oLAtEBtm+57i/patGjnWGVDIkYL44OOrjGsypn7nEs
 zIQ9XM6VUyL72daSqLnvn8Uc/FUB/HRdgG/7edYpjWolSfyaTxffayQIdklnLyPWPofoYSQw1uD
 PVOQD7rRbRxkkVWuuTPY/kms/tTg+eBINhaYsBIn+ZrlO81I7UMf+AXn2jH0MMTq4GbEc1zR8h8
 uC6FGLAOhHQdHkXwCM6cMPaXvEYYgvgV3GCt0kpeIIyvNpiC6xCtKVj0wNHl+YoAXyZpks3S0Dy
 mmbq27+GeXwF5ceS5WS+zo/7dgp9ad1JORXnde9bXxGfEB2OCCcbVx4tYLJlLj1cm9L+47mWWwW
 rhMxmENItYIrOa/aUNlvMeRjWRHU7lRc3PjIajK7UsXe+h7+Pk2SHZ3jhGiEjMXOkuMlvTcQCjS
 1FPz2sQA4A9osQdGWLg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4OSBTYWx0ZWRfX2V+PrGjA1bBT
 sqL5EWFP/0xVmj+iKlJycNoJ0Q7DQryPzIfVWIaZtT5Ojb+0Kx+B27V1i5zYl4gzI0EtSCeuECb
 yFGREN5ggJoIvReQaVJGw0DvXCHfH4Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> [Severity: Medium]
> Is skb_at_tc_ingress() a reliable direction signal for every caller of
> __bpf_redirect()?
>
> tcf_mirred_act() only checks this inside a tc hook, where tc_at_ingress
> is always current. But __bpf_redirect() is also reached from LWT xmit
> programs. lwt_xmit_func_proto() gives those programs bpf_redirect() and
> bpf_clone_redirect(), and BPF_F_INGRESS is an accepted flag:
>
> ...
>
> Without a tc ingress hook on the host-side veth, the same packet and the
> same program get -EINVAL, and the packet is dropped.

Real finding.

This patch was re-posted as a Fix to net as patch2 in the series
"net: don't redirect decrypted skbs to ingress, psp time-wait validator".
This path is addressed there by calling tcx_set_ingress(false) in bpf_xmit().

-Todd
