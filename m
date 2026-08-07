Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F143E06A;
	Fri,  7 Aug 2026 05:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786081542; cv=none; b=elXH9UCirF8io/whz/HgQUQD1t8KjnE+6w0YxCgYqtjuVBiIleAIUTSPsL9a5+j47864M5bC0lqevdpEI/+3vjZ6X8TXuMEnWFFF9EBqS3VHzQWtsdL05oaGDqdobfycR+kWjFn6WohAFniYJJ6daYjMOkEcWQH8l36WZnXHV+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786081542; c=relaxed/simple;
	bh=XEA4BT0LkK1Iq1kR/R0KipogGUWsDyNP3b75JT7lBOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=StDbjN6V5504QIzNflX2nG5U9VRPT7PbTlCyVyTLuZCHyRJwNbYUH/2yuXihpQcr3VYkhYqdCNf2x0FU9gOGM8tfd2kCDknfkAE/F9Fi8rDGqoLSrmsX+y5IVOibbQeafzedQqNeV85xAEnRRqUebM4Xi6ujzan9lQh6sEXDlqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XiEMxGio; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XiEMxGio"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770HxTV4068702;
	Fri, 7 Aug 2026 05:45:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XEA4BT
	0LkK1Iq1kR/R0KipogGUWsDyNP3b75JT7lBOY=; b=XiEMxGioLOCnZmNNZMXFvm
	uHiAn9ipSTM7MlCakf12s/9lhuj9HhIFNj9HCwWL7S3ohQWS2J3czcKlRunrnqKH
	8t2gjg10dN5FLYVryeP58jo9f/el6o85NYvlRHeVMmtvXTNSPvdDZaK+qvswUQTj
	yIWimmmdTYbIwjDkZBVLMjfKJsB6KQwIHHrgnzRN4wsHomgWCItlB3as9jD6kMDB
	nT1Ej7F7r0nEtzT6A3LXU9lGfUNvW3hFzVT+jU7KIqeSUZqOXZfPPWY9rRtIDGn2
	GCsFWPLYaStCyK74fGqAGDMqPWCPyx+WmQu6K+Z1BdsVLWuPIz0OrlpHxZeOXTjQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy022cqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 05:45:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6775fJAT016185;
	Fri, 7 Aug 2026 05:45:32 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgp941-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 05:45:32 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6775jVGG4260476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 05:45:31 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1938C5805A;
	Fri,  7 Aug 2026 05:45:31 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85AEE58054;
	Fri,  7 Aug 2026 05:45:24 +0000 (GMT)
Received: from [9.124.213.67] (unknown [9.124.213.67])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Aug 2026 05:45:24 +0000 (GMT)
Message-ID: <e16d16f1-029b-4d30-b393-2e9e525a2998@linux.ibm.com>
Date: Fri, 7 Aug 2026 11:15:22 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v1 2/2] net/smc: reduce TX slot contention with
 exclusive wait
To: "D. Wythe" <alibuda@linux.alibaba.com>, wenjia@linux.ibm.com,
        wintera@linux.ibm.com, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        sidraya@linux.ibm.com, jaka@linux.ibm.com,
        oliver.yang@linux.alibaba.com
References: <20260806064252.39180-1-alibuda@linux.alibaba.com>
 <20260806064252.39180-3-alibuda@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260806064252.39180-3-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 5Z1A-X9Ul4AbIGvY6DC94YAoYjzATQny
X-Authority-Analysis: v=2.4 cv=e5k2j6p/ c=1 sm=1 tr=0 ts=6a7570fd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=V8dVQpNtD287ao_dHYcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wg8Cl8HsGDvmhnxFt346RO9uKVX49UbI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDAzNiBTYWx0ZWRfX8hvqpcHirg8N
 rDGFekFISNfXNrpmQMugTeNqOkDZXV/ih3Ew6h8biHE+N2VJrqP7Gqw/Zo+vsGRA4wPRjVIg+OI
 tlcAxwWGQB86l5GnQIPyPXWAyR11S2vBO+8GRFM9puNRNe769AEMq5f43gkyfG+YxNOruHs4xXI
 fIgLtK2zFNpuxjxmFMJ5UpW8LWC2K48ZIpe38vdAqDuc1jSjDRwig/imJ1oIHOuDn7RT36VQ9EB
 Vr/SnhKzEoDnWVlM/SAxd3ptYXrZqdfHrE87byfW5l/iKIhSzO5cKdjKBmaPrA8chZhi/3HZOxM
 eVcXo+ql2P9K2ommoip7lkVQsYcNNkF2EKBPm+Hf7Lzeax8L2sukCFWl6h1Gkf+fjQPEOaMw/Sh
 CDGDYr42woHwEdmq9kVavdBNjpSavmhR8uLy5OkqyPdKUGFaeKhSgWNNMiTn7gAEY/78zSHbKSa
 QOK+I2G/Z6KmCEY39mg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDAzNiBTYWx0ZWRfX+EzpRCfcR/D3
 z5rur2urkutzrnix7KXx9vDh9L8Hw9fSoYt7wYtB9PkhIgI82HQuzTJYUHu/giKMYbDkKJd3Yb3
 FEgvMVCT/r7dXRZXkB1cjSbN0O6U1Vc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070036



On 06/08/26 12:12 pm, D. Wythe wrote:
> smc_wr_tx_get_free_slot() waits for a free TX slot with
> wait_event_interruptible_timeout(). Since the wait_event family
> enqueues waiters as non-exclusive, wake_up() may wake multiple
> waiters even though only one can use the slot, causing
> thundering-herd contention when slots are scarce.

Have you run any performance benchmarks (e.g. redis-benchmark or uperf)
to quantify the benefit of this change?

Since the motivation is to reduce contention caused by multiple waiters
being awakened for a single available TX slot, it would be helpful to
see measurable results. Please share the baseline and patched throughput
figures, and any observed throughput differences.
