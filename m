Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC06C437858;
	Thu, 30 Jul 2026 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785418222; cv=none; b=DzNxnNVDNIkcsi3BVXHTf32yuZqigpMEHaysJJIBmTcLZPvb3xZ7PoKsXwloiYW1cRUkAH3RqqmyesXZ9XM8HG8exeTfT2Z3mQqOpgLycgAKU6Z9jLJtj9+npPlx+X42v2eywdHE9gl3/s6/jsPjPoilIM6pPQofLsJ3rK3PXp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785418222; c=relaxed/simple;
	bh=vyMc9pIzmKcydAUii23iP28qwzy/u/ZShI7DmgIcenU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqIZMM5HmsJifdtHTrtBaXGHMYRJFlNuroc6UQt4y+VJ+kVQAe2+DTgumgMcqXdOe4yWbZeDg70RVJP9toWHreD3Wx9/4Zf2Fx++x55D/GYYvvtUef/sVADbyJawelQefdhNbJZ12egB+pCG3kiuBG19IewTtQyeqfY2oCm0UnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bOgVmS5A; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bOgVmS5A"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UDHd5U3091356;
	Thu, 30 Jul 2026 13:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=K3MZ8q
	z686VXATVvJ9B2o4NyIJBX0gJaDjpzGsCDl9c=; b=bOgVmS5AZHwwLx4KNtnrjp
	PfjGHTnPg4TlP1ofGJjJ6/M2ncvl24xjcc7m6sR+HxzNpCHdGPnEoRij5T8m6vkm
	/yX8GiH0/r22LI0lOBG4vm6woeWYBOYBFkJ2c/pgEQoV76SsJUCgTJ60IwvUHZaC
	UIMsQWWR8iRItny9tjRFPvGzziCoQLUI9+7PCwNj8/ksN88hrTjF6OxilQr3uS6l
	stMwcH8H7c7K2UiMNmC3hMzxQyFKhbJvvumCUcM5mc/hP1QyXyImd7Cmnvdqiz9t
	4akj3AQeC0g4qEN4abV5hOzfO1xBVlqpz5y+HDsr1+OTrtTzYjn12xylBo6QrgNQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7qx2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 13:30:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UDQJIW022883;
	Thu, 30 Jul 2026 13:30:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwbmue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 13:30:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UDU9mW44171750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 13:30:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 253B220043;
	Thu, 30 Jul 2026 13:30:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A755D2004E;
	Thu, 30 Jul 2026 13:30:08 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 13:30:08 +0000 (GMT)
Message-ID: <3b0a153b-f47f-4260-b7d0-efef5ec0bca7@linux.ibm.com>
Date: Thu, 30 Jul 2026 15:30:08 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Use unique names for software steering
 caches
To: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Alex Vesker <valex@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
 <ee358aca-dfcb-40a8-9dfe-dce1ebb9c063@nvidia.com>
 <20260723061352.3b4b5e58@kernel.org>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260723061352.3b4b5e58@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: qtjtgTLYNevbAkyp8itgLVYcyTxHHn_O
X-Proofpoint-ORIG-GUID: wRohPMdY8qJfgu8LfpgvQ8DCHIGLBxZ1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEwMSBTYWx0ZWRfX+uIhzqnJUtqC
 lugKGvpoue1GLiOLq6sS8OOSSS3WQzIjXQhXUO4S2Unz2DtfqERxt1RCZFq+zyeYD/SJ09Zbmce
 wYrBOwbWHsg3hbwqdWwh+11JF6vvArh/M2Rhkb68dSx5aYR1upLNuugSXAMlkidtKgOc/PjunOy
 qPBApIN6U1yScXihqUMdvWJyylNcWvfUCSjzWeCCcrMS2kFPdmwSmEp3u+SVtrLFUwqZgr6MrDd
 LTBIjpqm/lc2vqz6dURsDOPiu3QQGB0Nic+nMCVAAr4RPtUVJjkiBygDGKN0npUJSmuQ+tVvgPP
 e7yswENTXPB/bcnuGkaTdpcWntREZiCwAcMHF8oVo/ylif3HjHmEMYz/haz+H2wkyeLRc5YkMCH
 Mf9smzzab3duH9q0l62/CFUBFPvVpsjEUXZvoik3Qg/JOnsDHDNNllhhdg7Djy4JoBj0PEdmCpL
 pJl+auVZRnq1m7WBlEg==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a6b51e5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8
 a=sgPOia-50TS-BxYDRLMA:9 a=QEXdDO2ut3YA:10 a=hnaCgzpD1CAA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEwMSBTYWx0ZWRfXyIgaY96kZIOg
 uEVX9qWX/eZeiuv5vySVTIRBzYyjHayYGZuD8m0NNdXBhr+5YTtpXuAVhtvXwZxvFl5flEkmVfg
 dymjm+76UHMdBcmVUoxJSNQVr85n1sk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300101

Am 23.07.26 um 15:13 schrieb Jakub Kicinski:
> On Thu, 23 Jul 2026 09:45:39 +0300 Tariq Toukan wrote:
>> Acked-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Too late.

Jakub,

quick followup. I cannot find this in linux-next.
