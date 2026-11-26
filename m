Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675400;
	b=jtmaBPjN8nIKnr37RIVvGF8FM6c/kdLvTZGJlcWDda9tOLsooMo7YVGPYM5XToBk1d74
	 SvrCOe4QJ42pEK71h4ffFTj3H2a1miALFCJpqxM+solrQfjnEiOuNhfhIDoGb8JOVg3Tl
	 y0+DW8ynPNvFm6YyBkkegZYYsHjLW4w1hfzlGonySC8HS3b6vVRnsSRwK5Y7R4CxhxbxX
	 8/jpx0dZcSx9pYd8efcYikNUxbquOes9RBm7OYhUgI4D78CSZZJ+A1rLhC9J7t0GRdxVN
	 w8oSvoFDuIq+BdTJMkEL+5uzhRbTlPIKk0OVKCFXpqs2AbX4XAyfADgB0dVcO4i7yLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675400;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:From:To:Cc:Subject:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Kw9FYGMoWGha+atXC8tXkrwTERGaM0lIewiTNWFke10=;
	b=mGyq3EXIq/DMS/H3OIagXLorEaMThZ3yqEhXu2WaDJpE3sNcg0kOf8yMdZy1QpruK1WZ
	 2fiZQOclPLHZJKPsuoXfkwSAxD+kdsXpIO28Et1GM/oKqdbhH/CxON0pSvCzlTJFLOQF8
	 lteKaaDJi/b5TsCCNpCl/kFn7cH3X+pTn4AiDosjRHQgyamT6QSfZu6KGzSv5m/kTLTlu
	 769N5gUmNfSBMSAP84XC67CGCnHP9oqKpCbgvJwNwAuR2jmA0P12E2sgXnnJk4HtA+6MN
	 Y15EWHw/VKQTUp+NKZyAow2pcA5cbEqzYOIAz+099tRy1WMKbTlg2iWpoAMeG1FKRXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NObQbStW;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45817606A31E;
	Thu, 26 Nov 2026 06:43:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45817606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NObQbStW
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34qv03281780;
	Thu, 26 Nov 2026 06:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Kw9FYG
	MoWGha+atXC8tXkrwTERGaM0lIewiTNWFke10=; b=NObQbStW4cSKOQn7Mk44DU
	OxJtXU82uwRslC6oLJ3Kj8otwIFLxG1qgUzmbQvhkT3Bj1wZvT8NzrR46YBg4xYA
	sOkE3pjXaqkhVyO4v2+3TqpQe1PuOZTHmt13Jbfywd5TTYBA8dSEpRL/CBoJks+R
	sjJGJAji3BC+2xQ7in8HRFh7n0PH/onS6ZnyluMwVLkgtA6gIuCH/qf8qnETDkhw
	z0Cx5oEqXaVoMtvhV3dYIDp+C6tYZmR8RxhpFeNUlTNrEFmuUrxXXIVMeE9jPkV5
	MrT/p4oeyR0jjJvgIRy1Xf9VnyU4iBPnMZ4bKYTejb2KQFHju5TF326R4sUVQxRg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fag2wf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:42:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34V8g3117327;
	Thu, 26 Nov 2026 06:42:55 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5a4172aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:42:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6gnnM25232030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:42:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AB6B20040;
	Thu, 26 Nov 2026 06:42:49 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FDBD2004B;
	Thu, 26 Nov 2026 06:42:49 +0000 (GMT)
Received: from localhost (unknown [9.87.84.240])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Nov 2026 06:42:49 +0000 (GMT)
Message-ID: <83784e4c2e7a0df1e16a791dfe588f36@linux.ibm.com>
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
Subject: Re: [PATCH net 2/4] net/smc: do not credit stale CDC completions
 after a link switch
Date: Thu, 26 Nov 2026 07:21:38 +0100
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-2-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
 <20261113-b4-disp-1a9ab9b0-v1-2-4a7c8d85d849@proton.me>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX4EImtPN9XaYR
 3QGHGtYo4432MqGiK2TDsliT+BJAqyFV4YoEYVeXsUckTrE6dHEmMFuaJ2301QZVWfDGl6jmkJ+
 dgAGvM5qnWmVV9Py6iAOIDkSpBSomVq0L3vaAx1Eyu/mE1SEX3TGW1y1wTLWKV03tzimbBee+La
 I4s31WOGIJUjVJmbjUI+4dANXQwHjsRgb2ic/z/eb0nq9LwZffpp7/KLRKFCfvZ+O3r/IHlyyks
 m/h8npK7QiR4IJ6Y9NH5jaYAzAIVph8qrZW3iTfMu2z+U4ndyIKuyUzRS3rIEuYE7sXVsshVaT9
 Z12d1JnW+wxgE8V6E/JKiQnJmICQvK5/u/ls9uVLX9dXLceeJS8yxd5douY6C/TUlXOv8iUgZmU
 ydCZW9r46p4Eb1mzgMIrp9Q0VpnA79rqk5yWKihc8+90qM0BAin5gtsCSwOn5RnKJ0Qa2YgJYL5
 zRu50OMhwmpXMNEucBA==
X-Proofpoint-ORIG-GUID: tn8TYgHWZ2BCK9yM9ZstpJFClP1LMqUA
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b07d4f0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=gNxIf0SVXD2PMDUOH5gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Wluwzk3ey7rcEWtlbJEWohqLru8UHaE3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX96dhDU+dGkZj
 Iq1dCjCdlSop1hhSUCMqsNZ3MTSxSuHp/yH9DMvbFhou/YISPhpra1G0vlE6DYBpE+vIWMM+Uqb
 CVPczpnaVODVCzpS2vfP69JBZbz1J+0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611260025

The review comment on this patch looks valid: smc_switch_cursor() advances
conn->tx_curs_sent in place with smc_curs_add(), and a concurrent reader can
observe a torn cursor. This is pre-existing, but the series touches this code,
so please address it or explain why the current locking makes it safe.

Link: https://lore.kernel.org/all/sashiko-outbox-215218@kernel.org/
