Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1438556BB9;
	Tue, 22 Sep 2026 13:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083663; cv=none; b=AEy2yyuKAqTV6dyWUpj+pW2o30HQ6scEB7CFU/Z8m9k6SGqYVCDzHZSsqSxtgTZIvmVwkyy7Q2uWL4ztYEsPtg9WNJo8i5cysFFpPtDlCcOlzfq9tPG7/iYBluTs8FgKPNodZdf7taemz78u+P63L82uPCj1ow/adlfrWN2Bx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083663; c=relaxed/simple;
	bh=HtBjFhQo2KNlnP/8pcTEURZW0JluXrGthVybVMuE4dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPYzbMO5t2DHegAppJDvKunA/gTsJf+LPuzTsk+kAHycu0/FemIbSYmWPQRF0mY+UX7Ctxsm3qRUL+67DLvYiUz/IqJDUXXjXwCcA05i6QIdDfsFY7kZXMIbSCH84htFro0bplPXwfJg9dCRke/3yC8lkSdN4eBZ4qzf2aqPmBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nA2DnUBO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nA2DnUBO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBZWSP3332494;
	Tue, 22 Sep 2026 13:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HOogWA
	IGgCJsZylGBXJfljkwtjNKsM4tvxGJgCTH7mo=; b=nA2DnUBOPtxykd3oD4uivO
	YvI9Zde9v2XSUJScEMyoq/gBAtHy0jyprrGxkRL2Kza+OkOJ++dIfzZTX8qAU7Hy
	jVGWV2QiuWuvaIHgYPXYICMNHok9RWksJGIqhoBbNsPdaT+v/nyhBy/M1Evu1F6r
	kjlVMCijZ2mN+A4XN68NMGW75FZIoVfyOcM5eTb3GVKEpjcZKjWl+u1x8L8UfO+b
	rFC5TKb1+sFMuyMo7vepPa6755tANdsRm3YoMQQdHsEG2Fe9Xt3tOEg4zB2Bgkhs
	Th4l/jRFLTyVFOYrS/ANdfKnD2sui07Lp64af/j6AGdRZhtrAV5IIz2h13MjaVcg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgqdkbw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 13:27:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBWU152774587;
	Tue, 22 Sep 2026 13:27:33 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt53vj2pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 13:27:33 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68MDRWtq55640518
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Sep 2026 13:27:32 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F30805805D;
	Tue, 22 Sep 2026 13:27:31 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4DAF58058;
	Tue, 22 Sep 2026 13:27:25 +0000 (GMT)
Received: from [9.124.209.242] (unknown [9.124.209.242])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Sep 2026 13:27:25 +0000 (GMT)
Message-ID: <6b7736f4-d759-476a-8bc9-9038ef5823ea@linux.ibm.com>
Date: Tue, 22 Sep 2026 18:57:24 +0530
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
 <2111df0c-33b1-4330-8adf-ac5a0f1de451@linux.ibm.com>
 <aqwM5USzvdm5zF40@linux.alibaba.com>
 <d11098fd-042c-4246-ba3b-9c2662447f21@linux.ibm.com>
 <arD_Wzbv3Z01ZSCv@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <arD_Wzbv3Z01ZSCv@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ab28246 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=rT1FFLCQtNxIGc05ObYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE5MCBTYWx0ZWRfXzF/ZdggcYtN/
 XrDRAyiJ0amhPUNuDQDTFDD3tJPmibRaHZF1ZmG9e5Qf2/3I2m+Hyne/qle79NjFfzAkMvzsHOS
 16kjdhwxURSWajdq+ErkH7qzZU4xAoJOjxsWlfJFp9k235W3FXW5CzC+tSwVbQ4UVHBLnhBAdlb
 uF19xFFFd1664EygDv70arx7XeUXmNWS+0dVo/pMluW7+lJzfIJbSo5JDaJt4tfZ11VFIOf77BU
 1M4aprbXIssADqNwr0hZPMwcsycTnvVMRUIkaGb3uaxNut3VSztww2V/nvtoCkod/NcvuWksdM6
 iP+uiSiho0KKXEVHZhnj1PwI9MYQBP4gOqCO9IwDVzoUBXnN2q9y902lbC+4/uixIpl48/JHL/O
 MMTf8TL+GRJeHeFfKOx329QDrZ1VP89JW5q1NOFchXs0hLgxBZAlostygfTSJ5Hm8/kITYYV4tJ
 VanbEsoFFgAFjDLAlcw==
