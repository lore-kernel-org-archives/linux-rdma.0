Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E6D25B2F4;
	Thu,  6 Aug 2026 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006239; cv=none; b=qg82M7KqETtbyeDxP8hZbJJSro2eE8Ul+SyBrbcMZewiXhh9AxN1LeBO2a/677rLkMBM9zGtWkvgVZuSWrbw8DUDOdAZJSuCWxHIn4DVC1Cxu9vEMUOioFM7r5GEOewEHGIR7OpVqVR8CqFx+6PuJRFleOBPKEhIey5Fmi9EelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006239; c=relaxed/simple;
	bh=vyzg7piNovw7zLe8IegZE+HcioBWNVQ+zkupiGhfNU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hNVanRyk2j5UuvrLwtnjhJsddhOrb0SQjMHzVSZz0UCNc+wD03FdNtMCtI4gSI9rd8C1UjdAINOMhPb7jZ6U0RaJi+xzhceksWL4FO2RtOYNba0ZloPrlXGu1H3xwGjjxw2F/iqkEI6FgUHGyYZhGjMOhdoISXXguuGD/kU2+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mTenKd7h; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mTenKd7h"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675NlgRS1066119;
	Thu, 6 Aug 2026 08:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=W9qg6B
	U5J2eP2WtS8IpkXouMPnmOqejfPhQHyKQJA8g=; b=mTenKd7hAqz4S8aXZbjOlu
	wxaXadW3QskvO1IefQOGunFsC8q5ZbCaI/4sPyw4znT6/9MmxdOUEyFJ1fyAE7th
	6Jnr7oPhcTvq7hkoygAfJabctfAN2FQ8g+jIxtIyLD3Qe+paG2jAoW7WfVqoF9dW
	yAv7jCGpa0vUkP6ZYtnJ1t4gfuXoAHq9XuWsffpJxcpR98ANxqaIXeKxftr/gBsv
	IrQWqBFhIO7Q+KG8uzLCUIaKEzQZ/kS9yTvxI7RYko9O4OKb9webtyowoQdkzWim
	bUJrpokbKKJqQnThYrZF6d7S6gssGQOpzS4hi1aj5aa/vQqXCaTBAVnCd+KHZPRQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a478jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:50:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6768fZgu002570;
	Thu, 6 Aug 2026 08:50:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyt6wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:50:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6768oNwJ30081452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 08:50:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C470620040;
	Thu,  6 Aug 2026 08:50:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6925320043;
	Thu,  6 Aug 2026 08:50:23 +0000 (GMT)
Received: from [9.224.91.49] (unknown [9.224.91.49])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 08:50:23 +0000 (GMT)
Message-ID: <b4dccacb-e129-47eb-9b17-aaac13d9fa9a@linux.ibm.com>
Date: Thu, 6 Aug 2026 10:50:23 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] dibs: fix use-after-free of dmb_node in loopback
 attach/detach/unregister
To: Hidayath Khan <hidayath@linux.ibm.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, wenjia@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com, pasic@linux.ibm.com,
        gbayer@linux.ibm.com, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260727093530.968834-1-hidayath@linux.ibm.com>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20260727093530.968834-1-hidayath@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a744ad6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1GTpPYFZVA6rkABA6Z4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 6aaULCIUy4kvxIy1XHVC1NmXXX0v7m4z
X-Proofpoint-GUID: aY5aSJ1ETf1IZwi7RIyS2iq9e0OEtbae
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX2diKg/jQ6hbV
 +2W/lvMw7LwOmD+upst1rAZ0Y8L/zzoGGyI7xup04OhaX/jrJcQHRCaEuVAIeXFS+//yK66s0By
 cFym9MvRDtMemDqXhUujfiMb4nq0iSg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX7bdPHelN8daI
 K2IVOf0iv+0pzLl2IH27ziDMPq2LyylnEi5gJjSxiVVs6CrWBk2+re+zvW9Qwwfjt+jhMuOgqnm
 zO6s+RE0v1LvLMU9y5vj9IWh0rNWRDLEIw3B2RjpcCoJHchM0Qe+t6kBOp30ypT2Hq3E/oMpVw6
 L41QTWhHeHYy3XOMDt86UIlZv/1LejH5CBlHtwb9fDVGVV4RpYmcloEeP0QbKigTAkxUHIP7fmq
 Gmu/00vgqg4o1UoB2XdBigJQPMXqAZSIbRdHyhiqV3jDJDv4LkCjB/IPerHhLEMWRg3FzyAcA0c
 ovMovE6J6FcjVeO3FTr919J/nwomVS1UY8dC78KqKCABSllLUh6YEdYBtNZY9OuS4evxAa70jkg
 jp57973iN1hQvfl2sc9QtbujFgC+8zEujE7lMW+3sMvsXtORvDlcvyz+LRhewZrF2SEcZw79OIh
 Vw1wEHoZ7+IxaA+8dXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060068



On 27.07.26 11:35, Hidayath Khan wrote:
> dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
> look up the dmb_node under dmb_ht_lock, drop the lock and only then
> operate on the node's refcount. Nothing keeps the node alive across
> that window: __dibs_lo_unregister_dmb() removes the node from the hash
> table under the write lock and immediately frees it.
> 
> A concurrent final put can therefore free the node between the lookup
> and the refcount operation:
> 
> CPU0 (attach)                     CPU1 (owner unregisters)
> 
[...]
> 
> Note: commit cc21191b584c ("dibs: Move data path to dibs layer") moved
> the code to its current location; the race was introduced earlier by
> commit c3a910f2380f ("net/smc: implement DMB-merged operations of
> loopback-ism").
> 
> Tested SMC-D via ISM and dibs loopback.
> 
> Fixes: c3a910f2380f ("net/smc: implement DMB-merged operations of loopback-ism")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>


For the records:
Deeper analysis showed that there is no path in the SMC code that can lead to such
a race. SMC currently is the only user of dibs_loopback and was the only user
of loopback-ism.
So the stable tag was not really necessary. Sorry for the noise.


