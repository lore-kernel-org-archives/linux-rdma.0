Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9924436998A;
	Thu, 17 Sep 2026 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631141; cv=none; b=a0ZaKIjYAd6AIg6SlQfdmEmTF9t89zFvgKWuzMG8taP1hyMdTjHiPHjcbDeeRtHX8ZEgyE46SOHiPy84rVabTVLzD1n1waFk8EBqOmWKgdpZEGUQmwAthVUf4zYj4YL1rHqVp2ab1kvXtbTII8Oqe7sq3WdOCNzcdFixQ/MP9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631141; c=relaxed/simple;
	bh=wYkVLRiQ/c8MB//VxSE/MH0TtIiIl3SvJq4VmgGj5t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gCXFZ/K/cdZxz4NVd5lqZd4cRMmvJonku+j50V2dJ6w3cWE8wRzRPhZnQzG1Sd8T9G8WRbpb90EhqTzNMFAXuR0PCHDOKlsW82n7Ml8E6DUIy9U05B4X5d6z4hxF+/cSxNpImqDEw1N1LsbVo/IZmN+gIV59pkD8TVSGoMf8yAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jb/r0kgl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jb/r0kgl"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H61mxh1559933;
	Thu, 17 Sep 2026 07:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nAEyfe
	y+ndQVH7m7O565seyFo2OqhDD94WA1hj34nrk=; b=Jb/r0kglmoovYY1ytIqVrK
	/eZMVpkEHv/lkr+acaCSBgbkLzUQaQMvOA83SQB/MFjT3fmjit0Gh+9SsJFps39J
	rbZjSPecS78kwsLk4o+3l9QFreKzDWz29SGDYwbtAZsTrV3Gg3hOUSLMTchhIFDV
	Ob+Duj1TbzGFOx5mU0H8bwIQWv7lGiQKDqUTYj7CtEfZSi0/E5R9XuZELvWxnSUI
	nkYw/OMUj8RRql+2mOhFsMoqWLFspvB+fl1qxJq2N49q2XRdIEl6iHDdBmUHKdH6
	qDcL5Dmfg3btoYYgupnKQ0jWB8/xwzFOEOktvaVH37VjRdU83GrIWX9kxUpMgG6A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmv5j0wfy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 07:45:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68H653I42660566;
	Thu, 17 Sep 2026 07:45:31 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gr5fjhcgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 07:45:31 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68H7jUr417695392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Sep 2026 07:45:30 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AF795805A;
	Thu, 17 Sep 2026 07:45:30 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40E495805F;
	Thu, 17 Sep 2026 07:45:25 +0000 (GMT)
Received: from [9.111.206.205] (unknown [9.111.206.205])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Sep 2026 07:45:24 +0000 (GMT)
Message-ID: <2111df0c-33b1-4330-8adf-ac5a0f1de451@linux.ibm.com>
Date: Thu, 17 Sep 2026 13:15:23 +0530
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
 <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>
 <aqq0rnQjiKymR3TM@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <aqq0rnQjiKymR3TM@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDEwMSBTYWx0ZWRfX2Vh33YTUFRpW
 lg79GYxSOA9gzJpwFRSC3JGMoOJ5PKeGlcWz7Dc6umn+gdJy2z4v3Jf1tp8SIcDR5OV5CuSpD4u
 f/VX2RzB9T1fPE3RmAbznO5Zt6qA3uzKbtrr2t7LwXOiD6b2dQMVc95So+eYpd0HD5VuaNhj99G
 caL+ek0ckxtHjLek7fhJp38v3YD/gPm0L1h3Twns1ZoKQSdZO40NW60d+5+jwxHKs5uf2FGVB+t
 OgoEobYQm7x99FR7AyFU3NBw0AZeuQtPaF66Krbbpkgo4HqUe8sC/ufD8Dnd7z4P/xtmCg9X0GU
 1twmpdNFL8oZUzMjhvUUjzSHWqHnW7E7yeghXsg6xLcxEw+vs11bz1k02dc7idpim0Jt3CUOTWA
 b9NEB+aUS30L/oS0IFIRpDRLqYoaqS2KoLDCokiWrFlj3OFcY6GRBKKH3SBe1maab1c5oo3eQob
 WE0g1ReRf/Xd4bLVSxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDEwMSBTYWx0ZWRfX+P2LiH6QFWqx
 CPNN5YIb1cNl+WZwNbrp3YdaPSuDg7JKLt1xzNnC5dbPWnwiTpsj8lcVVxMu0ka8F1D6CbipkQ6
 8Wp9A1Y7fzh+A5n0DD8+4eELxdOkY9c=
