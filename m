Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071334;
	b=Gz6pq7hRSOcEVPdUxe9a5E2VAV/N8O0ZnovykuaawBb/ZjG0wbqTfiMdarpTv2fyCabc
	 A3T4FLLxyZSotzNkqeMFmE4mi0L3kSD7dvZ2JBiJFV2cqMUu4lJnP20rgMWOL0zmXf89A
	 slt/VbPXyfbYhVaDT/jvAh7XRcnKQuzmt7PlgngEaWgP2tSFX3qqKT6ayzgElqpvPiyGY
	 xaRTso2UJ6UwYCUnQWCDLsjMqxT3OZCkEu1QPDolE0HI6K7Shrtq5XP1mVOuYJiELVddA
	 zeymo3kBxGGbY34u3c+mP/yLaX0JB1fbiqotIY0ok1UmeGH5J/CZ6sDKzpC1Rxq26+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071334;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=XbDJzxeN+JXqSFrGp8mU9y6ks2MbNG7YtB3q5fkM8/o=;
	b=oxzanH1WYOq5QF64jB/TUPUtz0KNOaiQBWzRKP8kJL0+n55MjAPppmLrKsW6HMRivYnJ
	 7fIpR0uXbuXQupKUQyc5oqh/jj1U1L/yrs7Ewg0aubwJFEDqec68w2Y3Bn9j7kSC+vNuD
	 XoUraFyB9vPT8tjWpYNikFZ2cyDwWr8jwaMkOyTzpU/HqYyZ1xHsQwaK3Nap9IwigOa99
	 7j2dLbm3gOPsjnE17XFCa2swMN5ve6IgJZnnXpB/M4ij9VUT5/LbB+K90r7m0cFuhO6nK
	 ANTunHWvMY34eTLWyZ6iF9MIuxoAiROQe11QLsAAUnBkbE+MesqJ6cCiATW0H9fFMoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=RVZdRj2f;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4E606A320;
	Thu, 19 Nov 2026 06:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFF4E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=RVZdRj2f
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ4j5pt3147934;
	Thu, 19 Nov 2026 06:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XbDJzx
	eN+JXqSFrGp8mU9y6ks2MbNG7YtB3q5fkM8/o=; b=RVZdRj2f58Xk0W3GmRtV5t
	+Vpq8kxOC8Li2NFimKWf7P5eXRDLizn43GP9edZUsku+YG+bt2kcw9VgF6NqqRfJ
	ZNL22xg0SFMI0R9gfiLDlQpTJ9Ny1JwZEcxfXBYQedrzw2+gwOLLMbOfbpTtIqgS
	qdmM4wZCwsvci7AMUGNJydOOEbbDVZCVO2RuLu9O3Ry3JVFMvNyWv9lWD2TL/VVJ
	vPl8Vfh+P2h1pSTDKXQK0jxB5bghVlYltaUQXnW+SK9mEfJBtAaWXtTDWXJIaEfJ
	WaLZCdwmzvbe7XRlGx5E1BmrFQ5FQeE1Z74B72WYnhKB+yUXvJ8Tla86b9s9yxcg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105wxwjx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 06:55:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ50AZU1755313;
	Thu, 19 Nov 2026 06:55:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j067nkqk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 06:55:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AJ6tGAe17301896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Nov 2026 06:55:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65C272004D;
	Thu, 19 Nov 2026 06:55:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2ED5320040;
	Thu, 19 Nov 2026 06:55:13 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Nov 2026 06:55:12 +0000 (GMT)
Message-ID: <3b16c6c2-7bf1-4261-9c0c-abc56aa6d608@linux.ibm.com>
Date: Thu, 19 Nov 2026 12:25:12 +0530
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
Subject: Re: [PATCH net v2 2/2] net/smc: do not reuse the DMB of a nocopy
 device
To: hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
 <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: Jrsp9cMQGDq1x2E6UhwsDWWMka3-uSY5
X-Proofpoint-GUID: myVQCLeObe6D_KCi4D2MoDVKUKxZGTnC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAyNSBTYWx0ZWRfX2ad03N6qxzjK
 LbjSAnbuiDcfL8l+k/2ZujWjTNvu9O/KJ+fZP09Rz+rEhm02D3OA2EqWOfTMOJaMzq4IFjB/gx6
 /DxFpdLFzANH356wxCEhJU/+ab/GCttWyuJYUtHAZrAWEkZrmMQJl/nq0B+82x64aDlmX0SgWTh
 pi6YEG+GBETkqsefaDeearX8qJ1bfKsWo4SqrfYDaSYlxn/YhdC4eqGY01xGbBZbAaBBx6xrbi6
 7WFchevCHqlH++TN8AK6Iq7dc8xk8hPUSFA1sP34ZebAhjiEFq7xd5lfgvW8fSf1oBGDrKunC8s
 QnuxCck7xgkwu0VYzOq8PL7ZdnFbgIiqm6/Ca60mQoOk7K4OqQiJYhB4hCSU+TefsM9/cif2sJk
 CPkRG3/Cx3DJj1aehD7ev6mKTUngdORXGqFY299TzH2Xgviy6eS717Llfr0lVJLelvAlG8r7fjh
 C9J1+BjZcQbuqTrMLsw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAyNSBTYWx0ZWRfX9FYr9cz2hPt2
 OeNFi2EJYeD12+kuUfYdCacg9FBB+DYkttBizbub7ssV2DUYwUROQMsJ9ixTmCoBoYWbay5FaFl
 M9HBbC2dZmBqRgbTIcaICo2mXWT6lt8=
