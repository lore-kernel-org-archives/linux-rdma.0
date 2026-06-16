Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962163A1E69;
	Tue, 16 Jun 2026 14:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620047; cv=none; b=BpOK4rvl1xVDwTC/8EIuN7XTjqjvyLkbnq9tMJcRVQms3WsSztbpfNmJMbQKMBJh+XZf+LZ5AMTQScQtBnwLoP6pKmWw0z0nVWJyhfjsXFaTdoTXabmlkZdncQ2bU8MDTgg0BgXWiXPkN9jeV7GiA+igk1y2tfEJyCkQcdLsitU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620047; c=relaxed/simple;
	bh=1TEa1AEWrpo5vlROCNgvTad5PWUPE/qQn8wASMr7nCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYFlxNNljk3OgAb7QSfXwHQsEnK8NOzoBm9Mffvs1wKCnzBXvzLYzZnlbgkNnrnYVtc90cYZhrVnI7ULvtkRHeqyqLq/Zm6NktxUAlXfDhBAQZUBGK0tkizThOcEqnx2N9AJzu2UU4kqUfw70KZUOObfbQRa4RfRSDdtXX/g8TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aRI6qfEo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aRI6qfEo"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GEICjj1763843;
	Tue, 16 Jun 2026 14:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IjuEIJ
	SriwuP01r/+rNqGP9V1B2LCAw9Xpaog56O+38=; b=aRI6qfEoXL+uBKVIlvR1P+
	DUjnck+WtmfRzEYpFdxNSPPozP25iDNI9i13sKCum7JQbawWmYMynlD0LY3VgFHn
	/gIWOHDgzEzjXATGUcaePVXKCOxaXSyqmOAF6T7S4qSoZ2irSv49lHGlWi+VygOe
	VcB9jBZdFUxz1uYJ78unQtBJz/z5abIgfMSv9/kopVLFUsSGonR+pyxn8CRKBbxr
	CS7J8Lw2uFqokAegqewYMOo1XFHJS1Twfik4nvGw1L1eSPdUsgTppXtu/ruCT6rE
	MQ5McqFS34VBh3qh3dbheMvlr/6um28nY7GXzxf0lV61jGD59LURWoVRCnmKIGdw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es23np4ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 14:27:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GEJd7C032673;
	Tue, 16 Jun 2026 14:27:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eshhq3x7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 14:27:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65GER6OE23593388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 14:27:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04EFA20043;
	Tue, 16 Jun 2026 14:27:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0205F20040;
	Tue, 16 Jun 2026 14:27:02 +0000 (GMT)
