Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795471295;
	b=352n4w8+B96AolaD5DJuyz+71ZaQUZYQIDA5qbKGHa3eCfaZQA64qTbZHgClEVob0jV1
	 pgfw0QhQFVswJfveeEYecE2wP3BsOSab+zdrC36PwfiVvglYCTzXuKYxkpu6eGNxCgTPZ
	 OH+ZiJOBl9U0bQ5tBh1RJM0NoPm/ctzqFfMMv+V4pqPGezEq9e9YQaMh2mbBtGoetpqi0
	 cihlMLpmIyh0Mpi/FgXoOnOmstpeNhs17ldp0JCD16mUwRlOzmcY1bDJi8aip2jTxnhuN
	 ybzkLmcy20Zi0H0iTP1G3WZrtA0Yoi6mNSmaLvX4TD3R2LiHTyUU3fzcI3xxVJbAkZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795471295;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=HXlZPN3cIE8dHERwMlz7eNxXWyTGYF+BUQZX4Ynl+DQ=;
	b=j9U2Qa83NsZyOSftRbGtOYmgPsl8xkawEvZogAQblb2spjXZq0ceRDJmkdQVzVONBNhl
	 2M8g8rtlWlAi0IVwKvHHTOHrrF/ig0/lw8chz19DL0ogLWDti8mPfQKfFKJXVPzgxVUj6
	 bMRRF85Mies3y8oUVqOQnchzWR8e+1O+/uhRO9ot0+057crT0LwNS96noXZDRUIIZ5jia
	 FS0HIIMpqkSdzpLO9vO1xxlfTpvaHjoSEUgvEZxiG/IPCHbIlqDEhaOuDh5SqxjwepCcT
	 Lw43T4sSAWRvpxH9JsSa3UbP9QpMMuGyT9xq/7Yu5p6eJtF2Rf+PhVK/JOvbpKNZNLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MsrTYuOJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A459606A337
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 22:01:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A459606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MsrTYuOJ
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwD7F249953
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:01:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=HXlZPN3cIE8
	dHERwMlz7eNxXWyTGYF+BUQZX4Ynl+DQ=; b=MsrTYuOJYQ2wytJCLzkEX65+iJt
	K6N23+oL6xEcDGJ6PnEdfU42/bHNwn1aZcR/d2lCBKBQ7Hjj5EWmqpCETDR9eQ1F
	hl3GntDVNxWEv7byptEAlCVTSzTGeKygL2vYEP366PP43s7n8Fa39izCDAto3Fdf
	iPIIXEISjxVunEbIg8Yn/yVRpvBRcQc+0u4ptdDH2EwkDaF/8mwK246FEvT6hxTu
	d7eYm0b6mO1LTl1Np0uBWTtI0HM68lYEvSlPCZsdeFOTuP8hsDqM+/qjp0qtqRo8
	DhjuNo74AJTvHSy2mYz/hx7xhE6DfnRTv2ksulgkxzIKCUsoYPC/EzZGhew==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j39v3cp7y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:01:33 -0800 (PST)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cde9044a96aso1077805a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:01:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795471293; cv=none;
        d=google.com; s=arc-20260327;
        b=Vlqvlj2Oafhv2yFzCqbYeVB+/KQKnV1fJMy2/Q8dXB1BgBy9jzpfO7p8Zmvc62wPaW
         /YYQYmRtorF3J7iaiOOnY6lV/Q+xUQ8OrQZZQfgwwRF5Gb9Q1R5ROimSew1b/A5VEBCN
         SwmDOdyPKLi68FT+oLOID8JLvBEgNQGz6MLvowf3YuNZKVs0IELDDgyHqGfJHxT0D5ry
         EHhivtrLdPDECQZb/a07Q0XZl3v2XDCk576aLo3UzwM575axuhYivr8lzuq1pO1glWdw
         qfCMWKgjq7tS8SCIiKPB8ciToP5lRYEsHk+p9Ipuix7dqaXVrzv4nm1QwdDAUBA91w5V
         /kxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=HXlZPN3cIE8dHERwMlz7eNxXWyTGYF+BUQZX4Ynl+DQ=;
        fh=Jyhjz3kHVZ8ZhiLdpZ/d3+oQqA5YRfZKv2MTi9aDrZo=;
        b=DTggh70FcMSXbCLmBPJOnH3p2LMftndPdxeEJqgVNkzD2MyS6wb4BxhEA/mqKK/0UC
         csrv2lMxBXRdRbzklsZPYJhPkK4gcyTRZaQek5EfjFBrtuE78PsgbjT/OuQEiJT+ZJZM
         jsDuTfENo+45mQ/Z+B2HTxS27S+3lV7C0JyaAcpVKi9t9Ab2H09vp8LK0o65Hk5LhuWh
         7UI4vWTT1JtD+CwWUHXrCqvgSBTbQPiXdi7l6FNVoLhQwJaJW/cInpRpbDZ3NN6MeXzL
         5NNHaESYQzUJ13JoSiBARgJoT8EVgVgj6lBnHVQVz1DLj1LGxufy/RE91J7ynKw2pLMH
         Dzeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795471293; x=1796076093;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HXlZPN3cIE8dHERwMlz7eNxXWyTGYF+BUQZX4Ynl+DQ=;
        b=O3nQRTeOHoGQaQwOKgI5EkFMYwDOFpniw6zD7znrFGoBRHmMgOe5Wl+ssa7iEEq5Ip
         ocLl4QBiTJB8a6cmHQFDQW0hb/b6Bzj9XnKfw39hca7uV/pghVl+srEMivG7UVnW9n1m
         7/mZLjpKk/wkfPqnj8le8OlSC9z5vcfKRIQLl+yD8GmCNF1FrUoWyNouBO2nJ06roYM+
         IPeue7HuKK3fI0/jBnsPQcbCQW7X/CRIdBqCFj11NF2bx8ennWk2JCF24RBVFOQK/GFN
         tI/gjU2/R4Z1qfFnVUgMCzMM47OJbjaGNO056pWpkfQPdUtlm7CCKMtACHJMpHejZYZv
         AUlA==
