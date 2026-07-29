Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9811B47ACC9;
	Wed, 29 Jul 2026 12:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329430; cv=none; b=s+xPwSsSG7KgjKbW3TWJGZCCMRxvQ+YulSkbjCaK1qYAln2+hMcO/VNggJb0dwpChyf5Byy+44nPjxMbepT7ZISISdvgONCMD54Hq+wViE4idu5F6A8ySWn2L4uFAbVUzwIDbA548eUrQeUdOvvlRfjCfFKu7fsMgVaD1qaltlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329430; c=relaxed/simple;
	bh=2ihxzM/ly4cqQLOesA/1RhT3mdrV4Kz0thLHaCKTg9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB9y3PPRfLgrOXoH50zLzzTmR+wc3UyQ6Qq5qaMIx/ctIYZb4h/XNApiL7pHvdn4LXn8+TuHuWdmQRKrJmsH2mgxzd9bf11sBydyFgL6XTv+Fpoyd3IZu8r9zl+xyZyk4b3L6cpmk5B86ew0lC7ZDe/oJSN1z+fM9VHhdvsVIh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O9hkoydf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O9hkoydf"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TBIA1C3953722;
	Wed, 29 Jul 2026 12:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2ihxzM
	/ly4cqQLOesA/1RhT3mdrV4Kz0thLHaCKTg9k=; b=O9hkoydfHNwCI+aDhDQae0
	7JA/oqzV1rvDIWEHz7Ad8kyuQq4Y8qYGABUCAHQPYVTn0yfc9WSmuBCHEbYVEm6B
	Xu0oCPfJvIF2FLTF4KZ2bvK7FrvNQcf537SAQjpXshZGITUUAQRHB5UX72r1R+E4
	IHXHjjclRKso40zyW/b2dV752PxrPYWbdTj5FBRd5hL5vnn/9B8e/RPdkizh9r8j
	BTpyj/CIbJkgNj9KBlBMyMmCuhZ+ynuxrGan3AuTYZstfbc9ei8ApEbj38mGRx1L
	GEKDK+2/BUBZ98AKxpWmCqdn6pHThDq/6jHED9V5mpdTkottn7COkY7TFzyX1sjQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyj9wvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 12:50:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66TCfHVL029927;
	Wed, 29 Jul 2026 12:50:13 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y6evb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 12:50:13 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TCoCUp1049110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:50:12 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 406C258059;
	Wed, 29 Jul 2026 12:50:12 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7108F58043;
	Wed, 29 Jul 2026 12:50:02 +0000 (GMT)
Received: from [9.124.223.194] (unknown [9.124.223.194])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jul 2026 12:50:02 +0000 (GMT)
Message-ID: <9d2d6c92-2d5c-4b12-af1e-78062da8730f@linux.ibm.com>
Date: Wed, 29 Jul 2026 18:20:00 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] dibs: fix use-after-free of dmb_node in loopback
 attach/detach/unregister
To: Alexandra Winter <wintera@linux.ibm.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, wenjia@linux.ibm.com, mjambigi@linux.ibm.com,
        Rahul Chandelkar <rc@rexion.ai>
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com, pasic@linux.ibm.com,
        gbayer@linux.ibm.com, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727093530.968834-1-hidayath@linux.ibm.com>
 <fedb6ecd-f5e4-4830-9595-237215fa0164@linux.ibm.com>
Content-Language: en-GB
From: Hidayathulla Khan I <hidayath@linux.ibm.com>
In-Reply-To: <fedb6ecd-f5e4-4830-9595-237215fa0164@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfX1AYSUqo6/c80
 M0BgEyg3CBrWweE98C8BeOR3FPOjPNg+AT8CRAyalOqQSWsmewiJpnMkwZBUlATn44GSce7fhL+
 ESZgUACdrGZMIUd4qEJmvNyUi8ro9Xw=
X-Proofpoint-GUID: TPgpCcYfjCWYvfEwRzKe4HL9ZrKnIPDL
X-Proofpoint-ORIG-GUID: mkX1yKPkKuGxTemBW9iafx7wxFYvCAOA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfX/thqRPL/jnWj
 ymKoEeg6bz4QKgf8FV4ZxoQyPjNV1+m20pxVUFY+tOn7eOQr27vwQZflsGabm0I+GrXvK6Mnlwt
 CMTDh6T9TL8QnoWhFDqw93SAlXpoE/kLmc1r6QaBP1yudttZRoRG/e+ykWreiIUE1/v3tosq3qN
 vfjq43PLIlLaFEP3hWxPmY9aAPIFIimdktj1zUb0bwiwKdRBwwxDT0DsxPt1DaKYCO5y9iluolR
 BzfdtTJWZCw67uhUjlJ3K9vOknvvlQ3Lw5vWI6uJMrKuJO1WYoFLql5kfExujQ4dRmZYEfrYtf5
 XK390xvr/G+v3kuolNwdhisBd7ClTWDAcbjtRZMDAh04QizmOKYaeWbnDsaBs0Ixhw2lBR0a+jN
 ayClPgVRyA1ENz5vJijHivCPCiMmjVIBmxQnn76SqprqkeqzhIJ0hFK26iC0WGpsLjC878jchy0
 JSdtE7H3wNsQEsKBMnw==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a69f706 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=o8dFRQB0AAAA:8 a=_9ao5c0ydNkKcCpahgwA:9 a=QEXdDO2ut3YA:10
 a=D5cU4ZU6l4KboW5xFU7l:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290106


On 29/07/26 5:55 pm, Alexandra Winter wrote:
>
> On 27.07.26 11:35, Hidayath Khan wrote:
>> dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
>> look up the dmb_node under dmb_ht_lock, drop the lock and only then
>> operate on the node's refcount. Nothing keeps the node alive across
>> that window: __dibs_lo_unregister_dmb() removes the node from the hash
>> table under the write lock and immediately frees it.
>>
> I had lost track of this, but Rahul Chandelkar had already proposed a
> similar patch [1] for this issue, but never followed up with a v2.
>
> Rahul, Hidayath,
> Would it be ok for both of you to add
> Reported-by: Rahul Chandelkar <rc@rexion.ai>
Sure, happy to add Reported-by: Rahul Chandelkar <rc@rexion.ai> in v2.

>
>
> [1] https://lore.kernel.org/netdev/4gRZFl1CWvz2x9j@mail.spacemail.com/
>
