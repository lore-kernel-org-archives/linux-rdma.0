Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58D322749;
	Tue, 13 Oct 2026 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899113; cv=none; b=jG/BAXkUwqph5AjOgsiVScMdlh5DADkQL62NntuC2M2yS8KMJ6E5+r+iwQLm39kUTT6yTWywTGLDoCQaX91wrYuuR6so/Bop20yb0CcGLw0plltB8fgGxg9RZB74Lbv29/7QC9TxSq0qACTh2iY+QEA3bWRifgQginyhXmsWr/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899113; c=relaxed/simple;
	bh=QSRGdC6xICoZtrzBYDuiV8GKbYzY4ggrqUxmlEhioIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hubeygBMtpmlkA7BQ2MDJrTL1MOqHJhq2pEJg0yBp4/a3XPe2eVfxAom5Cyt447jn78hUc6Asltdbp3oNcmfCBlZ8ecYZnWz5QUuL7uUVd0dQ3ve+gjyJPFUnUiJF12OAaeH95na7Jp3Kc71RIQuR2HbMFvyrq3WwAqPx1/ySa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ic2AjTUK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ic2AjTUK"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2ErAi1932337;
	Tue, 13 Oct 2026 13:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NIT35x
	qvv84SmJoWXK5jX+LUQey2iXexsvZBNl097Pw=; b=Ic2AjTUKXjpWLuERolxgUq
	GEcSoPhcSmrOw3dqgRlnUeAsdpSEhd060HVF+iDZLEyHLF6mKVvdEvCPucRGXZRc
	HfT8Hx3wMLxme0rLnydoMScHOPnCwdePQrp4dObAyj7zEd5QC+1dN4rsbH883asU
	FwtLFWfHyOSayMByXxmssWr0wJZeby1QAeTJfsmGwnwCPNXKF/IRDX8Aepq2rZju
	LVU5cEyTAmMdiI1AoqqN0e3WJiBjOYhBATGEiv7nYnJzXXmI1lGprHwxsLSqKaPa
	PdtotUVggSXgpGhcCj3dY4MdnaAP3aabgLzANZU61l7BxFtdXnrfjcqw0NWOolIA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7e1w5yr7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 13:45:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69DCUHGp1440160;
	Tue, 13 Oct 2026 13:45:03 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h81wg1wsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 13:45:03 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69DDj1aM19530244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 13:45:02 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6D605806A;
	Tue, 13 Oct 2026 13:45:01 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E65215804B;
	Tue, 13 Oct 2026 13:44:54 +0000 (GMT)
Received: from [9.124.215.85] (unknown [9.124.215.85])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 13 Oct 2026 13:44:54 +0000 (GMT)
Message-ID: <2a851672-3ef0-45a4-bcdc-c2bfe9370886@linux.ibm.com>
Date: Tue, 13 Oct 2026 19:14:53 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v9] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261012080034.38770-1-mjambigi@linux.ibm.com>
 <179187859972.434549.160211929714609734@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179187859972.434549.160211929714609734@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA1NCBTYWx0ZWRfX/hpvL4E24sHS
 x8gE7PXb0t6rUAw5qrd7VBBz2j8HjqKfzKXOFrTw8GrXrRtQUR02/1tlTgeGfSnMqBTWWhJSKf+
 ATXzFthF+mvyWE/36WZbf3eUzATh71I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA1NCBTYWx0ZWRfX1aYVHa01eFGD
 QzvWI/uZPzczwUHvyx44+XCDv9IrjehFUBFPREZ1p93EIiR67a6L5TUf4FO6iRAizli5249gftl
 XFYmBVyHewlpExMay/OD6i6rX9eGMWK/b185qYGEk+/Q0YkgbWRUGpkfhhQKIkKkrSRSbFspMRY
 JQ72Mf0N93jOkKHUWBscTYqcb2+NOW4wHUmoWWbnWvC+v0aXJB6BNjzqiCvQk+Xr0/HDLMJIwMe
 RVl+aSkWkkUsG1V7U29VOMP/PaXhOrXKfzAX1istVQbBlG9c9X6yumsAAGnGndT6pivAGkIWr4b
 e4DHzC5hqD6lfExCjd88BoVvNUbqgZozeNVzCryaeE+B2Pq/Ew5IJwlroavH7MjxPlzuHXerZzZ
 x7BMtcYQGEMj0LhURBQ+WGj/cMcBlQVBdofGQK9gvsoM3FFi+BBzGPmLlL+2lv7GlbANeGyC2Mn
 ez/WHskAJtEhujLzHIw==
