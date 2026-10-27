Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793119855;
	b=zm9+kfbmuTBTsjSk5SCAa/1WPcQmINs/4GMGVu2f+jMPLTsHAXX+C23AcRNHxKotQGNL
	 +M1OAuLBU4G7BPqq9KCaS6MYq4B3czfhXqIcxlej5NZIwSC66wO8epSRjq44nB9BVFIJG
	 SfW6cmFjJsVMy2mjiiukob5WiJWlxOX1ew5WykYlGHlL8SaA8n+Z0dQeo2Lq2fHl0Y5Iy
	 DfG0W7WFX7f920FsEIOGozDBBwQoGKgvtGG+XRLTtxRGdK4zyT20BUpwYfPAPkXsR2Aiz
	 sztlEDMrUnFSR/72VifyiielHR/c2N0LcLhcoA+YyKouCRE1286roYiinmrMtvGvRWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119855;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=TNVT5SIENBUHIp7NEAsmxJXryvr6yV5ijHD5gywhn5Q=;
	b=oFnxBkx92Zj1tvPSWWCixuEVotBkA0P1f7puZ87poNF4fJdTyt5gOtpkDFye0NAVDLQ4
	 5JxXLTU72/TtmkgX2EpiRUtcL/clp8JrXX3W4ss7lb0eRX4mzsKmgFFRRNoVD9jXrvyvW
	 k6glEba8lZmu+79cNobKKkUKYi21ugRpOUA+ex59ds4T8zO31C1dII4IthTBkGyA/WMrc
	 UuUH0rWNG/rwHDNr9siROBW7Y/tgtQ62VFLNxg/n49fwvowdJmorKiMtTIuhKGk+Tivn+
	 ywDSJpOdJQvbhJVI85aglY+dZb8qkq8NahwPR+5QJ1srxmcB5Oosx3uz2Gme+6s2B6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=CvGazHpM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BC2606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 16:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0BC2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=CvGazHpM
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69RDn2Ed957226
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:50:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=TNVT5SIENBU
	HIp7NEAsmxJXryvr6yV5ijHD5gywhn5Q=; b=CvGazHpM7r6oRX3bfZbviQcSr1N
	4E0Myd1oOxoHpURR8O3ygO/Dpk/n1BaOz19buAwlnVLr0933AuaeEvpDCFHFgYz6
	abeMKNuKfzjQowKx+jhyOIDNoHJxkAcx98V9472nirEz5YyvT0sbM7FfdvAjRys0
	myg9dJmXQEXflfKncql+ipZFqVziwE147BeO3Mf+MZRkZ85jYo0DUmrHYwzFSUTJ
	fuky37CemmmW6A5xNs+7SuYVHono0IQjLn09R2nqGqXdEjB/jtzeZIdsxjt0ZtxA
	1donqVG410NYAK6Gju6/OsKk5vwG5hhXUeThTDdEFiP5RIa1aM+2sYN+e0Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hjstu2sfc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:50:53 -0700 (PDT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e93e2f72bfso70567795ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 09:50:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793119853; cv=none;
        d=google.com; s=arc-20260327;
        b=e49qI/lAPtHsR4eX+VvI30BHvOiu4LbZc1P2p9vRiqZSG24jo2UMIYBCc+DMaFYBri
         8oLIcAvXYYomQW2qwlY+fIBK9JTfnv/uG4hUUrW4C5H4VrZi3ohI7gOl/keS/1gunp25
         Rv2Eds3heBNI8o3ysHtOqwQjfkRCnafkdUNTb+F692CoYzbswTUq3g0ssx/zZMhuOaZC
         Dk3eu4OcI/nMRq0h5uEZLoAEI68qgmPFd40dU5FFlZaNvW239EZ/PvcMa6PfqvIpDl/u
         lk3hEgwriSkhBFHS9NctJe17Yl1GCUYvHs7J5motCP3TqU1dQ4SEJfwWPo8peGmvsAUd
         RANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=TNVT5SIENBUHIp7NEAsmxJXryvr6yV5ijHD5gywhn5Q=;
        fh=8zQYEH/DQkaf8KtFtmftO7wKCFKEdsNZmzpHhBsB8U8=;
        b=JWrNCCABAdhKvwwvECsLfAJlfBAKl7QjIjTxyr+9DuYErnS4Y8hsOvg/CmVZohSKKh
         q5QF3KHJKqJlb4zkoeTsMm/vG2KYengOpk/dedz30W4pHDsrTB/AEc+IW0BlfBy2+3wo
         O936/6FE1BSD4S7BbUECxwwJCmfFceBtqDM+qW7S2exk2hIhyF5n4o+jwM0+BpbRt4IU
         mJSIplH0mQoCwcDe5TjT4H1BqRIIkpuHD9EV/hkmBpOxXjbk3CBjvPJG22JlKoKaefFN
         f8hyGZzBGvq+IJo3A5Lu6xPoYL2A6qbQJtSSe/9pnyQd/qa4aNQnMgE8BtmKd83dyy0R
         UNLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119853; x=1793724653;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TNVT5SIENBUHIp7NEAsmxJXryvr6yV5ijHD5gywhn5Q=;
        b=AG8w/pqcQ7eU8EA1FqIYBWF5mdTQ/y1ZIYwmX/SolbGVPmR/rQVJX1GhKI/Bm3/DfG
         nQjZx+pCEmGpH3y2VHxxNcb81HepvJwsDoYA1I5a180NQ+RbnhjRaoGCnVoCu0HPC3kd
         YzWxnXluFG89VhtlRqopZW8Frn9qFX4rga1TJg3G6KL6Jk9mAEaRt6O4aVB6HkZJ/Ip+
         Q1Cnx1zZ5u6zl+hZ/ceZkLjr9O6ZN608GvgNHRHBC+eCR0xZ8FPYJ1lC+f5OiEuWQeW9
         PFLwVCEnQ1kUyV2TNa1XAce9n+hPXWSsIdY2nb+QOq3Ro35SmMoEhaybrcnCnElZkGrT
         S6Ww==
X-Forwarded-Encrypted: i=1; AKwUvBy4AhXUeVAlzZY2pzRudcq0F3P9pmNOeH/dWmo9FrJ8bEkTSgy0woLdQibXfRbsSSd4jP7mdCx+pIqb@vger.kernel.org
X-Gm-Message-State: AFq9FYKElFuggNj38rVNtjjXkOwpvz0/DuisWOr41o1727zxDrqrR/ZS
	bB/mZTlpPZ7wg2kXPS6BijuM6oS/SZFEFjwO1a23cP2Ed6tzvbHDr/ODTPAYszvtYQo8aCGrGf5
	a2bfei9AyjUqAcRuyMnbDOp9ZQ4MaMZ3sx1t2rDKM7+pbYsz5dL4T1TyyrzXCe9EGqGAjPnv9pz
	lP4Odp/EXljYYLeSPq/PiGu9rKVwDE2+Btsajp
X-Gm-Gg: AYBFou3WllWqgkEJC6AlM78lq70hP733MffZCiX/9k0YcZDTGTb6vrLkss30pPa+ncm
	XyubwJt4WKxMxeMNTZPlFCn2OxsCom3hfaaj8Vkp8cLG9jTuEHvE0wH4L68E0n9aDGukwwVE7W9
	SE1eCJLPvT8SXTqADb9ArP/4pyMvFdsXHT2V81Suj7Hh0xsCAZa3AAR5cnHT3Oxlakq7vxMUAFo
	UGYmMrDVj1eb7BrD++/lv5+VRL6OgAA
X-Received: by 2002:a17:903:2c0e:b0:2e2:c995:b00a with SMTP id d9443c01a7336-2ea9c83f0acmr97399145ad.48.1793119852772;
        Tue, 27 Oct 2026 09:50:52 -0700 (PDT)
X-Received: by 2002:a17:903:2c0e:b0:2e2:c995:b00a with SMTP id
 d9443c01a7336-2ea9c83f0acmr97398875ad.48.1793119852321; Tue, 27 Oct 2026
 09:50:52 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023234640.1459291-3-toddfreed@meta.com> <179288570143.3134.8925369868949382653@kernel.org>
 <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com> <DMFQ63T8HLVV.3L1SY71TO7GHU@gmail.com>
In-Reply-To: <DMFQ63T8HLVV.3L1SY71TO7GHU@gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 27 Oct 2026 09:50:41 -0700
X-Gm-Features: AclHuK-jcpXRH06paBbeGResR_5OkEC2X2pBFWTmfK1GHPn1XqyQ0qM4p7DKnUE
Message-ID: <CADh2yMyGdz8XR263w9PbMf+pM1MvNh015CUX69NdYCMfjFnv1Q@mail.gmail.com>
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
        mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
        cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6ae0d66d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=YJpWPkmKExx_aQuJnOoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0LkTYXfoW3dV4msqyLn0iECoEt7PtlH1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA2NiBTYWx0ZWRfX27XjiQ1ZS9BQ
 tsJfzoTA8ol1GDQdmILYN47LPKjCV5fdrkq0VLDgO17OMHgjNZmkW0ktA5NwceeLV1tUVDgdIei
 2lXiospwSAgEK69sc8WNlUR5/x65jFfAJtwlYB0GI3Q6uRQ/rZTNqidCDc7On5bzLHYLtqAL6Bj
 u6RudAqFi15w219F0EK4BtuT4DhYZe370LWUrusxPk+m4kUBCdP/QJCz1w2aryJ1l8qc2eMyx0p
 tDgn3bibALV4RmkQdRG9cyXbzHlYor0bpGsd43StRENuKkItqEE16+yIfBr5UK1PeXA+UejAvmT
 0EIFCJTOeIHYP2KkchpOD3SEpBljW7N9I4XDyHnKT5ELoGRAtzYmmokGHdXI2c9qIa8hNsuAhNo
 t+iRpKbphegfReWaL8/Osxft7mqKnPMC7ItOgRrVIprdBNs4Rvuccd69iEnuKVQqUk0giXDet7x
 mZu/r2mRB5QueaFos0A==
X-Proofpoint-ORIG-GUID: 0LkTYXfoW3dV4msqyLn0iECoEt7PtlH1
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA2NiBTYWx0ZWRfX9lJ4mJC+xuK2
 Y2G6lLCn88OJ/Sju9LDnpTLQcuFb+MhMGcVg+Eywzn7vsuKwQyDpJW2Wfa1Jd4Lg+W66vNqF0oB
 W80zc852aQZwJhP3tkGtRjY/5zDPRNw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_03,2026-10-21_02,2025-10-01_01

> >> Before this patch, all of these packets were dropped at the is_udp check.
> >> Forwarding the decrypted skb itself looks blocked by
> >> sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
> >> dropping"). That leaves the ICMP error path as the open channel.
> >
> > Agree with this finding.
> >
> > Ok, this puts me back in mind of the approach in v0 of this series ; just drop
> > packets with extension headers. Actual support for extension headers can be
> > done separately from this fix.
> >
> > pw-bot: cr
> >
> > -Todd
>
> Like Jakub points out, this equally could affect tls offload. We need to
> be careful with any features that can result in device-decrypted data
> being sent back onto the network. Another gap that exists currently is
> xdp tx or redirect. That would also affect both PSP and TLS offload. I
> think we should try and make these features work with crypto offload,
> rather than building up more and more defensive checks.

Adding the skb->decrypted check on the ICMP path makes sense to me, as
a fix for this specific case. I am a little wary of fixing the known issues, and
missing some unknowns though.

-Todd
