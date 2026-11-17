Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794947561;
	b=uHor1qT5XpvQd33cXfIHosERgYEtroT4MzsmhIaT6SSrOeCaA1sjBX3eB/o8PMXR1wB/
	 w46rH10NofjVkzviEbucNsLRKIYBtrq4eH9jrzcrEoDPBMItEb8bhfRzvrJ6SW9cyzj+l
	 IFdaQGIYPvVbyrbQZrZIkPZ5J9uddsXjRYvk0eWrOkazptjU+rDN9OtYguqLcDxG3yAbH
	 0jEZIFL5l+21FsLb7edwokOg3BxtgDzofKMx8BsT7+7gyz3O3Sv7gsoTCHpNbAIICXmzk
	 MtBk3w9ykcbnPMpbelFj39zUu36/GrTkw1nQep/IDJo/gwsO429ZGp7gqhDPyh6GbiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794947561;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=0kZrkgBlVJ6Br1d2+SootkU27cD8cvHld5OQI8t8s/o=;
	b=TAha8ZLu9SiRHPa4bA9gqonxICzhnqZPz+ZdJk0zz8jt3T0M4ptArUF5BumjoWW83A7u
	 tJ3ZzkARpIKQIiGgbUz4URtrg1B5SDzS9o1ziLCrPyI4tLMHyNxbqyE5YBluqOaCCkTfe
	 c2OcixQ6EzVfdyJf5GSG0RKuYTE0zkWUPhG7X5G56aTMYvBouzXjnlY9RNXOsVm/Cb7fJ
	 coQCTPGMYNULW1rlr2lE8+QQJ4NTVMvHgM6fy9RgmdB+FVoaO8KOgvngsPCO9ir8pXovV
	 9jfdY0GC0Rvdg1XZZcOKjQcrKmgQku1AP+a4G5Qp8hLPq+jpS3fgqAlbn/Q5P6+U0cw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="S/cJHIGQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C65606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 20:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C65606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=S/cJHIGQ
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHJ9Vql2418839
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 12:32:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=0kZrkgBlVJ6
	Br1d2+SootkU27cD8cvHld5OQI8t8s/o=; b=S/cJHIGQUWCeVVmYPfyE/H3OXIr
	C+FScFtToC7kEonJ53c6uQzVRAxI+YJlYPGEYds54+MNSr4IEMD0mKcHYDxXAdrE
	SEPPGDvtNUrayxoC4QQ0HERmpoGw2nbQFj8i0wXIDSkLcC48lml+1DUk+GS04s17
	aKXAK1VVdtpBWIznDhE39mOnzZWejBo7iGvPAusT2us4vlKH6wzzDmgv16k1WOBq
	7BA6KrN4q5VJd3ggyZYAvNrpidhK0IacxKYfeeBTXagj9wn8nUmbKXCRAx8g5+bB
	DxboWdy/0RNdniQY/cO3+s4SsWdcJ2VbpTOWc2QySNjCDjuPU8XHOnM93MQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hycj016pq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 12:32:29 -0800 (PST)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8b6463f95a4so153543b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 12:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794947470; cv=none;
        d=google.com; s=arc-20260327;
        b=Tmlu3N5Sz3xzkx59yJ7NBnB0wamnlWKNn5mbXe/zg8l4WoDwYd5R8KIMyCNYhJGYmU
         FbLP1ibd62R6VRVfxIxgyWlPYOhGHG99L6stDWplx5XRiw6dvUL0jNNAwnTR2NIUQIYM
         BLOAZD86TqfIKfDLkjkB1zn6yWPAy8Zv6IjiAenfu0bGMTnHAzVnsBXpgiwePA/AEw+r
         x/wIiCKg+VLZNhEPr+cgLvZ8GmwUAntgDqxb9uknJgH+FdZrWdB7H7oSO9aZHy2LHP2q
         5OWoYnGYd9dYPlYCAqVO4Nqxku6yDnkPPzItSrjFReWUFSu4Q+Kv/e9XTW+mFhHcfffG
         tKMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=0kZrkgBlVJ6Br1d2+SootkU27cD8cvHld5OQI8t8s/o=;
        fh=ApyG9TujxMTdsvFL8b51g56joxGsvlkZIfVJWyBqvDA=;
        b=K5x0T/RZMfZC5PWkT+Lh6FT9W48oIRk2o4emrU1j+eXSYxdtNaj59epQCgTYOhjzpD
         G+jg6yAG6jHFkyXwaS3DasX+15ixsnKRjXZO6SxmQNUYCmPAhcyFusuEmBjb7daTi+0K
         Z/6bKJALjlF41JO65gPtKas/Rn5XeSCseRlb1uPec8NpoiDD6QGFa0oEwB4RCWo+jRuo
         H1ANnvb7SHL1junXWaYzeF+Scx2gcTtKOIY9lg9LQSTKleentaRGf/xArQHmqdAomkqk
         ZZ5YzQvP3uCBovSX/OhIiwpLy5QtoKz5ebK8qTYFDOgFlDtT+CKlHHPlzc7+dVXttmwl
         04ZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794947470; x=1795552270;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0kZrkgBlVJ6Br1d2+SootkU27cD8cvHld5OQI8t8s/o=;
        b=iL5bPJ03TLZuCUrSxGrzZtYWVwKF25ayjoavZiP5uhoLL1tuqHEU3Abs21WRhsih74
         yauyb372V9AnxoUJx1OqU0bqHsMRNEdPwAIQnk8qLJdXSEMWMJeq/WsQwRkXg95h3bqt
         vw9JWlh/Ey/F/n5APUovHwxx0d6J9LOWemxgjjgW7ih1nYm2n9diTweVSOuBoyD5UfJU
         bHGZ7lG8Tev916TCBq7AcbkXOVU61KI4PoA+uXbC3cp5eop9WAnc2UF1H7XdFV2tu/Ls
         dCn/h7IXK47B9O75nhZmYRT3nVxmpzrjsQIgxLCOhXuoWjQANRVzizTeiD/ZqVOb3NYM
         WpiA==