X-Authority-Analysis: v=2.4 cv=K+m3jCWI c=1 sm=1 tr=0 ts=6afe9d59 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=A71DM1VK_zVggMTEpyYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1011 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611190025



On 15/11/26 12:39 am, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> With DMB nocopy (the dibs loopback device) the peer writes into the RMB
> through its own attachment, and it can attach late. smc_buf_unuse() puts
> the DMB back in the link group's pool with its token still registered
> while the old peer can still write to it: the next connection that takes
> it gets the old peer's CDCs, and a peer that attaches after the other
> end gave up lands in another connection's DMB.
> 
> Unregister a nocopy DMB when the connection ends instead of pooling it,
> including when smc_conn_free() finds the link group off its list and
> skips smc_buf_unuse(). The next connection gets a new DMB and token, a
> peer still attached keeps the old DMB until it detaches, and a later
> attach fails. Clear conn->rmb_desc, which a retried connect() would
> otherwise use after the free. Devices without nocopy keep their pool.
> 
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  net/smc/smc_core.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c142..6a673ce74937 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1243,6 +1243,22 @@ static void smcd_buf_detach(struct smc_connection *conn)
>  	kfree(buf_desc);
>  }
>  
> +/* With DMB nocopy the peer writes into the RMB through its own
> + * attachment, which can outlive this connection: unregister the DMB
> + * instead of pooling it, so the next connection gets a new one.
> + */
> +static void smcd_rmb_drop(struct smc_connection *conn,
> +			  struct smc_link_group *lgr)
> +{
> +	struct smc_buf_desc *rmb_desc = conn->rmb_desc;
> +
> +	down_write(&lgr->rmbs_lock);
> +	smc_lgr_buf_list_del(lgr, true, rmb_desc);
> +	up_write(&lgr->rmbs_lock);
> +	WRITE_ONCE(conn->rmb_desc, NULL);
> +	smc_buf_free(lgr, true, rmb_desc);
> +}
> +
>  static void smc_buf_unuse(struct smc_connection *conn,
>  			  struct smc_link_group *lgr)
>  {
> @@ -1266,8 +1282,13 @@ static void smc_buf_unuse(struct smc_connection *conn,
>  			smcr_buf_unuse(conn->rmb_desc, true, lgr);
>  		} else {
>  			bufsize += sizeof(struct smcd_cdc_msg);
> -			memzero_explicit(conn->rmb_desc->cpu_addr, bufsize);
> -			WRITE_ONCE(conn->rmb_desc->used, 0);
> +			if (smc_ism_support_dmb_nocopy(lgr->smcd)) {
> +				smcd_rmb_drop(conn, lgr);
> +			} else {
> +				memzero_explicit(conn->rmb_desc->cpu_addr,
> +						 bufsize);
> +				WRITE_ONCE(conn->rmb_desc->used, 0);
> +			}
>  		}
>  		SMC_STAT_RMB_SIZE(smc, is_smcd, true, false, bufsize);
>  	}
> @@ -1306,6 +1327,9 @@ void smc_conn_free(struct smc_connection *conn)
>  	 */
>  	if (!list_empty(&lgr->list))
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> +	else if (lgr->is_smcd && conn->rmb_desc &&
> +		 smc_ism_support_dmb_nocopy(lgr->smcd))
> +		smcd_rmb_drop(conn, lgr);
>  	smc_lgr_unregister_conn(conn);

I don't see what this branch buys us on this path. The link group is
already off its device list here, so no new connection can join it and
take the pooled DMB, and __smc_lgr_free_bufs() unregisters anything left
in lgr->rmbs[] at teardown anyway, neither race from the commit
message can happen on this path.
Beyond unregistering the DMB somewhat earlier, the only remaining
effect I see is the conn->rmb_desc clearing, justified by a "retried
connect()" that the commit message does not cite.
Could you point at the path that dereferences conn->rmb_desc after
smc_conn_free(), or drop the branch before it goes to stable?

Thanks,
Sidraya
>  
>  	if (!lgr->conns_num)
> 