X-Authority-Analysis: v=2.4 cv=E6pYNqdl c=1 sm=1 tr=0 ts=6ace35e0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=BeDyHFNucifB5wfUc5IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 9Vjz8dmj8LoBZRuQxdonLKCFox42RsHX
X-Proofpoint-GUID: ag2I18yveNTAbog_ZNycXib5NjbdfiNb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130054



On 13/10/26 1:33 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 (2) · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The patch adds `smc->sk.sk_prot->unhash(&smc->sk)` as the
>   first statement of smc_conn_kill() (net/smc/smc_core.c:1520), so it…
> - [Medium] The new sk_state-based guards in __smc_diag_dump()
>   (net/smc/smc_diag.c) change the sock_diag uAPI output for sockets…
> - [Low] __smc_diag_dump() (net/smc/smc_diag.c:161) now copies
>   link->ibname into smc_diag_linkinfo.ibname instead of…
> 
> Pre-existing issues:
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_conn_free() (net/smc/smc_core.c:1279-1280) calls…
> - [Medium] This problem wasn't introduced by this patch, but
>   smc_diag_handler_dump() (net/smc/smc_diag.c:244) starts the dump…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch closes several windows where the SMC sock_diag dump can
> dereference freed conn/lgr/lnk state of a socket that is still hashed. It
> adds sk_state guards and acquire/release ordering in __smc_diag_dump(), and
> unhashes the socket before smc_conn_free() in the close paths and at the
> top of smc_conn_kill(). It also reports the cached link->ibname instead of
> link->smcibdev->ibdev->name.
> 
>> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
>> index bb0313ef5f7c1..aa6363abdd747 100644
>> --- a/net/smc/smc_close.c
>> +++ b/net/smc/smc_close.c
> 
> [ ... ]
> 
>> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>>  		sk->sk_state_change(sk);
>>  		if ((sk->sk_state == SMC_CLOSED) &&
>>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
>> +			sk->sk_prot->unhash(sk);
>>  			smc_conn_free(conn);
> 
> [Severity: Medium]
> This isn't a bug introduced by this patch, but it came up while looking at
> the smc_conn_free() calls here. Can smc_conn_free() leak the smc_sock
> reference that a pending abort_work holds?

Agreed, and it is a pre-existing bug, not something introduced by this
patch. smc_cdc_msg_validate() takes the reference with sock_hold() for
abort_work, and smc_conn_free() drops the return value of
cancel_work_sync(), so a still-pending work leaks the socket. I will
fix it in a separate patch, using the same pattern as
smc_close_cancel_work():

	if (cancel_work_sync(&conn->abort_work))
		sock_put(&smc->sk);

with Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation
message"). It is unrelated to the diag lifetime race, so I would like
to keep it out of this patch.

> 
> On SMC-R, smc_cdc_msg_validate() takes a reference for the work:
> 
> net/smc/smc_cdc.c:smc_cdc_msg_validate() {
>     ...
> 		sock_hold(&smc->sk); /* sock_put in abort_work */
> 		if (!queue_work(smc_close_wq, &conn->abort_work))
> 			sock_put(&smc->sk);
>     ...
> }
> 
> That reference is normally dropped at the end of smc_conn_abort_work():
> 
> 	sock_put(&smc->sk); /* sock_hold done by schedulers of abort_work */
> 
> smc_conn_free() ignores the return value of the cancel:
> 
> net/smc/smc_core.c:smc_conn_free() {
>     ...
> 		if (current_work() != &conn->abort_work)
> 			cancel_work_sync(&conn->abort_work);
>     ...
> }
> 
> Suppose smc_conn_free() runs from __smc_release() or
> smc_close_passive_work() while abort_work is still pending. Then
> cancel_work_sync() returns true, and nothing drops the reference the work
> was holding.
> 
> smc_close_cancel_work() handles the same pattern for close_work:
> 
> 	if (cancel_work_sync(&smc->conn.close_work))
> 		sock_put(sk);
> 
> Should smc_conn_free() do the same for abort_work?
> 
>>  			if (smc->clcsock)
>>  				release_clcsock = true;
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 9974149659c2f..663926465ba7f 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>>  {
>>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>>  
>> +	smc->sk.sk_prot->unhash(&smc->sk);
> 
> [Severity: Medium]
> Does this hide sockets that stay open from sock_diag for the rest of their
> lifetime?

Yes, you are right. The unhash at the top of smc_conn_kill() hides
sockets that stay open after the kill (SMC_ACTIVE, SMC_APPCLOSEWAIT*,
and the early-break exits in smc_close_active_abort()). It also
decrements the inuse count while they are still alive. Only the SMC-D
dmb_nocopy smcd_buf_detach() needs the socket unhashed first.

v10 moves the unhash into the smc_ism_support_dmb_nocopy() branch,
right before smcd_buf_detach(). The sites that really free the
connection (smc_close_active_abort(), smc_close_passive_work() and
__smc_release()) keep their own unhash, and smc_unhash_sk() is
idempotent, so there is no double accounting.

> 
> The unhash runs for every SMC-R and SMC-D kill. Only the SMC-D dmb_nocopy
> smcd_buf_detach() further down needs it.
> 
> smc_conn_kill() is called from __smc_lgr_terminate() for every connection
> of a terminating link group (link down, device removal, admin
> termination). It is also called from smc_conn_abort_work().
> 
> For SMC_ACTIVE, SMC_APPCLOSEWAIT1 and SMC_APPCLOSEWAIT2,
> smc_close_active_abort() does not free the conn afterwards:
> 
> net/smc/smc_close.c:smc_close_active_abort() {
>     ...
> 	case SMC_ACTIVE:
> 	case SMC_APPCLOSEWAIT1:
> 	case SMC_APPCLOSEWAIT2:
> 		sk->sk_state = SMC_PEERABORTWAIT;
> 		smc_close_cancel_work(smc);
> 		if (sk->sk_state != SMC_PEERABORTWAIT)
> 			break;
> 		sk->sk_state = SMC_CLOSED;
> 		sock_put(sk); /* (postponed) passive closing */
> 		break;
>     ...
> }
> 
> The early "if (sk->sk_state != SMC_PEERABORTWAIT) break;" exits also leave
> the socket alive. The application keeps its fd until close().
> 
> SMC sockets are hashed only once, in smc_sk_init(), so they never go back
> into the hash table.
> 
> smc_unhash_sk() also calls sock_prot_inuse_add(..., -1). The inuse count in
> /proc/net/protocols then drops while the socket is still alive.
> 
> On SMC-R this doesn't seem to add any safety:
> - smc_lgr_unregister_conn() clears alert_token_local
> - the conn keeps its lgr and link references until smc_conn_free()
> - the free inside smc_close_active_abort() now has its own unhash
> 
> The v6 changelog says the per-site placement "avoids prematurely hiding
> live SMC_ACTIVE/APPCLOSEWAIT sockets from smcss". The commit message
> describes this hunk only as an SMC-D dmb_nocopy reorder.
> 
> Would it be enough to move the unhash into the
> smc_ism_support_dmb_nocopy() branch, right before smcd_buf_detach()?
> 
>>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>>  	else
>> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>> index bf0beaa23bdb6..36a3b8f31f28d 100644
>> --- a/net/smc/smc_diag.c
>> +++ b/net/smc/smc_diag.c
>> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  
>>  	r = nlmsg_data(nlh);
>>  	smc_diag_msg_common_fill(r, sk);
>> -	r->diag_state = sk->sk_state;
>> +	r->diag_state = smp_load_acquire(&sk->sk_state);
>>  	if (smc->use_fallback)
>>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
>> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>> +	else if (r->diag_state != SMC_INIT &&
>> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>>  	else
>>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
>> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>>  		goto errout;
>>  
>> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
>> +		goto out;
>> +
> 
> [Severity: Medium]
> Do these two sk_state checks change the sock_diag uAPI output for sockets
> whose connection is still live?

Yes, they do, and the commit message did not say so. v10 documents it:

 - SMC_DIAG_CONNINFO, SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are no
   longer reported, even if requested, while a socket is in SMC_INIT
   or SMC_CLOSED.
 - diag_mode is reported as SMC_DIAG_MODE_SMCR for a non-fallback SMC-D
   socket in SMC_INIT. This was already the case before
   smc_conn_create() had run, because conn->lgr is still NULL then and
   the code falls through to SMC_DIAG_MODE_SMCR.
 - smcss, the only consumer, does not print any of these attributes
   for SMC_INIT and SMC_CLOSED rows. It does apply its -R/-D filters to
   diag_mode, so with -a an SMC-D socket in SMC_INIT is matched as
   SMC-R. The commit message says so, instead of claiming that there
   is no visible change.

I am keeping the guard. For SMC_INIT it is what keeps a reader from
dereferencing conn->lgr while smc_conn_abort() frees it synchronously,
and the uAPI has no value to report "unknown" for diag_mode. For
SMC_CLOSED, the extension data describes a connection that no longer
transfers data, and smcss never reads it for those rows.

> 
> With the diag_mode change, every non-fallback SMC-D socket in SMC_INIT now
> reports SMC_DIAG_MODE_SMCR. In include/uapi/linux/smc_diag.h, SMCR is 0
> and SMCD has its own value, so there is no "unknown" value to fall back on.
> 
> SMC_INIT is not limited to the abort window:
> - smc_connect_ism() and smc_connect_rdma() run smc_conn_create(),
>   smc_buf_create(), smcd_buf_attach() and the whole CLC confirm exchange
>   while in SMC_INIT
> - on the server side the socket stays in SMC_INIT through
>   smc_listen_work() until smc_listen_out_connected()
> 
> During these windows the lgr, alert_token_local and the buffers are all
> valid, and the socket is hashed and visible to diag.
> 
> The new goto out also skips SMC_DIAG_CONNINFO, SMC_DIAG_LGRINFO and
> SMC_DIAG_DMBINFO even when req->diag_ext asks for them. That bypasses the
> existing alert_token_local, smc_conn_lgr_valid(), list_empty(&lgr->list)
> and rmb_desc checks.
> 
> SMC_CLOSED doesn't mean the conn was freed either:
> - smc_close_active() reached through shutdown(SHUT_RDWR) sets SMC_CLOSED in
>   the APPCLOSEWAIT/APPFINCLOSEWAIT/PROCESSABORT cases without calling
>   smc_conn_free()
> - the SMC_ACTIVE branch of smc_close_active_abort() does the same
> - smc_close_passive_work() frees the conn only when SOCK_DEAD is set or
>   sk->sk_socket is NULL:
> 
> net/smc/smc_close.c:smc_close_passive_work() {
>     ...
> 		if ((sk->sk_state == SMC_CLOSED) &&
> 		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
>     ...
> }
> 
> These sockets keep their conn until close(), but now report no extension
> data.
> 
> The commit message says:
> 
>     As a side effect the diag_mode field is
>     reported as SMC_DIAG_MODE_SMCR for SMC-D sockets still in SMC_INIT; smcss
>     suppresses those rows before printing the mode string so there is no rendered
>     regression.
> 
> That covers only one consumer, smcss. It also doesn't mention the dropped
> extensions for live SMC_CLOSED sockets.
> 
> Is this change in uAPI output intended for sockets that still have a live
> connection?
> 
>>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>>  	    smc->conn.alert_token_local) {
> 
> [Severity: Medium]
> This is a pre-existing issue, not one introduced by this patch. Can
> req->diag_ext be read past the end of the request payload here?

Agreed, this is pre-existing and not part of this patch. I will send a
separate fix that returns -EINVAL from smc_diag_handler_dump() when
nlmsg_len(h) < sizeof(struct smc_diag_req), as inet_diag and unix_diag
do, with Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets").

> 
> smc_diag_handler_dump() calls netlink_dump_start() without checking
> nlmsg_len(h) against sizeof(struct smc_diag_req). The only length check
> before that is in __sock_diag_cmd():
> 
> net/core/sock_diag.c:__sock_diag_cmd() {
>     ...
> 	if (nlmsg_len(nlh) < sizeof(*req))
> 		return -EINVAL;
>     ...
> }
> 
> That checks only the 2-byte struct sock_diag_req, but diag_ext is at
> payload offset 3.
> 
> An unprivileged user can send a SOCK_DIAG_BY_FAMILY/NLM_F_DUMP request with
> nlmsg_len = NLMSG_HDRLEN + 2. This read then lands in uninitialized
> tailroom of the request skb.
> 
> Whether CONNINFO, LGRINFO and DMBINFO appear in the reply would then reveal
> bits of that byte, and KMSAN would report uninit-value.
> 
> inet_diag and unix_diag both check nlmsg_len against their full request
> struct. Should smc_diag_handler_dump() return -EINVAL when
> nlmsg_len(h) < sizeof(struct smc_diag_req)?
> 
> [ ... ]
> 
>> @@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>>  			.lnk[0].link_id = link->link_id,
>>  		};
>>  
>> -		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
>> -		       sizeof(link->smcibdev->ibdev->name));
>> +		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));
> 
> [Severity: Low]
> Can this report a stale RDMA device name after the device is renamed?

Yes, but this is intended. The cached link->ibname is what the SMC
netlink link dump (smc_nl_fill_lgr_link()) and the tracepoints already
report, so diag now follows the same convention. The cached name is
needed because __smcr_link_clear() memsets the link, so
link->smcibdev can be NULL under the diag reader. Following a rename
would need an ib_client .rename callback that walks all link groups,
which is not something I would put in a fix for net. v10 now says in the
commit message that the name is the one cached at link creation. I
will leave the callback as possible follow-up work.

pw-bot: cr

