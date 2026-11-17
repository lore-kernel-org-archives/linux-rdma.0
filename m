Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794954007;
	b=Yj58vgwMWnMR4ZX5mJGv6ZoWcFv/b0m+TCccLna5078G94dVmrosxhWBrAopETj7MmyP
	 PRsTZSFMzgvrLy81wtcv4HCDM21xq1oVsjFbJ6kUvONxykS3uOohM/C+u942INpCFd2+S
	 3rR4qIAb9sIN5/99KgSG8ubrE9TXLvKsKfwxFXibd0CAPLLr/wd6LVrdyjLw9ZP+yFU1B
	 YsfVPmdVSRAYsRK1weas3M8Xq6H0+X+4JO9j9tqwfR/F/dvWBrBazJfgl9IqP3yTX6x39
	 NA1I7/G6d0wZdDmJiaSCdOWrgiboM0OfKwvNw9jR0al3XjV4E0zqik79qT2d9dFGz/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954007;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=MrBB22VyQQ34wvgxAVrSinsIzWNGkBwccDyrerQ8zrY=;
	b=q0cx6etGuOXy0+SmyI2SyEtyGzu7iFWPhjGUAFIIDMEWOSvnVNdRt0w193vWU3ncGabX
	 eOI6sWKn/ndyQI4N0s5PA0DF2epQMCTsywRht8mn5iHxb7FXUxwGiV+a9tlPcPAt5+AEY
	 3RFJSyFn6y7CdFRb2kJkWjIRQ+IOCkFgMp0qZm6tC2xx8BzbgWLoN+U5Cv6lD/a585FIQ
	 D3XjqNp8aD/QMfIDALcM7yOE1t/FIUNreiat2KKyRS73lb7hvsx0N6FWUSYQHMBgVzhh2
	 F9hEsD6GWpO8TODb8suLuQGOzXJcXj/EsBKz2Z0nc4ahMfu1xqphRsOwuwTivoaKGZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=de3QWr9u;
	arc=fail smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3537606A337
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3537606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=de3QWr9u
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHM23tA2069821
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:20:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=MrBB22VyQQ3
	4wvgxAVrSinsIzWNGkBwccDyrerQ8zrY=; b=de3QWr9uJo7zpRux5nSBZrQPJI1
	ZuT9RzWRGoDJ4aCQ9SrU4Xxw9lwDJ7b3OmHlR8+w5tIEz3UPpJzxlfS7NWR2ntEF
	Sx5JJxBsNLgjr1SvG/Lb2/HWRTnrHpAqHnl2JEhCnWbe7ecSMNitIJpelIQxT7L/
	5ownN3a8BAw3B6TX+M2l1KOePj+0a7YZornHlcIw3dusVrCnZ3PNUvjXrb1W3Jbq
	9eI4VDUod9rq0HPbutUCHOxnMkEyvDODXmpDon9TP7Jv9fAYKQLTeTydSUIZhpUC
	6/Ldc6GrPMpfUutcKYiSWDp5WJmepsbra64rsMl8Xl+kkyO3/xGEv7ORWJQ==
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0w0bt130-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:20:05 -0800 (PST)
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4a4191ae436so242049f8f.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:20:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794954004; cv=none;
        d=google.com; s=arc-20260327;
        b=aLdW5WK2vhfomGiJ6ZuMbtmzn93gba0I1IsonJTfEZp9Y6+kNu/N56jkC9xmn+3PZb
         +f0EotO3WbKk3SMq0PiraOCuuvBRa56N1dEfUCxzDw7kKG9SknEWn5e+h2wuQikf+jxd
         VN0R2W8ClEuj0eCNbmLF0nxi2ecSJ9DGFo/j/vfr5lKdt8Y1r/9kHD4QXOyJa72H7Vbb
         tqnwYwyL+Im8Q3tsoyZlvnNmOuf3c+NoO5fotEHVELFLrQB9wWNtdOHXETxORvaUlP9S
         10mMckaOcrvEVz7MUByB8hDLZW9qgaxAYTqOAMUK0+LRtXhsca9cbBI+XlEJS+lHDWDQ
         7V6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=MrBB22VyQQ34wvgxAVrSinsIzWNGkBwccDyrerQ8zrY=;
        fh=UT/Dri5iLe3CpmwwQCWL1nAIn4dGjWovWEKrhVSO15E=;
        b=SWYx5G3l7ot8BD2c7YwKF9+2m3iav3JbPFcH67cWF5Tt0WANXgbnThRIYfe3ZB8aHO
         LFTJcNFCWszLpMs5LGKPE45ZXqtMJ9X5NFdFrx5lMfBX0Z6Zk1pdzFt76TLV6cqLN9ei
         o9c+M+unIBu9QYmLXNp7uqj3bkHKmCv3CWpzysSc41SUyOMQ3ZTtIX6G7/+SsWgOyayL
         brYfjBtSKClCQNRyU1bdNgtMeJi6i0Rn3xymH1RmJiOOdLdRt2qb89XvFSvHDRJRcTFV
         fmOuRdC/+LZmHFe+/hbgLbCw6a9bJSdMMmsPOVKyQvVI8fqGuN33YUcBlF9cbnPPTsvy
         bHHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794954004; x=1795558804;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MrBB22VyQQ34wvgxAVrSinsIzWNGkBwccDyrerQ8zrY=;
        b=AubPNifZSwC+HWfV+gPJO426UxXMAGfHOhBYBB+V7u2st4SecVeIMluzhFsBIChOWn
         Yw3qZ2UOResKuet6owLirgbuXnlA/auh2ta0JYgqigT/OYHWXwUKluJVzO6MLoEmSO45
         SzdFZDqLNSZ2eHP9ixBZuFnHJkVodzl2llfJWXQNUN2PDSU1HjqRZhDhzVrl64u/Yfnx
         WEJB7BSsF1HVfX5UAPITPc01eBgxB4V41Y+M0raNNlH7CWVscSWa7MjYa1dn2k/eiu7O
         jAqF2RwSGLvaysF9f/U0LyEwPrxvBa3Wp5/UZZu+DFHCbwBc9cUR6b03bZreGsTxulVA
         qnKA==