X-Authority-Analysis: v=2.4 cv=Zsx4uN7G c=1 sm=1 tr=0 ts=6aab9a9c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=QkDZmhBQ68RLb4DUF7UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: q1TGGz4qSp8bUxx6jNB4qirvIDmrWbc2
X-Proofpoint-GUID: 9MaHmtlYCeCaXkrNZ-tQkj2zwHgoZ5kc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170101



On 16/09/26 8:54 pm, Dust Li wrote:
> On 2026-09-16 14:04:42, Mahanta Jambigi wrote:
>>
>>
>> On 15/09/26 8:43 pm, Dust Li wrote:
>>> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>>>> The diag dump walks the socket hash table under a read_lock and
>>>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>>>> drop those references via smc_conn_free() while the socket is still
>>>> hashed:
>>>>
>>>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>>>> smc_close_passive_work() -> smc_conn_free()
>>>>
>>>> This allows the diag reader to dereference a freed lgr or lnk.
>>>>
>>>> Fix it by unhashing the socket before smc_conn_free() is called at
>>>> each of these two sites.  Any socket visible to the diag reader
>>>> under the hash read_lock then has valid conn->lgr and conn->lnk
>>>> pointers.
>>>>
>>>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>>>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>>>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>>>>> unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>>>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>>>> so direct calls at the two teardown sites in smc_close.c are
>>>> sufficient - dropped the __smc_release() hunk: it needs no change
>>>> since the subsequent unhash there is already a safe no-op - fixed
>>>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>>>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>>>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>>>> there would make live fallback sockets invisible to smcss -
>>>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>>>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>>>> and then smc_conn_create() on the next device; unhashing in 
>>>> smc_conn_free() would permanently hide the established connection
>>>> from smc_diag since smc_conn_create() does not re-hash the socket
>>>
>>> Hi Mahanta,
>>>
>>> This version looks clean. And you explained why we can't call unhash
>>> in smc_conn_abort() well. But smc_conn_abort() still calls
>>> smc_conn_free(), when the smc_sk is still hashed, is there still a
>>> race window with dump ?
>>
>> Hi Dust,
>>
>> Thank you for catching this corner case!
>>
>> During early handshake setup (when sk_state is *SMC_INIT*),
>> smc_conn_abort() can be called on connection failure/fallback and
>> invokes smc_conn_free() while the socket remains hashed, leaving a
>> window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
>> and dereference conn->lgr / conn->lnk.
>>
>> Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
>> and userspace (smcss) *skips displaying link-group, DMB, and connection
>> details for INIT state sockets anyway*, we could have __smc_diag_dump()
>> skip inspecting connection/link-group extensions when r->diag_state ==
>> SMC_INIT:
>>
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>> sk_buff *skb,
>> 	r->diag_state = sk->sk_state;
>> +	if (r->diag_state == SMC_INIT)
>> +		return 0;
>> +
>> 	if (smc->use_fallback)
>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>
>> Together with unhashing before smc_conn_free() in smc_close.c for
>> established and closing sockets, this cleanly closes the race window
>> across all socket states without touching the hash table mechanics
>> during fallback/retry.
>>
>> Does this approach look good to you? If you agree, I will prepare and
>> submit v5 with this change. Please let me know if you have any other
>> suggestions or alternative approaches, and I'll be happy to look into them.
> 
> What about this path ?
> 
> smc_listen_decline() -> smc_listen_out_err(), where smc_conn_abort() has
> already run, and the sock state is then changed from SMC_INIT to SMC_CLOSED.

Hi Dust,

Good catch on the smc_listen_out_err() path as well!

In smc_listen_decline() -> smc_listen_out_err(), the server socket fails
handshake and is transitioned to SMC_CLOSED while remaining in the hash
table until smc_accept_dequeue() runs.

Since userspace (smcss) skips displaying all connection, link-group, and
DMB details for both SMC_INIT and SMC_CLOSED sockets (smcss.c:186 and
smcss.c:199), we can update __smc_diag_dump() to check for both states:

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
sk_buff *skb,
 	r->diag_state = sk->sk_state;
+	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
+		return 0;
+
 	if (smc->use_fallback)
 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)

This guarantees that __smc_diag_dump() never attempts to inspect
connection or link-group fields for sockets that are either still in
embryonic setup (SMC_INIT) or have aborted/closed (SMC_CLOSED).

Combined with unhashing before smc_conn_free() in smc_close.c for
established connections during active/passive close, this cleanly closes
the race window across all tear-down and abort paths.

Does this approach look good to you? If you agree, I will prepare and
submit v5 with this update.

Best regards,
Mahanta

