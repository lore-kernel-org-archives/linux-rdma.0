Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1E3D79E2;
	Mon, 27 Jul 2026 07:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785138316; cv=none; b=XCRIgTlBeEu+oLrYnVRlj5cR2ldCkvSaC0rGeB/Y8N8AwpSU8qi/2Y5f0WpDUcI/EVjeYvxSI9vCeD4ZI+KT3FRWSVTj4CXWOGnnRt97EwpSMBT/6uoaB1ECAQkGKX1ezmypRFLmNy5R//XOgwru+dpnyp8Ih14xNNYM4dWBFcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785138316; c=relaxed/simple;
	bh=Y48UqEdY8UD/mnR1Xgg3AGCXzClbo97Kxe/4Za5E3Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EuecFkXcqVDEdhGpozNviqF5mZDBgN0LDlwM+Zcrcz0ym40PgrOouL3bq8DCwqZmXsit6sUTXwSm7ZVZrp+7Dub3eol6ndp8zlwAyOA5KDr16A7ujSUKMzUIw7neyki+qj7SGOduU0hC0eroAy0M9d0uwpgnmQ1/tbWwVIP0Tyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JDOqA30R; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JDOqA30R"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1lj2m3186224;
	Mon, 27 Jul 2026 07:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=blZCI/
	1xpqf/j765CrKMQj8PfyFCK8vf8g6GviadJDU=; b=JDOqA30R8S6huG2X5Kl9bx
	slnThqC4oZmW0w9azRAU8ai+1cMA+ir1XzbQXy8o48j2J5pv8edzQT9CHXKIslxv
	pObIDvzN3BNAtV4ceoKm94IWUxTeg4y+owPS6PaUwIkI8mmMCOpbyWt4BeM/u/0/
	OheJj4eatcwH8r1lV9C+O0yRTiObOg5B65aCPhvgs7QoDW9VQgaT8yUB2JYZcMTy
	hmYxNBMEST1FqYzKQQjp+wYxnouUsVkIsDXcQiYMSIJEOnbsaxletqTaowrPPMqI
	X9T6UqRC+GlSq7pq5Diqvc431HwV6cOPtBxSPjFTM0Se6+KJIVe3MofUSurJf82A
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyc6ssv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 07:45:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66R7fTHW019312;
	Mon, 27 Jul 2026 07:45:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fq4jge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 07:45:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66R7j8OA51511804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 07:45:08 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BACC20102;
	Mon, 27 Jul 2026 07:45:08 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A030520101;
	Mon, 27 Jul 2026 07:45:05 +0000 (GMT)
Received: from [9.124.222.121] (unknown [9.124.222.121])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Jul 2026 07:45:05 +0000 (GMT)
Message-ID: <af7fc73c-b932-4234-ac2f-91e96669048b@linux.ibm.com>
Date: Mon, 27 Jul 2026 13:15:03 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: clamp peer supplied CDC cursors to the
 buffer size