X-Forwarded-Encrypted: i=1; AL+hErGfgYAIZIhyZQ8m/hQyA4+vxL/c9g6+PvMWh5p0XLIKia0VwPo4lxk4jKcZPKFBXeK46B1Bmsv2ojxt@vger.kernel.org
X-Gm-Message-State: APuU4Z/VLqFabrMENBijDPLvQo+CAIo8fqdttcno26r/4Sw8m5j43ftV
	cnMAhWygNJs3hdBBivRkgRU2PXasyms4N6EfgSVxd64CSIaZ3Tpm439LNsj0EtEnSg6grxFaixk
	KJzntVwxnBM39HwIuWbwZ4uh5yaDmzuHby4KZAVCmSQde29mtGa1GLlu7WvULrSKpKJfI5QZDoe
	yVRTCvWefhzawbT0VOeRO54ZBBwqfGM8r9KlVh
X-Gm-Gg: AZFdTZdvcYV0K298MedbDtjGL3B6eVtWW1bQAMgBjyaxCT5/Qu8Fzfxm3aURJeRskIr
	sFfC6g/wovi3mcCyKl7i396+ihllH7J9JrqQTeQreEYxpTH5VIR0/SjXd92wpdLHhG7LSNcJ1RB
	yfJrjL6p9kRo0YrT+trXlz/NU3IMNe9QNYCpxzggE3ltZnfslo80kEB+wI9DuyqtlRB9Ij0L4BG
	MTJNtQM+hI6WjxPl+kddIJF4eIja0xUwUwW/gNKAg23m9DRGXU=
X-Received: by 2002:a05:6000:2383:b0:490:f98f:addd with SMTP id ffacd0b85a97d-4a6331c6cdamr2082704f8f.4.1794954004539;
        Tue, 17 Nov 2026 14:20:04 -0800 (PST)
X-Received: by 2002:a05:6000:2383:b0:490:f98f:addd with SMTP id
 ffacd0b85a97d-4a6331c6cdamr2082645f8f.4.1794954004046; Tue, 17 Nov 2026
 14:20:04 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-5-toddfreed@meta.com> <179471269504.2199510.18115986956046547098@kernel.org>
In-Reply-To: <179471269504.2199510.18115986956046547098@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:19:49 -0800
X-Gm-Features: Aa3M54pE3seHebOeBtbI3cDpMgrW25pWhWq5MbBS5In6ZJStfYB2VZ8sEpNY7Bs
Message-ID: <CADh2yMyRSH4ZKZaGxFLVXHTE6v3XF38jh2OykqXRxvP4=0TKgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp associations
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
X-Proofpoint-GUID: 2gZ02msXxga-z0ekccKn1MkxtT_PEnuf
X-Proofpoint-ORIG-GUID: 2gZ02msXxga-z0ekccKn1MkxtT_PEnuf
X-Authority-Analysis: v=2.4 cv=NM1AaE6g c=1 sm=1 tr=0 ts=6afcd315 cx=c_pps
 a=pX1sPZUoWPGeQgUnKQNIgA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=6yLQ_yHwUL-M3baYCL4A:9 a=QEXdDO2ut3YA:10 a=XGGHjNwGSpTZ5T66x7Ix:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX5SuZiW1s67/f
 942UwGJtUp4+tFym/gcZ0NoDkN/wSCHH3eEqe3Wfa8plmOm58WZpG8C7EV84GArQl3z1OHlSdec
 w+fPzXPct156IdMMfm7ofaZEsm0Ek9c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX12kxUWqwdfJQ
 fte/GN45iVPd9fAmfQlMTHpAfhAViLAYYOauxorIK46w37OFofkdR5UqsuwBY4XfWhnk8xvA7LX
 o7sIrL17hgTNwZsiLwp1YFZQPDIktsaS8qCConSMy2oXb/kZh3hcJ435iVacvLD0zl5FTiehZdp
 9MUR88YRAZ0dhcjaZxSMFohHhKcWnew/2eTu2AUwWxcSDOXx1GbCEzhuoMkzUxB453Ll30eQQAM
 LSW2vPjSo7j+7UyfTkztOOr9rUwOHH2akzXs5P6W7gJXWK1IBkMl8CAlzFTrrxpYAApKIxs/Y6Z
 MlsDthDJIHx0Jp0RQ5qvWQFd1d2yxIfjow5rxwnkE6QKYp0JNwSMlhn3A1Gk5q7PPAgMpHE+1xa
 ry1JcZSlzc6QzN3TNkoYKIubCyCEkS8iURKL7nHZbvRdyeB+ev0flNV4MNWjbhFSruJQ/YiqQJz
 h3jmDLbhYm/O/J4s3gg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> > key material enters through netlink and is never reported back. no key
> > is stored for rx associations, and users reference associations by id
> > and never handle keys
>
> [Severity: Medium]
> Is this paragraph accurate? The code in this patch seems to do the
> opposite in two places.
>
> ...
>
> So user space does handle keys, and rx-spi-alloc does report key
> material back.
>
> Could the commit message describe that more precisely? For example:
> "the Rx key is returned once, by rx-spi-alloc, and is never stored or
> reported by assoc-get".

Yes. In v2 it will say the Rx key is returned from rx-spi-alloc, but not
stored. In v2 rx-spi-alloc won't create an association at all.

-Todd
