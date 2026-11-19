Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079219;
	b=HVe1VWfxfgrImqxejFRcKppWdVkIcpjZQkrzP8Y7/cp5mQoO2Ez4dOpt6kOIXWVuQqJd
	 WzYdn1tz8lE+IXJl6fPx67Eyc3A6l9miPrJR44cV58cghjN+TM0aQywehNmvt/hqe54du
	 FZUtWh9Qn5CvC0KOk+iHmy+Ze9Kv++u1RoeGYKL7d5+4Oimnl+RsCq94E5SaQx20DX/bZ
	 4V6TfED0BbPm4BJKmLb4aFQK+o6uAm7/q5Sj/M2ErgnZ4cv78CQ7wu4Db7sup1UE6Q42b
	 RqqBnZ4scw481nwYM8GEvf0phgTBczKBeiGbZCnbdbgp0RvAO+Nwo9zlrCcmRjPIIlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079219;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=frKkoCk6xBtyjbkWcHlzNLhRxmjlYle5oVkeRYBbllo=;
	b=iGC2pxZR13e1yJ7Bpv+UCwGI0l/gObR+XPkj7EwH9FWgeCFnlv9bkXTWDQRU0pNZhUcD
	 nrtX3+dcMrw6wyWiDG+gKH2bRkVyZh9CgC8cU+wO8uZoWnpjINavDVUNF2tHBQATIxpv5
	 cv1PMcKcTWq26w34VpBbu/fH2ch7253E+4ssxyov0Ib3/TZEAIF9b8hD9X7gDIHS3HD9p
	 FGokkybkdt9WQiGIXkZACwPZPDUB4UeyegkiS0EQJbtoc/g4wTMh13Fjq2lZ2JLjMh6nP
	 TW/tXqW/NRCNqxtCVT/vypY9fnHOAq7A/qOB38V8iY8fZA5r907hz88Kr9Ccp8LSbAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=OM0t7dsD;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468A606A32A;
	Thu, 19 Nov 2026 09:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6468A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=OM0t7dsD
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ6v2Xa2237182;
	Thu, 19 Nov 2026 09:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=frKkoC
	k6xBtyjbkWcHlzNLhRxmjlYle5oVkeRYBbllo=; b=OM0t7dsDdtnu44IyAeynrA
	A/9mnCSJWnwkeDUT0SmitmgGs1HTDQXShV4cnSE1sw63SAZZqHuL5gZz6krD61Fp
	E3p3X3I5MupMLXbcxd5VphXGPm4ceyhTURyt0H+eGUEuxR+3gTG40UiQNLpvzk9J
	B154NY4o6QwMkHieAJGkr41BhTaqkqaqAEms3ro60W1x6M5/ZVupPMXTKXdUC+O2
	M/yv7S8WhA2psQINMLauOKyR5pppy+IKsYPyH8pMB6+P1ZY9325fU1tnA8BXJ7/7
	JpMciO0cHyTIReeZ8PGqqiBHfcdNj9voLuYWGoi2w1WXReQiTGhUE4FWBN8/9dKg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105vyk4b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:06:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ74upp472245;
	Thu, 19 Nov 2026 09:06:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j1hd6ub48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:06:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AJ96jkf50659594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Nov 2026 09:06:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54A942004D;
	Thu, 19 Nov 2026 09:06:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0855C20043;
	Thu, 19 Nov 2026 09:06:45 +0000 (GMT)
Received: from [9.68.25.8] (unknown [9.68.25.8])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Nov 2026 09:06:44 +0000 (GMT)
Message-ID: <d0ab5673-9bee-422b-87b1-001dd598d2f4@linux.ibm.com>
Date: Thu, 19 Nov 2026 10:06:44 +0100
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
Subject: Re: [PATCH net v2 0/2] net/smc: do not reuse the DMB of a nocopy
 device
To: hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: AwpY3AtU2pVswCr_74GU69iiNI8jMQDI
X-Authority-Analysis: v=2.4 cv=Z8x5j3RA c=1 sm=1 tr=0 ts=6afebc2b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=R-E7JfZ1IrJ0hd1D-KYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: miH9KQ4BmOzJQN-SkintPdd2ZGfG6ICS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAzNSBTYWx0ZWRfX9Up7iGve2nZI
 KXSRFiGmaeYIR21Ysz4ziqAF9dy2ZhSeORL7rS5sQR1EnOa/tPuQ30GcFgbTtUjxovXN2dxN+HD
 EXuX7BXHqdIpy7wbFI1GIk5n7zoD+Ag=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAzNSBTYWx0ZWRfX4uXQ1drZggN1
 YaOY3x+Nw0JLWqw3vDaxUGttODuzo3qoo7VdCWB4ICzgG3sRi4pusbefQmk/0OMQ03gGQ+xmoZu
 40UoUp1KMPpKvI2KS6qOxGcHHfxpoFZbL8Ine5SN7KFL4ByoKJvb4d084wHFE1cmmPa53VigiGP
 qX9PYu//9MVryeZsqTM81nvIhYIBY8RDz4ZyvQVo0uC/yFtqJVd5Mdo7swi/C6/07WE5jGIMS33
 n7+cqc8h5DicjJhBXVyMcfzYj5W/169ByHiW6wISnT9IBklMf4eDY9kPGBLyvoWLXQky5w+zcKx
 7ugdbjr88N0NlQ0fcU+JIg2Oc5p8LsUuTl0ymg+tisEIS2z6ba5t5eY+rphwRQQC4ljBwewYKgp
 zXl0OS12MqJPz1SuYuSFUQSMJ7RqW9IwVVryZxkSDhgxf6dqx7s+FznJSHoZReqXDzplSHqS3i5
 jbViyXJ2I7+Y2aWCz1w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_02,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611190035



On 14.11.26 20:09, Bryam Vargas via B4 Relay wrote:
> ISM pools its DMBs the same way and an old ISM peer also writes its CDCs
> by token, so AFAICT the reuse applies there too. This series does not
> change ISM, and I have not tested it.

As mentioned on v1:
ISM does not provide an attach operation. So nobody will write into a
receive buffer dmb after dmb_unregister.
