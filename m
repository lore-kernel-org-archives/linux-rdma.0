Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301100;
	b=2H0ums9lIO+lryEhC8MBLVNwc8rs0sPEo/UPxTQu74h1GR26jQZe5c8u/E8mAxh9r2NN
	 dnXm98kFnzobcNix3R4ZPSeV3Y8Igz8e60D2WD9ls7Evj7vsMU8KDQJkHb+61UVvm3MmQ
	 c1hfgEQlKxeEy8axS83MZEO9i3d/ePL3GTNaIba87ZdFJk9o16S5zRM0jtNNpnnZVpl1P
	 dLW4okH5RqM9D6GI7J8P5vxDZctHpGHk5xs+oALvKTN86AT/DhoXLzDKl3uE11jJO/T0S
	 Xt2XP10Ueg1FYUpIrylYrdZym1DLUeIYdh20aKYx8TJVeCJWu3eWzcx8bx+Yb8zdTaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301100;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=AKhrhDde+zeBNLPRYslkMeyaWbMgjnPsZgQx7lt5jPM=;
	b=FnJVNHUvb/iYxSqZQ7z+1utmT8thD4nu9OgR8hrbvZ5qy8IsOq9GlKE6vvWlVdFf9XVW
	 k33Rn7NdO4DdChQ4a3fLdaDk/I4sP7yKYm92b1YNGNkr2r64U9UaPA8LIrIBzu6Ky2XBn
	 s3d7h8ehF+AhYtdOxxSX1JOt7JQG1OjRwZgE2tf2gAU/28qRmrqmIUgd+4BYrfi9PmbI3
	 Qb6C8kKMtZ/oR5sVIGjE6068i93ltHdDjtDWuyP323WRLPcSkfE4bWPxQrQZx8BuYhfMo
	 g9rZg1zidHu1lv4YKVo1dj/0ZLKhEg1AyGGx3Dn/hx66ohw8uXwVt3BbeNYSPuJa4PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=b6yqshmt;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DBA606A31C;
	Tue, 10 Nov 2026 08:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5DBA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=b6yqshmt
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AA8EkGc603129;
	Tue, 10 Nov 2026 08:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AKhrhD
	de+zeBNLPRYslkMeyaWbMgjnPsZgQx7lt5jPM=; b=b6yqshmti4JvabJqcKKvFR
	IT+FTvO2MTZCf3WQEHFJRTKWHImI51EXRkM8y4YgD66Qqa5KeLUNZkRBLqFqPgvu
	6uqkAaUEKxOlb1cg5Ssb50/7EtvvHD5MebMYNyvUpWXsNcEmQPpEY8Qdj70L8XEM
	52RyGJywCaKEOFDggAfVSKUAHqrnats6TBbubk87MfvlTPHzDUiKScr2YPliZSUf
	3Us4XH/xcj6XtD2Yy0cim9Fd3bH3TBXtol3aJE8UZPdchc3xaDlnKXVp2yCctZwn
	U6Ni5RvnVBtuwvYvreth4W6XSyW/tS1loEpcvL84yCA/jrjZjsswPxVJ3HfZBXwA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hstdg3m01-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 08:58:10 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AA7nuBi1541655;
	Tue, 10 Nov 2026 08:58:10 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4htfthnrf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 08:58:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AA8w5S044761588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Nov 2026 08:58:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2BF620043;
	Tue, 10 Nov 2026 08:58:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C6782004B;
	Tue, 10 Nov 2026 08:58:02 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Nov 2026 08:58:02 +0000 (GMT)
