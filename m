Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104986;
	b=StqtATY0ScNdsVK6ltaTEFAlSzl5n612O62oT8vczoKJvDPyDx8mDryP2q85PbTfx3EV
	 NvcHtEhIh12UZpcEC5qU/2NInKZ/jn8SmU8VnAr6NvPdjwlBJBN/+/0iVCQO2yiKHsK67
	 UrPPfCOTxp2uFmsiMRyFZpZNYIl/mema8umIwlVWXINRczHCvtHETCh2m+o/8Jq3RvV5f
	 qgYOGxzbAzG1rt0GddTuOBljgG7qMx0olNRv2ngFavtjjLlY/WytxPCN1isghRv7XSzqO
	 I/02+Q6rOcDE2zJxEz/66MC1QAHdUucGmsQDsa5nOcCRf0VQM3WKNDcBtS6tH4Velhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104986;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cAYZtiD4RmUsJ181IMozOX2rIgNQJYDYOnyvHJ4wzu4=;
	b=reBPnekn+T7Y0Q/DpWR6lN4gdJp6ZwMJ39RL6Tw1C17BZ7nqHypiFu99KSnZ5faTXBvz
	 dVAhYh38Q84pjSXm0Nn+qxv+eeuccO6JAqOpKWZ+zCKAyiR38fLhrOk0SNyJfaNYWNByc
	 oFlXcqxLNSWneskr3rJRt66nbMmE7vFO8JtzDACtC8WeWMh4uwWTrXhVw9f7A1qW6z4ep
	 ZO3aCEw3enA9WqmTDKYhCqoV1xStneVlspzJmzVbvGqEkZGRiFMKqIUKaY5Q3fJzWPzBi
	 Yq2uIC7gFyYgFLk3W7WZh4T587+9ozJXmgC4XkoV8wGw6jyK8P58aIXyFj3y+uJN+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=KCHRdPaW;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE0606A31B;
	Tue, 27 Oct 2026 12:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91CE0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=KCHRdPaW
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R5i2181621752;
	Tue, 27 Oct 2026 12:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cAYZti
	D4RmUsJ181IMozOX2rIgNQJYDYOnyvHJ4wzu4=; b=KCHRdPaWX5r/TF4GqtN32U
	vB7wZ+ny+A9u1hYU4xJcmU8SqPSif4oBwjFg9BmItaYbCrNNJilf0iAeRz1y7enc
	TMy9IQAuqkk4CVWCqfHuM6x80AdvZ0sQHlZ0Nf20Ns1+zsg9+ZVTR+oHDV5mRWBH
	7T0NsSi4wtoiEmp73NMJj8sFL4VB/Bmrqa/hse2HmbK4yghbH8GQUFsGZ4WqBLfA
	YbRbnEg1XDTh4y2Nwom99wgXS8uUeXkdOqMt+dzbnfqVeY/jrVIDaQEgq1raMb9p
	VNE5B/wdB2AaD6ryrvdymW6DdPXK0IVxGMogL3k6XmTg5rqPPFPnNMfHExF6LnUQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgm63yd5k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 12:42:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69RAToEG3745276;
	Tue, 27 Oct 2026 12:42:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8gh2m9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Oct 2026 12:42:52 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69RCgmGu7995824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Oct 2026 12:42:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA8282004E;
	Tue, 27 Oct 2026 12:42:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 936A320040;
	Tue, 27 Oct 2026 12:42:48 +0000 (GMT)
Received: from [9.68.16.159] (unknown [9.68.16.159])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Oct 2026 12:42:48 +0000 (GMT)
Message-ID: <b15a3fe4-8f32-4414-a337-a1d8db5baedd@linux.ibm.com>
Date: Tue, 27 Oct 2026 13:42:48 +0100
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
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
To: Leon Romanovsky <leon@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller"
 <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
        Kees Cook
 <kees@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
 <20260803182614.23f26c91@kernel.org> <20260804080455.GB326170@unreal>
 <20260804145756.331951b7@kernel.org> <20260806111739.GF23431@unreal>
 <28c6b0e5-eff3-4556-802d-be6ed3f16615@linux.ibm.com>
 <20260915111309.GJ13683@unreal>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260915111309.GJ13683@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA0OCBTYWx0ZWRfXxZdX0+itH4V5
 YXUVvscWTVATBV0uASwCOaosJqk++VQQP84PEmtrETAUoWUmAwdy9d5VPgjUaa08lLxbOXylyj5
 nENndsKCFDER/I7QJ4oKZpuCEO9Y6mA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA0OCBTYWx0ZWRfX4ymx0a0L4W0X
 sfVtUplPSkbYpewLiAxG/IQB6qZMciNRyxxrVgX0d2qbcIgEL9Q0mycEFGhlU/8UJJ1SApC4P0F
 VppyZWDeFLNKKH1TbecWjogjQaIqWxCUiMVhHel/PxkHEryCo9Rl+dgRRkW03785dsLAQRfyZMK
 mX6CAVOOv1mB7lkZvGcx1TDaeBl3EbzCwA87IphmHfoWPjuEmWP6iibm3AwCgtUIFymqOnrL4Cf
 6G1jCBIYbezGgLcZDtQXBaRmMdHkVe4stUOCRmzsPDrLhMyHleL1emtWc2gsaac3/gCwonNcSie
 V/QK+yiVEcd5m/hvXz/O3ipw6RfIOud8m5ztGHV/xHdvVYj9akRbCffkTlgNKSpfTZtoAvDJs9N
 B14GUOTY+I8hky+pS1ln2P8Q5zm8q/SGm9K+XxAMauI9eMrPKJiyawCMAJv4bIMcJeQN++30kll
 UGap4pIpzFD6NBF2NVw==
X-Proofpoint-ORIG-GUID: XO6domchyrXlC7BJkvI93etUB6kHbIVN
X-Authority-Analysis: v=2.4 cv=Uu32pOwB c=1 sm=1 tr=0 ts=6ae09c4d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=lnHWk7NgPE1agIjKWVsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: V-hMrC93J2H9BeNXgICTpDFDw67yzzZu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270048

Am 15.09.26 um 13:13 schrieb Leon Romanovsky:
> On Mon, Sep 14, 2026 at 10:58:43AM +0200, Christian Borntraeger wrote:
>> Am 06.08.26 um 13:17 schrieb Leon Romanovsky:
>>> On Tue, Aug 04, 2026 at 02:57:56PM -0700, Jakub Kicinski wrote:
>>>> On Tue, 4 Aug 2026 11:04:55 +0300 Leon Romanovsky wrote:
>>>>> On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
>>>>>> On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:
>>>>>>> Prefix each cache name with the device name to make it unique.
>>>>>>
>>>>>> Why do we need a per-device kmem_cache?
>>>>>> Isn't the right fix to make this driver-level state?
>>>>>
>>>>> This kmem_cache is required only for software managed steering mode, which is
>>>>> configured per device by mlx5_fs_mode_set(). In general, resources
>>>>> should be allocated only when they are actually needed.
>>>>
>>>> Of course you have to wrap the init in a lock and count users.
>>>> Trivial stuff.
>>>
>>> I don't see why we should abandon the simple, architecturally
>>> correct approach of allocating and managing resources where they
>>> belong in favor of a more complex global scheme involving locking
>>> and reference counting.
>>>
>> Any updates on this?
> 
> No, we are waiting for Jakub to explain why should we complicate simple
> and working solution.
Ping.
So in the end this is something for you to sort out with Jakub.
I can just say that we see this issue in our s390 CI without the patch
so the patch as is is
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I can offer to test alternative patches if any.
