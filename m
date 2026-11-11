Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794433789;
	b=u6Moxio5/2h9NRGm4pcKy2ld48na889IHpoCkgl7Bq4nsyUoO7187DIIF+sGc+cBDMaT
	 m+kn1I1lAPzixL2VzXtIAqegU+wVRlsNFZDjlCxoKiE2oihyuMDxHiCDxM8nu0iPI3Nyf
	 cWM07Mpa8/HCyIqC4sJjENjsXMYo8gVIv9aEAb3sHv71nKy3i2HNx2gQ0MixOpFSbBnv9
	 ctmzp8M6Oodk25d6Q7jYZMueaqzhPzTYpp7zK+QE41jbhPoN4Co12KREEjAEUQq9iURNG
	 Npnn4Z+dh34dSpnbcpTSgRpmJayODPsYozrjFayOdEYu22MzLncYHxTEGSfQfJkYu7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794433789;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=5hjKfboVBJ7OBGDq8Y9w5OdAYwdgZTN1RE/HZ7spSHE=;
	b=rGyoiNHCBxFGA/1IOxi296fUv1KBuwC1raELgUhRGDed68khTD0BqrPBd0vEtDEtGzVY
	 /ZUBc+OkSgYiuhjVpx5B3YExji0B11m9EQp1uVwTOaFytBXSINCq+htTlm36S1RW74lU4
	 3tmNwDHpFANLnj5fvaQrPoyYcz/f3igvtp+FdBD08lx/AIvMXaWSnsoATQ1/e34ReuAQ8
	 Bv7dxWJH+ELehs0yP09Exbgn9nnhelZ6LdmHQRV2Tpo+bJ60l/3K4gVf+OzDLCFZpzJF+
	 sTfja5V/Z+vzlSal3IN7a2Vh75soauAi/PaubI/6qGnzwGBYbtyhROQxseyiq6aNK1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=GeyeUFFi;
	arc=fail smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27D4606A336
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 21:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27D4606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=GeyeUFFi
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABKk6nX341581
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:49:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=5hjKfboVBJ7
	OBGDq8Y9w5OdAYwdgZTN1RE/HZ7spSHE=; b=GeyeUFFiqCEKPkYZuQ6WCtcJ+ir
	veBlhkSCp2XR6ZvVC1Xnkgk73qpCo4mRZiSx00pz0ZaPhEttkWlhUPmxfs40TTQ5
	/X8zBYWeMo5qo2ppLp4+UZMJyHFMoiEX2DHlDDezkJ+ymYQXutBVAG3oQhntG9hM
	ZVeerH9U4yDTyfZo8k5T3RGORiWlI7Sy4seS228sgPILhH6xhQjGBjjWZwg6qsn8
	Vlh4ScYyoi1E4wMGavc4pJXl7aCS2fuFIr3busZsxl7CXn30LOVds332fP4+nkTl
	nDWVNpN6J2Xxb3bHvFuoJ6S2atc4WxsC5TivihwZ04AgSP+XyPVs1XTkmTQ==
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvbxcfysj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:49:47 -0800 (PST)
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-490c1867460so2700662f8f.2
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:49:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794433786; cv=none;
        d=google.com; s=arc-20260327;
        b=qyZM2HOb4Z2mqglib7ioQyl06F8vXYOUG0Qyq0ZlMFa0ww9uWFgcbcamQzd1higehs
         IPeqdMua7Hr2mq/zVx2YcsotcunwU6Vkb6gVj4rQByWyPVUw+7SvTPNRUdWxxWOsxK42
         9vkDxeSSOpZhqTTqq1x4EbSW7+vXNMic56LIHdKh9S+m74qtWj1CJtAjrUUJWxrPFZiZ
         NpVWCRj2kBmJ4cD6WAX/4+/9XakWReCCTUyo6+hyDHialzcdoZdDqGDfebnAlMo1KtLe
         G2+OH/Vv0C6YRfqKIZKxNKKuGL4UBAD3WF/ed6GIhwnzR0WOyRGTOtwWVr88GdkEScwe
         TvVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=5hjKfboVBJ7OBGDq8Y9w5OdAYwdgZTN1RE/HZ7spSHE=;
        fh=0rDT5yA9Gn1Konn58f7Xpv+fRbJKRKPrNeOYLBNmfQc=;
        b=Kzoy4u+EVyR7/TGE3Nl4Q5ivc6P1Ecqpg0KjKp1stDLoqlmsrkVm0PKk4T8PsLyWXl
         jbOd6/AcXcTQGr4MF/iOiIf543XzztY5fmLxqxzDxBNSHawSvk8feB+bnlLJizThAKxp
         8ZxYTyDDTd5LuKwOYKhjGUPlxMVmBTaRNP8DMVgGrGXC26++ep6mOxYauUspXFGwWXgu
         zhVSj17aU/05kkBECHZLxC6DbZ/8U5zazmTAhKJmRa/kcwB5hi3MC6CAxfpp6kDtuyrB
         96dG9FnEFyGC1e1ZGInriQ4Osb2Uc12MTABHRBDBoKg/TfOYxyrAkv4k3c5AAxJefYCr
         +z3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794433786; x=1795038586;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5hjKfboVBJ7OBGDq8Y9w5OdAYwdgZTN1RE/HZ7spSHE=;
        b=t+zE/nmzTZG4Uabop/GM3VZ6GoHWNLGAVBE7Cj0i58E5OBJgPMwnYS2Ddqb92sf2Z3
         /dZCpXga1WR7bVJOp4Z6ucXrlUpQxkOPugKqrWxv4bfMDnrM2rT+chL4r4h0AT8azqJh
         /WtmVLfmJ2cZrdqSWW1mYes2Cpgt8/iFnqR2O7UXtaJUrqjvREH+mQKY4bjq7mqg94uv
         Yh9/ft+77j/TPo+EUMXYNUIjaXTrFToVNLDMWC0eWCJl4RWGyN6unL9pmflO+2hdETM4
         RP6D3ny7tai2xhlFeWTApPLPcrEyAvYvSIqR5MLraJJGWzVll7kBTnGGAjGuUzh+crtD
         QmoQ==