To: Nguyen Le Thanh Tung <nguyenlethanhtung555@gmail.com>,
        "D . Wythe" <alibuda@linux.alibaba.com>,
        Dust Li
 <dust.li@linux.alibaba.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727040806.1911118-1-nguyenlethanhtung555@gmail.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260727040806.1911118-1-nguyenlethanhtung555@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: WLJ3-kqfLe5QJ4SMLFDuQMqS3yDgVvAs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA3MSBTYWx0ZWRfX2w0qfY/7WlPB
 O//TqL4UoLbmG4eEAlqV4rnAK3s5+RDD1D7XQqRI9qY/Qk9CoDRACFQl6hjnPuoFqfODOIeVfrS
 Zsyn3XfkII3Es9FbL6TnUQrt4I2VuR99rySkJOEWy5HuyhphIf9zg7gwLfiiDyu1jALWGKn9Ows
 8HlgMef0ilP0ox+f1NrCKGv+TVsoXDuXW8TV258uf3wlhVMwLaKT7iiREDt4gY0+A/jFCFuISlZ
 CD0pneyw+a57hh2Bnc+Vi+S6y2TnFgevPqo5VUqiztWa6hLRg2FD+hb3ngloMoIlMdIduldo4Ck
 X17EzeHtWC3QArDabw6CBdU8l2wbmCugsewLW1LZw/Lygt5svPmnbqW32aQizchyq5uqGUXPAEJ
 ny5ijBt1O/RWFy9FcFj1p7fDkR3V4xLJZE7IisEw1cmyw2neP/HRANeURD+hwndC2Ms74MZRElV
 Zttip+TCXSRt8RwXttQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA3MSBTYWx0ZWRfX0X3pwKBsM8Mf
 2zwt4800pt0zoOOaKmcIt2xfTawlJvp5GbygNhyM1URHPbcM0DTYPAzakKc0/3Wc+vnwH4TWL8o
 iIoyi4iA8XwL0vrKg8OdqERUYJWxC7s=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a670c89 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=5yyuC85hIx6mA88jmB4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: A3EPWhSQO4oe84PHd0fwVX0AwW-ek1sy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270071

Hi Nguyen,
I think Bryam already sent a similar patch to the mailing-list.

https://lore.kernel.org/netdev/20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me/

