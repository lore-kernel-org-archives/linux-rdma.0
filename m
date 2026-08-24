Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4D3AAF62;
	Mon, 24 Aug 2026 08:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787560343; cv=none; b=Uj15LASRsBzl8BJHCL//eyXHD+mV/aeVx6iATFDS5PZXkRQh6yUau+h0QUbtKXX5nATwkV3WVWjxCl7bhIA2qSGSxfRK3IQblwdFmwe87bM2EV00oyGhT7c5qks8433uqWi909H0Ul8Vm/2CdRkuZUUqXPSNooskYtfbfgT8PPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787560343; c=relaxed/simple;
	bh=s0vFBnZMwlAfy6AMmoxszWppenAdjDviStyPtJLJD+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ipXo8kiyGES3DG7Q+LTYls7L5V5aFyWcB/vm/EOkdtEkRtiuJwWySTEtOp+cTSDj04/lnRLS6ll2jfzfDHM6COJDO5YStRJJHlxhJaPhdmyV72IBtS375jY+J++T5izDj2CEXeDScCYnxqw+ZTvcIKuUBC1m98gJOmj+HMxnOlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N3UbUk9J; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N3UbUk9J"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67O5W5H3940186;
	Mon, 24 Aug 2026 08:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1zrRQ2
	NH/FFY8kJhmuzfVwPT/3VJi62Ewq0b4x/TINU=; b=N3UbUk9J0MUuSPiSElyn5e
	frrb74QxV6J7ybPWrnyCz093hHjd3x0QartNP/IqhFKbAgd0UCR+xNlKfy4wbF8R
	E2Z6YeotWDgXdRd5+MJiyx78qP+NRo7W7gml4Gr37KdMlrRK2QP2LctQYsBfMNLq
	/+/5gsQnWrIWF3MZQ46Ph+kdzTJcfzL731Ns2HqHwADp8haYx4miUt/l27MR5PWS
	xLMCKQZL+zUmrg5yV9IaEVCOxjzECyfd4HKda+TyqwpmEGprT/HqZORAE2fufjL5
	RuurqexF0Z2HvmpvZ/07FZyjnGlkGlFcLhuLrUjO55HppPV409y4DOw0pIF3Q3qQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g7393r3mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 08:32:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67O8QJKe019299;
	Mon, 24 Aug 2026 08:32:12 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7pfvvx0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Aug 2026 08:32:12 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67O8WAiJ17629752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Aug 2026 08:32:11 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3E9A5805D;
	Mon, 24 Aug 2026 08:32:10 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1524B58053;
	Mon, 24 Aug 2026 08:32:04 +0000 (GMT)
Received: from [9.124.213.220] (unknown [9.124.213.220])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Aug 2026 08:32:03 +0000 (GMT)
Message-ID: <758a944c-c26f-4509-a898-d93f345c19ca@linux.ibm.com>
Date: Mon, 24 Aug 2026 14:02:01 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 2/2] net/smc: reduce TX slot contention with
 exclusive wait
To: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
        wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260821091702.21458-1-alibuda@linux.alibaba.com>
 <20260821091702.21458-3-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260821091702.21458-3-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: WApZ08PhHDNh6VX1HZBLVxf3Zxs2qbhu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI0MDA3NCBTYWx0ZWRfXyvuaPqPotyiN
 E2xAe5dkMdXsA3HsCB8XDxKI/CRUkDLtTvQamoNilyyjeke1ThrZKxL1SGdCOJidysF6luZGSZU
 UNXYM0VPsCZJwJ8xHRAxBJbRal7PWgDGquDdyVRrmtbOQem4ZkIpxm5rxlJo5YSw11hHsYeBA5L
 TqZ9OzucH+TevVPuH6hvIiSA0TBRg5D8vzdduKMasedtwgOkYEEdLM42g5mhhkYr2yf+zDaNwnQ
 N9FTE1wxBXLasVyLRi4SjgQCFwmv4vV92u4cXQ9Wa+FjelImtM2u00fYNM7+on2SEsSEcvJBhzz
 eKdfbwEU+YDFS4SOlWccyZOVY+cscgd25TG1obSLeP3LVSA3WD3jh1q8XJg740CMDVZysCxaAWj
 rKii/n++8RSy8L4bWWJP9oJTTnLLd2c1+DJrwxaPDox+eoIrtrTohZiCpnBk32RHXqDPvLBQ4O6
 xzS4ileDJ5d6kWUp6XQ==
X-Authority-Analysis: v=2.4 cv=Y/nIdBeN c=1 sm=1 tr=0 ts=6a8c018d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=WkmksbYtVH5hfBaYqvIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI0MDA3NCBTYWx0ZWRfX2d5hFw5ZNCCl
 b5lguwu2dKqcdHcC0ryB8iFR2pYp14vdO+NP4V9/FufiaplOCJfNBVB4+O2iUDYZuTPl1QSuJVh
 gBwoN5AfLQ+76kqooxICx75kYed+rv0=
X-Proofpoint-ORIG-GUID: pqF10GpYHgGShriTzhZpY2wQhv9uJRsZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-24_02,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608240074



On 21/08/26 2:47 pm, D. Wythe wrote:
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

Overall, I am also seeing significant performance improvements with this
patch, ranging from approximately 20% to over 150% across several
workloads. Do we expect to see further improvements once the CQ pooling
patch is applied?

> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
