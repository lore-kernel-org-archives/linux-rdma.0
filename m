Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A260314B95;
	Fri, 14 Aug 2026 06:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786687465; cv=none; b=Ja/WDZv2AwQNzOXBgnIa+n3fkrbJFSf7WX7y6jKrsN/B5z5agoDoyeA+Qxx4UYWPXe/hRaV2nwsX1ashoeXJSDWdyBnVAC4Zyi/hBj3n40SZa6AJJk9kONCapkGqb0Iwbgx8dU8zzqFBchnxW/mwaZEYYHIeK8ULZCKNBXGNObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786687465; c=relaxed/simple;
	bh=4QwCK+2+R0mCEEKjLN+FFC5zRKkuMoIOIFZRJtxJ5YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJTUYOp+Ny6a9MTaz4lJYIul78FbFDote1j7yN8uEhMn7y3vf8VJuU84O/uZj78abSXtbra2qZNXaIVBz5o85hy/+6qcMb/Pn2zZEd7TpMDHJ0o6jWZC5IHvsBCFEaO7vWyDH9IEutMCH7mtwyeSSTRkn3XpGbk/qs4R+hvczAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SEqoVnEt; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SEqoVnEt"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E4VkFW2471512;
	Fri, 14 Aug 2026 06:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lfU23O
	CC/cjK3OOW8Ub2ZtJQ/HCw2ewM6+zIqddGUvI=; b=SEqoVnEtSjAV/ND2qa9kqg
	vBKCkrkRQh+63vbS/rRRIXaffmsJuB+IBKlXpl4UbCKo95XyklcUiVYkqB6+9fNf
	70eDk3jlT+/sAEeggMYr/6LkRbJnNfsENTiG0i/Hie7Ovp/rp1RDtZtbUmpGXNWi
	MnV9rGjuNl+MxZqO6vwH3uil11JshyAPyABxzG+e2jx3oUOF+hHj6HcrHuNKgRKh
	2thh75zhgglDTWqdu/vzrUpD+6L1X6ovAzEUvSbIrj5QIsJ+JTHFczDD4j6IypyR
	IlOTcaF3EP5XagvCah+HoguiqTC7bX1AosNNuVCQ+O3h5OcpExRV2IsYtsEkZvTQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvk0bdmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:04:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67E5uftl025909;
	Fri, 14 Aug 2026 06:04:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqe95n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 06:04:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67E644mp39256370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 06:04:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BB0320040;
	Fri, 14 Aug 2026 06:04:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE5552004E;
	Fri, 14 Aug 2026 06:04:00 +0000 (GMT)
Received: from [9.123.7.41] (unknown [9.123.7.41])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 06:04:00 +0000 (GMT)
Message-ID: <d4c60f1e-c731-44d9-be78-31695dcd19ee@linux.ibm.com>
Date: Fri, 14 Aug 2026 11:33:59 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 2/3] net/smc: bound the receive length to the RMB
 in smc_rx_recvmsg()
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
 <20260723-b4-disp-0d07164f-v5-2-6a9e235dbc4e@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260723-b4-disp-0d07164f-v5-2-6a9e235dbc4e@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfX/5UXxC1JWJvS
 6R/FRwmZbp9GuLBmkMg3c6KfeSXvb0/kBB1c0dP2fvFlEGfR1CGaJKJvWNaUWRgJMHcvZnhAJSK
 aRPTo/ceMaUz4JahERDmuWxDiQ8YcZ1tnZn8YB0c4xfWOdJAQZa3pp1171Pa4A6/4Lf1X9B9xFs
 +Qm19zuAAht6dNsviqroUgDUr+UJhQggjdcpL6qsCQYqYtFcNveFY+ND62jijixt3SAG34W61eF
 sFcpyvb9pI8NJNteMDE6iAxE7UctCQ7FxrSQV+4cRfobqtfg87wk5npC3mkY+tEIpeHHyjwNoCp
 yC73lvgr2ICjN9gIspOYICTXwn9dd4rEHkYImuz8Y8BC1eHG2bXcop/VhTZEm6TEgm5vnuc9usM
 60igC45pBh2XWQjFznudim9Um5lSPN0qoHvAfM73VKabe4xeq5kjpmQoDWplTIaV0vuZSteUr1e
 nNcL2Jfs06sEMxqjQIQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA0NSBTYWx0ZWRfX8kti6ixc/q6S
 aGn+lIS6vl/he7nLkcxOpSi8L1MbPy1YwIKJaibPvyZtQkwS/JjvbyOiWrOwsOGBoXiyUUdSOD/
 QhvbHnc0Yz5DLjyLs7w4kr2qZSclF24=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a7eafda cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=SRrdq9N9AAAA:8 a=VnNF1IyMAAAA:8 a=8faO1vT75ZJaWqpTyZgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 85dQN9MRRDkXioPCyKa0MDvjx8HSnRFU
X-Proofpoint-ORIG-GUID: nFeZIczXxlk4Og3tNpbw_VSmBoEEDQRC
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
> conn->bytes_to_rcv is accumulated in the receive tasklet from the
> peer's wire-controlled producer cursor via smc_curs_diff(), whose
> differing-wrap branch can exceed rmb_desc->len; a forged cursor drives
> bytes_to_rcv past the RMB, and over many CDC messages overflows the
> signed counter negative. smc_rx_recvmsg() reads it as the readable
> length and does a wrap-around copy whose second chunk is not re-bounded
> to rmb_desc->len, reading past the RMB into adjacent kernel memory and
> disclosing it to the peer. The nearby readable >= rmb_desc->len test
> only feeds SMC_STAT_RMB_RX_FULL on a separate earlier read; it does not
> bound the copy.
> 
> Bound the readable length to rmb_desc->len at the consumer, treating a
> negative (sign-overflowed) value as out of range too, so the copy can
> never exceed the ring. This enforces the documented
> 0 <= bytes_to_rcv <= rmb_desc->len invariant where it is race-free
> against the producer update in the tasklet; conforming peers are
> unaffected.
> 
> Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_rx.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index c1d9b923938d..f461cf10b085 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -442,6 +442,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after waiting on data above */
>  		readable = smc_rx_data_available(conn, peeked_bytes);
> +		/* bytes_to_rcv is accumulated from the peer's wire-controlled
> +		 * producer cursor; a forged cursor can drive it past the RMB,
> +		 * or overflow the signed accumulator to a negative value across
> +		 * many CDC messages (which a plain "> len" check would miss
> +		 * before the size_t cast below turns it huge).  Bound it to the
> +		 * RMB in either case so the wrap-around copy cannot run past
> +		 * rmb_desc->len.  This enforces the documented
> +		 * 0 <= bytes_to_rcv <= rmb_desc->len invariant at the consumer,
> +		 * race-free against the producer update in the receive tasklet.
> +		 */
> +		if (readable < 0 || readable > conn->rmb_desc->len)
> +			readable = conn->rmb_desc->len;
>  		splbytes = atomic_read(&conn->splice_pending);
>  		if (!readable || (msg && splbytes)) {
>  			if (splbytes)
> 

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
