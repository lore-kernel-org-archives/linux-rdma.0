Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CEB29A31C;
	Fri, 14 Aug 2026 06:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786687490; cv=none; b=hCb6ZEjPM+K5xd+oV3cV5zTTQQbjLq/Yf1tkaI5WegFIdcJC3VBpWkE6FvzLXdP9gXPpntzpbVdB0CqVqisCKfz4OPYybph/r76eDaA9KcffS9B4QM/+0D76jU1Ng2DB96QN7gjxhriWeMFD0P5o7C0lwtG4lVw7AXKCATNkvxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786687490; c=relaxed/simple;
	bh=no5Uk7Q4ogKCUrnwrK3tp4xLlJmcMOvzpUg6zRswpes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6/4u1bGwwYGtrEt4nEQdl9eMkBG1C7hRFRTctfJ4hnSM8ZGE8OU2tfILxWP/06SpfEBO2iEogUIAbUROcxEsFMyAvBmz4VyNPEgWiV/aJZGxoOSxzKgs16Ppf2K9zoYLh8QeNtN8tySdNcPMsHKY/fMFCbbZPKhwSJj9uWlVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TY5szi3X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TY5szi3X"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E4VutW2471746;
	Fri, 14 Aug 2026 06:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=csWaWw
	UIKMkt81dagcRhcS1YLE8meVrGpJbBaAMDyhY=; b=TY5szi3XIbCAXbgdsCaq8J
	CLA9j5+H8CKxY0jqMa4WJRiyoJxuF+1brpT8VI4z+4rLGyQMFy298DqRljTyb+AR
	V5+zP0IBibCo6/Wn2FcwLw+JBx7knB/c/lSv1UQpnHrjWzZJ245H1dN0+hYZAlKA
	3YHgiyTvWl+43nTz3KbvFfmNjIe5g+X4a/InpCQeNvMw0xXxCWpG9EYIfzxzRdgt
	BCb2IRFKLwTqbVv2XH/gzoIfWLefkIlM8NpYtsOFVbrOmKyQbjW7D/N8Bk2g+JE/
	PulgRNvPrk9gxdnONvsK1ZbN23idb/v3wb6d7fOnQTXGfDMRpeH8Rt9KXIDsf9OQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvk0bdp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:04:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67E5uI8H025310;
	Fri, 14 Aug 2026 06:04:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqe97r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:04:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67E64TZE38535512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 06:04:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F2DD2004B;
	Fri, 14 Aug 2026 06:04:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F27020043;
	Fri, 14 Aug 2026 06:04:26 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 06:04:26 +0000 (GMT)
Message-ID: <86298632-1324-49f0-b952-0db50b4a5e87@linux.ibm.com>
Date: Fri, 14 Aug 2026 11:34:25 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
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
 <20260723-b4-disp-0d07164f-v5-3-6a9e235dbc4e@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260723-b4-disp-0d07164f-v5-3-6a9e235dbc4e@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfX84HO/oXWbTuq
 8Lg8am8CyZXe+Yxazc2kkaOyS194fbQSzajKP31y+wr4XywkxQoK8JCdCaxLjHskPePTfHzVk61
 qUdUDFypuuOP7WzbGvXVoqCXI7KnJy5T2fPtX/vq75T4+4W5Jze8xx5FI0zKtCyIW9Qs22csLj0
 BO+YO56nrp5axPc/GroYOBNKouvrxS8IUWaE9q0wTPX6gObLN4aojXZDJGb0/FyIaJMtWjXLptX
 qCXhskhliYHkXSl/YKcvVLFYyclX4QXU0SwFt+/X9/EE1QjTFoC6ThIkShyNJLOfuFht9VBbwgr
 Y9fVNq6BOLNWq/1B0so0QxtnP0tfm57JSPO4mJDNtsRKEro63FQv/OjcAl3RSaikVBRq5c1CPCS
 yeKVv0XpTPy5uHAr1PtmNLohdqyaO16UjZUS4BCunC7OUJ8vT3ns/TzsZcJg+mVRV+afThg4cMd
 g1MWAhyCtMJwWgGLPQg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfX/K24KgMFNcIl
 p1UMAZRLDw40+veCg1disoEKWWc1w85Ao7bciMMhnc8VQhZlMfYh5F9WIMKLmW421vLpUQ4N/Qo
 plzCZbRA8y84kVF1fPLEVWZkcyYgIEQ=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a7eaff4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=vqei2IpvL71RVgCJUYIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: rJmk7d3J4ZCttQckaXLZWKpep5Pe2pyR
X-Proofpoint-ORIG-GUID: paqyA2fX5yUiziS_m9RwL5QntnnwrzbL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140045



On 24/07/26 5:53 am, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> On the SMC-D DMB-merge (nocopy) path, smc_cdc_msg_recv_action()
> advances conn->sndbuf_space from the peer's wire-controlled consumer
> cursor via smc_curs_diff(), which can return more than sndbuf_desc->len;
> a forged cursor drives sndbuf_space past the send buffer, and over many
> CDC messages overflows the signed counter negative. smc_tx_sendmsg()
> reads it as the write space and does a wrap-around copy whose second
> chunk is not re-bounded to sndbuf_desc->len, spilling the local
> sender's outbound data past the send buffer at a peer-controlled
> length: a heap out-of-bounds write. The nearby len > sndbuf_desc->len
> test only feeds SMC_STAT_RMB_TX_SIZE_SMALL on the user length; it does
> not bound the copy.
> 
> Bound the write space to sndbuf_desc->len at the consumer, treating a
> negative (sign-overflowed) value as out of range too, so the copy can
> never exceed the ring. This enforces the documented
> 0 <= sndbuf_space <= sndbuf_desc->len invariant where it is race-free
> against the CDC tasklet; conforming peers are unaffected.
> 
> Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_tx.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> index 3144b4b1fe29..5916f02060fb 100644
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c
> @@ -233,6 +233,19 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace = atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space is advanced from the peer's wire-controlled
> +		 * consumer cursor on the SMC-D DMB-merge path; a forged cursor
> +		 * can inflate it past the send buffer, or overflow the signed
> +		 * accumulator to a negative value across many CDC messages
> +		 * (which a plain "> len" check would miss before the size_t
> +		 * cast below turns it huge).  Bound it to the send buffer in
> +		 * either case so the wrap-around write cannot run past
> +		 * sndbuf_desc->len.  This enforces the documented
> +		 * 0 <= sndbuf_space <= sndbuf_desc->len invariant at the
> +		 * producer, race-free against the CDC tasklet.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace = conn->sndbuf_desc->len;
>  		/* not more than what user space asked for */
>  		copylen = min_t(size_t, send_remaining, writespace);
>  		/* determine start of sndbuf */
> 

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
