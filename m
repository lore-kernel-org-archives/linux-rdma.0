Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72D41CB2E;
	Thu,  8 Oct 2026 07:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444738; cv=none; b=OgYqY0qrkgk8xCrivlDk0BA4nMxCNJ930IYkXEmloguPPrEicGUgakk+wiLJD08YLyb9osbLvtIofwGUX43u8dWdATzvWG+/5ZqDlfWoPCHQxsL7nF03Mej8LyZtSIn42Lxnxnug4xUjkBbd+GXa9synss0js9PZD0vUcFAen6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444738; c=relaxed/simple;
	bh=1H5ao11OpqcDBK1gtnGjlc3WEjMqPTLmxmkaQFoAt6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CG/Oq5gmpXVUShEojGnFaoRx+1cye/SoNtWaEZpdfdip9lDLxkbiF4phQXLH4pCrJN7i5vBACUaIR+cZGeQUL3+/65BYykYCZT0IW/NOQe8ElVa8Ub2L9k86b90muyOFkV/cnSbica4VssiIqv/I6RazfR0+2rt+CLQ/7qGESmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JwWTbJkF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JwWTbJkF"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6984Zdfl2735873;
	Thu, 8 Oct 2026 07:32:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=454br6
	3ae/7yeUKzAmFzQqTylu9PzF1I1saksy/sCCA=; b=JwWTbJkFv1J6gdALgWEr8J
	9x/VkUvzrxuwLk2euPnU83b6Q1r+ClApiuSmVY0yLKaw+8Dv2av0E6jtNcdlLBVG
	51ssM87r7YS1xk+CcUcvQ6581S92bTzqKS7eDu6SGOXReXwY81IV9yjWU0u7j6Ks
	OsJSWcN25F6rGUgKeBnpLatt8TdPOE5Vk6+zs5iSGaUeOYh/tUfXpxLnKyywx9Z5
	emKm4rNc12odDV0bl2bZs0mfIGLEsCYsXBCF7q6MITwthY7b8uZae+t/baAV0NXp
	w9gIcPUgyA7TFQ/K7LuMRHQazuV9wBoUPxnK6iOG/MYGE7T4Ad2DMdg9Xb3iPWiw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjw24kw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 07:31:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6987IXkr3107263;
	Thu, 8 Oct 2026 07:31:58 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h58ek6ckx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 07:31:58 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6987VvuL33554990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 07:31:57 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3564D58069;
	Thu,  8 Oct 2026 07:31:57 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DC055805D;
	Thu,  8 Oct 2026 07:31:51 +0000 (GMT)
Received: from [9.124.217.43] (unknown [9.124.217.43])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 07:31:50 +0000 (GMT)
Message-ID: <4bb7f15e-2cd8-4598-9bab-1ea5f5d2bb59@linux.ibm.com>
Date: Thu, 8 Oct 2026 13:01:49 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/smc: serialize clcsock access with its release
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
        "D . Wythe" <alibuda@linux.alibaba.com>,
        Dust Li
 <dust.li@linux.alibaba.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20261003183325.2289707-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: q2F9IXGVQIzMayWxBpIM2DNicJHxAFlJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAyOCBTYWx0ZWRfX9E8vBci6Wzuc
 kwn5Viq5UEJF8uwiBEXR3KBfcoZL3Ta5L0W0fHl4WlY39l342qg+AIwN8Qh5kR19j1JKvqKDOUf
 sQCLX0a93Pnrca4eAmzljObUJDE6iYdYQcKf9PR8RytmhosqCx2Sx+QW3h1NuseVD6D5xYsi6CQ
 ZF8hdQpmYrutbf7/wh6CQe3NKHxUYxczgOIHGTWi1kvm0KJ3olO3PJw9pkivPYwJodKKr5Ua3jE
 vr+gG6yblN46J+amero0HpNOco/itA97DBKXK1YhGKLU2ukWS3gS6f3P3G0fjrPREVEHEPk1ZNa
 aEvbe0QYjWf0nMx5rOBwVnmMvTO36XZm6QySkGRewpGzUMEx/6cfvwvpmPFF+Ecz04u/NlcIMSX
 o1hx5u7xnZctYTcjdHxbOYkUHSDhrBVRGoQfOqbO5JXLQNeKbLVMvlrl417mClBgDAMfte8lIU4
 ou3X3Rbt4oQBysBJxEg==
X-Authority-Analysis: v=2.4 cv=cIt1IVeN c=1 sm=1 tr=0 ts=6ac746ef cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=8oSq24xotcjpyH-63FsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAyOCBTYWx0ZWRfX+SGf45hTQ8B+
 1wuQQ9RpTsjT7K53v9IVJzYoi2fOU/rfQBzAWgatVw1XnYTAiySMuvV884vUxUpMETMN6ZGBHnU
 tcY2SU7NDR7WuSQN7kMGOtDKyksxscw=