On 27/07/26 9:38 am, Nguyen Le Thanh Tung wrote:
> smc_cdc_cursor_to_host() converts a peer supplied CDC cursor into the
> connection's host cursor.  The count field is taken verbatim off the
> wire and is only compared against the previously known cursor to
> enforce monotonicity - it is never validated against the size of the
> buffer it indexes:
> 
> 	temp.count = ntohl(net.count);
> 	temp.wrap  = ntohs(net.wrap);
> 	if ((old.wrap > temp.wrap) && temp.wrap)
> 		return;
> 	if ((old.wrap == temp.wrap) && (old.count > temp.count))
> 		return;
> 	smc_curs_copy(local, &temp, conn);
> 
> On the first CDC message of a connection old is {wrap = 0, count = 0},
> so both guards are false for any peer chosen pair and a count of up to
> 0xffffffff is accepted unconditionally.  A conforming peer never emits
> count >= size: smc_curs_add() wraps at the buffer size, which is what
> every consumer of the cursor assumes.
> 
> The most direct consequence is in smc_cdc_handle_urg_data_arrival(),
> which uses the producer cursor as a raw index with no further check:
> 
> 	base = (char *)conn->rmb_desc->cpu_addr + conn->rx_off;
> 	if (conn->urg_curs.count)
> 		conn->urg_rx_byte = *(base + conn->urg_curs.count - 1);
> 
> That path is reached from the receive path whenever the producer cursor
> advances and prod_flags.urg_data_present is set - a single bit copied
> verbatim from the wire - so a peer can read at an attacker chosen offset
> of up to 4GB from a known heap pointer, far outside the RMB.  The same
> unvalidated cursor also feeds the atomic_add() into conn->bytes_to_rcv,
> breaking the 0 <= bytes_to_rcv <= rmb_desc->len invariant that
> smc_rx_recvmsg() relies on when it computes its second copy chunk.
> 
> Clamp count to the size of the buffer the cursor refers to, so that
> everything derived from it stays inside that buffer.  The producer
> cursor indexes the local RMB and is bounded by conn->rmb_desc->len, the
> consumer cursor refers to the peer's RMBE and is bounded by
> conn->peer_rmbe_size - the same sizes smc_cdc_msg_recv_action() already
> passes to smc_curs_diff() for these two cursors, and which it already
> dereferences unconditionally a few lines after the conversion, so no new
> pointer is assumed valid here.  The SMC-D path reads the cursors from
> the DMB rather than off the wire, but they are equally peer controlled
> and reach the same consumers, so clamp there as well.  For SMC-D the DMB
> is registered with sizeof(struct smcd_cdc_msg) extra bytes and
> buf_desc->len holds the remainder (smcd_new_buf_create()), so bounding
> count by rmb_desc->len also keeps the rx_off based dereference inside
> the allocation.
> 
> Found by code inspection.  The unbounded acceptance was confirmed by
> calling the unmodified smc_cdc_cursor_to_host() from a module with
> old = {0, 0} and a peer cursor of count = 0x40000000: the value is
> copied through unchanged.  Replaying the resulting dereference against a
> real 64 byte kmalloc() allocation produces a clean KASAN
> slab-out-of-bounds read.
> 
> Fixes: 5f08318f617b ("smc: connection data control (CDC)")
> Signed-off-by: Nguyen Le Thanh Tung <nguyenlethanhtung555@gmail.com>
> ---
> Compile tested on 6.8.12 with CONFIG_SMC=m: `make W=1 net/smc/` produces
> no new warnings.  The two functions this patch touches are byte identical
> in 6.8 and current mainline.
> 
>  net/smc/smc_cdc.h | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
> index 696cc11..a71e46d 100644
> --- a/net/smc/smc_cdc.h
> +++ b/net/smc/smc_cdc.h
> @@ -219,16 +219,34 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
>  	peer->conn_state_flags = local->conn_state_flags;
>  }
>  
> +/* Bound a peer supplied cursor count to the size of the buffer it indexes.
> + * A conforming peer never sends count >= size (see smc_curs_add()), and every
> + * user of the cursor - the byte accounting in smc_cdc_msg_recv_action() and
> + * the direct RMB dereference in smc_cdc_handle_urg_data_arrival() - relies on
> + * that. Nothing validates it, so do it here, once, where the value enters the
> + * connection state.
> + */
> +static inline u32 smc_cdc_clamp_count(u32 count, unsigned int size)
> +{
> +	if (WARN_ON_ONCE(size && count >= size))
> +		count = size - 1;
> +	return count;
> +}
> +
> +/* @size: size of the buffer the cursor indexes, i.e. conn->rmb_desc->len for
> + *	  a producer cursor and conn->peer_rmbe_size for a consumer cursor
> + */
>  static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
>  					  union smc_cdc_cursor *peer,
> -					  struct smc_connection *conn)
> +					  struct smc_connection *conn,
> +					  unsigned int size)
>  {
>  	union smc_host_cursor temp, old;
>  	union smc_cdc_cursor net;
>  
>  	smc_curs_copy(&old, local, conn);
>  	smc_curs_copy_net(&net, peer, conn);
> -	temp.count = ntohl(net.count);
> +	temp.count = smc_cdc_clamp_count(ntohl(net.count), size);
>  	temp.wrap = ntohs(net.wrap);
>  	if ((old.wrap > temp.wrap) && temp.wrap)
>  		return;
> @@ -246,8 +264,10 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	local->len = peer->len;
>  	local->seqno = ntohs(peer->seqno);
>  	local->token = ntohl(peer->token);
> -	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
> -	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
> +	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
> +			       conn->rmb_desc->len);
> +	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn,
> +			       conn->peer_rmbe_size);
>  	local->prod_flags = peer->prod_flags;
>  	local->conn_state_flags = peer->conn_state_flags;
>  }
> @@ -259,11 +279,13 @@ static inline void smcd_cdc_msg_to_host(struct smc_host_cdc_msg *local,
>  	union smc_host_cursor temp;
>  
>  	temp.wrap = peer->prod.wrap;
> -	temp.count = peer->prod.count;
> +	temp.count = smc_cdc_clamp_count(peer->prod.count,
> +					 conn->rmb_desc->len);
>  	smc_curs_copy(&local->prod, &temp, conn);
>  
>  	temp.wrap = peer->cons.wrap;
> -	temp.count = peer->cons.count;
> +	temp.count = smc_cdc_clamp_count(peer->cons.count,
> +					 conn->peer_rmbe_size);
>  	smc_curs_copy(&local->cons, &temp, conn);
>  	local->prod_flags = peer->cons.prod_flags;
>  	local->conn_state_flags = peer->cons.conn_state_flags;