X-Proofpoint-ORIG-GUID: JmTFHhvHzQ6XZmEIrocGqJNeRgIjc0nu
X-Proofpoint-GUID: 5L5W9osxLl1JYGd8pxbS1h7Q6p2kLl4y
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE5MCBTYWx0ZWRfX4jXKoaOdSbWC
 0+mzL5xUKVhYyeMWHd4fFe170v5UFj5+eW+1H88gmZ91Pq8HmqDgnDrBZu/DUT8VkbDH3WkExGo
 eoe7oegKuZB8kWqkdcwgRotRFMoTshw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220190



On 21/09/26 3:26 pm, Dust Li wrote:
> On 2026-09-18 12:57:13, Mahanta Jambigi wrote:
>>
>>
>> On 17/09/26 9:23 pm, Dust Li wrote:
>>> On 2026-09-17 13:15:23, Mahanta Jambigi wrote:
>>>>
>>>>
>>>> On 16/09/26 8:54 pm, Dust Li wrote:
>>>>> On 2026-09-16 14:04:42, Mahanta Jambigi wrote:
>>>>>>
>>>>>>
>>>>>> On 15/09/26 8:43 pm, Dust Li wrote:
>>>>>>> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>>>>>>>> The diag dump walks the socket hash table under a read_lock and
>>>>>>>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>>>>>>>> drop those references via smc_conn_free() while the socket is still
>>>>>>>> hashed:
>>>>>>>>
>>>>>>>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>>>>>>>> smc_close_passive_work() -> smc_conn_free()
>>>>>>>>
>>>>>>>> This allows the diag reader to dereference a freed lgr or lnk.
>>>>>>>>
>>>>>>>> Fix it by unhashing the socket before smc_conn_free() is called at
>>>>>>>> each of these two sites.  Any socket visible to the diag reader
>>>>>>>> under the hash read_lock then has valid conn->lgr and conn->lnk
>>>>>>>> pointers.
>>>>>>>>
>>>>>>>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>>>>>>>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>>>>>>>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>>>>>>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>>>>>>>>> unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>>>>>>>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>>>>>>>> so direct calls at the two teardown sites in smc_close.c are
>>>>>>>> sufficient - dropped the __smc_release() hunk: it needs no change
>>>>>>>> since the subsequent unhash there is already a safe no-op - fixed
>>>>>>>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>>>>>>>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>>>>>>>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>>>>>>>> there would make live fallback sockets invisible to smcss -
>>>>>>>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>>>>>>>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>>>>>>>> and then smc_conn_create() on the next device; unhashing in 
>>>>>>>> smc_conn_free() would permanently hide the established connection
>>>>>>>> from smc_diag since smc_conn_create() does not re-hash the socket
>>>>>>>
>>>>>>> Hi Mahanta,
>>>>>>>
>>>>>>> This version looks clean. And you explained why we can't call unhash
>>>>>>> in smc_conn_abort() well. But smc_conn_abort() still calls
>>>>>>> smc_conn_free(), when the smc_sk is still hashed, is there still a
>>>>>>> race window with dump ?
>>>>>>
>>>>>> Hi Dust,
>>>>>>
>>>>>> Thank you for catching this corner case!
>>>>>>
>>>>>> During early handshake setup (when sk_state is *SMC_INIT*),
>>>>>> smc_conn_abort() can be called on connection failure/fallback and
>>>>>> invokes smc_conn_free() while the socket remains hashed, leaving a
>>>>>> window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
>>>>>> and dereference conn->lgr / conn->lnk.
>>>>>>
>>>>>> Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
>>>>>> and userspace (smcss) *skips displaying link-group, DMB, and connection
>>>>>> details for INIT state sockets anyway*, we could have __smc_diag_dump()
>>>>>> skip inspecting connection/link-group extensions when r->diag_state ==
>>>>>> SMC_INIT:
>>>>>>
>>>>>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>>>>>> --- a/net/smc/smc_diag.c
>>>>>> +++ b/net/smc/smc_diag.c
>>>>>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>>>>>> sk_buff *skb,
>>>>>> 	r->diag_state = sk->sk_state;
>>>>>> +	if (r->diag_state == SMC_INIT)
>>>>>> +		return 0;
>>>>>> +
>>>>>> 	if (smc->use_fallback)
>>>>>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>>>>>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>>>>>
>>>>>> Together with unhashing before smc_conn_free() in smc_close.c for
>>>>>> established and closing sockets, this cleanly closes the race window
>>>>>> across all socket states without touching the hash table mechanics
>>>>>> during fallback/retry.
>>>>>>
>>>>>> Does this approach look good to you? If you agree, I will prepare and
>>>>>> submit v5 with this change. Please let me know if you have any other
>>>>>> suggestions or alternative approaches, and I'll be happy to look into them.
>>>>>
>>>>> What about this path ?
>>>>>
>>>>> smc_listen_decline() -> smc_listen_out_err(), where smc_conn_abort() has
>>>>> already run, and the sock state is then changed from SMC_INIT to SMC_CLOSED.
>>>>
>>>> Hi Dust,
>>>>
>>>> Good catch on the smc_listen_out_err() path as well!
>>>>
>>>> In smc_listen_decline() -> smc_listen_out_err(), the server socket fails
>>>> handshake and is transitioned to SMC_CLOSED while remaining in the hash
>>>> table until smc_accept_dequeue() runs.
>>>>
>>>> Since userspace (smcss) skips displaying all connection, link-group, and
>>>> DMB details for both SMC_INIT and SMC_CLOSED sockets (smcss.c:186 and
>>>> smcss.c:199), we can update __smc_diag_dump() to check for both states:
>>>>
>>>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>>>> --- a/net/smc/smc_diag.c
>>>> +++ b/net/smc/smc_diag.c
>>>> @@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>>>> sk_buff *skb,
>>>> 	r->diag_state = sk->sk_state;
>>>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>>>> +		return 0;
>>>> +
>>>> 	if (smc->use_fallback)
>>>> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>>>> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>>>
>>>
>>> I checked the code again, and I'm afraid adding SMC_CLOSED is still not right.
>>>
>>> smc_listen_decline(): smc_switch_to_fallback(), smc_clc_send_decline() then
>>> fails, and smc_listen_out_err() sets the socket to SMC_CLOSED. The socket
>>> stays on the accept queue, hashed, until accept() reaches smc_accept_dequeue().
>>>
>>> But the early return sits after nlmsg_put() but before diag_mode,
>>> smc_diag_msg_attrs_fill() and the SMC_DIAG_FALLBACK attribute are filled.
>>> The record is still emitted, but diag_mode is left at 0 -- which is
>>> SMC_DIAG_MODE_SMCR, not "unknown" -- and the fallback reason attribute is gone.
>>
>> Regarding your concern about wrong output when the early return fires
>> before diag_mode and SMC_DIAG_FALLBACK are filled: you are right that
>> diag_mode must be filled before the guard. *smcss.c* reads diag_mode at
>> lines 177 and 179 for --smcr/--smcd filtering, which happens before the
>> SMC_INIT and SMC_CLOSED state checks. If diag_mode is left as 0 for
>> a failed-fallback SMC_CLOSED socket, --smcr would incorrectly include it
>> and --smcd would incorrectly exclude it.
>>
>> *SMC_DIAG_FALLBACK* however is *not* needed before the guard — smcss
>> only reads it inside the diag_mode == SMC_DIAG_MODE_FALLBACK_TCP branch
>> which is never reached for *SMC_INIT* or *SMC_CLOSED* sockets, as those
>> two states hit goto newline before that point.
> 
> I don't agree on this.
> 
> Here what we are changing is the UAPI behaviour, which should not be
> constrained by what smcss did.
> 
> And SMC_INIT can coexist with fallback. For example:
> 
> smc_sendmsg() calls smc_switch_to_fallback(SMC_CLC_DECL_OPTUNSUPP) under
> MSG_FASTOPEN while sk_state is SMC_INIT and never changes it afterwards --
> fastopen does not call connect(), so the state never goes to SMC_ACTIVE.

In that case how about moving the check further down, like below? This
way I am not changing the UAPI behaviour and SMC_INIT can co-exist with
fallback.

smc_sendmsg() calls smc_switch_to_fallback(SMC_CLC_DECL_OPTUNSUPP) under
MSG_FASTOPEN while sk_state is SMC_INIT and it never transitions further
— connect() is not called in that path, so the fallback reason is real
diagnostic information that should be reported. The guard after the
SMC_DIAG_FALLBACK nla_put preserves that.

--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -103,6 +103,9 @@ static int __smc_diag_dump(struct sock *sk, struct
sk_buff *skb,
 	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
 		goto errout;

+	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
+		goto out;
+
 	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
 	    smc->conn.alert_token_local) {
@@ -185,5 +188,6 @@ static int __smc_diag_dump(struct sock *sk, struct
sk_buff *skb,
 		goto errout;
 	}

+out:
 	nlmsg_end(skb, nlh);
 	return 0;