Message-ID: <a1580381-e2a2-4b89-8014-4839e9f9b7be@linux.ibm.com>
Date: Tue, 10 Nov 2026 14:28:01 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v15] net/smc: fix lgr/lnk lifetime vs diag reader race
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261102083122.1098393-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J+M/fwnS c=1 sm=1 tr=0 ts=6af2dca3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=A18B6vshVeObqJlLmTMA:9 a=t49UGZ5PcdqPmRO1:21
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDAzNCBTYWx0ZWRfXxDqzr+Xx11NY
 EPtZpX+lWVkvXhc5rJeXb9GNYBT9fIeYvb6c1ZkWhYCGGtEFNXvBY55tHj/+fl5VvLcu9mvjEbX
 0eM3MxBhl+Pbhdmj8FF/2T9s5CYnVRQLqCaW1P9ZYx8wCxr7owsCSRqc3dsSr4fne14C0/2h610
 dMqZv5Z4gghAgLvS5HQZQB9+6m/7e5gIJDbUt29MEBw44+Lux07eYUtFOPvq6rOAJ3v4ALTq8CX
 7RtJM4tIvMW2owbXOJ5Us/KQLRzYK8+ECc6c7uaJpUoe6CW0Gw9I1m6LGPJwU5z4nocRl4gnNwt
 N3lHfOl3JUwyy30CixWvr9fqLwlMhmP6vg4IOoUV6nhi10vXuKTMqyDHCMcELmcRz8tQoJKSTR3
 aLsmYJtWKlec+FAGkBoFhT0KqrAfgr2QoELbS0Ht0g4Atr1snI8TzhIMtCn1iTeEeo15D6Edtpg
 6LjuGuP/oF9vpcCT6vQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDAzNCBTYWx0ZWRfX2RdvAc25MjUq
 lgdYJl+aQPk24gGZIBk3ANXaRwQi6t5AvVfzTpDm2KGjO4WWUWgsGTqYuOok2DPnv33NZ8nb5vI
 Vodyz/sP5jfVCfpLD1ks3x/OpSm9KTA=
X-Proofpoint-GUID: zunmSTqOYlabiqT7arIJRM0E5ezkDnQL
X-Proofpoint-ORIG-GUID: mXGpMYYXWQvr8cX1DTw1VMMesGbZ58oX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_03,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611100034



