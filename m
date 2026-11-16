Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794842901;
	b=bbxOuFeb/cvFh+hmdl0KHt0UnvdqFI1xUi4B+2Yptcpw9QT3yb9fExhg5tMJ2HiguYwC
	 6HCC/5KpUzuetU24VUI3dxDR7pXuISSBWFw1DA8n8o+X5/NV1/4GSZPcjbrD0L3ShPhRQ
	 zPDnUWS2pKHhp9QMv3t5nf0lnCw/FtIpHQGBRqHjifimLIr22oMdjbqSTzItyQ5CJfO+y
	 VQ2rL4RCNm9nugwcoPajtS8iHcva50jogFifKUbCp3ylAK7a7cwLo1mWdA9rAb9KLuRoW
	 MCOMzL0keT9W97WIc0JE5zso6nHqhZLYmdNaLq4AQbnCHRZB0437Gb8tC7LEhvFFEyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842901;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:From:Subject:To:Cc:References:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VUxoL+hkMuqSpkoWW3gH+I8KuNofLq4r+vKUcWDgU4I=;
	b=3FtRcnumhbUHPsWtV/W4bKOojZR8X0ygjz6ZGAN4+gVV/yKCPHJWj6rwp/rknj7S9F8U
	 Zk/0CKmQaXFqJAp8go3cXIIEcZOGKtcj2uk2CkBt3r6laUXhKgprz+oAXqxElwFv9VKgr
	 S3y5eDoHItnBVOiAS92LYZ33Tgd8fUvytmjOIfIIT+LpiXeQzltsBNU7LpkWPJJU3nEcW
	 6iFdePevPrBZm8FfNZGfzbGa2jQ96MouG7vKjn5MY10qH4oShDwzmlIVjWTydp4o+JqHV
	 8JOZmYNIMzoAzHlQWLVIwdbAh0Z1vyG1LPpXRA2Hs8U8QDY73pCYfTGaePM1NPzN9Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lrd3cWTt;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC9F606A331;
	Mon, 16 Nov 2026 15:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EC9F606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=lrd3cWTt
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGDuOqI2214172;
	Mon, 16 Nov 2026 15:28:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VUxoL+
	hkMuqSpkoWW3gH+I8KuNofLq4r+vKUcWDgU4I=; b=lrd3cWTtW0CXO/4mmn7OcG
	4NY8RsD+A0Knga30x+EUHjTod+7LaCfDm4uWJsdeoRjl3zEiRTID3haY6zEadipU
	bz9q7t3oBrKO1/7e/rIsaizUmoKr3zGEGrbzdJ9ZL4cMHn7BxY+8aL7xNbAjuojq
	kge7ju0pQsnCQN25GEYfCiw+Tmb03f2Py9FrwYuZkqoOVSzFziqptvJ257576Qfx
	4KejQiDcA+34kbWZ0srUidNx/LWwIkAq8mQHGR+UypW+4EdoPTecmTnav5o4LsOo
	nnCJIa9EA+DjfDKStV1bt+AZn/362WAESG5tlfGGXqGOGkv+aLXRYj7Eb7qEKquA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxe2d5vdg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:28:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGF5tng1877673;
	Mon, 16 Nov 2026 15:28:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hy46fyvkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:28:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGFRpVZ39518540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 15:27:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EFB220043;
	Mon, 16 Nov 2026 15:27:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3671520040;
	Mon, 16 Nov 2026 15:27:51 +0000 (GMT)
Received: from [9.68.31.53] (unknown [9.68.31.53])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Nov 2026 15:27:51 +0000 (GMT)
Message-ID: <f23d9c47-b254-484f-b0c4-d1053d337c64@linux.ibm.com>
Date: Mon, 16 Nov 2026 16:27:51 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [PATCH net 0/2] net/smc: do not reuse the DMB of a nocopy device
To: hexlabsecurity@proton.me, Mahanta Jambigi <mjambigi@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller"
 <davem@davemloft.net>,
        Dust Li <dust.li@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>, linux-rdma@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>,
        netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
        linux-s390@vger.kernel.org
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
Content-Language: en-US
In-Reply-To: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfX7GFluGf7knYh
 ZkPNObjdlfA1qABHvN1snafOV/8xcqexBUH2iZUFTBiSwYUFVP5gvCLy6pK2l6a4huNlFj98+hb
 1CcGlyuQNEpuPF/B12XRe3+G3mcMNgY=
X-Proofpoint-GUID: SZSbvN9P7F-mQt7A9Kks8pxZMBkQxRl7
X-Proofpoint-ORIG-GUID: XZPaD2B7ZnPkgiM-p9UwiVPLnXQIlSXs
X-Authority-Analysis: v=2.4 cv=IruL47/g c=1 sm=1 tr=0 ts=6afb2107 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VIMLV4syELct9QTXEHIA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfXw1d4V5UKaK1u
 5yO8cNEBno8o4gMBlV+NVP8sBOOY+YHGhRQw4P02jKZxdzkroqYp09Oi7pJw0TBvnZn10JHVPe3
 fAjOozB1Jpe+1iFe3NwjYnVcjU4HaLwpTs4xODY4qQrYsQcJ9MUIRXC5xaPUa8wWjGNyBdLmJco
 AoC9XxeKUc+glPwayHvu72W1KdTE9k4MEcL32PipbW4wGoEPsJvO9Tx9aZNI0CHOGNK+bqrAABI
 OOD+iBH43RJDeWUxUAL76+ipy6PImXrQzMtrNxSxcjSfSUSEIJqUotKLKFpcfwu8z+FFr5LTUwj
 zxR2QMAP6PUUibDeNHMVfrw8K/It+QbwmsBD1jp2mRfkGDM2h5I1MLCFARxBy5x55fE0p67LUPO
 /8wzn5aTnlyhM/nmJ2pbpJQWuvvszIrFZ5MrxhUce8L5Xvt3h5yCkjIfMELo7oferL56rEn34Bg
 YqRY6jnZzTQ1WFqTCNQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160061



On 13.11.26 14:57, Bryam Vargas via B4 Relay wrote:
[...]
> 
> ISM pools its DMBs the same way and an old ISM peer also writes its CDCs
> by token, so AFAICT the reuse applies there too. This series does not
> change ISM, and I have not tested it.

ISM does not provide an attach operation. So nobody will write into a
receive buffer dmb after dmb_unregister.