X-Forwarded-Encrypted: i=1; AL+hErEZlMmrkYIgSN1q1J2RitRaXpUTGLarq3k7uDFNipNoydKX94prxQ//T1PKQvj4szsePQoubkmJIErE@vger.kernel.org
X-Gm-Message-State: APuU4Z+k4aerdX9qbpkFwv3t0hrxpjFnlBh7zjBZsuBP6bE2++sTVd/o
	OISDMoEbB/d8xPWoNLTE4n+bN8jUH149fBkhm4knf7FTyH45Ce5q72XU4Gpf68un/GikZxmiYt7
	E0p5Y8n1rGSshvNQc90PTbKmCISQMuWkiKIxvoOsDohIkNautEpFhExBDH5FzZC7zUG+WObjjd+
	JKtDPT1z/ZE2sShlWXLPssJZAp8PxwYEDFFuCe
X-Gm-Gg: AYBFou1TF59yJaDIZKH2/bZo3rrCV8GL8AnIUVEyCasSsIWCcVWCpU38lL9i9bSjRyc
	f0geqCbhUPS3dzRMMvMQfEtTJ4taxhG+tcplrj++JLndXJ5qNiM49IhfUHRuON2WuT0Q6uzzgmR
	qynq8WV6Kq35wxpgso9ViFe4ZwKMzXDudvffikWZc2LY4qTf1UIa60Ol4VGp2KIa+nnOUUZyYC4
	SJStRFTyY4g2YUMNlivhHoDr8xslrBCIdHNtbq1Eipkk6zkRRY=
X-Received: by 2002:a05:6a20:5491:b0:3f9:bcb9:30dc with SMTP id adf61e73a8af0-3fe976e2e5amr393690637.38.1794947470129;
        Tue, 17 Nov 2026 12:31:10 -0800 (PST)
X-Received: by 2002:a05:6a20:5491:b0:3f9:bcb9:30dc with SMTP id
 adf61e73a8af0-3fe976e2e5amr393672637.38.1794947469714; Tue, 17 Nov 2026
 12:31:09 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111001831.3710881-6-toddfreed@meta.com> <179472727319.2199510.15887061947101112689@kernel.org>
In-Reply-To: <179472727319.2199510.15887061947101112689@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 12:30:58 -0800
X-Gm-Features: AclHuK8h__y1ykH_oWn3mQ1fV3WrPBL6thnn5AjT_UEvICUWUOHi7PKgkI-L6EY
Message-ID: <CADh2yMyYxVE70K1BnbqzDB5h+7vDBzpL7r-yxnhq=7Wgb4480g@mail.gmail.com>
Subject: Re: [PATCH net v5 5/8] ipv6: icmpv6: don't quote decrypted payload in
 icmpv6 errors
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
        tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfXydezHEx6qIiW
 7WfzpDpVOdO7KVRAa1bdDC7WdvPRnyEHkK4NM+XRrs9ZdVqRIpfPJNp2fjgpePh/iUFFQcYKc3p
 PWe7yFD3O/3pFQ7J0aEEJ4QaU2h7ufdWDw2peJ+WO1Rwud9ItuoSkkG3iHKUiLDuZMm04PUnQ6r
 6CxTfQCNg8DNDZpai8DPYeq+JrMkTGUElnOg0ebUI+40MiWCiwjsCKX1MzA4uI5W3WTLt0ZRYk9
 cY1N/l0rWCK3PX7P25ZysW/x1C840FXayS15k+LFWJqUGWXCMYzRVwViM4w2JgIIf1CRHwZS7MS
 m5htajb5qfDCoonF2X0ynJND4dR3QJf71c0pFAfUOrs8bDp7XrOagINIvCLfMH9zmUJ+oUdi2S4
 HteBbKAOdWn+mMowJxT6RNH2pfeAa0GOw+cqAu+nmib0/CUUEd1Hsck9I9UCr4ydynXvj+nqULn
 JSy940+I7UsrMPQC9Uw==
X-Proofpoint-GUID: gikInzsXOrlBfLKITmk9VqoGlGLi2lHc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4MSBTYWx0ZWRfX6O9QEBa5cbhS
 LYgWzxyxA+lENkXxGMVNMPL3Bbe1uuPkFmAJHR1jOr/w/lPUvfHR9nbJ4E+VR4R1Ki1B21DULpK
 m65h8Hi4YqC34mjsephNb+pSr/nxSc0=
X-Authority-Analysis: v=2.4 cv=Q5NHcI2a c=1 sm=1 tr=0 ts=6afcb9e0 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=Ve4a7iEx9DEsMjZA-ZQA:9 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: gikInzsXOrlBfLKITmk9VqoGlGLi2lHc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> [Severity: High]
> Does this cover every ICMPv6 error builder that quotes the invoking packet?
>
> nf_reject_skb_v6_unreach() in net/ipv6/netfilter/nf_reject_ipv6.c builds
> its own Destination Unreachable and never goes through icmp6_send():

This path is covered by the nf-next series "netfilter: don't send decrypted skbs
in clear text".

-Todd
