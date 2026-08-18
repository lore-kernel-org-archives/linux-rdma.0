Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0E333B6DA;
	Tue, 18 Aug 2026 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067495; cv=none; b=SuOLyVz3aUTW2U7mJyXZ7fTqV9eJTE62rws8TMmM/fmqiywa11Zabhu9yyH9fQ/+7y3kjOMBcUyXpBE8+v1GoV1CU44NLI61x1ubNIOupiXBPxywcu8qhFQCF87sHvbjrjwZC4jKppgohe2+1FehVNpJGSFQVCan8F0+2Ceqn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067495; c=relaxed/simple;
	bh=tuNvbcrDpB2+KBB+DN1JUJbXIi9AKJAz2UAks1AgaCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pui4Xof/WV2fI0VqkEuosztBWxItwER0VSj2YYTcQ9tn7QMMrf5aSF3loBb9Z+bqlAv7aMY9AixR9rB/u7LC2tVeKSOijABch1ZsHSF9fGRjco3VdM+VRjOTMIhXM4bA+znzqBxsy6DaZ46dNiHpmzhJjOaKlxygAecRNHR//oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p+U7hIUC; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p+U7hIUC"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IE3ZLk455077;
	Tue, 18 Aug 2026 15:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=f5xwOO
	QORYBaSWxbnrdh2wlzEOV3P0HR4yGQ7vY5Heg=; b=p+U7hIUCbJtPPPxTpAB1V1
	vbNDQK8CxfWr38WRnTabPUj4ZBVxGkiiQhxcNI8I+cxcbOCYCG2S2XMmk8Dllx1j
	cbudGyxhz9oM7XUsfwlJhhqFR8hbEch6ytnowIGlf+Y0rB7N8yLsGGWGwNyyMWA/
	Hz0CGQGEQjqREewWFEegWtVWkils663HqaINvolKj/KHLr37zx7aqbcGcqLnKETf
	j8wz61k5WBuIIIV35iVhC3KgYgr6dUj/p867GZTPIM1fTJVKv4HeweMROn2+Da+Z
	LHXRqY1uiVorUo9Pf6U0YGD7tC5LeGQYt4Z94hkDuWzgsgfnghExr8lPHeOpLhww
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3s662-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:38:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IFQKPJ022455;
	Tue, 18 Aug 2026 15:38:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g34ngbrc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 15:38:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67IFc1Lv46465434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 15:38:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7183020043;
	Tue, 18 Aug 2026 15:38:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 739FA20040;
	Tue, 18 Aug 2026 15:37:56 +0000 (GMT)
Received: from [9.39.17.238] (unknown [9.39.17.238])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 15:37:56 +0000 (GMT)
Message-ID: <d3b6d485-bef3-4a04-8fde-d78c80de05c6@linux.ibm.com>
Date: Tue, 18 Aug 2026 21:07:55 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6 3/3] net/smc: carry oversized SMC-Rv2 LLC messages
 in the queue entry
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
 <20260811231902.47089-4-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260811231902.47089-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: yu8mlwleHzU06iPMP7MrlnR1X4ZqOrzj
