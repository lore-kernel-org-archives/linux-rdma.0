Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0951D2E737F;
	Mon,  5 Oct 2026 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220181; cv=none; b=lQgs3sQctKwmHb2QJR4tumojHwtRdBNZY58+j3QdQhm5KXyPltp8KavUdDEoo7E86GZr2qGAWc6Wzk5u/RaK5W2UezWPL8wELSlezZ+zp8DP37mtclykbcajRTpuk4pvyjqnbVdSb9FluwhN2yDza6myRWaoRi7IBGLjRMRrbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220181; c=relaxed/simple;
	bh=6eNWLxi3XC5hnQMZZFGNoAUlqM6meGtN/6Vqbk0a4yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uEg1bfy1aqFIv0sTR3bilVb9K0EX0722sVg73t1GphmWYr7uq/dlj9OBbShvb4rDrKX5+WYGO7oTJBlMpKH1U+R7snRZ0BkQPjYiDzP6b+TCELK7UOQJEw8aCWTmsAr+HXNHetrI+aHVxM/Qso2qgGR2ASOyAsCfRLOOiC8Ov2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sm7vlAZU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sm7vlAZU"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EZZ5s3285211;
	Mon, 5 Oct 2026 17:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=di4qI3
	Cwp+BfxwkQAeN1wv1+JQWyKnPX9H6gYSNRXw4=; b=Sm7vlAZUKAqLCIlrmFOvy5
	ABcyUuFm14kleqoudWPPgpJvf5cOXy8nMihEQX3oL0qi2JrPIP2+eMKis81SxVSd
	j/MKU9PQWrse3+QA4EIZWttc71z6f/6EiTOxPOeRUS0Kh4f67cxGLGVt58fX8zbM
	M7FSksKUmYEJ7K/bZW46LdfKJjz2mSuVUHhE3S4SYXJgAzFoBNPyWa+VcorsxQh/
	l5P/THJ7XYQQCpjnrw3cxX0z82HmJFvrW9NLooU9cmHk7UTErSc7/f8JGNhN/lCx
	PVFlnCqd4YXaDgHvkHnpSVw8+JeILYqQtVOKJvfS+z0pIUF8OcJwqJDc7Ztb4sKg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2scrbgrg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 17:09:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 695EWZIn3025094;
	Mon, 5 Oct 2026 17:09:31 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3d1jpcpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 17:09:30 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 695H9TrY3736478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Oct 2026 17:09:29 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D3665805A;
	Mon,  5 Oct 2026 17:09:29 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6499158051;
	Mon,  5 Oct 2026 17:09:22 +0000 (GMT)
Received: from [9.124.213.181] (unknown [9.124.213.181])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Oct 2026 17:09:22 +0000 (GMT)
Message-ID: <1e2fc39c-7062-4d66-954f-53811fda8854@linux.ibm.com>
Date: Mon, 5 Oct 2026 22:39:20 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sinfo@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
 <179120636424.1402591.14325781567092984615@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179120636424.1402591.14325781567092984615@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2NyBTYWx0ZWRfX8Ffs4bb79L5x
 0vfmJeFxXSPA9zg/9jxQSQ7qRK/dRJAm96tKz5cjtcDfYlt05Awu+Ld9Fv2Tus4vSnU73AJH73L
 wjGQROf6D0Eqv8HtNOAn1RNTLdk1puM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2NyBTYWx0ZWRfX5Q5N87W6AAml
 31GLLKEYpB/B+ZtZqIwogcuL5E6lIiR/4zdr3bdr9HkiCd9h2rABGbVM0NtCgxuLhwVUHCKtbkR
 M1A1gsC+dmUJ584nEZiZ8tBYqbvVQuOQL908/txlxfEGbJoEl9q0sOhnJUk+RAV7MaUPhglVS9v
 guIEF8tetHTt1fd7jSPqrJx+oCiZC5Yst9eNhfPkApQn3s9qw/X98xwvWvRx1YB280pvDmgGNzp
 amkrnsp1AXL0L8g4MKqYB/jVou1+bCI3lBplJyvSDz79GXQ4EFMb1/dsZRDnflUkVmaHF9gCdi5
 nctifo63upLCgfkoWpgOcPba0MXzjvEh8FuYD2LEjIwLIsxzPa5Xq7N5BqXy1He5Houd5ACseCR
 tHCHgYkJ11nHqxvBHyoKM8qHQXtaIWLXgJ6Ot6oLjEzdvrPDXNhGAQ40gYnzxVMM3oChbyKTUDL
 obLL64UQCrEHLeCnK9Q==
X-Proofpoint-GUID: ETgPZYWLNkwWQi9dtHrsQBsjJO9Q4qsT
X-Proofpoint-ORIG-GUID: J6B_AkogrLXUfMsruMVo1j1-MtD1L4Wt
X-Authority-Analysis: v=2.4 cv=B7osQ+tM c=1 sm=1 tr=0 ts=6ac3d9cc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=8WImSUdLa4LpenjYlHkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050067



On 05/10/26 6:49 pm, netdev-bot+sinfo@kernel.org wrote:
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