On 02/11/26 2:01 pm, Mahanta Jambigi wrote:
> The diag dump walks the socket hash table under a read_lock and
> dereferences conn->lgr and conn->lnk. Several paths expose a window
> where a hashed socket has freed or partially freed conn/lgr/lnk state.
> 
> First, smc_conn_abort() calls smc_conn_free() during early handshake
> aborts while the socket is still hashed in SMC_INIT, synchronously
> freeing the lgr on the smc_lgr_cleanup_early() path without holding the
> hash write_lock. A concurrent diag reader can load a non-NULL conn->lgr
> and dereference it after the kfree. Skip the connection, link group and
> DMB attributes in __smc_diag_dump() for sockets in SMC_INIT or
> SMC_CLOSED or fallen back to TCP, and take diag_mode from an is_smcd
> flag cached at connection creation.
> 
> The state filter alone does not close the race. A connection aborted by
> a failed handshake can keep its alert token, because smc_conn_free()
> skips the unregister when smc_lgr_terminate_sched() has emptied
> lgr->list; close_work may also have been queued before the abort, as the
> CDC receive path is not excluded by the handshake's socket lock.
> smc_close_passive_work() would then move the hashed socket from SMC_INIT
> to SMC_APPCLOSEWAIT1 or SMC_PROCESSABORT, states the filter does not
> cover, and later run a passive-closing sock_put() that
> smc_connect_decline_fallback() dropped already. Return early from
> smc_close_passive_work() when the connection was freed; the check holds
> the socket lock that every smc_conn_free() caller holds as well, so a
> hashed socket with a freed connection stays in SMC_INIT or SMC_CLOSED
> until release.
> 
> This changes the sock_diag output for such sockets: the connection, link
> group and DMB attributes are omitted, which smcss does not read for
> sockets in these states, while SMC_DIAG_FALLBACK is still reported and
> an SMC-D socket in SMC_INIT or SMC_CLOSED still reports
> SMC_DIAG_MODE_SMCD from the cached flag. A fallback socket is a plain
> TCP socket with no SMC connection state to report; the stale conn fields
> left behind by smc_conn_abort() must not be read.
> 
> Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach()
> NULLs and frees conn->sndbuf_desc while the socket is still hashed. A
> concurrent diag reader entering the CONNINFO block can dereference the
> freed descriptor. Unhash the socket right before smcd_buf_detach(). As a
> result, killed ACTIVE and APPCLOSEWAIT sockets that are still open are
> no longer visible to smcss on loopback-ism devices.
> 
> Third, in the terminal teardown branches of smc_close_active_abort()
> (PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
> smc_conn_free() drops lgr and lnk references while the socket is still
> hashed. Unhash immediately before each smc_conn_free() call at those
> sites. Sockets killed in those close states are therefore unhashed, and
> their inuse accounting dropped, before close(), even if the fd is still
> open.
> 
> Fourth, use smp_load_acquire() / smp_store_release() on sk_state to
> order these checks on weakly ordered CPUs. A reader that observes
> SMC_ACTIVE is guaranteed to see the connection setup that preceded the
> store; a reader that observes SMC_CLOSED from smc_listen_out_err() skips
> the connection fields in any case, so that particular store is hardening
> kept for uniformity, not a required ordering.
> 
> Additionally, in __smc_diag_dump(), use the cached link->ibname instead
> of link->smcibdev->ibdev->name, avoiding a NULL pointer dereference or
> use-after-free of the IB device when __smcr_link_clear() zeroes the link
> during concurrent SMC-R link failover. The link data is still read
> without conns_lock or send_lock, so a dump racing a failover may
> transiently report zeroed or mixed link fields; this does not affect
> memory safety and the next dump reports the new link. Like the SMC
> netlink link dump and the tracepoints, the name is the one cached at
> link creation time.
> 
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 2a0674fffb6b ("net/smc: improve abnormal termination of link groups")
> Fixes: 46c28dbd4c23 ("net/smc: no socket state changes in tasklet context")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R connections")
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> ---
> Changes in v15:
> - smc_close.c: return early from smc_close_passive_work() when
>   conn->freed is set; the check runs under lock_sock and every
>   smc_conn_free() caller holds the socket lock, so it cannot race with
>   the free. A connection whose unregister was skipped because
>   smc_lgr_terminate_sched() had emptied lgr->list keeps its alert token
>   after a failed handshake, and a late peer CDC close or abort
>   (smc_cdc_rx_handler() does not check conn->freed) queues close_work,
>   which runs once the handshake thread has dropped the socket lock; it
>   could move the hashed socket from SMC_INIT to SMC_APPCLOSEWAIT1 or
>   SMC_PROCESSABORT, states the SMC_INIT/SMC_CLOSED filter in
>   __smc_diag_dump() does not cover, with conn->lgr pointing at a link
>   group whose last reference smc_conn_free() already dropped, and later
>   run a passive-closing sock_put() although
>   smc_connect_decline_fallback() already dropped that reference on the
>   failed handshake; add the Fixes tag for 2a0674fffb6b, which
>   introduced the unregister skip in smc_conn_free(); close_work is also
>   reachable without a stale token, because the CDC receive path queues
>   it under bh_lock_sock(), which does not exclude the handshake
>   thread's lock_sock(), so a close_work queued before the abort runs on
>   the freed connection as well; that variant exists since close_work
>   was introduced, hence the additional Fixes tag for 46c28dbd4c23
> - smc.h, smc_core.c, smc_diag.c: cache the connection type in
>   conn->is_smcd at smc_conn_create() and take diag_mode from it instead
>   of dereferencing conn->lgr->is_smcd; v14 reported every non-fallback
>   socket in SMC_INIT or SMC_CLOSED as SMC_DIAG_MODE_SMCR, including
>   SMC-D connections, which puts them in the wrong smcss -D / -R group;
>   SMC-D sockets in SMC_INIT after smc_conn_create() and SMC-D sockets
>   moved to SMC_CLOSED by smc_close_passive_work() or
>   smc_close_passive_abort_received() while the fd is still open are
>   affected; the v14 condition on diag_state in the diag_mode test is
>   dropped together with the lgr deref
> - commit message: reword the fourth item; with the SMC_CLOSED check in
>   __smc_diag_dump() a reader that observes SMC_CLOSED never reads
>   alert_token_local or conn->lgr, whatever the state was before
>   smc_listen_out_err() stored it, so the smp_store_release() there is
>   hardening, not a required ordering, and stable backporters should not
>   treat it as a standalone fix
> 
> Changes in v14:
> - smc_diag.c: also exclude SMC_CLOSED before dereferencing conn->lgr to
>   determine diag_mode; a server socket that fails in
>   smc_listen_decline() with rc < 0 reaches SMC_CLOSED hashed, with a
>   stale alert_token_local left by smc_conn_free() when
>   smc_lgr_terminate_sched() had already emptied lgr->list, and the lgr
>   can be freed by terminate_work while a diag reader still holds the
>   hash read_lock
> - commit message: document the diag_mode change for SMC_CLOSED and the
>   limits of the smp_store_release() in smc_listen_out_err()
> 
> Changes in v13:
> - smc_diag.c: also skip the CONNINFO/LGRINFO/DMBINFO blocks for sockets
>   with use_fallback set; the SMC_DIAG_FALLBACK attribute is still
>   reported. After smc_lgr_terminate_sched() emptied lgr->list,
>   smc_conn_free() skips smc_lgr_unregister_conn(), so a socket that then
>   falls back and reaches SMC_ACTIVE can keep a stale alert_token_local
>   and a diag reader could dereference the freed sndbuf/rmb/lgr; a
>   fallback socket is a plain TCP socket with no SMC connection state to
>   report
> - smc_core.c: drop the v11 and v12 changes (unconditional
>   smc_lgr_unregister_conn() in smc_conn_free() and the
>   !lgr->terminating check in smc_lgr_schedule_free_work()); the v12
>   check was racy against __smc_lgr_terminate() and the changes moved the
>   patch away from the diag reader race, so smc_core.c is back to the v10
>   change only; the Fixes tag for 2a0674fffb6b added in v11 is dropped
>   with them
> - commit message: state that using the cached link->ibname avoids the
>   NULL pointer dereference and the IB device use-after-free, and that
>   link fields may be transiently zeroed or mixed in a dump racing with a
>   link failover, without affecting memory safety
> - commit message: drop the claim that other kill paths leave the socket
>   hashed; every smc_conn_kill() ends in smc_close_active_abort(), so
>   sockets killed in the PEERCLOSEWAIT1/2, PEERFINCLOSEWAIT, PROCESSABORT
>   and APPFINCLOSEWAIT states are unhashed before close() even if the fd
>   is still open, and the dmb_nocopy unhash hides ACTIVE/APPCLOSEWAIT
>   sockets on loopback-ism; smcss visibility thus depends on close state
>   and device type; this supersedes the v10 entry below
> 
> Changes in v12:
> - smc_core.c: guard smc_lgr_schedule_free_work() with !lgr->terminating
>   in addition to !lgr->freeing, preventing free_work from being re-armed
>   on a terminating LGR after smc_lgr_cleanup_early() has called
>   __smc_lgr_terminate() (which sets terminating=1 and cancels free_work
>   without setting freeing=1); without this a concurrent smc_conn_free()
>   decrementing conns_num to 0 would re-arm free_work, and the subsequent
>   kfree(lgr) in smc_lgr_free() would leave the armed work pointing at
>   freed memory
> 
> Changes in v11:
> - smc_core.c: unregister connection unconditionally in smc_conn_free()
>   rather than gating it on !list_empty(&lgr->list), ensuring
>   alert_token_local is always reset to 0
> - commit message: add Fixes tag for 2a0674fffb6b and clarify that
>   copying cached link->ibname eliminates the NULL dereference / UAF
>   during concurrent link clearing
> 
> Changes in v10:
> - smc_core.c: move the unhash out of the top of smc_conn_kill() into the
>   smc_ism_support_dmb_nocopy() branch, right before smcd_buf_detach(); the
>   other kill paths leave ACTIVE/APPCLOSEWAIT sockets open, so they must
>   stay visible to smcss and keep their inuse accounting
> - commit message: document the sock_diag output changes for sockets in
>   SMC_INIT and SMC_CLOSED (extension attributes omitted, diag_mode of
>   SMC-D in SMC_INIT) and that ibname is the name cached at link creation
> 
> Changes in v9:
> - af_smc.c: change plain store in smc_listen_out_err() to
>   smp_store_release(&newsmcsk->sk_state, SMC_CLOSED) to order the
>   preceding alert_token_local clear (done under write_lock_bh() inside
>   smc_conn_free()) before the sk_state write; pairs with the
>   smp_load_acquire() in __smc_diag_dump() to close a use-after-free on
>   weakly ordered CPUs where a diag reader could observe SMC_CLOSED while
>   conn->lgr still appeared live
> 
> Changes in v8:
> - smc_diag.c: use smp_load_acquire(&sk->sk_state) to prevent
>   speculative load reordering on weakly ordered CPUs (such as arm64)
>   during handshake abort fallback
> - af_smc.c: pair with smp_store_release(&sk->sk_state, SMC_ACTIVE)
>   when transitioning out of SMC_INIT
> - smc_diag.c: copy cached link->ibname instead of chasing
>   link->smcibdev->ibdev->name to prevent NULL pointer dereference / UAF
>   if __smcr_link_clear() zeroes the link during link failover
> 
> Changes in v7:
> - no code changes; commit message only
> - document the SMC_CLOSED leg of the early-exit guard and the rationale
>   that smcss already skips CLOSED sockets on the userspace side; add
>   a Fixes tag for ae2be35cbed2 for the smc_conn_kill() hunk since
>   smcd_buf_detach() was introduced by that commit
> 
> Changes in v6:
> - smc_diag.c: inline sk->sk_state != SMC_INIT into the else-if
>   condition so conn->lgr->is_smcd is never loaded for SMC_INIT sockets;
>   retain the SMC_INIT || SMC_CLOSED early-exit guard and out: label
>   from v5 to defensively skip the CONNINFO/LGRINFO/DMBINFO blocks for
>   sockets with no live connection
> - smc_close.c: remove the unconditional unhash from the top of
>   smc_close_active_abort(); place it scoped immediately before each of
>   the two smc_conn_free() calls in the PEERCLOSEWAIT and PROCESSABORT
>   branches, and before smc_conn_free() in smc_close_passive_work();
>   this avoids prematurely hiding live SMC_ACTIVE/APPCLOSEWAIT sockets
>   from smcss
> - smc_core.c: unhash at the top of smc_conn_kill(), before
>   smcd_buf_detach(), so the socket is off the hash table before
>   conn->sndbuf_desc is freed on the dmb_nocopy path
> 
> Changes in v5:
> - guard conn/lgr/lnk blocks in __smc_diag_dump() with an
>   (SMC_INIT || SMC_CLOSED) state check placed after the
>   SMC_DIAG_FALLBACK nla_put; SMC_INIT can coexist with fallback
>   (smc_sendmsg() MSG_FASTOPEN path), so the guard must not suppress
>   the fallback reason
> 
> Changes in v4:
> - dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
>   changes to af_smc.c, smc.h, smc_core.c and smc_core.h;
>   smc_unhash_sk() is already idempotent via sk_hashed(), so direct
>   calls at the two teardown sites in smc_close.c are sufficient
> - dropped the __smc_release() hunk: it needs no change since the
>   subsequent unhash there is already a safe no-op
> - fixed premature-unhash issue present in v3: smc_conn_free() must not
>   unhash because smc_conn_abort() calls it before
>   smc_switch_to_fallback() in both smc_listen_decline() and
>   smc_connect_rdma() error paths; unhashing there would make live
>   fallback sockets invisible to smcss
> - likewise, the ISM/RDMA retry loops call smc_conn_abort() on a failed
>   attempt and then smc_conn_create() on the next device; unhashing in
>   smc_conn_free() would permanently hide the established connection from
>   smc_diag since smc_conn_create() does not re-hash the socket
> 
> Changes in v3:
> - redesigned as a single patch; dropped the lgr_lnk_lock spinlock
>   approach and the 2-patch split
> 
> Changes in v2:
> - split into a 2-patch series; patch 1/2 adds per-connection
>   lgr_lnk_lock infrastructure to smc_core, patch 2/2 fixes the diag
>   dump path using it
> 
> 
>  net/smc/af_smc.c    | 10 +++++-----
>  net/smc/smc.h       |  1 +
>  net/smc/smc_close.c | 14 ++++++++++++++
>  net/smc/smc_core.c  |  8 +++++++-
>  net/smc/smc_diag.c  | 12 ++++++++----
>  5 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index d10244af5bd2..ec5980add7a9 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -980,7 +980,7 @@ static int smc_connect_fallback(struct smc_sock *smc, int reason_code)
>  	smc_copy_sock_settings_to_clc(smc);
>  	smc->connect_nonblock = 0;
>  	if (smc->sk.sk_state == SMC_INIT)
> -		smc->sk.sk_state = SMC_ACTIVE;
> +		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);
>  	return 0;
>  }
> 
> @@ -1385,7 +1385,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
>  	smc_copy_sock_settings_to_clc(smc);
>  	smc->connect_nonblock = 0;
>  	if (smc->sk.sk_state == SMC_INIT)
> -		smc->sk.sk_state = SMC_ACTIVE;
> +		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);
> 
>  	return 0;
>  connect_abort:
> @@ -1488,7 +1488,7 @@ static int smc_connect_ism(struct smc_sock *smc,
>  	smc_copy_sock_settings_to_clc(smc);
>  	smc->connect_nonblock = 0;
>  	if (smc->sk.sk_state == SMC_INIT)
> -		smc->sk.sk_state = SMC_ACTIVE;
> +		smp_store_release(&smc->sk.sk_state, SMC_ACTIVE);
> 
>  	return 0;
>  connect_abort:
> @@ -1957,7 +1957,7 @@ static void smc_listen_out_connected(struct smc_sock *new_smc)
>  	struct sock *newsmcsk = &new_smc->sk;
> 
>  	if (newsmcsk->sk_state == SMC_INIT)
> -		newsmcsk->sk_state = SMC_ACTIVE;
> +		smp_store_release(&newsmcsk->sk_state, SMC_ACTIVE);
> 
>  	smc_listen_out(new_smc);
>  }
> @@ -1971,7 +1971,7 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
>  	this_cpu_inc(net->smc.smc_stats->srv_hshake_err_cnt);
>  	if (newsmcsk->sk_state == SMC_INIT)
>  		sock_put(&new_smc->sk); /* passive closing */
> -	newsmcsk->sk_state = SMC_CLOSED;
> +	smp_store_release(&newsmcsk->sk_state, SMC_CLOSED);
> 
>  	smc_listen_out(new_smc);
>  }
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 427b6d63b993..36b243b34a9a 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -196,6 +196,7 @@ struct smc_connection {
>  	struct rb_node		alert_node;
>  	struct smc_link_group	*lgr;		/* link group of connection */
>  	struct smc_link		*lnk;		/* assigned SMC-R link */
> +	bool			is_smcd;	/* SMC-R or SMC-D connection */
>  	u32			alert_token_local; /* unique conn. id */
>  	u8			peer_rmbe_idx;	/* from tcp handshake */
>  	int			peer_rmbe_size;	/* size of peer rx buffer */
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index a8d4b4b65f24..dcb560f1947c 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -155,6 +155,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		sock_put(sk); /* passive closing */
> @@ -166,6 +167,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		break;
> @@ -370,6 +372,17 @@ static void smc_close_passive_work(struct work_struct *work)
>  	lock_sock(sk);
>  	old_state = sk->sk_state;
> 
> +	if (conn->freed) {
> +		/* conn->freed is set under the socket lock, which is
> +		 * held here as well, so this cannot race with the free; the
> +		 * state machine and its postponed sock_put() are not owed
> +		 * anymore
> +		 */
> +		release_sock(sk);
> +		sock_put(sk); /* sock_hold done by schedulers of close_work */
> +		return;
> +	}
> +
>  	rxflags = &conn->local_rx_ctrl.conn_state_flags;
>  	if (rxflags->peer_conn_abort) {
>  		/* peer has not received all data */
> @@ -437,6 +449,7 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);
>  			if (smc->clcsock)
>  				release_clcsock = true;
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e9..0a9f5418329a 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1532,8 +1532,10 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  			tasklet_kill(&conn->rx_tsklet);
>  		else
>  			tasklet_unlock_wait(&conn->rx_tsklet);
> -		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
> +		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
> +			smc->sk.sk_prot->unhash(&smc->sk);
>  			smcd_buf_detach(conn);
> +		}
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
>  	}
> @@ -2053,6 +2055,10 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  			goto out;
>  		}
>  	}
> +	/* cache the connection type: smc_diag reads it after
> +	 * smc_conn_free() dropped the link group reference
> +	 */
> +	conn->is_smcd = conn->lgr->is_smcd;

