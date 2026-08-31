Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC7833987E;
	Mon, 31 Aug 2026 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788188278; cv=none; b=aNOy4hGvuv6Gdgh2H4G68td4Cn6JWPaVXreyf09I8hzCwEKShDHtHsZKvHxGRbIojcWDiyXXq7WMONhdTxuMyuG5xtYsk0rg+kHswVGZlXB5FiV8OlCK9k+rRUrfODFUKrpx6KPurjkKoF4O9zTuCDfqjAmsvMZh+EP115/gzps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788188278; c=relaxed/simple;
	bh=HO5kmOtNwuKp9RdzryBYT5mTV1ZJaA3grxXdS9DNCL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hk0iqV+von0kteDNPVHihTCNzbx+T0lTgwoRbkxxa/iGDNT9e6D2v/N+wu/4+KM/CvG1lKGySPIuAMFbg0SJ9aivHsq3xNjSlVWSNvPQNkf4ZSE9sk4Z5oIbEGKYqRP1k3kiJrzPlyBp+5rArjMqtuMSOpFxFs7a0Yhv43U5mc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l6I71WtC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l6I71WtC"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VEZ9Eu2582944;
	Mon, 31 Aug 2026 14:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hZIcpU
	H15T+9a96dE7EJP8l8tHDu5cwRhyicisjUOWw=; b=l6I71WtCmB/p7U+Ds+zf0H
	svcttTrIyLnfU2yGLysxRVR3+acrdhK4Q7NNb9RQO0neWeLF8ir6bMVUgAhrG9PX
	gQXNv6rw9VW8e4rjbiiIZFNEDt/gvxZd+u8RHrcJUWUJeiZTjhIkPli8Q/PlgFq2
	RXmH9QIs3SoIL7C56GeZsMFF9vvf6WQqTAsNmIC8j/+oSj674NLG2R25iIurbgNL
	iqNsZzn5nacPV3F9V4Y3mhS1s2hQ0gZDgrmOzn6wm5e0i7bUr5k2nCGTuzp4NEV8
	YoV/p1DHAZnH8PKgnMEA5T5DY9I2uoSry+4AQMVdPsueXDJGqaWSvtXpoP7EhZUw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2t1usv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 14:57:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67VEuM1Q003228;
	Mon, 31 Aug 2026 14:57:47 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rq6nqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 14:57:47 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67VEvjnJ29032960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Aug 2026 14:57:46 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8BEA5805A;
	Mon, 31 Aug 2026 14:57:45 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64FE458051;
	Mon, 31 Aug 2026 14:57:40 +0000 (GMT)
Received: from [9.124.217.200] (unknown [9.124.217.200])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 31 Aug 2026 14:57:40 +0000 (GMT)
Message-ID: <4f303f9f-fd20-475a-8004-1a670dfd34df@linux.ibm.com>
Date: Mon, 31 Aug 2026 20:27:38 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 0/2] net/smc: fix diag dump lifetime races
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20260828065439.3582783-1-mjambigi@linux.ibm.com>
 <apWEzobrZ3QR3IfN@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <apWEzobrZ3QR3IfN@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a95966d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=neV5QV29Z2xUnIvzB3QA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDEyNSBTYWx0ZWRfX3jatAELW01r8
 IBsHyfuWmKzKlrrsPpmLWStI0L5JzZ6mAoFqYdXrKpkY1gY5EcmnC+C89V/yvumt+nD579JoVZy
 cd5V/I5RGFnTkZrQmmAbxPVesriFqbs=
X-Proofpoint-ORIG-GUID: -N3OhC-74rvQlZ18lWypARTHJR5EsbdS
X-Proofpoint-GUID: FuhQQLgOjlbMbPyeWDkx0JCxXzKpsuHu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDEyNSBTYWx0ZWRfX1BEnnsm/caeS
 4Zm+r+nSzbH8zYKALGBHgo4e1HUzmIy5JgZgtGiL3+qEmxQ1T4cTcv0lJDaHsGJ7uOrQgNTWsnN
 ugNMvWZvLaXWvA7K8MOk1l+hV1lrc4/ljhNQHjEwCiJR+AqyZiOtNJ1pTm7yqxfQ4cWWmIgocrc
 Cz7jqRw/lsLjx8zoG+BF5C9YE02KzVuZVfL1lw1PrGraErKarWCv/OXe9nEIV9atZMLyNDilNgv
 uq7loBpuaiESTN0jnJjymaqIyO13iAantT1qdnUyyyBYBIuVXnWqxn3+USLFdZ0/yqsqEOhS3NL
 NuzMvJz1rm/3FZJdg4102Yc/o5hQ4JDpUE4MbWSuY6BLAFbMw5ZUrmFIGJgmj8IfSolwbNTVz6C
 5CJst40H+KMyyZ0fKTyEHVCpIqudLQmDHiBKQ30xpS+BKTVcgzAVoDf1++C1r1dhLtRXCVILPBZ
 im2b8U60kYMnxhDS8DA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310125



On 31/08/26 7:12 pm, Dust Li wrote:
> On 2026-08-28 08:54:37, Mahanta Jambigi wrote:
>> This series fixes multiple lifetime races in the SMC diag dump path.
>>
>> The first patch adds the basic infrastructure needed to synchronize diag readers
>> against connection-owned conn->lgr/conn->lnk updates. It introduces a
>> per-connection spinlock and uses it in the link switch and connection free
>> handoff paths. conn->lgr and conn->lnk are NULLed under the lock before the
>> borrowed references are released, so a non-NULL conn->lgr seen under the lock
>> guarantees the lgr object is alive. The diag reader can rely on this invariant
>> without borrowing any extra reference.
>>
>> The second patch fixes two races in smc_diag itself:
>>
>> - serialize clcsock field access against smc_clcsock_release() with
>>  mutex_trylock()
>> - take conn->lgr_lnk_lock when reading conn->lgr and conn->lnk; use
>>  smc_conn_lgr_valid() inside the lock to check that the connection is
>>  still registered, then snapshot all required fields and call nla_put()
>>  after releasing the lock
> 
> Hi Mahanta,
> 
> As discussed in the other thread, I think we should defer the release of
> smc->clcsock and remove clcsock_release_lock.
> 
> In that case, we should no longer need these two patches. Also,
> introducing more locks in SMC is the last thing I want to do :)

Thanks for the new series "[RFC net-next 0/7] net/smc: tie clcsock
lifetime to the smc socket and remove clcsock_release_lock" — once it
lands, we can drop the mutex_trylock() fix for Race 1 (clcsock).

However, Race 2 remains open. Your series does not touch smc_core.c or
smc_cdc.c, so smc_conn_free(), smc_switch_link_and_count(), and
smc_cdc_msg_validate() still write conn->lgr/conn->lnk with no
synchronization against the diag reader.

On the lock concern — lgr_lnk_lock is a per-connection spinlock. It is
taken in smc_conn_free() (teardown), smc_switch_link_and_count() (link
failover), smc_cdc_msg_validate() (failover validation branch only, not
the normal CDC data path), and the diag reader. None of these are on the
per-message send/receive hot path. Could you explain what specifically
concerns you — lock ordering, memory footprint, or something else? That
would help us understand whether you have a different mechanism in mind.