X-Proofpoint-ORIG-GUID: iNqLJhYbGGOAX37_esZ8SRpQD1EA_WQF
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDExNCBTYWx0ZWRfX1Em7cuhTJaCo
 ps3NI9ql29XcBxIykuhba1XmmJji1y286BVDPouz+GEhSVF9No6gBTTRzh1ZIpz0fJjfrHrs1FC
 dv5pZbCh5853BwdsoSBYTmps6ryiyes=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a847c5e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=eMjwJFQtSrC_Qr7Pna8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDExNCBTYWx0ZWRfX4WDsepB39Fo7
 KtIzj+PAVxwtgmkBFKGEnppYOjnUMcAXR6sGO/4DVdls7APtRfNZsZKABuXrBPlOePgOiwHUxLE
 M3xkJe338HCz8aHrrDzB6tUIqXppFoN6EaIffQDfB31p87OL3RO+u4xNsoVpgkv0Fb7IUg7dz0T
 kucUIqoPxv7x6+iBhvpDw6Sh2TTW6LRbnf2m9j2UcJLETEUBk6H37wWACvKvKP0TFjq26H47t1f
 VumdoUJcwXnAxcGcu2bRbVXiBfqPIJCr1BbAA1Q0L/OnlksQiYntcTiov10NQTODiL5sVKTXoLg
 VWRB1VDvk/s2UsZT2dLj/PAqiSz9X03i7pur3wprUT3W3cd6Pqa1NjEpGBQX+c/uYy5ZQkmLqMC
 pV5MHGwzDJwhmq7iVpbkK0e+LaeIdWvhtEqt83/6fD2CE/y+mTe5umLVKMfWsFi59jXJM+niNZW
 prTXcAk8ZYBxipC5WEQ==
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
> smc_llc_rmt_delete_rkey() and smc_llc_save_add_link_rkeys() read the part
> of a v2 message that does not fit into the 44-byte union smc_llc_msg, and
> both bound themselves by the size of the buffer it landed in, not by what
> arrived.  On a link with a shared v2 receive buffer a 44-byte
> DELETE_RKEY_V2 declaring 255 rkeys reaches rkey[9..254] in whatever an
> earlier message left in lgr->wr_rx_buf_v2, and passes each of them to
> smc_rtoken_delete().  One of those 255 matched a registered rtoken and
> deleted it.  An ADD_LINK on such a link installs up to 255 rtokens from
> the same bytes.
> 
> Copy the tail into the queue entry, so its length is the length of the
> message that arrived, and declare the rkeys that fit inline as a member of
> the union instead of reaching them through a cast.  The same
> DELETE_RKEY_V2 now processes the 9 rkeys it carries.  The copy is limited
> to the longest tail the two functions can read, so the peer does not pick
> the size of the entry.
> 
> The bound the previous patch placed on links without a shared v2 receive
> buffer is no longer needed.
> 
> Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
> Cc: stable@vger.kernel.org
> Suggested-by: D. Wythe <alibuda@linux.alibaba.com>
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
> ---
> Changes since v5: added the Fixes: and Cc: stable tags; asserted that the two
> DELETE_RKEY_V2 layouts agree on offsetof(rkey); limited the copied tail to
> what the two readers can use; corrected the comment in smc_wr_init_sge().
> 
> Measured over rxe with KASAN: a DELETE_RKEY_V2 carrying 12 rkeys over a link
> with a shared v2 receive buffer round-trips all 12 values, the last three
> coming from the copied tail; 8, 9 and 10 rkeys and a 44-byte message declaring
> 10 give 8, 9, 10 and 9 processed rkeys respectively.  kmemleak reports nothing
> over the link-addition path, and does report the queue entry when the free
> added by patch 1 is removed again.
> 
> Five runs per cell with and without the new limit: a 44-byte DELETE_RKEY_V2
> declaring 255 rkeys reports 9 processed on a link with and without a shared
> v2 receive buffer, an ADD_LINK v2 extension installs the 6 rtokens the peer
> sent, and no KASAN report appears.  The only message the limit changes in
> that lab is a REQ_ADD_LINK, which copied 16 bytes that have no reader and
> now copies none.  On the unpatched kernel the same DELETE_RKEY_V2 reports
> 254 and 255, and the ADD_LINK installs 255 rtokens per call.
> 

Nit: There are a few extra spaces after sentence ending punctuation in
the commit message. Please remove them.

