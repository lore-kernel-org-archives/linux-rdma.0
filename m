Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDD4346AED;
	Thu, 16 Jul 2026 06:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784185055; cv=none; b=JZEz7iAfqW9TeArCWSoTf24IfRNTKE4G8AZx0wZLsFVuqqiwcY1uu6OpcKgGYwSX0fCXApNBbxfKZQ8QkPYbbwJQxN87igz/U45xXjUQLpPl6OH82VPxUk1qaoAKl4fTVXBiuUcpwXq010c0UP8BVztovdcYSSbs8gZ8hMcPDm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784185055; c=relaxed/simple;
	bh=ErF52CX+fFgofAQMX/JrPKF4sF23WdI5fdgXAc4dzdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nIVDTIGY+VmyoIwIEhPznPPpHqvR9sQepg+/DdpwM7SdijWkMapkkYRFkW6lkeVXyph1MazwFjFm1CHAhXldoGrsCaSlMIzQQS9olG2yaP+Rg7izy4pEWEJUyP3bNTP2K02BzU7PqVI4NxbS7gQaLlq21rCHVJFPv8TJ6YJbZkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ogeLC8o2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ogeLC8o2"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G4BwZc260731;
	Thu, 16 Jul 2026 06:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=snMTDz
	bwNNdymeS84mQCskZpkjKf/Sl4uqcM+jXOw90=; b=ogeLC8o29AZXJHVIYCrhNa
	o3y7jL8p41uQ+8iNgvrv0o3KV7VDLsHADgDoLSl5DVuoNGka2g9PBTXZqi4Uj4ww
	5xysOwim8ulCb9zTFXP0Bt/7wS5aWxByszNv+FRq3DdCGIUDoUr3h1vobJQ5XLIr
	wvXL6Z8iciNr1JWE8o25lyT5X2ttASy0ovSZAooKHsnn0jdLP78gmMxfVPP4AyOK
	NuLqPk+kvxC1YISEv6pGVb+JRQfsc5R8t62ioL7X6Bi97vV/rbwNEe3T4PGSOT3c
	myE40mF3GOI6JUNfNn+WOzKFeGqeGOKlulkry0fY369r2OIX5DnMaQGxQdtHux0Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fcv33fxcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 06:57:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66G6nafc030076;
	Thu, 16 Jul 2026 06:57:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc0hwbwrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 06:57:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66G6vKxt45351322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 06:57:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42BFE2004B;
	Thu, 16 Jul 2026 06:57:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1106620043;
	Thu, 16 Jul 2026 06:57:20 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jul 2026 06:57:19 +0000 (GMT)
Message-ID: <6e100e63-5985-4438-bb38-8dc7b0afed05@linux.ibm.com>
Date: Thu, 16 Jul 2026 08:57:19 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Use unique names for software steering
 caches
To: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller"
 <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA2NyBTYWx0ZWRfXzishSvp8nUU9
 Brv8Yan1mmrbTjKkEV1KbjM+b8OOPWQ8gA8T3jPdpbeh6Jgc+ZNQOuZyTttlRFNoOsU01Id7Y9M
 3Pi9rwLS0DhUmErhOOb55a9Yd+HamUU=
X-Authority-Analysis: v=2.4 cv=Mp1iLWae c=1 sm=1 tr=0 ts=6a5880d4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Ikd4Dj_1AAAA:8 a=T3xCB02hYxg-SKxtKl8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: NInK9OtOZWU8BZ3B6N3W5g3eEgMmkv9Y
X-Proofpoint-ORIG-GUID: idGo9oa_uhq6jdnNcrI-1o_PtYr-JbRK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA2NyBTYWx0ZWRfX4lhDyGYGneaV
 vjuMeORHarKj6WOiiunVxACmiGXJgtJpz/54V0j1G1NXpYFr8/H+WFMD1qJ/FHEUQDmVHLxsBng
 MfxPR/+9fyZ5OVvqk14KmXEVnFbTyHCVXbkG9D8cAidZjwWeyVlfiFXqIY5tmZE9eT3ROnAVupT
 uAVPZ6aE+icAPLYh8Jtzzo24EsRFnKUuMfVxvmWs3TIP9rg6CgUwlmgnH8ZvtcVICBEDFuwgwdR
 mLU1LBLvv94pdgD8kqUzHGjHdtIArFxLMft3rJqK/SgqF0/WpKOwy0GFk+JyBt0xxlN0wE2c3bT
 aFTj6o+TyeVf6kcMajhPrEP25bCEmhLzfzo4zieAtYbZpOuPxLvNiIB8zMu1WNz3goGXczp52iw
 lyR1g3jSV5JLkoHqYIQGrjNHYF+CklnwzJnFrrQJ8Llw4r+ngSvV53/8xP3ugRnN4KZ0uKJPnCB
 s8aOyROTSAC2zAOfeYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160067



Am 15.07.26 um 10:22 schrieb Leon Romanovsky:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Each software steering domain creates its own slab caches, but all
> domains use the same names. When domains for two devices are alive at
> once, the second kmem_cache_create() triggers the following splat:
[...]

> 
> Prefix each cache name with the device name to make it unique.
> 
> Fixes: fd785e5213f0 ("net/mlx5: DR, Allocate icm_chunks from their own slab allocator")
> Fixes: fb628b71fb2a ("net/mlx5: DR, Allocate htbl from its own slab allocator")
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Closes: https://lore.kernel.org/all/a3cea501-4d1f-47d5-b6d0-fcda9a0aab16@linux.ibm.com/
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

error is gone in our CI when the patch is applied.

