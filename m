Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FCF379EC1;
	Tue, 18 Aug 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067177; cv=none; b=Zu/uFfSbED0n4YNFkE9XOZk5NN7oY7su4/1m8+ylCJoCgTQb+mnXZxmU00Z1xbqDwkyMQIBEL4jtG/YXdty8U+dH1SaE3dAuanrsot1ysKJVFZCQvwtGR1Z//ZqrCUv8ZKU7Ug898I6HDfbhozL7/Bs7NPMUsvVGX0K5PNsvJNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067177; c=relaxed/simple;
	bh=VvD0J37ir0e+6lF4/vW2Px67MMZ67SyBnKd/s4bkqx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s0nXv676kOHVpvvzEIIUYKnQoK0r+J3Z+Wrs7LjGmJ5xfdGU9yCykJcTG69iq1Vaeu1+8NUpD3TO5rZWvuzIft93sJrnNztCiG7e4zANsqxGoH5lrMZ1KsHyqffnqfEkcxwNzwvqONtMGU17V/RkyAC1Wh9vxFXTSrFOB5GWixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=picrml4p; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="picrml4p"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IE3Q2o454852;
	Tue, 18 Aug 2026 15:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+iiNwE
	wmOFteb60/smKLh/7Rg6bdyZwdh7oV8tfWkp0=; b=picrml4pjZVA5HwkP4P6ue
	62g81FhHnC9UMSjfAnh3aLwqF0WGqvR5Zfp9fy0umNv9TRNZSgLSwL6bUbNrfVJz
	gFT+AGCTN2kipyhK4yVXu0WBuxDWqefUGF6MpFBagNWuxZISdpkR+Zn8k3peLB5d
	uaxc9G9TEmzeT1hGFAa7XWYQSFxQGik4YAeCkKMqEQgmNOV7FboY5yvlBF4OB56F
	/8hj1A37HGlJPWQLk36S1Gre+kqemeP1tfY9CovVGXO/hGHd9eEt2BZmw0WhW8gP
	Q2NeWJWJNG4b6ReRYAS9nfPV6ZJp86s6QIE643BP2yrdrq4XRcefeT1Qf+DTSDbQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3s58p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:32:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IFQMIh009545;
	Tue, 18 Aug 2026 15:32:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ek3xkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:32:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IFWeXb45154560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 15:32:40 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40CA520043;
	Tue, 18 Aug 2026 15:32:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E06C20040;
	Tue, 18 Aug 2026 15:32:35 +0000 (GMT)
Received: from [9.39.17.238] (unknown [9.39.17.238])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 15:32:34 +0000 (GMT)
Message-ID: <5f8c6328-dcb2-4031-9714-28d8f6c61169@linux.ibm.com>
Date: Tue, 18 Aug 2026 21:02:34 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6 2/3] net/smc: bound the peer rkey counts in SMC-Rv2
 LLC messages
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
 <20260811231902.47089-3-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260811231902.47089-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: cSsW9-iS-DAY2B7y55ITzxChCzx6DFtW
X-Proofpoint-ORIG-GUID: DOXmvJriSxRzZduaW6qsUB1vLfRCRoGT
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDExNCBTYWx0ZWRfX4zb/CxgFqDSk
 YVnbMn3swQsH+h9/O5TdEraj0tSBffgrK7DDpwXJxd/7IA6DY4z0y3KteH3/JbK/kRvz0t0TP8X
 raxFp9a4p/0hDIW7VEQJ6bs7oRskrVE=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a847b1e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1depko-BxKNq_XK0ZqAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDExNCBTYWx0ZWRfX2C5t5tcDYNju
 mI9QvPajETMlpwNLCG1mULedqlUqAVhTxi7MtKoH+RdRc0UPAH2J0YDgbXbLqA7JEmV3WppeexY
 G1ZrP4hq27vuARkj8fiGWQca7fb0Rq6ba/KGaO79PGNy0nguHgI8hZ54fC4kBlTvgkeE4ZeWzKm
 tw0wBAL7bbnCoN32cJ7M8c00yf4q0f3wexnrOJzkJxgX2sk3GFhcyMvzCu1fPzO3AvDDg36uows
 /yuEAI6hClW0gywC5whAZq4ts9XU9RFPzlJU3NVMYAWeHQuNc+TBjpS4gt7iPwdUemS33kaJ6Sm
 ABBn9wKJbrar40Qmblfa/2ciArKWQgPG3n2eCbe6vKHyCjrIdexbTDz31WZH7smRn6Y7F6SeK3R
 DDqwyFYsT6PgjYIYsB+agNZo7Rx+b89XvF7s2GCezKTa0qQLA0vk1YFliw8vaudWo3UKpG0dxCV
 9l7jLE+pVG0SM9zdl0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1011 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608180114



