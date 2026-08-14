Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A527C28E0F;
	Fri, 14 Aug 2026 06:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786687436; cv=none; b=nuvMY67n0uaRZaqeUhQGdPK0g+vZvSGxFQ1v8ZnGJFI5h7wtcyirmOOK6YMnFMwxNMVA3hnBTnQQMNzGF1+nEe/7DUltDxb6UFJJop7sEGrksr3v77jfLjq+MXH4qpPobYHUa2fzpGaILKncIDpXOIgZWi06jWyIb7hwX6uiE/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786687436; c=relaxed/simple;
	bh=vJ9V7UBsJLqwmW94hXBaNBGapsoAIdbjAf24Izm39Pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHYsp1XhpnDqzkeZ3hEJIHU8HAb1YfEaUz74m7svu+QBzO+dndHcffOcW7AkOnS39LBPZYyiP7ugF0LcwqHHyaV3Sr1MJAwAeJ5GPg0ZKpOJt7/iOM9Gqt2FP3c2FZ2wri/krwnj2JsOyH3HLOv1PN2xCkq1LUi5fHl3qIo/oyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s4SIg0pQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s4SIg0pQ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E4Vbff102864;
	Fri, 14 Aug 2026 06:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NyjTPv
	z8xeDEQNqGALmJ7Jjkf56BPyqMl0bAFOnXJ7w=; b=s4SIg0pQJGGwNBSwYY1NCE
	vI3oi/4C9vLt6VxaBezh3r/EOQZmTchzUZOf7BrDS5kpgquGSXJaVEO92H4kYti1
	bL47rpLgLX9op8MQh47vAWgHR/9L65YGcYp/oUHnup3G5UfGQmVZSI4qsOu/BHfs
	tWyTyhv0EW8qMVAufTyhlsCsFW5sGdnpCiZ3FtxQGwkq7ZEgekdvFTFF56FBK+Z4
	Yb7q4kEWNB2u4mjC9A0eqYQwQ7iHhMhpO80omJUOaIrOsStf/Q0tW7FJg4WRKWNd
	8SFuZCWzb6mvmDKtzYvW7sKShyR91cbUjr7CpHB9QiljkgBsLsAjjbinyHo9rk8g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvq9ud8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:03:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67E5ubCu025885;
	Fri, 14 Aug 2026 06:03:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqe93e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:03:41 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67E63aSJ38797726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 06:03:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20EAA2004D;
	Fri, 14 Aug 2026 06:03:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B96220043;
	Fri, 14 Aug 2026 06:03:33 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 06:03:32 +0000 (GMT)
Message-ID: <5933e788-4fdb-40cd-bb98-723b89ec7620@linux.ibm.com>
Date: Fri, 14 Aug 2026 11:33:32 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
To: hexlabsecurity@proton.me, Jakub Kicinski <kuba@kernel.org>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller"
 <davem@davemloft.net>,
        Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Tony Lu <tonylu@linux.alibaba.com>,
        Mahanta Jambigi
 <mjambigi@linux.ibm.com>,
        Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Simon Horman <horms@kernel.org>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
 <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: VH5w0qOOiimMOWvlHhvp7F-JKYtsEDJt
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a7eafbf cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=YUF9At5gBs46D7K_BuIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfXyJMNT0GbQZCY
 jiHew2p9r9HFBDcmRmK5f2bkzalHTvDfJf5WPC7Jbf2/xoq4Hl/6dtYj1Gj+OzBXpp8oJb4ar1p
 dsI7nwxsFJKH15OH5dvnhl83XsejD1tS4aRy80qRXXM9a7+dhhlt7CtUdpaRE2oISc0vwLtBbE1
 EJ98tR6enOzWMa1+W/LYgG6/viZ5XNFCkgW5GhBF9NQ2eP8T6sw/gu7F3aC/cmWkSVRZ5uQBRR0
 SW0mh5YAOcSnM1QauFru1tF2cuLoHRp2haa4mXcEh7oO7eFZIGZSGOp3FWPsp/MVXRZ3pxog+GZ
 4VO1t7oNO6aBX8sagybtbYXhdQM/MAxD8ff5h4Is6kwp1+1P2A/ggoXXtnWA8kTLAzIqzNvaVh4
 sK0isjF1A8B8SdZQWazEH6QICeTGM6MD5yu1jnJiVH12m8QwW/c2Zepf5I69LBVox2d9PTiyjTZ
 fL/rzqnRIzvQw45Ur1g==
