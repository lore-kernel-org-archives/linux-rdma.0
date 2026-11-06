Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970398;
	b=q8XTY6ynXs5QcCmUoOfQEdgGopcLVJ/jyPq/Q5/BTi/ocFPpLOX44E325MeG2/+wzC8I
	 sDDz++/dPJnJYGYat4hg/ByULfudk8SwQg/TBzNiQ+VKopQJHti53PIBu5bEUagrD1HPL
	 XndE32Ywq3YDf9/e7pCCj3FMw/f3hRt2A96A/Jd6LFJbTsGB9v55fphTdKmDvfMVv7ePB
	 k2NcvdTIiJ4JwtgTY2jNr5EERU0AMPjnhfJ9gwsbLomB9MU750GMtdTkZ/KoWGy9BXqoc
	 lbSBxEUs3C1n5bycbhJZpkShgC/d4fFVmJh35i6PLv8HNYW+jR2nSfyj0LKZoPdOl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970398;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cLXbzEM6shYhqrlETORb4D9tQ03r6mZonOGRycpaavo=;
	b=dkwir3ZAUp6cI4Ffx1mqqUHjifLvaKrYKPSzlMFWvxlKcnYIrsfR2012wmRxDfptHcYb
	 ih5JYPwt0svvJXoWiHuyg0rOs9k+Uq+f0z2KUW1QtMxuqGJYrotBqSA2Jwv+VvVqMDGDg
	 cPGuiII248hBoyWGaw5d3tDB/86N3Uor+7LO0TBJ1OBt87rIBAExeEiV5b2VeQuBQbC95
	 E17Rw79v4BeEnZxVu0Ql/khIY8mZv5fDMeeEKsihzBXnHhyviMEmO2E/7aGWypW/jPSJw
	 2g8+ExSjEeRrZawmsom4s4LDhd/trPfcTCOU3kytOjFSfD/Ld1KnXQYFnyI4bUXbllg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JQU1DmZy;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F8E606A326;
	Fri,  6 Nov 2026 13:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24F8E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JQU1DmZy
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AicHG2090175;
	Fri, 6 Nov 2026 13:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cLXbzE
	M6shYhqrlETORb4D9tQ03r6mZonOGRycpaavo=; b=JQU1DmZy6ZcgAbH79GqqKy
	Q0LTi2E2cQ6jWX68R+R5cY8z4wVcvGIgzOW0ykP8BwDAYwU5qjjN+AJItPGHrpf4
	iKR6Tfc9wiEq8K804A7bEbUdLhda4I8Rx9yy6lE9cb7YBOxfgo/LFcMH/o93aJsi
	1HF9ltRHZ1QkdcrwcdKrHJ+CbXODwy3aIBEL1aAfdOuyCKxBOqu4pVLPnJKcJmpb
	Hnx78/6fiJiGTruc8tZvvXEKuVvnvN2ZvbhZuBhhlFrajS5BW+CgC0fKhnjFViWN
	4rJTb3e3x2xkpOiYrbMtk8ZtDgl56m8BM5qTqtX5wJcgSsBRtXV/FPoXuW13E7qg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hs3rc48c7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 13:06:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6AYxF93159704;
	Fri, 6 Nov 2026 13:06:30 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hrmrerqk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Nov 2026 13:06:29 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A6D6S3e25559798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Nov 2026 13:06:28 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7895A58054;
	Fri,  6 Nov 2026 13:06:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2186D5804E;
	Fri,  6 Nov 2026 13:06:21 +0000 (GMT)
Received: from [9.39.30.115] (unknown [9.39.30.115])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Nov 2026 13:06:20 +0000 (GMT)
Message-ID: <260cdfcb-b89e-4f09-b188-1eae60d7d76e@linux.ibm.com>
Date: Fri, 6 Nov 2026 18:36:19 +0530
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
Subject: Re: [PATCH net] net/smc: fix handshake abort on a terminating link
 group
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261103123955.47454-1-mjambigi@linux.ibm.com>
 <179392563025.994134.873801434242167831@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179392563025.994134.873801434242167831@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1MCBTYWx0ZWRfX6FjLVMTeKvi+
 Bnmw5/Xd//UTjBg3Z97ZSrvZP9AGy9LVf6REpgBzrHW/xnSZ6AzMaXG4DiRQqOHTU3X4qCWWJ0u
 YiYItyeEH50NaxwM1E9dZrCsB4cBqMs=
X-Proofpoint-GUID: cbN8eIfA_kwf3MDkN8hzaYc9s6OGyvlv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1MCBTYWx0ZWRfX0HlV/xmjWkkr
 ia8fCqRxBDhr1XGr7L53Q2pvLHTmYOzYjW/sUv/1g7TYblC1CBx6CPFJqkpnd23wGWi9x9EX7YE
 15tq6lqIM0ou/fMT7FS+ctmNKoGClF+xkoPLMqqLAsVubdWuevhiO9eR8+2wa7REhf36/F0XDhn
 yPofqipy2E0aVUsQ+o1vnre0mx0b4mHUhHrbHXF3M1vuDMay4f55KZweqVCK/30wMgdmC0fIuJF
 iSvEv27Bp02HyxQLNdwtXdtfFazS8iPABZ1cc+yd38psPoUIQgZqF2nW6cNIp0DaSwVxt6xbKek
 cw7IXb0HGMIjTlQW7FOBMDyUFVhA/wqAtjXBGnE5Xr8oBV3BsgCozNdlNFHTGksWqe9DhfgXJ27
 AqvCiQE1fMc0UTJ7YEfS5DATAL/MyH1IaopRhZcCtatqOVkCcZb2RO3N2lCOGohxiV3TGR6N9qh
 tUl/NPrDmAPLlBhhtrg==
X-Proofpoint-ORIG-GUID: GnXBFNR191AD_w5bA3bKpWnUtmQCSkiQ
X-Authority-Analysis: v=2.4 cv=CY+dd7rl c=1 sm=1 tr=0 ts=6aedd0d7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=a-hTE-MRNJ52dIuAZL8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_03,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060050

I will fix both the issues in v2.
pw-bot: cr