On 12/08/26 4:49 am, Yehyeong Lee wrote:
> On a link whose device has max_recv_sge == 1 there is no shared v2 receive
> buffer, and smc_llc_save_add_link_rkeys() takes the v2 extension from 44
> bytes past the start of the queue entry's inline message:
> 
>   ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg + SMC_WR_TX_SIZE);
> 
> The entry is a 72-byte allocation and the extension starts at offset 68, so
> ext->num_rkeys at offset 94 is already past it.  This happens on every

Extra whitespace

> SMC-Rv2 link addition, whatever the peer sends:
> 
>   [    2.490065] BUG: KASAN: slab-out-of-bounds in smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.490431] Read of size 2 at addr ffff8880056406de by task smctest/106
>   [    2.490709] 
>   [    2.490792] CPU: 0 UID: 0 PID: 106 Comm: smctest Not tainted 7.2.0-rc5-p1-g77a5d9d9c99f #32 PREEMPT(lazy) 
>   [    2.490795] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>   [    2.490798] Call Trace:
>   [    2.490803]  <TASK>
>   [    2.490805]  dump_stack_lvl+0x53/0x70
>   [    2.490810]  print_report+0xd0/0x630
>   [    2.490828]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
>   [    2.490832]  ? smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.490834]  kasan_report+0xce/0x100
>   [    2.490836]  ? smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.490837]  smc_llc_save_add_link_rkeys+0x333/0x350
>   [    2.490839]  ? smcr_buf_map_lgr+0x1bf/0x2b0
>   [    2.490844]  smc_llc_cli_add_link+0xca7/0x1e80
>   [    2.490848]  ? smc_llc_wait+0x355/0x810
>   [    2.490850]  ? __pfx_smc_llc_wait+0x10/0x10
>   [    2.490851]  ? __pfx_smc_llc_cli_add_link+0x10/0x10
>   [    2.490853]  ? __pfx_autoremove_wake_function+0x10/0x10
>   [    2.490863]  __smc_connect+0x3f5c/0x4980
>   [    2.490873]  ? __pfx_kernel_connect+0x10/0x10
>   [    2.490888]  ? __pfx___smc_connect+0x10/0x10
>   [    2.490891]  ? release_sock+0x148/0x1d0
>   [    2.490894]  smc_connect+0x42c/0x580
>   [    2.490896]  __sys_connect+0xfc/0x130
>   [    2.490898]  ? __pfx___sys_connect+0x10/0x10
>   [    2.490900]  ? handle_mm_fault+0x1a1/0x430
>   [    2.490908]  __x64_sys_connect+0x6d/0xb0
>   [    2.490909]  ? fpregs_assert_state_consistent+0x56/0xe0
>   [    2.490917]  do_syscall_64+0xf9/0x540
>   [    2.490921]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [    2.490924] RIP: 0033:0x421bb4
>   [    2.490927] Code: ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d ad 34 09 00 00 74 13 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 10 89 55
>   [    2.490929] RSP: 002b:00007ffd473b01a8 EFLAGS: 00000202 ORIG_RAX: 000000000000002a
>   [    2.490935] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000421bb4
>   [    2.490936] RDX: 0000000000000010 RSI: 00007ffd473b01d0 RDI: 0000000000000003
>   [    2.490937] RBP: 0000000000003930 R08: 0000000000000004 R09: 0000000000000000
>   [    2.490938] R10: 00007ffd473b0f98 R11: 0000000000000202 R12: 0000000000000006
>   [    2.490939] R13: 00007ffd473b0f87 R14: 0000000000000003 R15: 00007ffd473b0f90
>   [    2.490940]  </TASK>
>   [    2.490941] 
>   [    2.499545] Allocated by task 44:
>   [    2.499693]  kasan_save_stack+0x33/0x60
>   [    2.499860]  kasan_save_track+0x14/0x30
>   [    2.500026]  __kasan_kmalloc+0x8f/0xa0
>   [    2.500190]  __kmalloc_cache_noprof+0x158/0x370
>   [    2.500393]  smc_llc_enqueue+0x72/0x560
>   [    2.500559]  smc_wr_rx_tasklet_fn+0x474/0xa80
>   [    2.500747]  tasklet_action_common+0x20f/0x8a0
>   [    2.500945]  handle_softirqs+0x18e/0x590
>   [    2.501115]  do_softirq+0x3b/0x60
>   [    2.501266]  __local_bh_enable_ip+0x61/0x70
>   [    2.501446]  __alloc_skb+0x732/0x890
>   [    2.501604]  rxe_init_packet+0x16b/0x4f0
>   [    2.501783]  prepare_ack_packet+0xb8/0x830
>   [    2.501962]  rxe_receiver+0x495/0x96e0
>   [    2.502125]  do_work+0x144/0x470
>   [    2.502269]  process_one_work+0x633/0x1030
>   [    2.502450]  worker_thread+0x45b/0xd10
>   [    2.502617]  kthread+0x2c6/0x3b0
>   [    2.502762]  ret_from_fork+0x36e/0x5a0
>   [    2.502925]  ret_from_fork_asm+0x1a/0x30
>   [    2.503103] 
>   [    2.503177] The buggy address belongs to the object at ffff888005640680
>   [    2.503177]  which belongs to the cache kmalloc-96 of size 96
>   [    2.503692] The buggy address is located 22 bytes to the right of
>   [    2.503692]  allocated 72-byte region [ffff888005640680, ffff8880056406c8)
>   [    2.504227] 
>   [    2.504300] The buggy address belongs to the physical page:
>   [    2.504535] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5640
>   [    2.504865] flags: 0x100000000000000(node=0|zone=1)
>   [    2.505076] page_type: f5(slab)
>   [    2.505221] raw: 0100000000000000 ffff888001041280 dead000000000122 0000000000000000
>   [    2.505544] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
>   [    2.505867] page dumped because: kasan: bad access detected
>   [    2.506102] 
>   [    2.506176] Memory state around the buggy address:
>   [    2.506380]  ffff888005640580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>   [    2.506683]  ffff888005640600: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>   [    2.506987] >ffff888005640680: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>   [    2.507291]                                                     ^
>   [    2.507548]  ffff888005640700: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>   [    2.507850]  ffff888005640780: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
> 
> Whatever that read finds then bounds the ext->rt[] loop, so a peer that
> declares 255 rkeys reads much further.  smc_llc_rmt_delete_rkey() has the

