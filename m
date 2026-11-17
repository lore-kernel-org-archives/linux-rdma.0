Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794954198;
	b=QERN2I2jedJ8sI6rJclGHQm0HgmUyF3Oh0DbrqHeZfTV5F9sK2KFVHI8Od82BNUNAb1X
	 E+LPK06xeEns/8JazBXJlefvPh2eHtIenloXRLuasJvFrzWozG0aFLVEDyz4cNvmskjAA
	 YrCpa82eG9h128SfKd4FLStMKWg12/SXMF3ILIQlU+vNK/EjI+alFkj6PpCZXRY8cahXd
	 buJ5KlTa/lTy/cSObB1Y1IYnAIKwVv30ZpuQnKVdtDVD2X75rBKYTeJdy6vI/w+pPPLpz
	 c0sqOzoYF9NkvuA9Yn9ZWiL7ix6kANgBEaaPSxNhmcI0WcpEpjl0d5MBsxaefbZR5Dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954198;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=3q13oIFHchXPM6DaArLZ3eJnxMU1PA66WCABp41gm7Y=;
	b=tuvBDTHiGRJ+djv5z967j5/g4Mdi83Xhh72qBnQdCIKPP3cxdPJPfvgX29Kb25s99Ahd
	 9sCNjodVuChKWlKeXNAAETEVxG461cn8CZ3gfCg0e+zQD+Os46cVmaxDuCFtrNqRIsbds
	 24iddYCVEhMetoCRMQtaxdP12dWjW/QdE6bK3p++A1ffkugkde1wNWoaatYOnPGnGG/tt
	 LbiuLRP9JkPfcS0b70afTJcwXGd/FNEaimQcyFAJDzWvUF0CA2qpiUwOixWYdcAIPCj+Z
	 11qkp4lekrzzAVqBbPzDkAf6j9Zb8k5qwc/j2DJc1IrqzVjVn/UDW5ecyrg3987Qomw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PUEFdh7q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8EA606A330
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E8EA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=PUEFdh7q
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHM2Kmq1450340
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:23:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=3q13oIFHchX
	PM6DaArLZ3eJnxMU1PA66WCABp41gm7Y=; b=PUEFdh7q5L2JYPw6JJBaFQxI/Q4
	sFzmHEq56Q7i7DCKlM+eBGQXCRALo2QecCYubDNvHctGTlp0t29rtrCt/ksnr/5v
	MYsaGrCwNt7LmrjIEzawBTBesaGCkpwbxnW9OMdlOtzRsR6B65xN5wcA1TYjTeNv
	lvp1H9CHHcxFrUxTA8y6bT/iQO3GLfcR6TTrPZOk+QAmiPz69IHcxbJ8rSYZuY14
	yvPAyZQf2z+g+EmeMCYhDgdvotkNIEvRlGd7J+d0+0Ok95giN7Lrl4QsrNYzci+E
	Ay8F4cJoZUYPPDUYjGUVg+o/we6jxKs1DNWxx2BDTD8p/yy0EZinKo8C18A==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0wd1srm1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:23:17 -0800 (PST)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eddadcce7cso1362965ad.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:23:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794954197; cv=none;
        d=google.com; s=arc-20260327;
        b=B12jPyU5j3xACj0Y4gSN9dzKJ5M/oc4fAi4/a7wpnLjHkQNoDbUMmi3o2zVcVeGCsN
         gzSsEp4Mt6l0Mg1umaDJJgKdxAgXotvG4czz/8FgggibztEOTxUML8X1PTWN9zZotCs1
         Uo/AZw9irIh5aIQC8w7hAEVyYO/az+IVLzCgGQIc/+ZY4FoYFgu+c+wTQYBUIhgbV5n0
         5iQ9Y6ea1++gfEw5dJFj60yu51t5HZ/PJoQj06HHJU17KOQmP0IhWOyA+KVzfFmsL3xS
         Irvd6gY5D4xu5AuJVhvp2PJCIQdbuZr5F2R+kC9yUtQUaGP6oDQXMStx6SGDuHH+BnKe
         Ry9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=3q13oIFHchXPM6DaArLZ3eJnxMU1PA66WCABp41gm7Y=;
        fh=oSavub1QTgG7RjpfxhvDYH++gWI77mbKihcptFkrGvM=;
        b=k/7LFiVe0f5gChXIb+k57GDg3jbB9tMW2eFAb3jz3ldeLFxZ6CucMGvNPrPUnx2foF
         5fx70OXxjRlOo5WaaQe9E5tJguEuX/8Xq655s9gZx4iJpsuDxtJUUDjC1igFBVRRQ6da
         +9+ULTf9HVDp9jcIDU0zWvoMPKr3ubqzX6OJ/cSHxLUilkW3e8vK838umEMrukoaCYtu
         mwXFDdUZRRhdqAAXIPjztDZI5w6aSKs9C04I7Fds3OJBAosev2Zud3HGCW9eI1TSmQGa
         MdJmkubzmFVfEfFLkIhjkbFAv98rHFWh7TQH/PiXYrgdHK29dGwdMldajhH56POw538Y
         6y0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794954197; x=1795558997;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3q13oIFHchXPM6DaArLZ3eJnxMU1PA66WCABp41gm7Y=;
        b=AIhR+X6BuJ24QTrwDCfBMTzH9TXRKtcfRnAdpgzGCqJh3hj2i/iCpxEHNgXBbxcMm7
         e24j5XRrLLRFF01RAuMVDbxQUxgAwcsafQs3DTiE0hmTPTMND2tBH+EcThn1n49qrVil
         uzf5XjyhB9u9qOKiSlyy5VCPmF76w2P4/m4AY87nsbP+X1R20+OCs3i2wlJc5buhqKVp
         xGVcsZXuikYoVvRcTpgiMOH3uMuKzumrKdPDJ4PQyZWcExttnlCy7fi2ZPBiD+4JqHAO
         DzksI+cjV8Hh6Oh/zKEZKP9XjETyAmlC0WMxEE/EqkWefUByG9p5beGRmOtiGnKZLv7U
         oxKQ==
