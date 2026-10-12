Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD3B46A5E3;
	Mon, 12 Oct 2026 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798583; cv=none; b=cXOtXok2V8HMVjt6ejQNS6ruYXMYVuX57eGu7okUPqD/SdtTLPfLyI6gXReywd/hkATUs1OKv6F+MF6bdyZWgKie7O/4jiBZNwnheUDkoFU1A5yGumCs1k93JhcxT+t3gHBAkDe3M+EASck2dJP1gWSCeRnkpkm9NGRL8vSkiQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798583; c=relaxed/simple;
	bh=JSrO162Bb0xVGY82I6TqZjOWNSQgDe1p/FuUG32frlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRfRMTw4eg0d9Cx/ZMf3snCy7OFGP9TRoUZD6c5rx0Tq6UVo05BBBG1vJ0PdbhC+/V//SkSZYdvim6+RRNFcMs1VTRs3UQqsIGtgjIoIPohpd4iE0avRtGvDQVbT1OphFMY1SR7oS7/sm/xr3VsdBhBdIruZoQN2vO4lC7ipriQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eGIHhL7e; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eGIHhL7e"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69C8iMLL2750236;
	Mon, 12 Oct 2026 09:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=yWvg31
	cmrWnAjP2Wz00NBC1QFW9PNKonLylsY2mzdeA=; b=eGIHhL7e0x0iI3v9aBt57d
	hrYh4W14NOpNG2QAIif1jkPBwxaETovTFlApuebW799+kGWpAcQ+dKI4+CsyOFpd
	gZe7h/PFxepQOVi6rveoBo1/yGQOcgP6D3fG3qFd4y7wsDnXjbBZE3vEeVB9GXp0
	JmXbaB61xtwJttII1WXLhG9SLIyjWeq/BErU8R0BLG+UeDWba+swF0Snk15lfT/G
	BqBv4/p7MA7uMk7TSMzz3Cl/I+6mTFmRMDdOa11oli9Z8+NOi6jo0zLIIOdsdsbD
	SEys/gqeXXMRq+z/HSkggZyy/t056Cp1GhntuXeJPNcWRC/ekmIQ7Tmak9jYy8Lw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dv07wqf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 09:49:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69C8K3NL1013624;
	Mon, 12 Oct 2026 09:49:30 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h82cycass-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 09:49:30 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69C9nU3h13107784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 09:49:30 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DD97581F6;
	Mon, 12 Oct 2026 09:49:29 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B3AB581FA;
	Mon, 12 Oct 2026 09:49:22 +0000 (GMT)
Received: from [9.124.213.153] (unknown [9.124.213.153])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 12 Oct 2026 09:49:21 +0000 (GMT)
Message-ID: <8af035ab-fe01-4ca4-8f39-6a409127d915@linux.ibm.com>
Date: Mon, 12 Oct 2026 15:19:20 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012080034.38770-1-mjambigi@linux.ibm.com>
 <179179225758.2527009.15422843250132893660@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179179225758.2527009.15422843250132893660@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDAzOCBTYWx0ZWRfX+PbO2ah4xNx+
 A5Aq60JZ6kdHydakK4Zg6vyl1tRHadwf1Jr9xm4pgTqvnhC4B8UKwN09T0ZU9RpWlAQXtkPJjy4
 RzFC8fN3w6iltxC23GopTDBRKDUDI52qYwanODuPGe5fkNkxojtWIyoSOLMWpg+Myol2oZkKMgk
 DEmcCSGnsoWGVk/3BboyONa2zCYiYjuYsKFXI9UpeT+DuUS8jdO7nNwhuBgvoLWg5gJ77UJDdZD
 tDFPq0dco3CxO+5+qbPfD0Sv2XvFcDjzqZ3ArV0TdL/zeO7zwVL2cxouG3zCDKEeR4SDzUmunXa
 0YN4KYGO29tvi1f5Y9ndpAno4AbMuhLQpv2Mnm/dE2RAydfW6481buC1k8ISmNpMCx6ivXXKFXy
 crX5pszzeKiHInwAOgcMY/9vS0Jpre0A6bq4MTzVGvHIcDc78UYGcRwn7wmQYSktnTw5zYMlGkP
 iobEOUmF5xB7U12Ct7w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDAzOCBTYWx0ZWRfX71zX/M//M6qq
 CkxGghcfMhuAeLeyNTZT7uWNaNJio+CBgOWZkMO7hRFHnF3cuEb3Sn/gUyAjovB25eY8r4ZAY5O
 o/XGFGEghltDBNUbnQA5IItf5LaCrl8=
X-Proofpoint-ORIG-GUID: gpN-nQqL1g5TVOLUHsXe2_cpzlA37IxF
X-Authority-Analysis: v=2.4 cv=a6KlZkSF c=1 sm=1 tr=0 ts=6accad2c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mNU-isJH3YWoj62YpE7kxzk7RJ5jxZqF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_03,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120038

On 12/10/26 1:34 pm, netdev-bot+sinfo@kernel.org wrote:
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

The races are theoretical — none of the four windows were triggered in
practice. The smc_conn_kill() / smcd_buf_detach() race requires an
active smcss poll to coincide with an SMC-D lgr termination on the
dmb_nocopy path; the smc_close_active_abort() and
smc_close_passive_work() races require a concurrent diag dump during the
narrow teardown window between sk_state = SMC_CLOSED and
smc_conn_free(). No stack trace or error message is available since the
bugs were not hit in a running system.

