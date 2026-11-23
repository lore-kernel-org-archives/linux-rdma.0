Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795416371;
	b=DoE27KeCSfAntVwfIqf2N14solCHHmaFCMdweymsGAioJ0HWxstTqr9Oef4vk6vlQ1ed
	 i0KM1vc/6FcM/7KMhNqpxgz/NpfbQSdfgLecmS0Bw3vzf0dI4/vdyaW2HZqL4w38N2jWB
	 RUU2GrH0zBhE7c+ZlYt3zU1+zcS+ZoxAeSf2qQxRFVZXXj7ZkAOB8sMj2gyOSObTVSnDJ
	 G/kg5n4sWR2o4JWM4ARtpFOLVCP7WFMF/YQUzD4PUipxPjjRVvJDitV6eynQ0+KPla6t+
	 UAZAmNkZKLTanni2i0ycUhagTygszOaXMQgT8jIls//7nMa+PWeATrazqOAsvDejp0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795416371;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=17GLhYG3TSW0kUKpdTngosp6wTo3jNrYR5Um6SmNLJo=;
	b=EkPJ1SjcT/5xLmw9L6ZefDmOFuZyw4wndtuqU5q2CLEbiFxPFEC/ch8aTN/6TGUTL0SI
	 D3tU3Gg24rNKmxzqFaJGIcMZ/yDGoeyrIuBz7WzgLOvluuVXfPVqpub+k4iVaM9Tb+iDn
	 WXHF7Cetrh9qNh2NAh2Npm3z/b2o7wW11pvJ4nnvns94OrDKrRQKlWBFLMJhIWaZ7ACks
	 gB72r1fR9MLY7CnBK4eooTb5SqYXVc20odYswI0eJwxlZMO8SG+WaGsWmdlrOPHgs/roa
	 FrPaB5nwryW3eQR/oMamorNqIAXMvWOd4yOlGuUcsT40RU0gFD64Q96tJANsUmZpUlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Q2QteLVI;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFA9606A31A;
	Mon, 23 Nov 2026 06:46:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDFA9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Q2QteLVI
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN554kg2575169;
	Mon, 23 Nov 2026 06:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=17GLhY
	G3TSW0kUKpdTngosp6wTo3jNrYR5Um6SmNLJo=; b=Q2QteLVIsHgzla82jiL56E
	UlYEgUzJZFCwQB35kfhsD98CnkxnPJ9DpX0t3xHUWw70stA6Pmk1VkNt4OkZIlaK
	2qiExIvDkAaQ/1Fl9BdzdHUPQVhda6CiFNDAhmWbtfS8Zgfh8KKEua9T6l9zRb86
	gXvFP9M6tozc26yDZe0WFhASPLMriB1dKgLj8nExzPpJ90PsbbNqxh8YDTNAPuCz
	G7MVjVWae6a0zvuQSa8cIvlPLSz6OJGFOyYaUTSwRqcEFiE2l18PQ0MYyATVp9O3
	RW/5Shrsh9XOP2ePT0bXrcz4A4RFoNqO4HqiP2LsnXaFmPTWw8Vcdk7ymsxOZNNw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34gv1m1r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 06:45:58 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AN54IOe684348;
	Mon, 23 Nov 2026 06:45:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3p0vdrfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 06:45:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AN6jrBO38207754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Nov 2026 06:45:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F52E20043;
	Mon, 23 Nov 2026 06:45:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 866952004D;
	Mon, 23 Nov 2026 06:45:50 +0000 (GMT)