X-Forwarded-Encrypted: i=1; AL+hErGhEyVI4ZfYvGg+SIQOdjslMGV5ZVdD2ulUKmpkWWkWqegT7hdiIfRMmPPlYGawIf8WLeOiuw1lOlH7@vger.kernel.org
X-Gm-Message-State: APuU4Z+GF51yfLA6/dl5ts+lZrr4ifsQRofgRDQ2zLJmYXZOVl1EI3BT
	ZcFkGS96vUpw69yRU2woj2tGQMC2h8UMo4FAojAh1wHg87RP2xKSPkXFhuY1/WatSfc6eKaI6II
	Vs6U5planDJGbT1fjB0Cc8nT8JtcmVC6uI7dx1TGSdJkU1Symi0nYgDT8jygqkwRdBFmCRjZxwW
	6lxPPGRpVjTeRRyjNj0OdVSXUpHRiw5KV6bcdU
X-Gm-Gg: AZFdTZekj3MOP4Bi4M4ZirdL8EHCXmsaycjto/csDwZocWP4TqGz8PLQNULfBoKKPPt
	M5E8etBIyhJwGHyPlkruxJMeJXxUMWioQm0daQcXFMGb43W/Dpna3K4VA/KoDLOwbVw6xosmFFa
	wxcNdjScG+RplSQ5JxMMDPOPOESqyU531rteVmh8FY1VihiUNkDzz8B8pxMkk0QRuyzPRZ0ZOW2
	QLZJfaUu8GA+KB2Z8J/UdfNLPbpP+WS3oSi4IKWLKo8B+qRb2w=
X-Received: by 2002:a17:90b:2fc8:b0:3b3:c3b9:7de6 with SMTP id 98e67ed59e1d1-3b3d07a212dmr668825a91.13.1794954196811;
        Tue, 17 Nov 2026 14:23:16 -0800 (PST)
X-Received: by 2002:a17:90b:2fc8:b0:3b3:c3b9:7de6 with SMTP id
 98e67ed59e1d1-3b3d07a212dmr668796a91.13.1794954196341; Tue, 17 Nov 2026
 14:23:16 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-6-toddfreed@meta.com> <179471269695.2199510.18062590833471363525@kernel.org>
In-Reply-To: <179471269695.2199510.18062590833471363525@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:23:05 -0800
X-Gm-Features: AclHuK_fZNKIqR9h7_djkUI-3BJ-ndjBhRGAOYb0D1EyikjXTaP2ikjH-ZrZrT8
Message-ID: <CADh2yMzkbDDFt00Bnd50HPFJf9-HcKHA8BpfOikBUPHjmdZaAQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 05/15] net: add METADATA_PSP dst to carry a
 psp association on an skb
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
X-Proofpoint-GUID: -qGYYalAApDBt48J8Ut8LDIMt8jV_Yk9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX4G4q3uU9DK+6
 xDt8avhFyaabPy2Q8d4k1chYJkgm0lwl8j3nibDHW98wbud0KzL+XaPLtkRNRcmr/8mYdd5Evbk
 8bVncc1sNO7rnJaLGVUK+ulLhDe3UMU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX/71AP04okH4b
 hgep45R2nKAhDbFRlNvXClZFkwW0qqH1DUkt8WOmunHNDfrPw4+8p/mOI0+N61NE1tOAQt0Uh6K
 CRwuK7QF+4+AqDdjaaNxdq/00oNnLkxNgbaF/ZepTMSyD78PKr717KPRs76rWuSynzHQ8zSTHY7
 8gi0xoemuu7twHUqXbvJJWfuAL/u0Bn5+DM8L0/XPZqphgAlHN9WS8aq6+QWnLFElG4ZnF8v1z8
 RL25V6ski3lSdsB1HiyyzjhYBOp//G+83aC5pkYiOptsoFtA8JuLRdXZNuT8uLlrngEHQxG4Sxg
 ra7PoD77lSo525W8NEQNXzkGtwksnUAd0H/P2vy5CDOrBs3wFN3hrcyCwYqKk5P+GDjQCVdJNj/
 bo9f4ahLPYWuVYyyTT1+MEDBMVOLqRzafyDSrCk3txQaE3uMCr0aIksWaWt1URPVVQA+xpjPdC7
 ciTemX8UdXLm8140frg==
X-Proofpoint-ORIG-GUID: -qGYYalAApDBt48J8Ut8LDIMt8jV_Yk9
X-Authority-Analysis: v=2.4 cv=LZ6peTfi c=1 sm=1 tr=0 ts=6afcd3d5 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=27JUocoGZ6S1wOk3j1gA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> [Severity: Medium]
>
> The commit message says this re-check handles the case where "the psp
> device may have been unregistered while the packet was queued, and its
> keys deleted". Does that still hold for skbs that get requeued?
>
> ...
>
> Can this hand the NIC the id of a DEK that has already been destroyed, and
> that may have been reused for another association? psp_xmit_md() would
> catch the psd mismatch, but it never runs again for this skb.
>
> ...
>
> The socket path through psp_validate_xmit() was already exposed in the same
> way before this patch. The new METADATA_PSP path, however, depends on this
> re-check to handle the unregister case.

This is true, the checks do not handle skbs that get requeued.

As noted, packets of a psp socket have the same gap today with
psp_validate_xmit().
I'll send a separate Fix to net that covers both. v2 will narrow the
commit message
and mention this gap explicitly.

-Todd
