Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675406;
	b=asALvqXdtn6u4mQmdsIiM+Zs1obqfU61tp2y3UlREudPnToNBCwh7/8GU2cSn3fu9xmo
	 Z9a+p44kki08fh1Fk93MwVbMXuJTYaY47ZSCs+6ogRzV5Q69u9s380G7zEsHeZ1pk1S6R
	 eNJEBFpMj9oG21WIOee22iErduUeCKrIuhkmsKwIXh4e7gGoJHg/BeI9nR4XY8vN0QdRg
	 X30T/NxfQoAMUgSYo+skb/LqR30n3ZYd2LsK1PfjiTJt/3fMAy1xmxhHIXYjLsHP9/HFX
	 ftLLvGbWrxaUA4QhR6vzG3uZN28NIwd/Mfs90rm+we2aGGRyuipidMszx/XuQByA6XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675406;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:From:To:Cc:Subject:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NQ5ulUva71qozabDWPdGe4qbUf8QtiMwnQp7WoVzIGY=;
	b=klV0eJ4rDVPUrtQ6dr2Rj9mzh/n2Suc3/6YYs0eGCAnHZsj2d/5GdtXFu7etKKSjvJ+t
	 5JgIXzlRTQMllE17ZJkHu/q9Z27iON/F2JjvgBWvNWi3phNBV+olaPNPBb8EHCzw/MbX9
	 aK4GRWWKbSagJQLq66MEaH+ZxBChWPRtbFYjmNqv0URs33cMeSUHJOKKDwX6gwKFfhPug
	 jp4fCt65hP20aVtaafFoALd0jLGlcs/rbE+P/oBPHLz+WoLQG2cbzXh09JbOSfbLFKGcz
	 bNLdf152J+iPsgJrFo6aewPL/sLjUvpc39tRcxm2ed7Hudl2pT4NH94ZIPOd/P9hYSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qYninGgg;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEF5606A334;
	Thu, 26 Nov 2026 06:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FEF5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qYninGgg
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ3PRo23182023;
	Thu, 26 Nov 2026 06:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NQ5ulU
	va71qozabDWPdGe4qbUf8QtiMwnQp7WoVzIGY=; b=qYninGggiUX7lxmaQCHBu1
	7Iov3/e/DsCc5fcqbWm/n+7ysIyXzPd57Hua7ZdZ1QQoXfeAZexf2z1QtXvnHRrW
	4AspzDSWRYy/kz/j9U0tUUH7ByExOoZMHGWqmFjbicztR0drEJIrKF9aftizAGs3
	7wudeMF692jzIyTV10w0ZbfJD5z8gXYow267tUT0Eacs+b/rMUaLSV/JpsUZ9WRs
	V+rYM+JKZFpYtKyRRtk2cR6SDsvX8dPXXlQ67ONENCkEMFyyeexunPtiLhCH7fpF
	FF7KFXH/ALeRJaxWdVJfdJYiKW8przd0cEdNxAoZGV1gAXar9qi+Uycc3rbOk1mw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1ff9c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:43:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34V8i3117327;
	Thu, 26 Nov 2026 06:43:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5a4172b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:43:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6h7fC34734478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:43:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BC6820043;
	Thu, 26 Nov 2026 06:43:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 610AE20040;
	Thu, 26 Nov 2026 06:43:07 +0000 (GMT)
Received: from localhost (unknown [9.87.84.240])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Nov 2026 06:43:07 +0000 (GMT)
Message-ID: <366063ac0493ac4f48df9947b98d6613@linux.ibm.com>
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
Subject: Re: [PATCH net 3/4] net/smc: fix the failover catch-up across the
 cursor wrap rollover
Date: Thu, 26 Nov 2026 07:21:38 +0100
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-3-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-3-4a7c8d85d849@proton.me>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: FRyLn_iT59iC6tUR_cXUELJ4h_rLSLkf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX2PSDSLzUi3Na
 NgZVySzz7dVZP45kxnsS/p+J51E8nw04FsNyPL9PI0nsDfITfSt2aDT7tBGOAaOW36l80t36Nqx
 bFW7cuUGT5DzKWX+Vod9FPhBw6YXerY=
X-Proofpoint-GUID: Rj8uPu4rawJSUz-imcI4oZGujKj5l-Gc
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b07d502 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=K52HgVM4_llsbcdT-toA:9 a=QEXdDO2ut3YA:10 a=QIn12Q3xbTMA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX/1Vh4QpaAq+G
 jMcnoPfjOpTho3Xz1LhKDscKTLzqNlhh0K3WIIhgX56IXHfk82cPXenkZeDwNJFQ0Jha9JpioEY
 NGuYf/ZXigOwcU0hYvFrcyS/VLGfrYw3Uhse54IzHBZQg7DEHA3SLjnNIsoIIEkxYjcBOP99PLT
 cd5WZOFU/1RjVHL7tcSOH2HB1KfAvHWoNbTuh7TSEF28gNJidVxU7wpJ5dtdmh+tYYzVDim/U7e
 Yj6qNBcI/1FQkzPXUjjOeE7fGS3HHynxqVDBx1ZhvJfc55HQcpGh/pNX1AWzZUCatvhxArP7HFV
 mqL5ZDwrh/jtjeQewPRhBpNpr6TTkSa2nZgee4FaTlSsn3bu9c7JBkW1nPpes2rN9KUXfyC92ta
 M55P7jKS9Hl/bnCeZ38/Tt7RRzGwPBDyWrFW2RyFSHw9eEtzjs0BzRkL8E9eBDbEQbVCrIpivtz
 ajkkPrO2obIyiVzNMew==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260025

The review comment on this patch looks valid: clamping diff in
smc_switch_cursor() can leave prod behind cons. Please fix this before
reposting.

Link: https://lore.kernel.org/all/sashiko-outbox-215219@kernel.org/