Received: from [9.39.16.33] (unknown [9.39.16.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jun 2026 14:27:01 +0000 (GMT)
Message-ID: <430a9dd9-ecfb-4465-9eeb-f854fbbc2e61@linux.ibm.com>
Date: Tue, 16 Jun 2026 19:57:00 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/1] net: smc: fix splice entry lifetime imbalance in
 smc_rx_splice
To: Ren Wei <n05ec@lzu.edu.cn>, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, wenjia@linux.ibm.com,
        mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, ubraun@linux.ibm.com,
        stefan.raspl@linux.ibm.com, davem@davemloft.net, yuantan098@gmail.com,
        zcliangcn@gmail.com, bird@lzu.edu.cn, lx24@stu.ynu.edu.cn,
        d4n.for.sec@gmail.com
References: <cover.1781097957.git.d4n.for.sec@gmail.com>
 <192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <192d1b44ed358ca143f44ef167d14153bccc51e9.1781097957.git.d4n.for.sec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XtnK/1F9 c=1 sm=1 tr=0 ts=6a315d41 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=lELoO6ydEwu01aG-FtUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE0NSBTYWx0ZWRfX3aLGkuxzoGY9
 nQ8con6vPfodRZHjAhAtq7B5aqdrNqZ/zW0qc9cTwUNyO7feqwS+u93GPdt1URw8RBaxXpOj7Fr
 X5L5sNG0uOvsEdMNpEHhj4AM9/jzwfR9FqMoCMa9ERnTStuqGDTDH2qa7X9zK/rSmMeKuqeG+Yd
 5SjnfYqRcbTsjn45nFVFAKULD9xAYG2xLe1yS27cjqDHy69YatG5RNatTXs0/hrgChj4oITUF6w
 3v8FqzTVHQ8nRpMef9lvHqBBN2Y9y4s7PqsC42x0eUwWBLZqAZkV8YHKsnTKmgqHtKMZ+LglcxH
 tYXEtfqj1XiWDUbv0+K8bhv7FK/k6gAVU3Y9lttrfrAVjrDaCvd2fWmUa8lb5o6u58vVSQM5jCb
 OLw6EhPzkZfPh35xxOAWH0+U+fxRN+1Nt0SahssZRagPtrnSjWWHgpdQrMsIIaxURF1Qq46iasi
 zfnpjx4SqoLS2ZfwKjA==
X-Proofpoint-GUID: c0J0dIn_JX-poNTUfy1y4PPQMiLBYcKK
X-Proofpoint-ORIG-GUID: 34lRAMndiN_j3wEzws5yH02GX2zEQfeh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE0NSBTYWx0ZWRfX3rX96ezEwEg0
 ilxy5r6FKDjUmNWIbHrN5zKu99LrCKOY6GjYuY4WsN1epbalw0P14BA6EP8OBjj7uUIFPdQ2Bsk
 hwc90HB8XsyAYAYu3aOpu4NKPTAtOgo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160145



On 10/06/26 11:24 pm, Ren Wei wrote:
> From: Daming Li <d4n.for.sec@gmail.com>
> 
> smc_rx_splice() hands candidate pages to splice_to_pipe() without taking
> references for the lifetime of each splice entry first. That breaks the
> splice ownership contract in the VM-backed RMB path.
> 
> splice_to_pipe() drops unqueued entries through spd_release(), while
> queued entries are later dropped through the pipe buffer release
> callback. The current code only tries to take page references after the
> splice succeeds, and it derives the number of queued VM pages from a
> mutated offset value. This can underflow page refcounts and trigger a
> use-after-free. It also leaves the socket lifetime imbalanced in the
> multi-page VM case, where one sock_hold() can be followed by multiple
> sock_put() calls.
> 
> Fix this by taking the page and socket references for every candidate
> splice entry before calling splice_to_pipe(), and by releasing the
> matching private state, page reference, and socket reference from
> smc_rx_spd_release() for entries that never get queued. This makes the
> SMC splice path follow the normal splice lifetime rules and removes the
> broken post-splice VM page counting entirely.
> 
> Fixes: 9014db202cb7 ("smc: add support for splice()")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: Codex:GPT-5.4
> Co-developed-by: Liu Xiao <lx24@stu.ynu.edu.cn>
> Signed-off-by: Liu Xiao <lx24@stu.ynu.edu.cn>
> Signed-off-by: Daming Li <d4n.for.sec@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  net/smc/smc_rx.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index c1d9b923938d..88aee0d93597 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -150,18 +150,23 @@ static const struct pipe_buf_operations smc_pipe_ops = {
>  static void smc_rx_spd_release(struct splice_pipe_desc *spd,
>  			       unsigned int i)
>  {
> +	struct smc_spd_priv *priv = (struct smc_spd_priv *)spd->partial[i].private;
> +	struct sock *sk = &priv->smc->sk;
> +
> +	kfree(priv);
>  	put_page(spd->pages[i]);
> +	sock_put(sk);
>  }
>  
>  static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
>  			 struct smc_sock *smc)
>  {
>  	struct smc_link_group *lgr = smc->conn.lgr;
> -	int offset = offset_in_page(src);
>  	struct partial_page *partial;
>  	struct splice_pipe_desc spd;
>  	struct smc_spd_priv **priv;
>  	struct page **pages;
> +	int offset = offset_in_page(src);
>  	int bytes, nr_pages;
>  	int i;
>  
> @@ -209,6 +214,10 @@ static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
>  			offset = 0;
>  		}
>  	}
> +	for (i = 0; i < nr_pages; i++) {
> +		get_page(pages[i]);
> +		sock_hold(&smc->sk);
> +	}
>  	spd.nr_pages_max = nr_pages;
>  	spd.nr_pages = nr_pages;
>  	spd.pages = pages;
> @@ -217,16 +226,8 @@ static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
>  	spd.spd_release = smc_rx_spd_release;
>  
>  	bytes = splice_to_pipe(pipe, &spd);
> -	if (bytes > 0) {
> -		sock_hold(&smc->sk);
> -		if (!lgr->is_smcd && smc->conn.rmb_desc->is_vm) {
> -			for (i = 0; i < PAGE_ALIGN(bytes + offset) / PAGE_SIZE; i++)
> -				get_page(pages[i]);
> -		} else {
> -			get_page(smc->conn.rmb_desc->pages);
> -		}
> +	if (bytes > 0)
>  		atomic_add(bytes, &smc->conn.splice_pending);
> -	}
>  	kfree(priv);
>  	kfree(partial);
>  	kfree(pages);
Code changes looks good to me.
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