X-Proofpoint-ORIG-GUID: xlM9j_tYAlyiAIR9UZ92kv-f7uKfOZjY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080028



On 04/10/26 12:03 am, Chengfeng Ye wrote:
> Link-group termination can release the CLC socket through
> smc_close_active_abort() while the SMC socket is still open, for example
> after shutdown(SHUT_WR). A file reference keeps the SMC socket alive but
> does not prevent this asynchronous release of its CLC socket.
> 
> smc_getname() can race the pointer removal and sock_release(). The same
> missing lifetime synchronization affects smc_set_keepalive(), diagnostic
> address copying and an in-flight SMC-R CDC receiver. smc_shutdown() can
> also reach its final CLC shutdown after its close helper drops the socket
> lock and a concurrent abort closes the socket. Holding the SMC socket
> lock alone is insufficient because CLC release runs outside that lock.
> 
> KASAN reported the getname failure:
> 
>   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
>   Read of size 8 at addr ffff888109abb4e0 by task poc/103
>   Call Trace:
>    smc_getname+0x19e/0x1b0
>    do_getsockname+0xe5/0x170
>    __sys_getsockname+0x8c/0x100
> 
>   Allocated by task 95:
>    sock_alloc_inode+0x1e/0x280
>    sock_alloc+0x3d/0x240
>    __sock_create+0x7e/0x430
>    smc_create+0x121/0x240
> 
>   Freed by task 0:
>    kmem_cache_free+0xcc/0x340
>    rcu_core+0x50a/0x1850
> 
>   Last potentially related work creation:
>    evict+0x446/0x6c0
>    smc_clcsock_release+0xa8/0xd0
>    smc_close_active_abort+0x26a/0x3a0
>    __smc_lgr_terminate.part.0+0x137/0x2e0

Hi Chengfeng,

Thanks for the KASAN report and the fix. The UAF in smc_getname is real
and needs to go to net and stable. However, I think the v2 approach of
adding a new spinlock and extending clcsock_release_lock to cover more
readers is treating symptoms rather than the root cause. Let me explain
what I think should happen instead. What to keep from your patch.

Please send a v3 with only the smc_getname fix:

int smc_getname(struct socket *sock, struct sockaddr *addr,
		int peer)
{
	struct smc_sock *smc;
+	int rc = -EBADF;

	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
		return -ENOTCONN;

	smc = smc_sk(sock->sk);

-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
}

That is 4 lines against the confirmed KASAN-reported UAF, uses
infrastructure that already exists (clcsock_release_lock is already held
by smc_clcsock_release() when it frees clcsock, and already initialized
in smc_sk_init()), and is a clean candidate for stable. Nothing else
from v2 is needed for this specific bug.

Drop the clcsock_lock spinlock, the CDC change, the diag change, the
shutdown change, the connect-abort change, and the smc_accept_dequeue
change. Those races are real but I will address them with a proper
structural fix as Me & Dust Li have already discussed on LKML in August[1].

Why the other races exist and what the right fix is

Every race in your v2 — keepalive, CDC, diag, shutdown, the
connect-abort path — has the same root cause: clcsock can be freed while
the SMC socket is still alive. Several close paths call
sock_release(clcsock) before the SMC socket's own refcount reaches zero:

1) smc_close_active_abort() — for PEERCLOSEWAIT*, PROCESSABORT,
APPFINCLOSEWAIT states
2) smc_close_passive_work() — when the passive close work transitions to
SMC_CLOSED
3) __smc_release() — when sk_state == SMC_CLOSED

Every access site that can race with those releases is then forced to
take clcsock_release_lock and check if (!smc->clcsock). Your v2 adds a
second lock on top of this for the BH/atomic readers that cannot take a
mutex. This complexity is unnecessary because none of those early paths
actually need to destroy the socket — they only need to stop it.
tcp_abort() and kernel_sock_shutdown() are sufficient for that, and both
are safe to call more than once. sock_release() is the exception: it
frees memory and must happen exactly once.

The fix is to move that single sock_release() call to smc_destruct() —
the sk->sk_destruct callback that fires from __sk_free() when the last
sock reference drops. At that point no concurrent user can exist:

1) fd users are gone: smc_release() calls sock_orphan() before dropping
its reference, so no file descriptor can reach the socket after that point
2) workqueue contexts (close_work, smc_listen_work) hold a sock_hold()
and therefore keep smc_destruct() from running while they are active
3) accept-queue entries hold a sock_hold() via smc_accept_enqueue() for
the same reason

This gives us a simple invariant: clcsock is non-NULL for the entire
lifetime of the SMC socket. With that invariant every reader becomes
trivially safe — no lock needed, no NULL check needed, the race
condition simply cannot occur.

[1] https://lore.kernel.org/netdev/ao5bB9OCbJ5PQbEp@linux.alibaba.com/