X-Proofpoint-ORIG-GUID: xclZ4MtRsTo6uX8KYPDKnW7i18qIirF_
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfX3+uYFm0YGt2j
 3XA4O/TQ8DU83+gUWWXelRFtjRUAx1CPkppAOllYfgFqa23NV1B88Elkd17waiIFLF3ABuXZOGa
 DU9HCC52cj6za360WwIwsr5ILY3C3Mg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140045



On 24/07/26 5:53 am, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import a peer's
> producer cursor from the wire into conn->local_rx_ctrl.prod without
> bounding it against the receive buffer. The urgent-data path in
> smc_cdc_msg_recv_action() then uses that count as a raw index into the
> RMB, so a peer that advertises a producer cursor past rmb_desc->len
> reads out of bounds of the RMB allocation in the receive tasklet and
> can disclose adjacent kernel memory.
> 
> Bound the producer cursor count to rmb_desc->len at the wire-to-host
> conversion, for both SMC-R and SMC-D. Bound only the producer cursor:
> the consumer cursor indexes the peer's RMB and is bounded by
> peer_rmbe_size, so clamping it to our rmb_desc->len would under-credit
> peer_rmbe_space and stall transmit to a peer with a larger RMB.
> Conforming peers are unaffected.
> 
> Fixes: de8474eb9d50 ("net/smc: urgent data support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_cdc.h | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11f2303..ca76ef630356 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
> @@ -221,7 +221,8 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
>  
>  static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  					  union smc_cdc_cursor *peer,
> -					  struct smc_connection *conn)
> +					  struct smc_connection *conn,
> +					  int max_count)
>  {
>  	union smc_host_cursor temp, old;
>  	union smc_cdc_cursor net;
> @@ -235,6 +236,15 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  	if ((old.wrap == temp.wrap) &&
>  	    (old.count > temp.count))
>  		return;
> +	/* The peer producer cursor is wire-controlled and is later used as a
> +	 * raw index into our RMB by the urgent path; bound its count to the
> +	 * RMB.  max_count == 0 leaves the consumer cursor unbounded here: it
> +	 * indexes the peer's RMB (bounded by peer_rmbe_size, not our
> +	 * rmb_desc->len), so clamping it to rmb_desc->len would under-credit
> +	 * peer_rmbe_space and stall transmit to peers with a larger RMB.
> +	 */
> +	if (max_count && temp.count > max_count)
> +		temp.count = max_count;
>  	smc_curs_copy(local, &temp, conn);
>  }
>  
> @@ -246,8 +256,13 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	local->len = peer->len;
>  	local->seqno = ntohs(peer->seqno);
>  	local->token = ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	/* bound the wire-controlled producer cursor to our RMB (used as a raw
> +	 * index by the urgent path); leave the consumer cursor unbounded -- it
> +	 * indexes the peer's RMB and is bounded by peer_rmbe_size.
> +	 */
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);
> +	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
>  	local->prod_flags = peer->prod_flags;
>  	local->conn_state_flags = peer->conn_state_flags;
>  }
> @@ -260,6 +275,12 @@ static inline void smcd_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  
>  	temp.wrap = peer->prod.wrap;
>  	temp.count = peer->prod.count;
> +	/* the peer producer cursor is wire-controlled and is used as a raw
> +	 * index into our RMB by the urgent path; bound it to the RMB.  The
> +	 * consumer cursor below indexes the peer's RMB and is left unbounded.
> +	 */
> +	if (temp.count > conn->rmb_desc->len)
> +		temp.count = conn->rmb_desc->len;
>  	smc_curs_copy(&local->prod, &temp, conn);
>  
>  	temp.wrap = peer->cons.wrap;
> 

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