Received: from [9.123.13.84] (unknown [9.123.13.84])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Nov 2026 06:45:50 +0000 (GMT)
Message-ID: <e6f7e442-4b52-454c-94fa-afd6f3c61169@linux.ibm.com>
Date: Mon, 23 Nov 2026 12:15:49 +0530
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
Subject: Re: [PATCH net-next 0/3] net/smc: fix clcsock lifetime vs
 asynchronous paths
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20261120124534.430200-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=CYCdd7rl c=1 sm=1 tr=0 ts=6b03e127 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Upmd74fEsTyMv7FUjCUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDAyNiBTYWx0ZWRfXxe8srxMzgE/H
 A/U1w5kMngIU39kXqZY+ODvEScS8dwsFeJbtgiQufCa0VcOUJfZ5pJZfY4eL3DQKL4vKgYy1F4C
 TSDyqnV94mnkSw1TaGGQ6XitiNtGWhc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDAyNiBTYWx0ZWRfXzYDOXi/wvlfd
 7oK6vICUsHoT7FzlPUJczbvIuUWZ/VyL5KWDU7dq8rwOZ7szDwMmK1mfdr1gHvWeAw/wJE/0LST
 2pyEvvtEleeo64I4b2Ce6sq9KvVKyhCP4SS9qCeXXGjPEJuZIAIaxopw6+WG9JECcuNRhWlhXs/
 j+E/J3JFnPv5sHH1veUrN9ElWKGBbqR5GMyz7lKmMSRiZMGzZ9kSdDS4nHFI2RtIlwL6JTQ/uJA
 DOjU8DTsZ35abt1GjsajRNaCAtX83Hfw3GYCKNQ2mJOnXSD3K1RnecT+Cs0EyQDFyKMYDYnm7Rt
 qHzLmPo0/55lCOtplEE2gOLcrFDPRD0lzheWnYnokIALZjhVsnge9HKVvElgZoGHw4ctc+4bCPt
 Aldd0W9rwvfnlD/Gpmj+S6OsH3rGDREkT+q9My1DqjqR9uyAmp+oYwJJNFDR8zqP/9ngwcnvjHs
 pazQlD+mBrtD0BQq0wA==
X-Proofpoint-ORIG-GUID: 51AcdNNdGWrJB3i3JaoP1Aq-mH2bbxf5
X-Proofpoint-GUID: 3sx1Nzu2eRREiTqtPi9aZlB1uKOZ6dei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_01,2026-11-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611230026



On 20/11/26 6:15 pm, Mahanta Jambigi wrote:
> The internal TCP socket (clcsock) of an SMC socket is freed by
> asynchronous paths: link group termination reaches
> smc_close_active_abort() and peer close reaches
> smc_close_passive_work(), and both can run while the SMC socket is still
> referenced by an open file descriptor. A task that uses the fd at that
> moment, for example getsockopt() or a socket diag dump, then operates on
> a released socket.
> 
> Free the clcsock only when no socket file can reference it: from the
> socket release paths, after the socket has been unhashed, and from the
> abnormal close paths once the socket has no file left. The decision is
> made under the socket lock, and the accept path holds the same lock
> across the accept-queue state check and sock_graft(), so a connection
> that is being accepted cannot lose its clcsock to an asynchronous close.
> The clcsock_release_lock is no longer needed: a socket operation on a
> file is serialized with smc_release() by the file reference, and the
> listen work is covered by flush_work() and cancel_work_sync() in
> smc_clcsock_release().
> 
> Trade-off: with an open file, a clcsock now stays allocated after an
> abnormal close until the application closes the SMC fd. The SMC
> connection is already torn down and its TCP connection has been reset or
> shut down; only the local TCP socket remains allocated until then.
> 
> Patch 1 makes the lifetime change and is self-contained. Patch 2 removes
> the lock and the checks it made necessary, and serializes the accept
> path with the asynchronous close. Patch 3 documents the invariant and
> adds a destructor warning for it. The diag dump keeps its NULL check: a
> socket is hashed in smc_sk_init(), before its clcsock is created.
> 
> This is hardening found by code walk, not a fix for a reported
> regression, so the series targets net-next and carries no Fixes: tag.
> 
> Mahanta Jambigi (3):
>   net/smc: keep clcsock until socket release
>   net/smc: remove the clcsock release lock
>   net/smc: document the clcsock lifetime
> 
>  net/smc/af_smc.c    | 123 +++++++++++++++---------------------------
>  net/smc/smc.h       |   8 ++-
>  net/smc/smc_close.c |  35 +++++++++----
>  net/smc/smc_diag.c  |   3 ++
>  net/smc/smc_inet.c  |   9 ++--
>  5 files changed, 82 insertions(+), 96 deletions(-)
> 

This series does not apply on net-next here.
The cover letter carries no base-commit: b4 am reports "Base: not
specified", so it is not possible to tell which tree the series was
generated against. Please repost with the base recorded, so that b4 am
and reviewers apply against the exact commit,for example:
  git format-patch --base=origin/net-next -o outgoing/

This adds base-commit: <sha> to the cover letter. Naming the base SHA
in the cover text is enough.

Thanks,
Sidraya
