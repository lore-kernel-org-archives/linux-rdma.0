Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18F93812FB;
	Tue, 18 Aug 2026 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787066988; cv=none; b=Pi1BfuvwmQrT086Bna4zgzKV6YAo0byXQqg1vUXmcx+RygmDyxL0dJb7FTQ0WnH8QI6JEmQudnfLUgp1/uw7CN327adei41NqdEnn4uvAVSl/AonAW6DTG+aPyk/ZZUogVY7wuvVerapepENEQeMbneI5Mfd/pqrGovRbWAU3YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787066988; c=relaxed/simple;
	bh=xl0NyXNqSvTP56iARQ/D0BKi55b3jNZbbiRk3wgwyk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BKThDcoYQ6ykC9Z8JrPGTswL7HlFW8uJezM1OQhnrR0zE0JTbdyq3RkRXfLP3RgqJEKtsaDujDCPUrS25pO2BtylsK5j/JX4SzMN8VyXvz2AiF/a9veprPXHKYxzoReOIX1TcURSMtpxO8MOQCPixc/+EdFfVbiYSYBt4aQVLM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=r2mx6SYv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="r2mx6SYv"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IE3Zkv455087;
	Tue, 18 Aug 2026 15:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=adT1B1
	9TjTjVHbV+6tXcTgDOYZLt+4FWuGuxN8YIy5A=; b=r2mx6SYvk/hRQgqgF92eqK
	xBp2gu5DgZEDNsQ/ZwLz0Bi6Bt+UX3lj7om03tGtGZ51q7CWF32WB6G6RLRJgxPC
	DP9HUEABov6vgQ5xcD9YnbarfUOWq+4jP37njU4fok6p2T+8H8BzbiSOwNcp7VBf
	UDmyk20lE7JRPfXIoMeu3pm0MRlxRU2Vxa00hK338c2mPHS2U0XBaZXEHx5SXyOR
	4RRlv3o9rrnxpid9T1N6e84DDtX0gtXCeV9NaL8XkSM4wOJ6JSnqPHLKpn/EaYGg
	FvWIsAT3OenmP9j0ANjTqCRDbpnrQNL2jtEQ0u0lYwF4IM9l1q5K0oXG/4UADAww
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3s4p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:29:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IFQOQS020197;
	Tue, 18 Aug 2026 15:29:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xh3w3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:29:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IFTLcp47251746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 15:29:21 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B5B520043;
	Tue, 18 Aug 2026 15:29:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19E1E20040;
	Tue, 18 Aug 2026 15:29:16 +0000 (GMT)
Received: from [9.39.17.238] (unknown [9.39.17.238])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 15:29:15 +0000 (GMT)
Message-ID: <f0877836-771e-4f87-bf7b-adc7053d8446@linux.ibm.com>
Date: Tue, 18 Aug 2026 20:59:15 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6 1/3] net/smc: fix use-after-free of the LLC qentry
 in smc_llc_srv_add_link()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, wenjia@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc: leitao@debian.org, horms@kernel.org, mjambigi@linux.ibm.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        guangguan.wang@linux.alibaba.com, kees@kernel.org,
        gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260811231902.47089-1-yhlee@isslab.korea.ac.kr>
 <20260811231902.47089-2-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260811231902.47089-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: HVmFH0Dq7NDAPlFAaSHP9FCOrXOpKxgN
X-Proofpoint-ORIG-GUID: iIWA3Bmrpev1fNI1VUGPY8WetMFYBMO1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDExMCBTYWx0ZWRfX4qAOgw9+5jU9
 B3xw7ykniW16ac/ej184Avrde6C7kxU1uq3eMWtOhd7ja5KrnUvVDtGLz3WGNiT5xg0D6igDwWN
 pFDenC1eOyT7rgnbI6Tq/CHuzJpSRs4=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a847a57 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=kukDy1qahNa2q44RZiwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDExMCBTYWx0ZWRfX24F9QwQRwMHe
 nF1W2GkS2bhBeHMk+Zjou8o3I3G5L7zB13ZCqVYO80Kk5r+7qsWQQkkKEPy0z2Ae6cXIXzUHz1I
 6newb0Vi8XwJUuTdJtTdZk3tirIkmKJxvDVkeBfBYjuEtaqajPii8O5vebVI70NfFTMfkGXzEaj
 NZczenBB3dvww2jSs8wvhLP03foGpiVRNRo0O6ZSDMNvDvYFp5dnWaeqe0Nl1t6ij1fRq1udbxy
 YX45hx7wd6SMeIOtdFo+0WWqYyX1Y+LySNzqSXQQnJKiYsrAD9BSU5Ie9qJdlft9POzdPQkkwOC
 4QH2dQ19XiTOsLc1aL1O2C60hydpmWrKLIqBh3SsN52mpcZ2YtH4lSVNrAsQPV4t4Yx8Tq7BJ8b
 psfV/i+nfTZHP33arVHw6bdvEQEtjQgweSkrH3ngnZ6X1DEpF/VLFVjDCiNd/7iByeqHD02gavv
 sN0OBHlm8N67W1SMRLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180110



