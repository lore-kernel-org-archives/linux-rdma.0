Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675413;
	b=3o9R5YT4lYvW+fwi7Z/acgeXJRY7IY1Mp0Sq4gU0qWaq8o0tm40qywDx/Dv+LypzYj7a
	 MVrs2rZasVb+LcWZu05krX6ORzOx8UBZEYK8Dmgv59AmX4IaTkb8bPX8lyOdY/LBDihfB
	 PZcJRwrYpqPqWI5xtcKrAEyEL3jpxSJEQ4WeIDi7h3KVZ110F4odpXF+ZkjA0+DVwNNCw
	 aVwHT6YthLT/sos2jE10m4+gFNeOgCf492M5JZ/RSrM1+fiwbnCGG2DBZuq8ne2E10+HN
	 sZLZ3mCVTFxvOFQZaA/lEN5n+wIQttPZOsoyaLkVUEEdtZLqftTnfASPKtJU/hqmnCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675413;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:From:To:Cc:Subject:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SahhETQ9fW4zv6X6m5rrXzRwkvqyUBuhxZ8WYasoFRM=;
	b=hmkkh7rI9XLcOJrUV5Pz/Cr5EOVeUyHPARPHmhCy1vwFHmivUhaPu68Z9rUNSXuUlWMp
	 zt5kDGZkMECWuGkyolzwQR/qCAS8/VVh1NpzelMJ5i2W9ds13thWTmbAR8zuMUdmM4wYe
	 Hfb/qKRluIYcWULvW1UBgE93fPeqsy/EVj0YoiPvWiyFPcDWBrrdLUykXjr8Wy/Qoy6Oy
	 zaaKysiE6riqNeyI+Db3G6zhOblIlmAFXVpVwfcnQE0blJkofahv63ui3YfosYnQl+/ds
	 2VmeMwDCWWj5i8p8UEKLIHiIP/rDMFxBNRDDc2eVXluX/D/ClqJ+ZwBcEoM28rNFo1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=WjS0QQAL;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF654606A32A;
	Thu, 26 Nov 2026 06:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF654606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=WjS0QQAL
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34xVI3133827;
	Thu, 26 Nov 2026 06:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SahhET
	Q9fW4zv6X6m5rrXzRwkvqyUBuhxZ8WYasoFRM=; b=WjS0QQAL19ixpSZ3g0LPVl
	okcHi8z9Y0zfa/3T99UPMOzLT5cAi+1sGAyPzuSGur6GTQGoU9ztASlDrujETtNr
	zFGeLD4hOZriFQ+TtLewCv1jHsUMXslBoI4UGBFg/SLh6YOuaKz7Qu41O41tmNOI
	4UjjXs556YZP0taa9ZBUoW6F+QeMAj19zpYh0ghJR1+URfanQ8csblNgVir3CXbv
	m0tD1/Y/m2YgKjmOhLIUP3317O6lKx5pUesbgtcebWK2CozgO98/CB1EJRc4e9mm
	9+EIq2UnCQmWl6zwIykyjDs0rLvcU51M+lRnHc8gE5EcXBHU6bIY8ahJibeGbRzQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1ff9q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:43:19 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34PNP1635236;
	Thu, 26 Nov 2026 06:43:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5axkxwk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:43:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6hDeR50135440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:43:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7377D20049;
	Thu, 26 Nov 2026 06:43:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 572CF20040;
	Thu, 26 Nov 2026 06:43:13 +0000 (GMT)
Received: from localhost (unknown [9.87.84.240])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Nov 2026 06:43:13 +0000 (GMT)
Message-ID: <c769cd79c084c38804b606cbe0b0d79a@linux.ibm.com>
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
Subject: Re: [PATCH net 4/4] net/smc: order the urgent mark across the cursor
 wrap rollover
Date: Thu, 26 Nov 2026 07:21:38 +0100
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-4-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-4-4a7c8d85d849@proton.me>
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
X-Proofpoint-ORIG-GUID: fpQNmkJofKrA5nRgjrwYSZ8nnjRp-BTx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX8hqHeVkqYTw+
 bi6cppshvZX2R8u0HAs/tZJDz2DAUclpzS0R/ojBoTotSdpT4YsF6bbiZ9KXVuplZ027oFQ7rcw
 KyjzuJPfcfy1KRPqIN6i5f2maVx3Xsw=
X-Proofpoint-GUID: HPMHrlQKQL8wqi_-DMUXmUw0YgPHRma2
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b07d508 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=NrW9tBCdj5waY1ZTGhEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX45wUDf3iShgs
 B0/ddg8NtO1ODDwwPJqf478y1yQNN9aWokvppcYxmRLbC+MMoHBRqYgYbGIfBRvgedDVTnPJwDK
 cuqTEk//Pji3m5JB/c2If6L5jTjAU/tRv++tOBrxEL2SuNeXwW3kAROl71AhGsqgwO2OKuMeMNu
 ljIMZuTqD6KsO6qMtRh2ZJ6BCWvWkL7oE5mKP3BMSIAjwsp6+FLadClwyjJR/YJpmyt2rcWTwT/
 pA0nS4qOkwErva6/qOz4StvSVIoFIDHLEpI08MapbkuyiCnryWvmuNYxe/7XOctuuTmdCFcUeJ0
 7Vmz4HmuUCDKA+c3yD1/L6/93L9MzoZrjHut6Ix1RpXPCUVvJKK12SNxG7mcYH2z9KG6dGixDT1
 O0bZHChaRV01e5lMBRJ3Id5MbVACa1tvAOn+ALQyjSRHU5ePN1nR4IwBGfsWLMbxrejld8T+UgO
 qAjlhDE0nbMD28j58Cw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260025

The review comment on this patch looks valid: smc_rx_recv_urg() can race with
incoming CDC messages and duplicate an urgent byte. This is pre-existing, but
the series touches this path, so please address it or explain why it is safe.

Link: https://lore.kernel.org/all/sashiko-outbox-215220@kernel.org/