This could lead to stale value on failed retries. is_smcd is only
assigned on the success path of smc_conn_create(). Take a listen side
ISM v2 attempt that succeeds and then aborts, followed by an SMC-R
attempt whose smc_conn_create() fails before reaching this line. If the
socket then closes without falling back, it reports SMC_DIAG_MODE_SMCD
for an SMC-R attempt. This is cosmetic, but you could clear it at the
start of smc_conn_create().

>  	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
>  	if (!conn->lgr->is_smcd)
>  		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb..15485a08d9a0 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -87,10 +87,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
> 
>  	r = nlmsg_data(nlh);
>  	smc_diag_msg_common_fill(r, sk);
> -	r->diag_state = sk->sk_state;
> +	r->diag_state = smp_load_acquire(&sk->sk_state);
>  	if (smc->use_fallback)
>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (smc->conn.is_smcd)
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> @@ -103,6 +103,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
> 
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED ||
> +	    smc->use_fallback)
> +		goto out;
> +
>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;
> @@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			.lnk[0].link_id = link->link_id,
>  		};
> 
> -		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> -		       sizeof(link->smcibdev->ibdev->name));
> +		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));
>  		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
>  		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);
> 
> @@ -185,6 +188,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			goto errout;
>  	}
> 
> +out:
>  	nlmsg_end(skb, nlh);
>  	return 0;
> 
> --
> 2.50.1 (Apple Git-155)
> 
> 

I see that Checkpatch throws 6 warnings.
Otherwise Patch looks good to me.
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>




