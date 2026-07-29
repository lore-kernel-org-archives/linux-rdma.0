Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7683E47F2D0;
	Wed, 29 Jul 2026 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327932; cv=none; b=jWo7FY9OYqakY90yaOCYRqZZFuF5oQSVg9+OjpJ5o6ZFsvXI54qy3BW2+TX9JMOCD6faR4x9WvEPvtEk3tkLCYr4u802eDMu/rqR43dukyy6EQmob0VPhjSq7oV+ia3XB6ioKi5ecm2AE0ER364+XwlTHaXTC2qyF8illqwQUac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327932; c=relaxed/simple;
	bh=4INEZDfxvinau2JwY159d/xUPtSiNSnOWn0J3lzYHw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OO/A317YXINwS/lRhV9LVNtNro1WVTw36DNfcufc4hCVu0PdyzvGlK5+Cb334U40gpz3THBSmZptP25UiCC3pfC2UC/ZZZ8d8Pob/vc6KDoImFoAcIDttHodY72e4jD2pL9moy+wvm0wSnXu3OmiqnPnX2Z9AhmWHGSAm73NJec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IaGglWqu; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IaGglWqu"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TBI3jZ4077075;
	Wed, 29 Jul 2026 12:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+5C613
	WTrEAgrx10lGrrHDdtf6pJ/PN+7NZoih2kbSc=; b=IaGglWqup6Dnuk6QJvg1b7
	kEcCCtZXdT6kyIULFNEMgf7EWUrKZ6KoFI0VCcNI6yDwL03iHEZEvFKlibSuxHkw
	lSnD9t3xmw4EdBDmmb53DjO1IozPXqOoCLGip4Q5jgak+dmF0+kJiQ52KlAuKMt/
	byTZKycth0JRiLaG5EJ3ATF02Vk+yazwcS6dgIiXC5OxEeCzsajfHN5agO3evsEj
	skMGVert456MANqTRgc/Z0RmxklceCc4Ac8M99amcY8oR/0Fr1vP7kzkC8KX+uZd
	4zAHyNSyZqFGyaeqVzTOuQ9YjNlimrGx6bEnNTVprUCvqTxLUnXp46d9jsJDR9XQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwd1u5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 12:25:18 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66TCBNmY025803;
	Wed, 29 Jul 2026 12:25:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y6byg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 12:25:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66TCPDJO16908726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:25:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C009F20043;
	Wed, 29 Jul 2026 12:25:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F36320040;
	Wed, 29 Jul 2026 12:25:13 +0000 (GMT)
Received: from [9.224.94.95] (unknown [9.224.94.95])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Jul 2026 12:25:13 +0000 (GMT)
Message-ID: <fedb6ecd-f5e4-4830-9595-237215fa0164@linux.ibm.com>
Date: Wed, 29 Jul 2026 14:25:12 +0200
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
        sidraya@linux.ibm.com, wenjia@linux.ibm.com, mjambigi@linux.ibm.com,
        Rahul Chandelkar <rc@rexion.ai>
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
X-Proofpoint-ORIG-GUID: 4MwX9pVB33iqrYqOxD5A_w2oVIBToZWb
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwMiBTYWx0ZWRfX20ynG5a+0ss0
 3ueQNYLWusR/X51uqNSB7pUTKaoEDXJNC8b1GomI6E2Ecy5Y3Xi+iUcAckmnrcP7w4kdVJ0pVkR
 p9SZgrt+rCOquIEHc+TjfnCN6/I4PUs=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a69f12e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=o8dFRQB0AAAA:8 a=DAb8WqUzKgD87k8msboA:9 a=QEXdDO2ut3YA:10
 a=D5cU4ZU6l4KboW5xFU7l:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwMiBTYWx0ZWRfX7GlIJnWnzeAG
 wRWEFtaAcINncWSZOygZRlhosCpKUIXh3eSm2yD2CKO0AMH1A6C+PWJu1aknfG0U/UNrVfDPpru
 GbgxnZ4EdvujGeMjyzmWoT0KV4YRZCVUc1ORePy9vjMPnO1ydYWyYrq+l2j0QVfOsRBWfBrNnku
 Ef37C1dWe4fKITN+Vg+Sqo4tOv8CdumpsF38j0TxLWCMSCYSm7BsPHlIYBHzHkfOnXF1KqN7Ryt
 VwZ9T4PkQw6jgic7tflXvyzs1+xceVzFql8SaoQib8+KGUD7K0r9je2egP7v3AMCx2SU/lQPsD4
 ZxCJCE0oHGWKX56HC32Em5KPQ39AOj/Pg8u9eHFq+xTKUN1DXgF7IJSTlO00SzIjdaRSNXFZhOy
 DhqjZuqcpDNLrB+0l3MittWSMovZrKRjsAZVPIm6DfVOzKT5oDiBwxdQbf6KWfLAP/LqHuE0dOp
 uD0H1ZbCqBXVo/6HUOA==
X-Proofpoint-GUID: jdfYQMc6znUxFmTKOdJGrdkhrh0lR4V6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290102



On 27.07.26 11:35, Hidayath Khan wrote:
> dibs_lo_attach_dmb(), dibs_lo_detach_dmb() and dibs_lo_unregister_dmb()
> look up the dmb_node under dmb_ht_lock, drop the lock and only then
> operate on the node's refcount. Nothing keeps the node alive across
> that window: __dibs_lo_unregister_dmb() removes the node from the hash
> table under the write lock and immediately frees it.
> 

I had lost track of this, but Rahul Chandelkar had already proposed a
similar patch [1] for this issue, but never followed up with a v2.

Rahul, Hidayath,
Would it be ok for both of you to add
Reported-by: Rahul Chandelkar <rc@rexion.ai>


[1] https://lore.kernel.org/netdev/4gRZFl1CWvz2x9j@mail.spacemail.com/
