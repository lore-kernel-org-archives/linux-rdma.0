Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFF53F6606;
	Mon, 14 Sep 2026 08:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376347; cv=none; b=fCdQYR+8EASimJM7OC2h4P0O8Wc6NnkqDua0qV0QIJ46PwcppNm2bRTHuH5f1QmNugv7jTRwNOWjfnO5QFOvmCmU0YKnfIDW1WZCH2NX9CSmDgA2k+A6003b9QXtGUqwcYgI3Zz3OeFaXBdvrVLnHNa4U5zDqjiiOBBhWaXnLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376347; c=relaxed/simple;
	bh=ZKR3YL7DOGMM33HkTzgkuXuovQncJmpU/sGGmUwK81Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AKPKvz43UkLgNO61GAtf9LA8z132unciLIXP7Unnugb7m7eeuj4QXmqc9gykFo8pN6MXkgex6GGiN8FQckbMm5TRgYJ5kSVC/1nzch+DLmHeMyj2zxFtBIRnPd8KiMY5nLhBvMhjMa2x7Q2qaQvXEGXJj4PLjr635HLV9iFDERo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S3JmjT5N; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S3JmjT5N"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E61d4W1220073;
	Mon, 14 Sep 2026 08:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aE4dvM
	a+pgFR08pTQqS/RYVptiyrSgj2EERRyfiKGvg=; b=S3JmjT5NDrTSGI8TRmjlVO
	f3ydBjaPYj7XBxa/CzNYfVHd6loxEh410Mi2tShzUyJ95eWAVOIeFJyPWxbk7Nf4
	TYN3eXnPi3SgCIdz0q6SW4jZASWrDJdz9CH4vJk2GyxshlPAsK20rxKe+ipEaHmU
	1es7frHhEalnkgApwCJRv1Br3vTcfRSDqRXEVgMCvBEnZyhH184xNrGKI0OTtmgE
	HLhuqr5hHd6ylh735oqIWRe8NtASkpx5egUDhWzTf2rANW+94ALWw68gRjfWSW7Y
	wglNOEbcOOYP9EzBi3vQGvR9ctDoxqZ8Gl20ZlzR8T/vXpx28K+z3SV6oUP6GYFA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf4r6x6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 08:58:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68E5o9Kv1775175;
	Mon, 14 Sep 2026 08:58:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gnhevw2y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 08:58:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68E8wiIA30933374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Sep 2026 08:58:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0B2120040;
	Mon, 14 Sep 2026 08:58:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3885E2004B;
	Mon, 14 Sep 2026 08:58:44 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Sep 2026 08:58:44 +0000 (GMT)
Message-ID: <28c6b0e5-eff3-4556-802d-be6ed3f16615@linux.ibm.com>
Date: Mon, 14 Sep 2026 10:58:43 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
To: Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Kees Cook
 <kees@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
 <20260803182614.23f26c91@kernel.org> <20260804080455.GB326170@unreal>
 <20260804145756.331951b7@kernel.org> <20260806111739.GF23431@unreal>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260806111739.GF23431@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 6z6PFjUIU08umo8wYdOkU-brpLRUJTT6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDEyMSBTYWx0ZWRfX0MgKatl/gdlL
 NEB80UX1ne+/lllmiMm+HreI4VvlAiHs4oTYPe5krrEdoX8WbgBkqGeVoaElHaRS6r7hKmZYJeK
 8xTxSvIeVA0tSeBMUjYELIJ06bXa0mU=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aa7b748 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=1Diy75IYRmTSxbJiyC4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: hdYAq1H2Qstr8mQixZrYsGG0FkWKm-8t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDEyMSBTYWx0ZWRfX+pgIVr6PBaJC
 5+mUidS7qJLX6x3IC5Cml79bbK/ONHAoRUh2vP8oHmA/ImdjqvLC635PO5RAXFuC8ncTDBvK/I/
 tQDI/erZmtaz2fHfaJN/kudTYdcYpH/0xPl3ZNJbxQhD2vZ3ZWorcZyGck2wlNBqPieh43FRZic
 InY5OXMRBoFlxblPwZ6B/Yr/5odhnLM3x9UPKCRDC/X7KcxXWaMKsbLpKxAEO0eO6vvr/kjq9g9
 3Vx0zE/ox1ELxuYcQijPi3hw3Vhgm7Xq/LovuWWE1h9iUjkJ/qtPsy/WuofRNdB3jtP0iGCwtlB
 3G4zrqNf/roay59QkeLLndUG/OpIBPLmDhWj6LclnRwIA4+jP/BYk/mGqlsxOmTBFtBPGoF1LIl
 sa5X0yRNmvJORbhXctJYxCfnXjPGtgj4ILFLuDqmIb06thfZfYt4TrXZmCQkfx8sm+9gkwovnBy
 3Rzg0wkVCGyVV23rGiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140121

Am 06.08.26 um 13:17 schrieb Leon Romanovsky:
> On Tue, Aug 04, 2026 at 02:57:56PM -0700, Jakub Kicinski wrote:
>> On Tue, 4 Aug 2026 11:04:55 +0300 Leon Romanovsky wrote:
>>> On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
>>>> On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:
>>>>> Prefix each cache name with the device name to make it unique.
>>>>
>>>> Why do we need a per-device kmem_cache?
>>>> Isn't the right fix to make this driver-level state?
>>>
>>> This kmem_cache is required only for software managed steering mode, which is
>>> configured per device by mlx5_fs_mode_set(). In general, resources
>>> should be allocated only when they are actually needed.
>>
>> Of course you have to wrap the init in a lock and count users.
>> Trivial stuff.
> 
> I don't see why we should abandon the simple, architecturally
> correct approach of allocating and managing resources where they
> belong in favor of a more complex global scheme involving locking
> and reference counting.
> 
Any updates on this?
