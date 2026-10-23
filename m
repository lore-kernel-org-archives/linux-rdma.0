Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775921;
	b=stOCSYe4PtL284Utd4F719k+M2J5RvEOa/EFPucQDMxeLttQ+TL2GKmS+oNE07AjZ9bc
	 UQHBoqG3HJo7sCEU3jpb+zto0QvfJiktLIkqqyMB8uqSGK6hI8XEQOT3Sq/J8CMYoWieP
	 Nc6dsis8LUXVyHoRziQIm5EBcucJ1dxOiVBVK51C3rvOtZPdUdgq+vlH50WBtDjAm/CRk
	 TWK8pc6MhTeMUVi1l4BSBRLyPRDQJU7E43qyBgrU0YS8YMuYXtHPVLbTEKzQe68w4gRGu
	 X2xMV8m6DUaOdx9jzGZwDVU2POmgAb7TM+FBlCHfbKImOL6MfFRXt+gPgyJVkOBtXLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775921;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+PpTXqmlLnD1gkK9da5UA4ivV9Yaq55UolUi13Wutkg=;
	b=bmWYUbWaw1n6Daz5T1XMrlF4eKV3l0iYhvZHIvbA3Pl7XNOMX1Pv3pWoARUnP2ySOPvp
	 Lki9f/3dWed+vdAar3J52zXYKYnvnS7BvXRsIyuteFMse/5aBiPuzb3kjW/lvpHk2WSVl
	 9OSFgc6xapxoB8PrN0R/asdhOwf6bdS8LrS/d3xjBxY9SAIfU3U2ZJSuEp9ugmj7vUbRY
	 dei4XLdhlkafKGVWVOreT9GM7sQ4aPJ2F6SMFg9SSJBi0usTT6LGx1RPDgdLbLdYhuYDw
	 jYaqSiADmcQ784JVooVO5/fpaf5WdOFT1z2mcHhtr+a85cqotAnpx/TVT4W2KqEWdxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="AoFg/Mh0";
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED0360A2608;
	Fri, 23 Oct 2026 17:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED0360A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=AoFg/Mh0
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NGoToR3668699;
	Fri, 23 Oct 2026 17:18:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+PpTXq
	mlLnD1gkK9da5UA4ivV9Yaq55UolUi13Wutkg=; b=AoFg/Mh0pNfHGvARrKU9rN
	REmBY0KHAOdJTdNcXPEetMTT9VflTtuAt7wqK+D3l6CWUqZyP9hU4P9MGw8JFH9L
	sAIq1HFCp0sIMO+qAU/2/F4ZZnRiHJdamDI0HwmA4C06KWpHDYqVIghSf/5fwljy
	grzFO5BPje6MHOdncbAIKMydAtG6Jb/Pp692LkeVo77WMbykkZH6iT3gPvYryy9V
	V1gJX0JpkI4+JgiE5TBVTx0V6FTT5KawcxFqKGUfUpEhF2S50EvqPCu5tTGIamL+
	btL7N8p00+kskZtZbjjpZPqWcT0ADLuwbaGxxHd8/dz2iUkFWWlbc2+V6sHRmjmA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw596ke0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 17:18:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69NE64fV1018552;
	Fri, 23 Oct 2026 17:18:23 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hg5exsn5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 17:18:22 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69NHIL5o15008382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 17:18:21 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 213B758059;
	Fri, 23 Oct 2026 17:18:21 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86F6C5805B;
	Fri, 23 Oct 2026 17:18:13 +0000 (GMT)
Received: from [9.124.220.1] (unknown [9.124.220.1])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Oct 2026 17:18:13 +0000 (GMT)
Message-ID: <498db6da-c461-4bba-a2aa-2415e99aeb97@linux.ibm.com>
Date: Fri, 23 Oct 2026 22:48:11 +0530
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
Subject: Re: [PATCH net v13] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
 <179276799858.3327.5559074809059802819@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179276799858.3327.5559074809059802819@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 9_nVIsYayCM8tqTaQpAz10y9qEi_Oj3z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA2NyBTYWx0ZWRfX4gNvBXi7Rv7z
 KsycYt2DKAE+PIzvggabMavLgIJfL99QbfgGOb41VwU4G+ztlHtG2BOXWvDK8UgL0XvgWakRGzj
 zTiWcvkIGat5FvDhH9GynEvRlHJQidg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA2NyBTYWx0ZWRfX0mU0URRhcLQy
 EpNvllxGNODaJx26ZnEPr7CSjLdLB1osXDCEedneduhAl1Ae50ZpBc4uqu6F8P+kDO33er3bsvn
 5amuDZmiTG4+nkG6RntAjkQnmrMjwL3Juhly/dNLYcyDKZwVdXxE/9KoCVnwD8zmvB6atEs5LRW
 GxRaE9O2rzPVwBcF8uchyHVCGZO8EWxa+vU0gIinwdKPuuFuA9gUXmL7B5h9y/B4pApCaLPBpLV
 wpok8foBxHg2k27wFgND6SY8j/4Ulk3DLkHLR3NTdDHwcy5BSXpl1U1ZFzxZLjNf6/mndNj8/f/
 SBpJAi07MkemnikS5qGOagreskCEnGxS3NrdaoLOVNGzAXyzuSQaB7+t/Rx/kcDD5lngYKl8qxf
 F77AovduAdS8GTVuSmNpLi5l3lI83U6b4gqa/mDwj+omSAAAvW5yZa35WrhFoqH51+FZyKBvoNr
 74py7VFjJjAx+ItC2PA==
X-Proofpoint-ORIG-GUID: xcgnfAcm4n7m6sQxpLMWvQpIQzoJl6Ih
X-Authority-Analysis: v=2.4 cv=Ob4NnRTY c=1 sm=1 tr=0 ts=6adb96e0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230067



On 23/10/26 8:36 pm, netdev-bot+sinfo@kernel.org wrote:
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