>  net/smc/smc_llc.c | 125 ++++++++++++++++++++++++++++++++--------------
>  net/smc/smc_wr.c  |   6 +--
>  2 files changed, 91 insertions(+), 40 deletions(-)
> 
> diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
> index 748d65186f68..393aa0af18d1 100644
> --- a/net/smc/smc_llc.c
> +++ b/net/smc/smc_llc.c
> @@ -157,6 +157,7 @@ struct smc_llc_msg_confirm_rkey {	/* type 0x06 */
>  };
>  
>  #define SMC_LLC_DEL_RKEY_MAX	8
> +#define SMC_LLC_DEL_RKEY_V2_INLINE	9
>  #define SMC_LLC_FLAG_RKEY_RETRY	0x10
>  #define SMC_LLC_FLAG_RKEY_NEG	0x20
>  
> @@ -177,6 +178,15 @@ struct smc_llc_msg_delete_rkey_v2 {	/* type 0x29 */
>  	__be32 rkey[];
>  };
>  
> +/* the leading rkeys of a DELETE_RKEY_V2 fit into union smc_llc_msg */
> +struct smc_llc_msg_delete_rkey_v2_inline {	/* type 0x29 */
> +	struct smc_llc_hdr hd;
> +	u8 num_rkeys;
> +	u8 num_inval_rkeys;
> +	u8 reserved[2];
> +	__be32 rkey[SMC_LLC_DEL_RKEY_V2_INLINE];
> +};
> +
>  union smc_llc_msg {
>  	struct smc_llc_msg_confirm_link confirm_link;
>  	struct smc_llc_msg_add_link add_link;
> @@ -186,6 +196,7 @@ union smc_llc_msg {
>  
>  	struct smc_llc_msg_confirm_rkey confirm_rkey;
>  	struct smc_llc_msg_delete_rkey delete_rkey;
> +	struct smc_llc_msg_delete_rkey_v2_inline delete_rkey_v2;
>  
>  	struct smc_llc_msg_test_link test_link;
>  	struct {
> @@ -194,15 +205,25 @@ union smc_llc_msg {
>  	} raw;
>  };
>  
> +static_assert(SMC_LLC_DEL_RKEY_V2_INLINE ==
> +	      (sizeof(union smc_llc_msg) -
> +	       offsetof(struct smc_llc_msg_delete_rkey_v2, rkey)) /
> +	      sizeof(__be32));
> +static_assert(offsetof(struct smc_llc_msg_delete_rkey_v2_inline, rkey) ==
> +	      offsetof(struct smc_llc_msg_delete_rkey_v2, rkey));
> +
>  #define SMC_LLC_FLAG_RESP		0x80
>  
>  struct smc_llc_qentry {
>  	struct list_head list;
>  	struct smc_link *link;
> +	u16 body_len;
>  	union smc_llc_msg msg;
> +	u8 body[] __counted_by(body_len);
>  };
>  
> -static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc);
> +static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc,
> +			    u32 byte_len);
>  
>  struct smc_llc_qentry *smc_llc_flow_qentry_clr(struct smc_llc_flow *flow)
>  {
> @@ -998,22 +1019,19 @@ static int smc_llc_cli_conf_link(struct smc_link *link,
>  
>  static void smc_llc_save_add_link_rkeys(struct smc_link *link,
>  					struct smc_link *link_new,
> -					u8 *llc_msg)
> +					struct smc_llc_qentry *qentry)
>  {
>  	const u32 rt_off = offsetof(struct smc_llc_msg_add_link_v2_ext, rt);
>  	struct smc_llc_msg_add_link_v2_ext *ext;
>  	struct smc_link_group *lgr = link->lgr;
>  	int max, i;
>  
> -	/* Without a shared v2 receive buffer the extension is not copied
> -	 * into the queue entry, so not even ext->num_rkeys is there.
> -	 */
> -	if (!smc_link_shared_v2_rxbuf(link))
> +	/* the rkey count itself is only there if enough bytes arrived */
> +	if (qentry->body_len < rt_off)
>  		return;
> -	ext = (struct smc_llc_msg_add_link_v2_ext *)(llc_msg +
> -						     SMC_WR_TX_SIZE);
> +	ext = (struct smc_llc_msg_add_link_v2_ext *)qentry->body;
>  	max = min_t(u8, ext->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
> -	max = min_t(u32, max, (SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE - rt_off) /
> +	max = min_t(u32, max, (qentry->body_len - rt_off) /
>  			      sizeof(ext->rt[0]));
>  	down_write(&lgr->rmbs_lock);
>  	for (i = 0; i < max; i++) {
> @@ -1107,9 +1125,7 @@ int smc_llc_cli_add_link(struct smc_link *link, struct smc_llc_qentry *qentry)
>  	if (rc)
>  		goto out_clear_lnk;
>  	if (lgr->smc_version == SMC_V2) {
> -		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
> -			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
> -		smc_llc_save_add_link_rkeys(link, lnk_new, llc_msg);
> +		smc_llc_save_add_link_rkeys(link, lnk_new, qentry);
>  	} else {
>  		rc = smc_llc_cli_rkey_exchange(link, lnk_new);
>  		if (rc) {
> @@ -1510,9 +1526,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  	if (rc)
>  		goto out_err;
>  	if (lgr->smc_version == SMC_V2) {
> -		u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
> -			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;
> -		smc_llc_save_add_link_rkeys(link, link_new, llc_msg);
> +		smc_llc_save_add_link_rkeys(link, link_new, qentry);
>  	} else {
>  		rc = smc_llc_srv_rkey_exchange(link, link_new);
>  		if (rc)
> @@ -1561,7 +1575,8 @@ void smc_llc_add_link_local(struct smc_link *link)
>  	add_llc.hd.common.llc_type = SMC_LLC_ADD_LINK;
>  	smc_llc_init_msg_hdr(&add_llc.hd, link->lgr, sizeof(add_llc));
>  	/* no dev and port needed */
> -	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc);
> +	smc_llc_enqueue(link, (union smc_llc_msg *)&add_llc,
> +			sizeof(union smc_llc_msg));
>  }
>  
>  /* worker to process an add link message */
> @@ -1597,7 +1612,8 @@ void smc_llc_srv_delete_link_local(struct smc_link *link, u8 del_link_id)
>  	del_llc.link_num = del_link_id;
>  	del_llc.reason = htonl(SMC_LLC_DEL_LOST_PATH);
>  	del_llc.hd.flags |= SMC_LLC_FLAG_DEL_LINK_ORDERLY;
> -	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc);
> +	smc_llc_enqueue(link, (union smc_llc_msg *)&del_llc,
> +			sizeof(union smc_llc_msg));
>  }
>  
>  static void smc_llc_process_cli_delete_link(struct smc_link_group *lgr)
> @@ -1819,27 +1835,28 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
>  	link = qentry->link;
>  
>  	if (lgr->smc_version == SMC_V2) {
> -		const u32 rkey_off =
> -			offsetof(struct smc_llc_msg_delete_rkey_v2, rkey);
> -		struct smc_llc_msg_delete_rkey_v2 *llcv2;
> -		u32 buf_len;
> -
> -		if (smc_link_shared_v2_rxbuf(link)) {
> -			memcpy(lgr->wr_rx_buf_v2, llc, sizeof(*llc));
> -			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)lgr->wr_rx_buf_v2;
> -			buf_len = SMC_WR_BUF_V2_SIZE;
> -		} else {
> -			llcv2 = (struct smc_llc_msg_delete_rkey_v2 *)llc;
> -			buf_len = sizeof(qentry->msg);
> -		}
> +		struct smc_llc_msg_delete_rkey_v2_inline *llcv2;
> +
> +		/* The leading SMC_LLC_DEL_RKEY_V2_INLINE rkeys are declared in
> +		 * the message itself, any further ones were received into
> +		 * qentry->body.
> +		 */
> +		llcv2 = &qentry->msg.delete_rkey_v2;
>  		llcv2->num_inval_rkeys = 0;
>  
>  		max = min_t(u8, llcv2->num_rkeys, SMC_LLC_RKEYS_PER_MSG_V2);
> -		/* bound by the buffer llcv2 points at */
> -		max = min_t(u32, max, (buf_len - rkey_off) /
> -				      sizeof(llcv2->rkey[0]));
> +		max = min_t(u32, max, SMC_LLC_DEL_RKEY_V2_INLINE +
> +				      qentry->body_len / sizeof(__be32));
>  		for (i = 0; i < max; i++) {
> -			if (smc_rtoken_delete(link, llcv2->rkey[i]))
> +			__be32 rkey;
> +
> +			if (i < SMC_LLC_DEL_RKEY_V2_INLINE)
> +				rkey = llcv2->rkey[i];
> +			else
> +				memcpy(&rkey, qentry->body +
> +					      (i - SMC_LLC_DEL_RKEY_V2_INLINE) *
> +					      sizeof(rkey), sizeof(rkey));
> +			if (smc_rtoken_delete(link, rkey))
>  				llcv2->num_inval_rkeys++;
>  		}
>  		memset(&llc->rkey[0], 0, sizeof(llc->rkey));
> @@ -2080,18 +2097,52 @@ static void smc_llc_rx_response(struct smc_link *link,
>  	wake_up(&link->lgr->llc_msg_waiter);
>  }
>  
> -static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc)
> +/* the longest tail either reader of qentry->body can use */
> +static u32 smc_llc_max_body_len(union smc_llc_msg *llc)
> +{
> +	switch (llc->raw.hdr.common.llc_type) {
> +	case SMC_LLC_ADD_LINK:
> +		return offsetof(struct smc_llc_msg_add_link_v2_ext, rt) +
> +		       SMC_LLC_RKEYS_PER_MSG_V2 *
> +		       sizeof(struct smc_llc_msg_add_link_cont_rt);
> +	case SMC_LLC_DELETE_RKEY:
> +		return (SMC_LLC_RKEYS_PER_MSG_V2 -
> +			SMC_LLC_DEL_RKEY_V2_INLINE) * sizeof(__be32);
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static void smc_llc_enqueue(struct smc_link *link, union smc_llc_msg *llc,
> +			    u32 byte_len)
>  {
>  	struct smc_link_group *lgr = link->lgr;
>  	struct smc_llc_qentry *qentry;
>  	unsigned long flags;
> +	u16 body_len = 0;
> +
> +	/* V2 messages can be longer than the inline union smc_llc_msg. Carry
> +	 * the remainder in the qentry itself, so that its lifetime and its
> +	 * length match the message the peer actually sent.
> +	 */
> +	if (lgr->smc_version == SMC_V2 && byte_len > SMC_WR_TX_SIZE)
> +		body_len = min_t(u32, byte_len, SMC_WR_BUF_V2_SIZE) -
> +			   SMC_WR_TX_SIZE;
> +	body_len = min_t(u32, body_len, smc_llc_max_body_len(llc));
>  
> -	qentry = kmalloc_obj(*qentry, GFP_ATOMIC);
> +	qentry = kmalloc_flex(*qentry, body, body_len, GFP_ATOMIC);
>  	if (!qentry)
>  		return;
> +	qentry->body_len = body_len;
>  	qentry->link = link;
>  	INIT_LIST_HEAD(&qentry->list);
>  	memcpy(&qentry->msg, llc, sizeof(union smc_llc_msg));
> +	if (body_len) {
> +		u8 *src = smc_link_shared_v2_rxbuf(link) ?
> +			(u8 *)lgr->wr_rx_buf_v2 : (u8 *)llc;
> +
> +		memcpy(qentry->body, src + SMC_WR_TX_SIZE, body_len);
> +	}
>  
>  	/* process responses immediately */
>  	if ((llc->raw.hdr.flags & SMC_LLC_FLAG_RESP) &&
> @@ -2123,7 +2174,7 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
>  			return; /* invalid message */
>  	}
>  
> -	smc_llc_enqueue(link, llc);
> +	smc_llc_enqueue(link, llc, wc->byte_len);
>  }
>  
>  /***************************** worker, utils *********************************/
> diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
> index 59c92b46945c..97ba46893b17 100644
> --- a/net/smc/smc_wr.c
> +++ b/net/smc/smc_wr.c
> @@ -602,9 +602,9 @@ static void smc_wr_init_sge(struct smc_link *lnk)
>  
>  	/* With SMC-Rv2 there can be messages larger than SMC_WR_TX_SIZE.
>  	 * Each ib_recv_wr gets 2 sges, the second one is a spillover buffer
> -	 * and the same buffer for all sges. When a larger message arrived then
> -	 * the content of the first small sge is copied to the beginning of
> -	 * the larger spillover buffer, allowing easy data mapping.
> +	 * and the same buffer for all sges. The spillover sge starts at
> +	 * SMC_WR_TX_SIZE, so the leading bytes of that buffer are never
> +	 * written.
>  	 */
>  	for (i = 0; i < lnk->wr_rx_cnt; i++) {
>  		int x = i * lnk->wr_rx_sge_cnt;
Patch looks good to me.

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
