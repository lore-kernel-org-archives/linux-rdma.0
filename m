Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795765748;
	b=nls27lBMqDuvbh/CiB0glGXmKR+Eju1B3YQ738ICFBUTD//p2uPEsL11E5pcDOMadfA1
	 6/mME27z8vM6FH3HY9PFYAzLnbJG4Cqwf2eZoRmqggiWZUOlJJsLLxu/P4zJQB/jQ4PKa
	 7FT4t8Ot2ZWDL1JUhEckX/s84vZK8+Zz9Z79pk+vL0r9l/BPjpoGnzoaZvxCBzkI2RE4K
	 8BbHlCSRwvmMEEwJocYZ6Qtj6nt64RSCVN1sTwQ/kIMVVf4ezgKi71kVOYt0Y3N0n+LP6
	 aZ2kKcsaoE0AO3vPspd9KWMCzJvlhTnmz+6Fo5zfb/tjjBTtm3G2JoretoAe8dqy0Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795765748;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nQ7srqwIRKHS4O4m0P3L0sXM/MfNNdnOet79aGC5Tog=;
	b=yyXCHZ3rAMPJennDM7QvmEPclueoaoBW2zJwBNiZnErelgE7uVkDpt7o3SaxVo2BmHEJ
	 f6KNaMAQ3BCRRV1CHOsETFWl+DwBkQIAUwfjsF2vguAqA3AvtIBMaYJvMOHK7ksDn3GJu
	 e9QGA5edh3uPqJ6NeJ1HQHB8KIE0dykyjRZorh70VReExgmuDVhHexwS3kpitkfFZfEAr
	 tKhOIF9TsZ8xk7wErKgsGxfBjB/maKrXoMV4er4LDDlW/RKhfySTlL1m4TAadpVlQ99za
	 hIvixpr9NXDywzcc2yrxImV/FR7Gge6R8q9ZS6ONup/ZMbKLwqZnEugf9u0B7vsgnyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qojdgp4X;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E046F606A31C;
	Fri, 27 Nov 2026 07:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E046F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qojdgp4X
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7Z3LX2458652;
	Fri, 27 Nov 2026 07:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nQ7srq
	wIRKHS4O4m0P3L0sXM/MfNNdnOet79aGC5Tog=; b=qojdgp4XZKm4SEEnsLzLKy
	TSePbx4X844Luh1+VGRtCHI2VRI2VSpz5ebmh6XjaAn/H0ysxSUowjraZ3E+fX5o
	jyABsCiWDE/jEJ44lx50ZAZHjtxWUM7m7JgTnov9C+07PI8mj4Z8l37GdOjuAcbU
	ukhEkuoNRlqbf1V8w/3ArsVKVafwLhS5SUzA2+G3pTntdV9zNXjcTiDjUUy/7icc
	6lCdsYO4KD8Q8iACY/Nm/veKtZ/tLOww4VuMd78eDlf/0CYBau1YVPv+1h85gGGQ
	WStcSRX6mJHBlNjxH3ZlHfLa5D6gzMih7y9R8CrdTKoqMgf3zmxGr+jshjKPqaOA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34gvm3xh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 07:48:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7JHDm3458667;
	Fri, 27 Nov 2026 07:48:52 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6uccss0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 07:48:52 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AR7mp5h29426428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 07:48:51 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 588CE5805D;
	Fri, 27 Nov 2026 07:48:51 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF02D58066;
	Fri, 27 Nov 2026 07:48:49 +0000 (GMT)
Received: from [9.43.50.30] (unknown [9.43.50.30])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 07:48:49 +0000 (GMT)
Message-ID: <ae1cb21a-7277-4e78-95ec-ab932dc14e70@linux.ibm.com>
Date: Fri, 27 Nov 2026 13:18:48 +0530
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
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Read the CQ consumer index under
 cq->lock when arming
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-kernel@vger.kernel.org
References: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
 <20261126185902.GW774860@unreal>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20261126185902.GW774860@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=CYCdd7rl c=1 sm=1 tr=0 ts=6b0935e5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=k0_99HL5sFn3h40b0ZMA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDAzMCBTYWx0ZWRfX8rFzZ0GuAnBu
 qy6qHqT+B8yoPH25yM6BYvm/Z4Gd7ebwI++IIMHdfpZeVNhN9B+LLdFexAZOztw89q5Do6tEVi5
 HUNgvSXZlr1oafInIplZHBO3XpYa8Xk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDAzMCBTYWx0ZWRfX5ZlxCULR7T7J
 aAqUCrc/5wZDH38+tJ230s0qHe2E4JzFdx4uIeJjN0zW7LsA0YnZb9fF0mkt/SpRTT222IboeaQ
 9yN6ogaUKBuD9GbIxqm/rs5qJ1MryjZEokru1aOHI82qwbOplSXil78zzJUAI6JQsax4laLykd9
 xtH6PTyTA+tU2ABkJiMYJINpYYTiGwOPNvGXYtto2nQTS3kMjBUrVE5kYD7Maj+iJ6LG+/wqBLQ
 RkpWjqvSCDwsyEOzBLzL7FezWKQ8Hzf1CVxxkgAYkYIYjCv5PSlltN05l+dY2BtzieiFMH8Vhrj
 tXofthulIRbmS/kBUmyOLxLoUH2G/fm9j6LSKw1khwvvIarFvGVFriBiMJaTFYMF5xnGAUClJEK
 pvlkYdK+9sJtXbDTAHQeGoVAAR123E+XmPb5je6Er9YMBukwopK28y5rNsStzXX+gWLfaqZ8VgR
 /f5JWUs9mCNfcP8VtcQ==
X-Proofpoint-ORIG-GUID: dwxCZeYkrvQ7mGIc2_IPDDUWj5wD142J
X-Proofpoint-GUID: dwxCZeYkrvQ7mGIc2_IPDDUWj5wD142J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_01,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270030



On 27/11/26 12:29 am, Leon Romanovsky wrote:
> On Wed, Nov 25, 2026 at 09:40:54AM +0100, Mahanta Jambigi wrote:
>> mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
>> the poll path advances the index under that lock. A ULP that arms the CQ
>> from process context while the completion tasklet polls races on the
>> index, as SMC-R does from smc_wr_tx_send():
>>
>>     BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
>>     [mlx5_ib]
> 
> Please add full non-trimmed dmesg stack trace to the commit message and
> resend.
Hi Leon,

v3 adds the full untrimmed report to the commit message: both access
stacks, the locks held, and the value transition (0x63d -> 0x63e).  It
is from the unpatched kernel.

The code is unchanged from v2; only the message differs.
