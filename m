Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675202;
	b=WR99iIEBRwLt/1CzG+crrOQcdEUGUTWO81+WWTYT5Ut7HuT57V1fmTBM4+zkMHkvEyvV
	 k3Mlv5acf0TvDYUNio6285yMTUR7lE/0jqoqpAM0lUBmA9WTBgE7NGEONPuMfd83j7OEr
	 H7aAUjoncEw/y+Js2pL2UzcO8jUeD3cjGcadGh81rXI6yKFIvkoDkPu7Fjkrk5pjVIch2
	 eMInfqBXO1DSHmX8gDaQPK0QLj73DEVXWDmAvq70G39ImkY+QsUhdG8mJacvlVyY6en5W
	 1oLzSjcyCrnuo4wOZxzXtgCM3UoEXkxxwDjfyaLQFo7Ae2JBYg5zRoFe39hh2QXrWSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675202;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:From:To:Subject:Date:
	 In-Reply-To:References:MIME-Version:Cc:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=kghJMKpjCr7I/O+cDkl9XA6c0C/krIlaFkrGrw61JTs=;
	b=37GcADGmU9bOZiX4096n7AndN/yHwz+od4iobfMNlCDnwgl+MUyRd/qF6d02UeiNdSDr
	 GdL5u/dHBgigVnRASQmSSvZCHjYTCVJFeI0PHb8KMGU5VPLWWucSE8ukp70dma+u3Q3+3
	 ABaBfo0olGiNwE1ymQjf+l8QDWBUe8m3kgEEbgSmyMGLU46rCGgaT2OlJRUFBv1k7PHP7
	 nJhmQuQHK5jXiN+E8otQGQiFiFTCxm932Yiy0RFLm0s/ZKVTx+1UYzHRpxKWIx+sJTMZ1
	 E/87VuW5J5jVYeY9beyuN/4u0TtGGIdNF3iHlixFhNNKQQX39odV0krIEKo14hZGvRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XqA37Nc2;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131F4606A31C;
	Thu, 26 Nov 2026 06:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 131F4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=XqA37Nc2
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34bYf3281350;
	Thu, 26 Nov 2026 06:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kghJMK
	pjCr7I/O+cDkl9XA6c0C/krIlaFkrGrw61JTs=; b=XqA37Nc2YkPcEg4XceHwNm
	ahHmPvU5X/aXcuEuw3Fu23n3EkLOcC+FYiIYvSusls8WbL9vLzWyKIAgkbOli++C
	MzUrPNC6ajAIHBlRPV4zt4vCDZhZcafSRODqCvkHegAfAgzvjIxrmRh88s8rxT1O
	hmeOq9aKv+xkG0rJr9jMr0zd65g8N+p/iCuDCrbBZYHWeCdtX9OW3gl5TZE+Ag1t
	HcKzgTq3UiNQtrrQ5olDKespaCQjct39/5SJEcQf4Km9e+unt5ayWXtoQasDs3hb
	D++LNwf9iCwB+E+sZKhRot9CqlVL0YaBuq9dxaIsnR4CzzHEQf26uERCRU6DZ86Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fag2p2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:39:52 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34V8J3117327;
	Thu, 26 Nov 2026 06:39:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5a417249-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:39:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6djcM41419246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:39:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F66620049;
	Thu, 26 Nov 2026 06:39:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62D3B20040;
	Thu, 26 Nov 2026 06:39:45 +0000 (GMT)
Received: from localhost (unknown [9.87.84.240])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Nov 2026 06:39:45 +0000 (GMT)
Message-ID: <3e66af3fba5b4744b099734fe5054e6e@linux.ibm.com>
From: Sidraya Jayagond <sidraya@linux.ibm.com>
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject:
 Re: [PATCH net 0/4] net/smc: fix the failover cursor switch and wrap rollover
Date: Thu, 26 Nov 2026 07:21:38 +0100
In-Reply-To: <20261123165127.2453df54@kernel.org>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261123165127.2453df54@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Cc: Dust Li <dust.li@linux.alibaba.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Eric Dumazet <edumazet@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>,
        Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX+i3MN2/IYO2x
 eZs7AwOIujp3JYO6tqr0R1PtUkIjjxxY60Ur4SIygyZzbMLI+iR1pBasrrDq15xIkSFcZdVJUSP
 XGUhBja5kJDU6+uaixxVQ5iaAsHglvl6xsRVVWtzIvVhJJRUP0+iZJ2K7eV+sSAyHRCs+6Gcvit
 G6MTt3R1Gx25kzbanQJlragvxu3Zs2Rkf4Wk1BXreOAHY25XXgm4w3PmE8W8usgHy+0E7UXYOUK
 RosWB2P6A+SMvwEnMoqfD3sHprRB4Hl+/6lGIgOeLC69p4egPbh+0oeKdi6HKVVd4aJqNu5rQWj
 kqDPisK/MaULRbMk3HtdAQNefTKUMySWyf+d9G8ptq2kaIX3bzQjlm7yBwZe+AShCFcEM1hf8pH
 D+B2MZmjaQTlt8TxtPLu5fIjshBYp7ni+eT/NZ18z65ONtUE9096hFkTUOulnTgYmUeZTFkze8x
 35vzuYTtoDt2DD+NyWQ==
X-Proofpoint-ORIG-GUID: PpNjQ2_9MLtpgmh8BxiiC9b4MZT8fA1W
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b07d438 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=GVtuyzs1sv75qvV3u5gA:9
 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
X-Proofpoint-GUID: DeWRG2scOcnjWXT9rZGnnJC_ad4YkjXm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX3DFxXlwFIknq
 kAiQQuQbIPECJD8I0AyqxXVr9MAzcYvclucpkpaP+IVMJIMgVUPlU9xWFdjCLve+h1TzZKDA0bn
 XZonYTNiczdZmr3bI8JKeh2JFQP6iks=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611260025

I am reviewing this series now; please do not toss it. I will send the
per-patch comments today.

Sorry for the delay. For some reason our mail server was rejecting messages
from the kernel mailing lists; it is fixed now.
