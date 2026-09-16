Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BB94734EF;
	Wed, 16 Sep 2026 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547702; cv=none; b=FXnLg5zfpPeV9udCspzKbmwRxYQNoBAcHKpGJBD3lCs6s4QMN0R35JPKXhTrYOiIex5kj2AIpKTxEeVennajFYorc3M+/pg6m8uATzWsjSjq0K2WAgQ6UJgQWHKgI5thWakES0Ry1SERNktOdt4RoNWugAHIBWl0NajaTueYSlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547702; c=relaxed/simple;
	bh=cc0gBrSRtQgDKF9OjnL3WLZPTEowHIvYsV0ALRjuzIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evrDv3QhxofbUt69aOIOjTcSq2WanxopYAbMOKcKpvCV1VE8alyRCfy3HcA9AuCpDdKO/XRxKp6Jq5PkeLQyIER4R5OP2lGzCe3Ne+41PB9m5worKoFOxCg/ZpUqv7jPWpA9/Ed32lvTyXixILHEb9O0xPXE3DYYB7NY3N7+u/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jxRLtJ/O; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jxRLtJ/O"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLVmJr791604;
	Wed, 16 Sep 2026 08:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kmcnHV
	o/VF1PQEVaXp5czCv6NEEorHC1Lrf+zvinosU=; b=jxRLtJ/OPuIAOhSSDkaeTR
	IUuKsyo+R+8cfMkw/SqTeyPmxqtH//hkV4UbT2oS+7V705hYORm8mg9K/cu0DzYN
	nnqum5ryXd8SD4WZLECuTkFikyDj5h/PQHSbZnAyaY/VwxIFpekwWNwOAZjJxoTy
	A1SKU7IwEecTr6UafXbiR1N+ybT1RKZGcrJI+h+RvslhDCIuA9L4Jh0E++LfKaYb
	+c8Kd88SKsWiGWJK0AB0l6GEzxPLIpBMr0S2VQqUyW1Zd9q519SHd3If1Ifnfb4f
	RfDBscvmWTFpuzmOAnfArrAW+LdmwuUhRhJJgTgToHBkTrogTZc6MjT+1xMH4OfA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmw5e3bd4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 08:34:52 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68G7VKFM1354977;
	Wed, 16 Sep 2026 08:34:51 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpw6d60a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 08:34:51 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68G8YnJ064880914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 08:34:50 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9898358052;
	Wed, 16 Sep 2026 08:34:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 619D75805E;
	Wed, 16 Sep 2026 08:34:44 +0000 (GMT)
Received: from [9.123.4.74] (unknown [9.123.4.74])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 08:34:44 +0000 (GMT)
Message-ID: <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>
Date: Wed, 16 Sep 2026 14:04:42 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, hidayath@linux.ibm.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
 <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX4Em5HNzT5pal
 eq1KKGon54KhlusFWQHiFyDb9JkeiqoAIdcA+2ZytslTPzyT77jnorMQI/YB2h2Z3CQ/OUzUH7U
 7xmeceU1LfappMr500Wj/xPGbgHMNLmHAMtC7hLO0uLXd7Y1B6aeeVVUYrUrfcHoafn3umDtYRp
 /jkCg5qe4DehghDT53bCJrVXjJdvYUs3EsoviUL50xlh3sfsQ2Urw4hE/7kLfkek47G1idznYHW
 jAZbKdz/S6imk2AfIsaEN1ZlLKyDYi5PUHLR+ez2Oii7y2/S/yKOwlBkIkgeoEKmD7z1kIxWaFQ
 2ouer50hjqJr99En1N2JCRS5HEjiztGVmjKnTOeoX4jLv5HforsN53BpCNWuPudGagdeKvBe5TZ
 ypxn1kQIg1X/gXt0C+o4qLsmktj0N/vHHJy2rCvZH1SZhjM0YnNx2L7QS+QdBeiPFwDGLAEYsiz
 9ddu9rnr9YqlRtq3UQA==
X-Authority-Analysis: v=2.4 cv=E/NYNqdl c=1 sm=1 tr=0 ts=6aaa54ac cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=YHxmyfIP1JK-PJW0Qm8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ERhaANj-Ri9YnmA8eZPjDjfQe14IxmCD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDExMCBTYWx0ZWRfX/4ISbXYEpjfq
 B96KRHw4ThAfKERCFJkhaOgbC304egqUDiu5mBT6nMVgs76KihkfrJDY4K+To+IW4gEblR0/K6H
 0ezoi2HcqMjrYzs845k5AvEmWWDIDMc=
X-Proofpoint-GUID: DKl4FDDp2rZ50n65ITuA9AM52mwOliTX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160110



On 15/09/26 8:43 pm, Dust Li wrote:
> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>> The diag dump walks the socket hash table under a read_lock and
>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>> drop those references via smc_conn_free() while the socket is still
>> hashed:
>> 
>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>> smc_close_passive_work() -> smc_conn_free()
>> 
>> This allows the diag reader to dereference a freed lgr or lnk.
>> 
>> Fix it by unhashing the socket before smc_conn_free() is called at
>> each of these two sites.  Any socket visible to the diag reader
>> under the hash read_lock then has valid conn->lgr and conn->lnk
>> pointers.
>> 
>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>> >unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>> so direct calls at the two teardown sites in smc_close.c are
>> sufficient - dropped the __smc_release() hunk: it needs no change
>> since the subsequent unhash there is already a safe no-op - fixed
>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>> there would make live fallback sockets invisible to smcss -
>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>> and then smc_conn_create() on the next device; unhashing in 
>> smc_conn_free() would permanently hide the established connection
>> from smc_diag since smc_conn_create() does not re-hash the socket
> 
> Hi Mahanta,
> 
> This version looks clean. And you explained why we can't call unhash
> in smc_conn_abort() well. But smc_conn_abort() still calls
> smc_conn_free(), when the smc_sk is still hashed, is there still a
> race window with dump ?

Hi Dust,

Thank you for catching this corner case!

During early handshake setup (when sk_state is *SMC_INIT*),
smc_conn_abort() can be called on connection failure/fallback and
invokes smc_conn_free() while the socket remains hashed, leaving a
window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
and dereference conn->lgr / conn->lnk.

Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
and userspace (smcss) *skips displaying link-group, DMB, and connection
details for INIT state sockets anyway*, we could have __smc_diag_dump()
skip inspecting connection/link-group extensions when r->diag_state ==
SMC_INIT:

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
sk_buff *skb,
 	r->diag_state = sk->sk_state;
+	if (r->diag_state == SMC_INIT)
+		return 0;
+
 	if (smc->use_fallback)
 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)

Together with unhashing before smc_conn_free() in smc_close.c for
established and closing sockets, this cleanly closes the race window
across all socket states without touching the hash table mechanics
during fallback/retry.

Does this approach look good to you? If you agree, I will prepare and
submit v5 with this change. Please let me know if you have any other
suggestions or alternative approaches, and I'll be happy to look into them.

Best regards,
Mahant
