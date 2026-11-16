Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794850427;
	b=K7WI3ydmm7IeRKHLgkzmBX9gSeZBUHePO/CD9jlxV6FFHPK4s+deG+cjCt5Ndkx9+0aS
	 Lhs7/nIKoqhAit+8ghJRj0bfYGJbH1PCGof1+nAmg1k8AYx2tipAQZCw3dA4YTu4HlOgR
	 m7n2Bee+joZJT2NEyMTcCKh28VUGxAIYQb/FyMMfpNkQaB/9MIZw2UWLeL9XUAZEB7nEM
	 3IVWdjPZkQbJ3Gjf3LG+tFkFmZ4KkqI7LR8k8xDKl6EsFVx/CH7tPkmiykgFpE608P7Ci
	 ZkMEd6+wTCIc5DDlAlStzgiqkSeRpfeBtsyDVTG9A3lWZn5TXm7j9qVV7JH0VT1YmXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850427;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=wD/xDzn2jI7CsEgGWOahq5nyJwZ09hv/n/XJlVnPNHk=;
	b=t65W4Wlrl2Ewt3vdDHhC1vzO2ASbLv3oW+NvVIoG3Gqd2771WArkQAsQcxvLDjVaC1MB
	 PsmmTzftGoqvxCve7+fIsm5qYnD6GpN7qfpAOGq2UskQwrFOBlCRqJwDMZkWOhtK+Mr+y
	 8sZTPA4d+jBlLzfvC2KXOgBqsSh605MAGUzfC2fU1G0rRj+gMtB9nYO1lFjsthPhUJTcT
	 4Aq03TcEs1b+1c8UNR9qYDh0yvE7LejbYqqgsyvTFwU2l/cuVtfQQfh7V6BNCGdQpD9Ya
	 kwBCN7AEuPGmo7/SZfLFA0Q5+iCOQZCkB8/HhzLexI6vARxAcnCJMOXH4EQ5VeeTlEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NXS4DyYl;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476FD606A31C;
	Mon, 16 Nov 2026 17:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 476FD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NXS4DyYl
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGGQ7pf2536576;
	Mon, 16 Nov 2026 17:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wD/xDz
	n2jI7CsEgGWOahq5nyJwZ09hv/n/XJlVnPNHk=; b=NXS4DyYlxkXcHgeoVKyjau
	xLRLHmDGV5bpKJECci3n9h0YFnIsBWwQrLTuK3nlG5gMonKyYZ8MZntDDX1MfZRJ
	JgbSdIzVNJq5SeO+UEEfKWOUeH5ngkl+bVQ5eWFx+h9p4/wWwkqMzRmSNydqlON+
	5Q6ec+pD7ZiQ/ueCYzZkUmlqoII+iWlnoAqjbiZC2zWZyPnYy4Ld9boO7EQgwOoK
	+/FgKn73nop+AuhHDpiXZEmFDfbKMwrNkXUsCU7M4+QbOwGOf/A/SIVDNiJxGJPk
	R3uvYu55vp5C0EDNu/RB69jkK6sNsSLOIsSr+lJ/WrxQxmUCr6QZBOa+WMH7QVZg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxe2d68kk-980
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 17:33:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGC5AC2210607;
	Mon, 16 Nov 2026 15:29:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hyxwt0cyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:29:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGFSp7B46203166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 15:28:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31D7620043;
	Mon, 16 Nov 2026 15:28:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA1D120040;
	Mon, 16 Nov 2026 15:28:50 +0000 (GMT)
Received: from [9.68.31.53] (unknown [9.68.31.53])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Nov 2026 15:28:50 +0000 (GMT)
Message-ID: <0941abe1-9ecc-470b-a52d-e804fd125ac9@linux.ibm.com>
Date: Mon, 16 Nov 2026 16:28:50 +0100
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
Subject: Re: [PATCH net 1/2] dibs: loopback: reset the client id when the
 owner unregisters a DMB
To: hexlabsecurity@proton.me, Mahanta Jambigi <mjambigi@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller"
 <davem@davemloft.net>,
        Dust Li <dust.li@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>, linux-rdma@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>,
        netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
        linux-s390@vger.kernel.org
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
 <20261113-b4-disp-19244662-v1-1-39b256b70ca7@proton.me>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-19244662-v1-1-39b256b70ca7@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX4xg3aCi4BR0s
 AOM5gZM2nmFw56eCpdGr3WK58ePm9oY6ihQOboxviqK4wgQGjjQz+oaaR6LRGFTimZs6UHPZXc9
 G6x8zjUtqtSguRuu131dW3weK13onXs=
X-Proofpoint-GUID: rKqczh8Tr3VUsV0bVncyj8-yeyM-vQlc
X-Proofpoint-ORIG-GUID: -3MSq1Ohx6ABc1M3AOA5NxIsT9w7SBwA
X-Authority-Analysis: v=2.4 cv=IruL47/g c=1 sm=1 tr=0 ts=6afb3e72 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=Ogwv88QQDbgmfivA3BsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2OSBTYWx0ZWRfX9eTGEnI1Ke9S
 +bt+1AT3KDeF4aWdFx1IEc3HSVUdXE0DfNVMHT8+3pH0veueQFsNUmCpi+8OcGH8uOq9mOS4haA
 8AHnXzkbmwtyzZwjW/jkHLzSebITTGwEBbhdrpODXXAaJ+72fl35YYtsfSOgMkSEguSzPtk5d/z
 JgPjEtDnvm782+H3y4kYhjdw6uPY3UEKdPGDyao3rw/9EUBEivs/A1WLn8uPyiJrLlidN+gemmH
 8z39tzlqB7gSf5PCYPvIE/hEM2WtzLOCcKVmXQxCOyqLK66RdNqQM9zhm46AxDYtC3grcLjwXmX
 u2l7KIuf3HLc8nYlnlhIrE7KZ4X4utcusx27oaabc02zj8gbPd7KKzJbvAHL/7kqa1IexT2XbAX
 TJWaEIhHslzkH/bn8fF5yT3ggCbTPAIJdwtFAGQNbDjWcLeBD1D3sFNfTR4ykqtGw5Cr4qLvQd3
 KB9QA2VaDPKVfvjQmNA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160069



On 13.11.26 14:57, Bryam Vargas via B4 Relay wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> dibs_lo_unregister_dmb() resets the DMB's dmb_clientid_arr[] entry only
> on the last put. If an attacher still holds the DMB, as when an SMC link
> group is freed while a peer is still attached, the entry stays set after
> the attacher's dibs_lo_detach_dmb() frees the DMB.
> dibs_unregister_client() then warns at rmmod smc and returns -EBUSY,
> which smc_ism_exit() ignores: smc stays in clients[] and dibs->subs[],
> and a later dibs_dev_add() or dibs_dev_del() (rmmod dibs, ISM hotplug)
> calls into the unloaded module.
> 
> Reset the entry when the owner unregisters, before its put, as
> ism_unregister_dmb() does. The index stays allocated until the last put,
> and the attacher's writes no longer raise an interrupt for a client that
> gave the DMB up.
> 
> Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>
[...]

Thank you Bryam.
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>