X-Forwarded-Encrypted: i=1; AL+hErH9epyrLvJXfVY0gSWihiAZWj7yBEdrgUPjjnLMHWLB8JBzRGGzBcyGpUKAtC4EJkAB5O6YzAOoHzVQ@vger.kernel.org
X-Gm-Message-State: APuU4Z/fqPGTp468NZZk+BfosqZqElWZF9btiJKB/BJQ10d5iCyTu2m9
	1V4YlOvjzaxo0DwJ/ZrzI8t6MfoTFaVaPETu5Eq+O2SPLm2pEnivAnKcn9XFPyfrB3yI3LI/7on
	ilURWweCloUnghJjRmvIXuwGGMXtVs2xHMuqMvIPvonxGIyUPg2t49Nfun4sNrmAFgLfcOPCAtI
	u2jrQ5rCGvRPll0jhaSFF0Uvc6abiBID/2gfcr
X-Gm-Gg: AZFdTZcRv+9axd5d1DyMuTzZJrSej3KgsjBYIEhTlKTIrpF0kovRTkdZkuj2ffUmUDf
	Vknvgzp0AzmaYvseTVHPP50vBOoY0Z5Y0T7CdR40BJR97T8dLVH5m+0n5ixxtdekIp32z88JURr
	cgnOS4P/i/Br8zarJdWqoz/WsnVqmdpJ9ZO3bqnX5lLNMhetcEZ8C5IvjuOM7pUOKDIvKJ+UKj7
	Du2q+f1zYBagw5jKUskDETaYNIeQXb9Lm3s6ObnZPMCM5evNlA=
X-Received: by 2002:a17:90a:e705:b0:3a5:147a:3b63 with SMTP id 98e67ed59e1d1-3b41c7e11bemr11000770a91.8.1795471292988;
        Mon, 23 Nov 2026 14:01:32 -0800 (PST)
X-Received: by 2002:a17:90a:e705:b0:3a5:147a:3b63 with SMTP id
 98e67ed59e1d1-3b41c7e11bemr11000723a91.8.1795471292482; Mon, 23 Nov 2026
 14:01:32 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117203137.804424-5-toddfreed@meta.com> <179529586053.3135.7106623626318776669@kernel.org>
