Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B362F37E317;
	Fri, 11 Sep 2026 03:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098865; cv=none; b=qlrdGdVwhvl8vmn0GEWi+z7w5EqIF58toE28t9q+u1+R4wlwd0Rcf6S67byoJTBdEZYUuBbc4lHmvQJeg363bon8Mxo2KQz8CXkaHuD5TvBVPG6tVjwQc+25KqGmrPyFPI298N5BXPjG8cmHnTuCkgor1UuF4YMEwEJGS0nKgNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098865; c=relaxed/simple;
	bh=4CNeuAiMXKDFzrKGBHnq1HcwHcW5lIpm1pwAxGeDApo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=antb711uFqhPyXRP2v/j5K728moYpBszayUvyEPVxMyUOo8agn2hPFdnSvl0JnzsGET3uquq70GTn+aYSqA5ejGgzHYdy8hwKXIm0hLcQ6Lcr9mjkCyIhgpqT/V6D01I+d5SY5RBBueOxrWiizfCzpL8XvEW41DnjDb38kBFs+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zf2oZX2j; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zf2oZX2j"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12QOM3366978;
	Fri, 11 Sep 2026 03:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G/DDPX
	8uJURHubi8aSxS5N+qxiioihbQfkz1SsalV/I=; b=Zf2oZX2jrSd1tFrOGz+8xh
	S8JdiB1Su0jQT2pFm4ic8z7etn4aIKrrmKMT1wroxdmsiYBlAej4Pw2vSfBrjZ7V
	ZA9KafUZ2axrCW4nj6v891P5QKx1TC6YRL8Uh3om7Sd/yRrD1eM2PpkByb/xzEbN
	JUk/XFUpHFfgEx7vJXvImktE7FCqeY2y0ZkXtH2dHjtRkf3d73PKENIpd9lqNinD
	4f/k6Crb5+9m3mawu0m6AaAsKBvUNjG7V42S9qD2622yP4xBcGhbdNgpaCzdND3V
	hRsT2eK63fD4fo4KG1FSGQkLfAzq1MokNI3Xy295T027BH+otp177Zv9k9lcOV+g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q92t5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:54:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B15Db2855289;
	Fri, 11 Sep 2026 03:54:16 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrc4u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:54:16 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B3sEve7602890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 03:54:15 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFF025805A;
	Fri, 11 Sep 2026 03:54:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9905F58052;
	Fri, 11 Sep 2026 03:54:09 +0000 (GMT)
Received: from [9.111.170.138] (unknown [9.111.170.138])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 03:54:09 +0000 (GMT)
Message-ID: <1347240c-080d-4bcf-be88-231d4e1477bf@linux.ibm.com>
Date: Fri, 11 Sep 2026 09:24:08 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/2] net/smc: reduce TX slot contention with
 exclusive wait
To: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
        wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260910104446.41423-1-alibuda@linux.alibaba.com>
 <20260910104446.41423-3-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260910104446.41423-3-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 2YDA34b_9ra1Xa-sEbpvW_QxI8j1lpkc
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX7vLBCc9wuimc
 zshcK4rGnW0lXWJGd1hEMVi7tky2lIN37HBWvtOsJvMf6KxblN+LcCPnef4jh7nMStP++n9LWfd
 n/WF2ePHi5TQC7XUBOxMO45mjRv8VLU=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa37b69 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=WkmksbYtVH5hfBaYqvIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX0G03dXi5uHKX
 jkL/gYXA/Vi+MO1qlWd811qKjpXgyKv8Ay6VNQkszdqpoPYL0KKTO4P5zOWwDxn1DN1gGvTCYkm
 W/NVjVLulbFdtwDZllszKTe/MA7vtzNcGiePX8J73NzHeRV/nC9zAqurOvIzovVCnllzJMgN8j+
 MWLzLNsM1XPSISALrgSoAwxxNek8AQFmeOJo7TjhDGWUywm7nBAsMv8yVGvLB9LkoH4GLD60QQk
 toVBL87EXD+vWpkZ512CKrYtIp8Q2HZLPRhNxfNDlHOr/gLc68JFQXjcKO/czr9y2z0o0M7iZth
 S8NcRhbWuHvtGZ4SuDVIHL0bjSlSZjl/p4l5kGNKDOYI1+3XRj1yPE6KYvshaeZ6BRjasj2jagu
 /FAJ+3k4sAShN7YWyhRJYZeO5oHxWvk/q1PwptUUaTAjUVWvRUcqUhsw9/ilOeh1KtnjSDHrK5R
 ugpNZHoaF5DbBcT4JUQ==
X-Proofpoint-GUID: jTBoy7z2KF5k7P7Xyb8JNSQE_kSj8aTs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110045



On 10/09/26 4:14 pm, D. Wythe wrote:
> smc_wr_tx_get_free_slot() waits for a free TX slot with
> wait_event_interruptible_timeout(). Since the wait_event family
> enqueues waiters as non-exclusive, wake_up() may wake multiple
> waiters even though only one can use the slot, causing
> thundering-herd contention when slots are scarce.
> 
> Use an exclusive wait loop with prepare_to_wait_exclusive() so
> wake_up() wakes only one waiter per freed slot.
> smc_wr_wakeup_tx_wait() still uses wake_up_all() during link
> teardown, so teardown behavior is unchanged.
> 
> This also corrects the return value on a pending signal: the previous
> wait_event_interruptible_timeout() path fell through to the "no free
> slot" case and returned -EPIPE, masking the signal as a connection
> error. The open-coded loop now returns -ERESTARTSYS, matching the
> standard interruptible-wait semantics and letting the syscall restart
> machinery handle it.
> 
> Performance
> ===========
> 
> Measured with uperf between two peers over SMC-R. The benefit depends
> on how often the TX slot wait path is actually taken.
> 
> With the default settings, where many connections share a link group
> and the send queue is small, slots are scarce and the wait path is hot:
> 
>   net.smc.smcr_max_conns_per_lgr = 255
>   net.smc.smcr_max_send_wr       = 16
>   net.smc.smcr_max_recv_wr       = 48
> 
>   workload                 baseline      patched     delta
>   ---------------------------------------------------------
>   rr1c-200x1000-50.xml     655.06 Mb/s   1.53 Gb/s   +134%
>   rr1c-1x1-250.xml         371.03 Kb/s   2.07 Mb/s   +458%
> 
> With a tuned configuration, where slots are mostly available and the
> wait path is rarely entered, the change is neutral to slightly positive:
> 
>   net.smc.smcr_max_conns_per_lgr = 32
>   net.smc.smcr_max_send_wr       = 64
>   net.smc.smcr_max_recv_wr       = 64
> 
>   workload                 baseline      patched     delta
>   ---------------------------------------------------------
>   rr1c-200x1000-50.xml     1.74 Gb/s     1.80 Gb/s   +3.4%
>   rr1c-1x1-250.xml         3.11 Mb/s     3.14 Mb/s   +1.0%
> 
> So the change does not regress the uncontended case, and recovers most
> of the throughput lost to thundering-herd wakeups once slots become
> scarce.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
> Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

I don't see a changelog describing what has changed since the previous
version. Any Sashiko comments were addressed? Could you explain why this
is being reposted?
