Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590501;
	b=zWMcA2pw7ayF1O+hLLIrou5RRdp/tVIiO1a0bgLH9inIn9EgOTuXPXyOx9jgazNEv5hv
	 usXrd2M8Cppnt22GNT7v50O3A+rq3NeOZYPnrnrFQuBdHCNAMojeGiLvkJcSPwEF2hIly
	 vrGCuGvjhwm5hY+KX+y35/gX88divsuSNb1TazckR0JrX8u4u51oOwHAEnIxBzrN+Q4+6
	 +UAeJFxR7yvzAWB1kvcWVFMf0aNgmH9+gm0WoFu4D8eOamZ1/MPs57NEoot+nZXbG348m
	 jIEtzxcX+d/KBC7LYbFcu/7aMTzumV6EDlnA0s8C8eQNRxLrqIP0tkNHUhfpcdfEq5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590501;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VymGh2xt1PlXFV+8vSa2twLhEcdpkPLNVW7EDDd1FJM=;
	b=KgMGte4EKgw2x8oyZa1m3ZjlQ48kLZxsdxMVbq8DsW3qfir1fKv/AyLLZmzc2kjCbvgJ
	 hjPbJrXaVc3A3fd2RfMnIE+7gjxa+CHacfUBP0HVhMiwDodb4t12KdF9rLfJNAFH6VieL
	 e6JbLsZeU/myQZ7UeFxV31B8iuvjAmzrgjOv65mm3oNTpFIMJ3cktDM/tCegCB4YUvTeB
	 fN8FxOe6CDFBTpeXcz/lvxJ2l8nsFBKUZxXg7+vociMmNUJhtpCvXI5KDdPmhh+qtY3PZ
	 mydGx+Js6vtcN6umx4k6udrb4fKKxAJJRU3UKKzW5xwSuLZJqsmhB515t1I5YE66FcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FQCk9SPm;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBD2606A321;
	Wed, 25 Nov 2026 07:08:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFBD2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FQCk9SPm
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP6YY8V687807;
	Wed, 25 Nov 2026 07:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VymGh2
	xt1PlXFV+8vSa2twLhEcdpkPLNVW7EDDd1FJM=; b=FQCk9SPmU4wn1EnuGwwp7q
	nsmyntmnozjKlxyZxZoelA1r5ZpKxY84ceLQzXR9uGQN23uuJzhzprAEPro/mmq2
	GvfxeyIpykvcC8qDcYqOO/cSVCKqvVPTM1Bwr0OY2G1NUptxE1jOr24mNbS27fEb
	SWJOxACotKmFz6Gr4bP3TxZDZ7fSKM7C8BulV4ZcqILxaRy9UhfHlCkK683RU4xo
	SQfWl6BHrhr8t/C/8+aDEh72eJx1Uhrcm/j2NzxkXDTYlfX6KXF4MyZFTZI38juU
	iuXHGpEXdXlb+/ozoUqYo5EWV4ll48P6V0xkvWQAXrNtbxKrjc7dtwKHaO7XUJLw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fab9jv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 07:08:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP6JLIB3429557;
	Wed, 25 Nov 2026 07:08:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfa1814-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Nov 2026 07:08:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AP7800b52494668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 07:08:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C81E20043;
	Wed, 25 Nov 2026 07:08:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24BB120040;
	Wed, 25 Nov 2026 07:07:57 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Nov 2026 07:07:56 +0000 (GMT)
Message-ID: <053512bb-0a86-4902-8a3e-79ceff20bcac@linux.ibm.com>
Date: Wed, 25 Nov 2026 12:37:56 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: fix sock reference leak on abort_work cancel
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
References: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261124073602.2341904-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAyOCBTYWx0ZWRfX6SERPZcenYYp
 GaRcyNicKCQqvcKSk++jH/J4T4CHAZeoM9BupXfJeKsf1GYNkijx3kyffHky4p1qgfsPH2HrLsO
 B0lXicVgemz1pdHlcljuk8RsxaFkcziCsyVewgQHzUJp/Y4GRZaHMKEF6NWx9ln0n+ee6JnaMQU
 dE8o5vmxDSGYLqBJdkpdZh55tLu0348ZztFnuuffF3+eIxDt94HJD+bhk5nr6uvhlXAekx9E+ju
 kjENIJ5IZVr9H/3RH+7RfJFPjaBJc/yNGNHlqLQMspIY/6KwjHge/98tvXWhqu+oPmlv9BTTEts
 HVyzhIvE2i8SS7apOr2vQm4s24svE0hOUGk+OcEYIhkL4nuFCeeTLhG9UrYHFBYil/M3h4VHq6b
 81UHyvzxWr58kw5KFn7FPrk4voCMbGG1ptuvDtuMbXnrYUtYZ/Y6JR8eN5W6k8lwb9wvDYexSgP
 I8ikhsFz5YeyIkuMuyw==
X-Proofpoint-ORIG-GUID: jvSgGNJ-DLXDb-hHbq137MwhvRGCdofC
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b068955 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=9a-4vhIoUcUKDQ7W_AIA:9 a=QEXdDO2ut3YA:10
 a=zY0JdQc1-4EAyPf5TuXT:22
X-Proofpoint-GUID: 4-R3wwfbccyKmlCIz0foSPTXquLZ8SFL
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAyOCBTYWx0ZWRfXy/rN2RoNFInB
 NAlKWG0Pq8u0lrAGQCe5pkaVeDjKsl+qNtLZoIbflk8p3I71paRIUdcuix01ORuCLOj1rsa7QNF
 ayLyhid0qc0dWeDOewAL7OGT90G43gE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_02,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611250028



On 24/11/26 1:06 pm, Mahanta Jambigi wrote:
> smc_cdc_msg_validate() takes a reference on the socket before queueing
> conn->abort_work, and smc_conn_abort_work() drops it when it runs. When
> smc_conn_free() cancels the work while it is still pending, for example
> because a close races with a failed CDC validation, the handler never
> runs and the reference is leaked, so the SMC socket is never freed.
> 
> Drop the reference when cancel_work_sync() reports that it cancelled a
> pending work.
> 
> Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> ---
>  net/smc/smc_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c142..3c08be976de2 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1276,6 +1276,7 @@ static void smc_buf_unuse(struct smc_connection *conn,
>  /* remove a finished connection from its link group */
>  void smc_conn_free(struct smc_connection *conn)
>  {
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>  	struct smc_link_group *lgr = conn->lgr;
> 
>  	if (!lgr || conn->freed)
> @@ -1298,8 +1299,9 @@ void smc_conn_free(struct smc_connection *conn)
>  			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
> -		if (current_work() != &conn->abort_work)
> -			cancel_work_sync(&conn->abort_work);
> +		if (current_work() != &conn->abort_work &&
> +		    cancel_work_sync(&conn->abort_work))
> +			sock_put(&smc->sk);
>  	}
>  	/* The handshake can retry another device or SMC version with this
>  	 * connection, so it must never stay registered in an lgr it left.
> --
> 2.50.1 (Apple Git-155)
> 
> 

Worth looking into the bot's discovery/validation point.
Patch looks good to me.
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>

