Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675361;
	b=C0JX/f2/F12VDNeNNzOinRKp0yk8gKdmb97W78hd9GIHBSqO+98QfnEKa1Xy3mTGm9k8
	 JrrHl+HcjAPpQQ35522tLrzWdG8jvbKxNAuAmTlKEhGhQO0Gnqxg/lzlWAu8HmPUndfEl
	 4NSoOBHgVbE72XGfOHLbNgO2iwlx4sOecZPDcENsCBfLfGJ5SEh/XzIJzAK8sWFS+Nd1j
	 kUHVcJp+/A6xSN/mCKJiqGdZEsDuEFOEpkyWEQs6cYEiBUBIyPDshBX4Bmm2WwkRcNh5e
	 8oz5az8tagHwql7iAENm8ylzuHaYKE+7dt60vrmVF9jo/SO0SfxheYT6eiKw5oISshw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675361;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:From:To:Cc:Subject:
	 Date:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Zuj5nD0beqQBAgWy56Kh7Cw/sEgcsVkpt8nbhWH2Rng=;
	b=jtZrYxFvGwnGq/5c1k21OHHdi7IioWMoaZLCL3+Zj5PiUTgoLb4/1YZbuvbaszR1s42S
	 0yFRWe3xMROxB9Cg3uRH9tps/W7X47Bvi0/HK1aapyddGzXIg9I6hh9kjLOMDnwbLRU9U
	 j6dQ66KD4AY6DGGEJ0Il9ZUtCdkMrWBiS9Q9VBWDH+Vux42Hi+MXddjLbJ27Jsf3Iw+nh
	 IxcW+ygQsy7hx57TiTVWrVECg4u9PuLi3re4ABrcmbcR2pXxVSbON64SuerMRmWJqF3Kt
	 dbmMlxKZ3UABxDF9u/sMcwNvgk7gSH/CFw5vxKmuQXBuP9debBvvJt7V8KNBFpY1lDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gmzL8wrg;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F03606A31E;
	Thu, 26 Nov 2026 06:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90F03606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gmzL8wrg
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34t1T3131253;
	Thu, 26 Nov 2026 06:42:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Zuj5nD
	0beqQBAgWy56Kh7Cw/sEgcsVkpt8nbhWH2Rng=; b=gmzL8wrgiF7k3FI22Sy/YW
	NC/EnQiCpxpleg6ayVfOhY1opjOcR5fqlC7mcQEryhNgVCOTQFocKsRqJacIt51+
	X3Ou7v9KE5/bVW7t7ZhxglikfuQ/ZcZp3SvVVt+gIVyYwuAyFbgX8QmEuVh8+85o
	ONhGaHAeqM08SZmJkuUDDoU/IZy2SGZobFEdDRbYdSn1TGVRamn5MYnrBPiGQgQO
	wl9Ufo0wqm17DNAP/lTPGCoLRBBd0yWmIH7kbaBkp7hF6+wKeELCjOkFB+ccEbhk
	TKa/R2unDdyu943v86L6WpEwFKqKKJB5ECjVgvEavfhfxHPbW8YOx0LPV0f+cUYw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fkr1et-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:42:29 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34Uc82799106;
	Thu, 26 Nov 2026 06:42:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3q4hhd57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:42:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6gNa136831680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:42:23 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 187622004B;
	Thu, 26 Nov 2026 06:42:23 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE9A220049;
	Thu, 26 Nov 2026 06:42:22 +0000 (GMT)
Received: from localhost (unknown [9.87.84.240])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Nov 2026 06:42:22 +0000 (GMT)
Message-ID: <2d0a26195a1867c67a204cf9327fe478@linux.ibm.com>
From: Sidraya Jayagond <sidraya@linux.ibm.com>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Dust Li <dust.li@linux.alibaba.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>,
        Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net 1/4] net/smc: take the socket spinlock across the
 failover cursor switch
Date: Thu, 26 Nov 2026 07:21:38 +0100
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-1-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-1-4a7c8d85d849@proton.me>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX63KmWeRV/9mV
 L/pxHgTlcUy19S/1CS7dwZQ+0HHHns31U75XoYoBx3nEhojD9gCuVaCWJTlkND1pGFSSsl6CUP2
 qDSyvnTk4kDqjj9LGqq+gCix3A1ljH042HKmlp0rPT3yxDlOtTkM8E0G4uICkyyekWUACg5lk/B
 Su/G817S24k1j81j97JN2e/1O8FGh2Wso2SgGBYjlIcKvc8oT6TWfpczac3tqGSvOGQAKIImTvq
 6ILNFLFa+yBDxLND+jmvU+GXOU0SJs63PPkzcmM12gvNIn4AkqHIRonzN02+Vk97vrac5SxUkvk
 F6x9H+GZHTTNF2wjpyjmJsl3YjCIDihUQwXGg/d1ZVnOlUKfSiEhGeXve1a/79pR8yv5jLRS9S2
 LKHO+iuOFyvXUmSxVR9/LRYihwaS85a9Nxvk1pN+UXRyFP14XMrn3ZdHrYUkfflSp/EGT5ylTNJ
 mWxMxruJhPHqZwFmdqA==
X-Proofpoint-ORIG-GUID: KcYNs8WkSwc9G44BFGBHallykboitjft
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX7IvPx+AyIuUF
 MKVcAV10pQBb24Ow+FFE+OvSjsMhXfkX3zlm6/01zOYhNpPpNj+NLY07EgqAz9BykyFrVv+JIrK
 u/oCDaK4bhkj/6Mqu3xJGq+qedoJTMY=
X-Authority-Analysis: v=2.4 cv=A9z5rKWG c=1 sm=1 tr=0 ts=6b07d4d6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=oUSw0pek__-I6iOKThAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3-Z4RQCW1OXIvPsVMPPc_jsZd2-MHk_n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260025

Looks good.