On 12/08/26 4:49 am, Yehyeong Lee wrote:
> smc_llc_srv_add_link() keeps add_llc pointing into the queue entry:
> 
>   add_llc = &qentry->msg.add_link;			smc_llc.c:1482
>   ...
>   smc_llc_save_add_link_info(link_new, add_llc);	smc_llc.c:1494
>   smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);		smc_llc.c:1495
>   ...
>   u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
> 	(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;	smc_llc.c:1504
>   smc_llc_save_add_link_rkeys(link, link_new, llc_msg);	smc_llc.c:1506
> 
> smc_llc_flow_qentry_del() kfree()s the entry, so on a link without a shared
> v2 receive buffer the pointer handed to smc_llc_save_add_link_rkeys() is
> already freed.  Before the Fixes: commit that branch always used
> lgr->wr_rx_buf_v2 and add_llc was not used after the free.
> 
> Reproduced on an unpatched tree over rxe, with KASAN, kasan_multi_shot
> and a link forced to max_recv_sge == 1: the entry is freed and read by
> the same call, and the freeing frame is smc_llc_srv_add_link() itself.
> 
>   [    2.523161] BUG: KASAN: slab-use-after-free in smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.523499] Read of size 2 at addr ffff8880052194de by task kworker/0:1/11
>   [    2.523789] 
>   [    2.523862] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 7.2.0-rc5-p0-g2c9dd296545d #35 PREEMPT(lazy) 
>   [    2.523865] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>   [    2.523866] Workqueue: smc_hs_wq smc_listen_work
>   [    2.523869] Call Trace:
>   [    2.523870]  <TASK>
>   [    2.523871]  dump_stack_lvl+0x53/0x70
>   [    2.523872]  print_report+0xd0/0x630
>   [    2.523874]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   [    2.523876]  ? smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.523878]  kasan_report+0xce/0x100
>   [    2.523879]  ? smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.523881]  smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.523883]  ? smcr_buf_reg_lgr+0x2a4/0x660
>   [    2.523885]  smc_llc_srv_add_link+0xaa2/0x1e50
>   [    2.523888]  ? _printk+0xba/0xf0
>   [    2.523897]  ? __pfx_smc_llc_srv_add_link+0x10/0x10
>   [    2.523899]  ? down_write+0xb0/0x130
>   [    2.523903]  ? __pfx_down_write+0x10/0x10
>   [    2.523905]  smc_listen_work+0x489e/0x4d00
>   [    2.523907]  ? kmem_cache_free+0x1c6/0x3a0
>   [    2.523911]  ? __pfx_smc_listen_work+0x10/0x10
>   [    2.523913]  ? release_sock+0x148/0x1d0
>   [    2.523915]  ? smc_tcp_listen_work+0xb4f/0xfc0
>   [    2.523917]  ? _raw_spin_lock_irq+0x80/0xe0
>   [    2.523918]  ? __pfx__raw_spin_lock_irq+0x10/0x10
>   [    2.523920]  process_one_work+0x633/0x1030
>   [    2.523922]  ? assign_work+0x11d/0x370
>   [    2.523924]  worker_thread+0x45b/0xd10
>   [    2.523926]  ? __pfx_worker_thread+0x10/0x10
>   [    2.523928]  ? __pfx_worker_thread+0x10/0x10
>   [    2.523929]  kthread+0x2c6/0x3b0
>   [    2.523931]  ? recalc_sigpending+0x15c/0x1e0
>   [    2.523934]  ? __pfx_kthread+0x10/0x10
>   [    2.523935]  ret_from_fork+0x36e/0x5a0
>   [    2.523937]  ? __pfx_ret_from_fork+0x10/0x10
>   [    2.523938]  ? __switch_to+0x572/0xdd0
>   [    2.523943]  ? __pfx_kthread+0x10/0x10
>   [    2.523944]  ret_from_fork_asm+0x1a/0x30
>   [    2.523947]  </TASK>
>   [    2.523948] 
>   [    2.531253] Allocated by task 48:
>   [    2.531399]  kasan_save_stack+0x33/0x60
>   [    2.531570]  kasan_save_track+0x14/0x30
>   [    2.531737]  __kasan_kmalloc+0x8f/0xa0
>   [    2.531905]  __kmalloc_cache_noprof+0x158/0x370
>   [    2.532100]  smc_llc_enqueue+0x72/0x560
>   [    2.532268]  smc_wr_rx_tasklet_fn+0x474/0xa80
>   [    2.532491]  tasklet_action_common+0x20f/0x8a0
>   [    2.532714]  handle_softirqs+0x18e/0x590
>   [    2.532886]  do_softirq+0x3b/0x60
>   [    2.533036]  __local_bh_enable_ip+0x61/0x70
>   [    2.533221]  __alloc_skb+0x732/0x890
>   [    2.533384]  rxe_init_packet+0x16b/0x4f0
>   [    2.533567]  prepare_ack_packet+0xb8/0x830
>   [    2.533760]  rxe_receiver+0x495/0x96e0
>   [    2.533933]  do_work+0x144/0x470
>   [    2.534078]  process_one_work+0x633/0x1030
>   [    2.534257]  worker_thread+0x45b/0xd10
>   [    2.534424]  kthread+0x2c6/0x3b0
>   [    2.534569]  ret_from_fork+0x36e/0x5a0
>   [    2.534737]  ret_from_fork_asm+0x1a/0x30
>   [    2.534907] 
>   [    2.534980] Freed by task 11:
>   [    2.535112]  kasan_save_stack+0x33/0x60
>   [    2.535279]  kasan_save_track+0x14/0x30
>   [    2.535444]  kasan_save_free_info+0x3b/0x60
>   [    2.535625]  __kasan_slab_free+0x43/0x70
>   [    2.535798]  kfree+0x121/0x380
>   [    2.535935]  smc_llc_srv_add_link+0x9a8/0x1e50
>   [    2.536128]  smc_listen_work+0x489e/0x4d00
>   [    2.536305]  process_one_work+0x633/0x1030
>   [    2.536482]  worker_thread+0x45b/0xd10
>   [    2.536652]  kthread+0x2c6/0x3b0
>   [    2.536794]  ret_from_fork+0x36e/0x5a0
>   [    2.536958]  ret_from_fork_asm+0x1a/0x30
>   [    2.537133] 
>   [    2.537205] The buggy address belongs to the object at ffff888005219480
>   [    2.537205]  which belongs to the cache kmalloc-96 of size 96
>   [    2.537719] The buggy address is located 94 bytes inside of
>   [    2.537719]  freed 96-byte region [ffff888005219480, ffff8880052194e0)
>   [    2.538216] 
>   [    2.538289] The buggy address belongs to the physical page:
>   [    2.538524] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5219
>   [    2.538857] flags: 0x100000000000000(node=0|zone=1)
>   [    2.539066] page_type: f5(slab)
>   [    2.539210] raw: 0100000000000000 ffff888001041280 dead000000000122 0000000000000000
>   [    2.539534] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
>   [    2.539863] page dumped because: kasan: bad access detected
>   [    2.540098] 
>   [    2.540170] Memory state around the buggy address:
>   [    2.540379]  ffff888005219380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   [    2.540684]  ffff888005219400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   [    2.540988] >ffff888005219480: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>   [    2.541291]                                                     ^
>   [    2.541548]  ffff888005219500: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>   [    2.541857]  ffff888005219580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
> 
> The offset is past the 72-byte queue entry because the out-of-bounds read
> fixed by the next patch is on the same line; what this patch removes is the
> free at smc_llc_srv_add_link+0x9a8 happening before the read at +0xaa2.
> 
> Detach the entry instead of freeing it there, and free it at the single
> exit label.  The reject path has to detach as well, otherwise it would be
> freed twice.
> 
> This changes only the lifetime of the entry.  The same read still runs past
> its end until the next two patches bound it, so a backport wants all three.
> 
> Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> Changes since v5: return through the existing exit label.
> 
>  net/smc/smc_llc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 954b2ff1815c..055a03eee5b5 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -1481,7 +1481,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  	}
>  	add_llc = &qentry->msg.add_link;
>  	if (add_llc->hd.flags & SMC_LLC_FLAG_ADD_LNK_REJ) {
> -		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
> +		smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
>  		rc = -ENOLINK;
>  		goto out_err;
>  	}
> @@ -1492,7 +1492,8 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
>  	}
>  	smc_llc_save_add_link_info(link_new, add_llc);
> -	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
> +	/* add_llc still points into qentry, so only detach it here */
> +	smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
>  
>  	rc = smc_ib_ready_link(link_new);
>  	if (rc)
> @@ -1512,14 +1513,14 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
>  	if (rc)
>  		goto out_err;
> -	kfree(ini);
> -	return 0;
> +	goto out;
>  out_err:
>  	if (link_new) {
>  		link_new->state = SMC_LNK_INACTIVE;
>  		smcr_link_clear(link_new, false);
>  	}
>  out:
> +	kfree(qentry);
>  	kfree(ini);
>  	if (send_req_add_link_resp)
>  		smc_llc_send_req_add_link_response(req_qentry);

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