In-Reply-To: <179529586053.3135.7106623626318776669@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 23 Nov 2026 14:01:19 -0800
X-Gm-Features: Aa3M54qKoeHizOx32dSF-QEKNJXmc6qKuSfI7qtOC8d-AkJeAsj6kZH5_ClB_hE
Message-ID: <CADh2yMxeyoDYgcp6WpF6F4hcLGvt+DxKTWLQQi7HrUo8fit8vg@mail.gmail.com>
Subject: Re: [PATCH net v6 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
        bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
        daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
        edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
        john.fastabend@gmail.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, mbloch@nvidia.com, pabeni@redhat.com,
        raeds@nvidia.com, rrameshbabu@nvidia.com, sd@queasysnail.net,
        saeedm@nvidia.com, shuah@kernel.org, horms@kernel.org,
        tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA4NyBTYWx0ZWRfX/Gwv0Tu6VDh7
 SU2Qtk71Ct3aiDj2tObRcK7GbbvWD/1YHC7scvkc6Z9Coo9GVvPnTHbIntlGFbG81z5ULxBNO1G
 kK4RHw4Q3Wiq3A5gbKon+2jtKZE0tsc=
X-Proofpoint-ORIG-GUID: CZXoh_qTwsIy6ozwxKQWr207i6Ydz__k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA4NyBTYWx0ZWRfX6KdkeijViB8g
 xA1EP7xSGXpg1SFVZtTGHgHopNRxMwB46uYLYMrbqNG8TnrYmAlcQ5dqKA3ChtClKmfEgiY5dxg
 lL4lkXrZBlvCWsiFPCmFbstZg2DoXBPP01VFLMmKBK5zuIV220SNiaaRjNv+8FbrEY/B3KlBsXo
 khLUWdX1hFscBQ00gnzPd01q6zZNPqh5rUF3NviBZlLYTI5WqfxI4Wg9d3wUVCUFs+kSWr2QZGN
 RWYCDmeYIsqnu+0Lo+QrNpZOpARPm4XQiZ5+vaUfGvwwY4Ju8troOj1Qbyv31FmNM7hCOP92YUc
 CDvaWiE/lThk64EjVDJlUnK96h62sgKzdMvXTaF/Lu6Ean4vlRCgFpmjffKPibap5dRamK+Aann
 3nmXHfp2++6Z6WM0J9YA0xF/ZLyVruQAkxtBNsYyYSsSndPPdDv9F+fJmxJHQFDGJm0TLR0ujZ2
 BBS/89a274uk/2eb3uw==
X-Proofpoint-GUID: CZXoh_qTwsIy6ozwxKQWr207i6Ydz__k
X-Authority-Analysis: v=2.4 cv=a+mlZkSF c=1 sm=1 tr=0 ts=6b04b7bd cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=vS69VSOLqzyyCQB8HVkA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

> [Severity: Medium]
> This check only covers ICMP errors sent through icmp_send(). Can a
> decrypted payload still be quoted in cleartext by the other IPv4
> unreachable builder?
>
> The commit message says:
>
>     nft reject in the netdev and bridge families builds its own
>     error (nf_reject_skb_v4_unreach()); a separate nf-next patch applies the
>     same rule there.
>
> This patch carries Fixes: 784abe24c903 and Cc: stable. A stable backport
> would then make an inet family reject of a decrypted packet send nothing.
> A netdev or bridge family reject of the same packet would still send
> plaintext.
>
> Should the netfilter builders be fixed in this same series, or through
> nf/net with the same Fixes: and Cc: stable tags, rather than nf-next?

The nf-next series in question,

https://lore.kernel.org/netfilter-devel/20261111003111.3826942-1-toddfreed@meta.com

 1/2 netfilter: bridge: don't refragment decrypted skbs" (dd5e0f8aebca)
 2/2 netfilter: reject: don't reply to decrypted skbs" (01538dbd6b9b)

patch 2/2 reproduces on net/main. I believe the precedent then would be
to send it to nf (not nf-next).

patch 1/2 does not reproduce on net/main. And it no longer reproduces with
the net-next series, "psp: introduce socket-less psp associations". I will drop
that one.

-Todd