Extra whitespace

> same shape for llcv2->rkey[].
> 
> Bound both loops by the buffer they read from, and skip the extension
> altogether when there is no shared v2 receive buffer.  The extension

Extra whitespace

> does arrive on the link, but smc_llc_enqueue() copies only
> sizeof(union smc_llc_msg) into the queue entry, so what that code read
> past the 44 inline bytes was heap and not peer data.
> 
> Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> v4 -> v5: corrected the reason given for skipping the extension.  It does
> arrive on the link; what is not there is the copy in the queue entry.  No
> functional change.
> 
> Measured over rxe with KASAN and max_recv_sge forced to 1, five test cells
> (plain 1-rkey delete, delete declaring 255, plain ADD_LINK v2, ADD_LINK
> declaring 255, and an SMC-Rv1 link group).  Without this patch four of the

Extra whitespace

> five report; with it none do.  With kasan_multi_shot the unpatched kernel

Extra whitespace

> reports 491 times in a single ADD_LINK run, the patched one not at all.
> 
> Changes since v5: none.
> 
>  net/smc/smc_llc.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 055a03eee5b5..748d65186f68 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -1000,13 +1000,21 @@ static void smc_llc_save_add_link_rkeys(struct smc_link *link,
>  					struct smc_link *link_new,
>  					u8 *llc_msg)
>  {
> +	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
>  	struct smc_llc_msg_add_link_v2_ext *ext;
>  	struct smc_link_group *lgr = link->lgr;
>  	int max, i;
>  
> +	/* Without a shared v2 receive buffer the extension is not copied
> +	 * into the queue entry, so not even ext->num_rkeys is there.
> +	 */
> +	if (!smc_link_shared_v2_rxbuf(link))
> +		return;
>  	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
>  						     SMC_WR_TX_SIZE);
>  	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
> +	max = min_t(u32, max, (SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE - rt_off) /
> +			      sizeof(ext->rt[0]));
>  	down_write(&lgr->rmbs_lock);
>  	for (i = 0; i < max; i++) {
>  		smc_rtoken_set(lgr, link->link_idx, link_new->link_idx,
> @@ -1811,17 +1819,25 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
>  	link = qentry->link;
>  
>  	if (lgr->smc_version == SMC_V2) {
> +		const u32 rkey_off =
> +			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
>  		struct smc_llc_msg_delete_rkey_v2 *llcv2;
> +		u32 buf_len;
>  
>  		if (smc_link_shared_v2_rxbuf(link)) {
>  			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
>  			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
> +			buf_len = SMC_WR_BUF_V2_SIZE;
>  		} else {
>  			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
> +			buf_len = sizeof(qentry->msg);
>  		}
>  		llcv2->num_inval_rkeys = 0;
>  
>  		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
> +		/* bound by the buffer llcv2 points at */
> +		max = min_t(u32, max, (buf_len - rkey_off) /
> +				      sizeof(llcv2->rkey[0]));
>  		for (i = 0; i < max; i++) {
>  			if (smc_rtoken_delete(link, llcv2->rkey[i]))
>  				llcv2->num_inval_rkeys++;

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