X-Forwarded-Encrypted: i=1; AL+hErGxj+Jn/c7YgUupKRJJG0JJjJSXXUs8P97/nqVteP7XvSB62BCErfPPnPbymk/8PAatMZk2SuVw7+km@vger.kernel.org
X-Gm-Message-State: APuU4Z/jkRIDAOW2M13zuUxzLnEUiCfhdWgmzHrm908FT0Xwvi7/BSZF
	hlnDQGJRnlstTclSRmqscV/FQfamPka8lngu/47xnqUkC41VQlfJyPbt3yb2rw7RxewU3sp1AGW
	vY5485d+ZEE5MJ2KU13A0cv7PYqjkuMMquLTidfCKZf8y4h8G63qrOWe1aDYOk+k813LfBwHo1t
	fFnqcRopChTrlh4znS2jhMh70C/Hf0WmFRqn6A
X-Gm-Gg: AYBFou16JRS9RRf0uMHQ9BDFrnXBT3SGF09/Fb6GOIiTSTSi0mxby0+7cVAmlLqa4Bx
	S+gUcHDw4yeqXreYr6ahoXirPduLGZZ1a/OqTpjq3+ovtqjVJWyIrUOSWKm7yXJUA2Ov0ETW2of
	eASzBh57F/V2wh+zmhf2oguVkUsEQHT7GXRD8DHQMLGyZXr7RP7oHTtH4DuvPIEnxRff8mBTkMf
	NaQUdPValKfwgSH50/yT64AduYP9olH
X-Received: by 2002:a05:600c:34c7:b0:49f:e701:51c8 with SMTP id 5b1f17b1804b1-4ba093583eemr60183745e9.9.1794433786484;
        Wed, 11 Nov 2026 13:49:46 -0800 (PST)
X-Received: by 2002:a05:600c:34c7:b0:49f:e701:51c8 with SMTP id
 5b1f17b1804b1-4ba093583eemr60183425e9.9.1794433786168; Wed, 11 Nov 2026
 13:49:46 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <20261111005533.6436-5-toddfreed@meta.com>
 <DMSJB8MZZCXK.MCEBRZQDAM5Q@gmail.com> <CADh2yMx8MPjcH7Bpj72rNNd_tT=6uSC5Ow9JyGjTMjFgs499Pw@mail.gmail.com>
 <DMSM3RNRY412.1GXB07F4KGJYR@gmail.com>
In-Reply-To: <DMSM3RNRY412.1GXB07F4KGJYR@gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Wed, 11 Nov 2026 13:49:33 -0800
X-Gm-Features: AclHuK_3wPHrs7nAKCIlAv8DB3IRwLLgS4civoUiRATHWDoZevdks1911kjhq28
Message-ID: <CADh2yMwFu5Gyadm2Y-NHCBtayEvN5H9LUM=Kf-tT69vmjm0DEw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp associations
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA4NiBTYWx0ZWRfX5Kxyma7Oq8Ft
 M7xaCcQ7sGkSLln4gxdJD0DMDXXVXjrH6YA6G7U6tpjAHS4lOyQ+3zJK939PLyqlthuSMGMU0F/
 nxaxkGJR9Ab/KpA25Xzx04QsyVEpBB3rJEDjUs/cUtHHBMbTs5VzE4riFbSszr6vdvqFM6aifWb
 VOnrEdhWGcYjiBgKvcnAU1PCyKJRpTLu+8Bwxl5wAdn76zbU3V0eSUzDpC1It3foesIoY69AuGY
 RS7ZTokII0XODY2CEc/gEHAy1i/ql8ZLHM1oB/QAWk7oBNOKqQNaEX9drLNY21e5LWfPUP5QXfF
 PwlKBuA3FDAr01hICh6gGFpSZNc09SUJlnpATVhRTzLcMFXkGMlU12r2WZMFcBasN8sUtR59YnQ
 B6wpS6KpJsbvIdzXZCdCQCR19os1AbRk25DylEXfOY+plW8iV487u0vbpi7BWRDo8Q9wZ5Le5Wx
 uDV4EUhlCmchDluQCyg==
X-Proofpoint-ORIG-GUID: RETByzixRKAaXysIfjx7qHx7yv01_FXF
X-Proofpoint-GUID: RETByzixRKAaXysIfjx7qHx7yv01_FXF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA4NiBTYWx0ZWRfX4LZlfViiIgrg
 AoSawYPHAKaqkuLsiHbSem/8qlK4R6RuXNyeDQXLjvqA2u+MtUvqthyZPFDr5OcuQ4jmstAEecS
 YkINOJU6ULRzA9VhiZvCeuNmy1m7PVk=
X-Authority-Analysis: v=2.4 cv=ZdKIpcVA c=1 sm=1 tr=0 ts=6af4e2fb cx=c_pps
 a=C8Sa+zVB7PeSwznsLr31Mw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=VU9VbmEmTQsFja8ue1gA:9 a=QEXdDO2ut3YA:10 a=eYhU8IiCvE_ms1W8Tcak:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_05,2026-11-11_03,2025-10-01_01

> I think it makes more sense for userspace to just get rid of the rules
> before rotating the keys.

Ok. I will drop the rx assoc objects. The robust userspace protocol will
be some combination of using cookies for state recovery from a rule
dump, and using chains to flush old-generation rules at once.

-Todd
