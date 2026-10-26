Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793052628;
	b=NoGRSWj0h4pk++dG2UhjOYj/+OOX/Zr6XXl50gxPBmeXswbBF0Bq1oj665LoOdSDvFVO
	 c627Q8iowblZbW/R7ixmgk/QWEkiSBp34pPuTUbI7k4taE6e6u/XKGwtW8vl65BuPxQF2
	 ivY8dFZVA2VGtEGkCR6OQb+BWDV9cfdHb4yIBxewqrvcFA+4zbOwxr8e7a8/DqIkbFKNe
	 9Y3ZTrhQdC1AgUwFTH7HzUKd3HtYEyqftynsoOQ9UCML8BPWGUBME5GWEsbAhW+oc9q29
	 IP3MZwSgo/r2PoIcM86v4kV2Kn1h1CjMml//ZQnbfQIE8M9I96Hs07LpFcGoJ/ZOqBw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052628;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=Jf+loG0vAvnxt28Kqn9IrWU5X0/8DtmZggaMgC0lLF8=;
	b=167j7w3cHkaXjl5ONgRgzETdaXlZ+2InmP19OYe1Ba97a1T8YIxTOHTpGhXaZX7Jzjyi
	 k37Lt8KTPnfsi6KVYSqx/DnbUKi/TmAjWSmlEtW7jTOH+PDM/1FalQom80Mp77NFt0QnU
	 aUpKhPlYfrY8ta0CHF9AhqlJ2VggKYN8KT4k4cXAfJmWNb/37StzZbhh2lNUnPBbmc3ay
	 DYq7SwxVeaWn4oQZ4InXUWrjaB2gjww+nYaXkdxLYCZudpD1qKyZDFy6sUFiTJW3Vv1JB
	 fNL0miNcUV1gbOdQ83HtQQKz7OzoVySkPFXumTYqO53BAl5cjuvoePl7d3jJd/FHFJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=dZ9tR9L1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CAE606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 22:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47CAE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=dZ9tR9L1
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QIn0mR3656484
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:10:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=Jf+loG0vAvn
	xt28Kqn9IrWU5X0/8DtmZggaMgC0lLF8=; b=dZ9tR9L1/IcxcsH4mEsKPx0GW5e
	UTGvTAWR0q1qhi/B1g7OHS+XHoohqe5XI+h4y/PThlpFE9BsEbWgJiN7eBQlxbFk
	c+8mY+yz8bMouKprc8O3DjrQU3Akz4oTvZpi4r2DjPk2vqEtNi0gM420ieQ5TBGQ
	OLZnhdv/E4lSiGhyExxYkBHSxocmkny3xTMO6kroAjj09D91kBCL+7qodbBM+UfB
	Z/cMVDLbA4rw5O2SP6MupF/qOmMi4axMzQQM+aUiaVU2MBQB2wI3Po4/YvMr8hp2
	zb5Z2ASgUu/S8qEr+ZMjM3GYoWb0Wyrhh5iLDNjyCR15YzzgAKPjekwpR9Q==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hgr03p9pb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:10:27 -0700 (PDT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8862ed0539dso4090037b3a.0
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:10:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793052627; cv=none;
        d=google.com; s=arc-20260327;
        b=rHF2tE9GNlBZ57soY3as8Q1WSlVydetsuq5dnJSvmqSRP1/yyDOO4OHocE3DYF5pNb
         TVMsD/hOpgOycSuQBtIhP0TXkHA0zlSwzAGSvRzRT3EQJ/AvrgMc8I59XBP239kZ9U6F
         QczKRXwrUOiBO5OQiezdUE15uLA8mrSlepGWXDCT7sZFJgLU8fm1jjilKoMWJIaekPaZ
         uPiY2sKDAzkDryISp3MfIKRwfSlvj1HPTNKnTgZRFOzVD5we6CYV2gvn+eob0T0ZnnUp
         IEm5wGjzd0O6Y+2twMK0JtbuDHiaXIoppkfGLfRM+zzVe66Yo7N4HKagMvhUZvAl1JeX
         Z2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=Jf+loG0vAvnxt28Kqn9IrWU5X0/8DtmZggaMgC0lLF8=;
        fh=tOySnwy2ltZ0PsCkyIoLTM1YWLXqywztYR2nGGPuMas=;
        b=IlvKITxvAJmPxQA9Jftsm/grte74D6iagqh+DJ3JH2IYUZb8EBi3p4KS8FkxFGvNvo
         8DnpR0NKqseJqW0PjVVr/1YK9SpgWQrVqpfIRa2CM2YFmG6i3ZpLaAiyDQuUlBLv/gXr
         Mg3mC8WvdOswyF2s8iI1DotNtVk1L8fVHSMvdylIcUWSQhmVA38dyYtQTcfKdOYWmIeO
         bzsqgc6UAcc/6V9RssEecAdFH86K3YJudWKAgIGdoqD701Vf3RRLVea4pji/jgbNOX1p
         l8cFbl/gC4UwXMNivICI6Uk0tgnkgOxEgIgc+UpCd+sqsJvCDtGwP7BecCTph8On8c35
         HmkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052627; x=1793657427;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jf+loG0vAvnxt28Kqn9IrWU5X0/8DtmZggaMgC0lLF8=;
        b=rTPMLBKURi1Ac6wd0jS0UgwA9ggNyoG/iNPgDKoP1P18+0H3GiheqcgfTcYj/ZeWez
         /WFPLynWBAsyx/kcibl8HUksM8nF2jtXUZkdcIu76eIie51EBLOdQbRqxaJe7O43cMP8
         Gcir/TorOOJgXM1kMU7bIylx6mBuqQCsrDg6o9HwiDf5qdy4yS9Ecfa9dtTdAomGbf2L
         Dtu0PRqIbwbG+YQG3eI80194JgQzYS/iC0xS0gZN7BdAzL3xlbwa9at9oLAZBoWzAj7I
         il/xy+/3aAQLXHS4KxE+g6AkJ6UI9d8wAov4YSVU416Y2Z+wSN6sBgrA0IJLp3d5kgT/
         uyZA==
X-Forwarded-Encrypted: i=1; AKwUvBzrqxZ2zp/suuSpn2ZmOcLC30gPSYZ1TPSEmAzkoYXSD5T028ctCAn9sv6TXRycCIxAVGAVUQZQeOXL@vger.kernel.org
X-Gm-Message-State: AFq9FYJjxr7MhYCEeMU++nI68G4LagKITRHUHqLWQ4wijYVsFdTAykj0
	KPbXY3BvkTy4TpdzHeqkz7xgwSme4ziJ5ttKHCLROlg7eYzTNX9zRluBTvhdAc3TyRnHpeJH9r6
	HOR2s9+kwCztftRwECmo9tWoogizjPUN8TXPmMP3Nx1FcZtV12S2yGLYRSiJ51++XcHSjzcqEEA
	wu59NhDxigRhzkjgDzkrPZCYpoYvjBcuGnh0Ux
X-Gm-Gg: AYBFou0cNllPr1DajcrO40wezDPS7C4QHGIF5luRLMIIbDdfqgJwhcTvkNx8cGCS+8U
	ciMqJ99TvPueW+/0TGu6uGUIELDDGhsjMhj/d3vx73B5FIl4JhziVs3zuWaqIjyp1jfyylMxFu7
	1xa0e1NAB+5vs5AIbJTm7mvu8txaP2IZPOwCkN1nnNN8RH/Nsg/8gtE9HT7aQ8ZSQJSKYKp/0Gj
	SDrl27iChejzwwLykGsfvoNTn4rwBJGeoft9i70lBuFAG7i5TA=
X-Received: by 2002:a05:6a00:a211:b0:887:3fca:835d with SMTP id d2e1a72fcca58-8a36772cabemr7073925b3a.29.1793052622066;
        Mon, 26 Oct 2026 15:10:22 -0700 (PDT)
X-Received: by 2002:a05:6a00:a211:b0:887:3fca:835d with SMTP id
 d2e1a72fcca58-8a36772cabemr7073902b3a.29.1793052621627; Mon, 26 Oct 2026
 15:10:21 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023234640.1459291-5-toddfreed@meta.com> <179288570316.3134.17338958323067090592@kernel.org>
In-Reply-To: <179288570316.3134.17338958323067090592@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 26 Oct 2026 15:10:10 -0700
X-Gm-Features: AclHuK_YNIc8WR5zn4HQHJZd6E-TfuSZHowIMObN80et51S8RIsFb5U_2Jx7cYA
Message-ID: <CADh2yMxPi+eNkQSVo5hUr=pNsnG21ZLjYf=GMFPS5eOtyedrAg@mail.gmail.com>
Subject: Re: [PATCH net v3 4/4] selftests: drv-net: psp: test ipv6 tcp socket
 with extension headers
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, borisp@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, daniel.zahka@gmail.com,
        willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
        cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4OCBTYWx0ZWRfX6m6iViHCN1Te
 sYdK8oHWZBlyYLtGeHo8UQlx8HVCMVqYxUfD/j5Bia4trvj5NcqtqF0pHj0ZOFg2TqgOdb7i7er
 C+EIUEAMjDjq5ckDDGVlo0QnN8GB5A/nmYmSH1sauYapRiHSi+HkAoslIJPV9xPOnRg1lUlBpLz
 /7CQ8USyDpHQZ7bK0GMxmPcbeg8TG4oYTpvFJbZ7dtZwAGOkN/Jo5OxGY06HZdwpe1IOZYEKwnK
 +wJnK59cuixg9wIf4fFjHO9Jy83bJ4LSMMR5td7CLX4CxJ0NmEB6xXQ7z4AuXHfoE0wb7IWTVX9
 OORRDjkIcP15iDzp9OvJcoWNos3JYsj2s8OD7ehoG1trojWDgHgNT0YyGCzndhGh2NNifHegt08
 3tfPHCzN1sgJcXey8Vle0HBbXGtSg/hSzGh1Ov+IS5KeCtQH4LCxWoKm0U99vZZh9JY8gdEfK2g
 tlejM/1xaUtU+cXcR2g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4OCBTYWx0ZWRfX5iqC00LQKT2Y
 qOCtHvGhkZp5uxMJbt4Z9wV1d6OTO4U9VMSHS4wpUMacv3ZHJEiXbUc8/Zwn6B71BbhixHfNjMK
 +iygXpcvcgTIsUmvFv/Kyoy5jBsVeoY=
X-Proofpoint-ORIG-GUID: eHsoxCblt3cnxfp3Ul70utPhry5kvOAx
X-Proofpoint-GUID: eHsoxCblt3cnxfp3Ul70utPhry5kvOAx
X-Authority-Analysis: v=2.4 cv=DLUacCNb c=1 sm=1 tr=0 ts=6adfcfd3 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22
 a=wrF_2KVHrNPQTX-trsUA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01

> [Severity: Medium]
> Can this skip path end up reported as a failure?
>
> Could the remote filter be installed before _make_psp_conn() is called?
> Another option would be to finish the key exchange before any early exit.

This is a good suggestion. I'll apply it to v4 if it makes sense (though it may
no longer be relevant based on the other changes I'll be making in v4 due
to the other finding.

-Todd
