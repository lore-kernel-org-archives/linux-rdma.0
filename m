Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3B13C9893;
	Wed, 30 Sep 2026 08:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790757205; cv=none; b=EpsLDrOkjJ+Xl/uIOwKOXe9pE4+Fo15jP9w7Vkyex+Z8O+VG8fSPD9tRESDxHIhlUm85kXB5dJD4ykZqUzLUaAwQx/ySR4gPO5ei/dJgpioVrzDiickbF0GM9fvp4+OJo+ye0mbGetdNXQqwOSj4PhE4ahAumt6sQNfrUFOKStc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790757205; c=relaxed/simple;
	bh=2P+24IJ4tpNgAKjcn6f2qL3ldLRiosZOezOINslhyLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bh1wvZroZd8Bz0q/bhmILR8otVfufIETyoangEh8Tq0NsQ6dUvlVQBDvmsFSmFNMsMvkUUH1ibze76B3r5Z9tbdI37sXmHbV6AdyCiK7fOF8LUPr0j7uFGbBaP6B33+XTv8LCJVY/jd7i+/Nrh0+CaIGdHQ4oscTluwfYAX+YWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k1jzxXn3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k1jzxXn3"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7bIUN2374473;
	Wed, 30 Sep 2026 08:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HVozmJ
	Ce5CuqcxQLM5wK3UMtL4EPP6p8ko4dfAm9314=; b=k1jzxXn33j2hLp5pKSFzI9
	WnHSml7tpLFG+qQwD0tNbXAYO9CtDnFHqqRn6SNBvlL4aBY9TcPIoGRNYBOAFsjM
	hAE460gotG9FcH1bDA8nxkqo9121SmZ/DiaCBTN0pILrL1DOZvikPv4dDTujIb00
	QGbiUwe8uYu8WkWD/tg1RQXW0gpwncHaoktrqw3U58k1mDcmDdPRm5Bam9deTYj9
	HAWZ/m9W8QxR0MavAV1NKhGlnL0/HLVl1+Oed/LkcVXqaGRGwqsGmVngayqp0E7Q
	3XYgy0vl/CMYcWHiJUZ+EZDsQSiWlgp/JfXEDUMCV9MzjhAOkbg+1i8VkpLG20jQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5s5bsh5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:32:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7lSkZ3082971;
	Wed, 30 Sep 2026 08:32:49 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0hfpawvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:32:49 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68U8WmLa25297564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 08:32:48 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0216B58059;
	Wed, 30 Sep 2026 08:32:48 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E98285806A;
	Wed, 30 Sep 2026 08:32:41 +0000 (GMT)
Received: from [9.123.5.239] (unknown [9.123.5.239])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Sep 2026 08:32:41 +0000 (GMT)
Message-ID: <50193f2c-1a18-49e0-bafe-bb0916b14b72@linux.ibm.com>
Date: Wed, 30 Sep 2026 14:02:40 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
 <179075363052.31693.7276499571222525560@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179075363052.31693.7276499571222525560@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDAzMiBTYWx0ZWRfXzqRJ1c/eD2Aw
 ONpwLwYv2YIZ8qEM6Otdc5kvACXXJa+SklTMgvfSaMF09v2AElHQ0zbFK2KKm7/bk1Fp/CN58XQ
 0Qpz5i9cvXBrAZWVd8eOQJ3iyJ9X23s=
X-Authority-Analysis: v=2.4 cv=HJ5WhYtv c=1 sm=1 tr=0 ts=6abcc932 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: kmSBDthRuDHvReWlkysbDKFOb5_HZgDI
X-Proofpoint-ORIG-GUID: LzYPD1s3SJgg_i5tA7UbtwAY078vbwH4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDAzMiBTYWx0ZWRfX3Ed8xY6fScHp
 A1JSgOcPp5Utu9KmkW9pN//i0icZvWixeltkmqAN/tp1lGyH4guHj1tTGC3fSKt+KfQbE9ilew3
 2RZ/+1LZ9Z7xU2VCT4cJx6JKsznhfR8iGzka/T5YHa/Z39bz7f4IRt/ABXY0YAEd9e/zx8hOcMl
 Dek3AQWNaXDiXXTwNYwnn1aE7XumIfu6mJl+ivFvUmWfL7ZwXEB6WSjeX56RKPgQWS4ERmKiWUT
 KGXQ/8/VCl9FfSMjPezYbl+36LSpdgy0aWXToFHxASXmbAG3Wbczzo/qEslkPtdWrsD4JZ3q3D4
 xg/jP7AKvAUunnPydweQI0rP+gbsS/s1Ns9K5Fk8mPHuGo5Cv0YH0QasO2zKGQOSp7Mh7qy/f/C
 88uWQodB+QKRVIuYkKIXaNb17kz/DKO9TeUqbAK45F5UkEw+zSEgB/akbgKeTr8URIlkGJRq0k4
 mJ0Jv281EMxbxpvPreA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1011 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300032



On 30/09/26 1:03 pm, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

The issue was found by manual code inspection while reviewing the diag
dump path in net/smc/smc_diag.c.

> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

The races are theoretical — none of the three windows were triggered in
practice. The smc_conn_kill() / smcd_buf_detach() race requires an
active smcss poll to coincide with an SMC-D lgr termination on the
dmb_nocopy path; the smc_close_active_abort() and
smc_close_passive_work() races require a concurrent diag dump during the
narrow teardown window between sk_state = SMC_CLOSED and
smc_conn_free(). No stack trace or error message is available since the
bugs were not hit in a running system.
