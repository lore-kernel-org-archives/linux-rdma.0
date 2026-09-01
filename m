Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5247A377EA2;
	Tue,  1 Sep 2026 06:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244879; cv=none; b=nCCrnTsTsvDtMX8D3bQX9V/XPDLmteTbhv/6GMAyNg8v74J9elQDHgd/fNRmlC4LMMiO2hrHAVLT5B7cUD0NYNp5TnKlt66GkDT1P2nmf6Y+6WDJsbw8OvfxkanJLxtVaY2WEZMV+v6+pRyUI33jeGDKycB1S/CUyxMTnlPzfUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244879; c=relaxed/simple;
	bh=NGrovVWKltM1EYboN3BsQncOFL37lglUgU8SWyO6vnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tgUfKDAKt7HJd+eVP9EeWa81kg06CXpkhO8Mdmsdryv0ouF6P9N9fSBfoLZMCb1ukn7P/6XujymYolcUE+0a/LhOfFOwdNSb6YVeMWO6EIIBZA66/QFxa+Y+NOhs2KsIDgshmU8DozPHZjqQr4IapbBkGWlEOjUJtLph69klX74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ingm5mCs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ingm5mCs"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68111afP3992819;
	Tue, 1 Sep 2026 06:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NGrovV
	WKltM1EYboN3BsQncOFL37lglUgU8SWyO6vnY=; b=ingm5mCsPFcGLVUgIiblsS
	DJpQbxJP5Pns2kwF6JAKHoN6miwXUQCXmCFTIEKTap5EeapPQh3+a84B8zq4p1qY
	r6ECSx6e/vKCkEq9LQO8JagMVWB+PawPeRa8nVSQ7sr22TeVtUxaxiqV20KFuN0i
	IqfaWXfzm8inl8F3o6gzxMefZqEJlnvRIDWoBYw1wdGxoib9/0w8J502j3dB4P2m
	/bM216KLcifHSLY4fgwO7dNQ49szviT/HWeme9m6q5bARvqO2IyhggCqipWAcjH1
	Bceu90Q4kYhZ9pblAYu24ZVqY3OCs7Rorg0+jzXIe6HuJGX3Wmd4e8ztux3aUyGg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbq2t5v3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 06:40:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6816QPFO005957;
	Tue, 1 Sep 2026 06:40:45 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gc9rqadxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 06:40:45 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6816egTt6423146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 06:40:43 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C946D58060;
	Tue,  1 Sep 2026 06:40:42 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90EB55803F;
	Tue,  1 Sep 2026 06:40:37 +0000 (GMT)
Received: from [9.123.0.223] (unknown [9.123.0.223])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Sep 2026 06:40:37 +0000 (GMT)
Message-ID: <db896915-5858-4fc3-a56c-77b626980284@linux.ibm.com>
Date: Tue, 1 Sep 2026 12:10:35 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
To: hexlabsecurity@proton.me, Sidraya Jayagond <sidraya@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Tony Lu <tonylu@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Simon Horman <horms@kernel.org>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=bc1bluPB c=1 sm=1 tr=0 ts=6a96736e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=wBPD8qU9tVWp8gPoziMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA1NyBTYWx0ZWRfX7frh9Pa6i9zU
 DT3i0fByF3eSv0euLLoMW+9jqeRIuq6xXTUVkv2x6HjL+ziPwVHEVtgxLsfF3MfxJGwo8MlFhgU
 IpaYZ+/33nUlQbHbuYcPHEWGnGwJboA=
X-Proofpoint-ORIG-GUID: 5cfmJn4YIf1Kkxv1MHDmOt8sHtH8XX3W
X-Proofpoint-GUID: J2GmjbB_k2_E8ltrN5-QPAA2DpK-29Kw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA1NyBTYWx0ZWRfX2ARbH/FVSPx1
 g8GSUFSpSU/uXVnOsVXN6scL7w2WmALSx6NsJjagAwUdr5pY4xP7aUixk7I33uzoQWw6kzBmQMe
 nQvI82aLgLNNLozWnZuqRpUvabfdUU+0xbI0hFuupRBl0rMEtP3DqVl1IfCt1qH7+sgxYH4++eM
 VDoe7s57GGzLvSxCkWA+aPbNXbVuQneW8Ikmkpr3FTFrvU1Tp4KQXBXDYCQmCYvwUv15d47J2l7
 tIWV+qWZu7C7R7W7AvSoguvZvRyc3UadYT4zC5bPbKHUnJCxH5bUGfKZEvWlCu/n+6jZ5G8if45
 Cs7Z8XlrFSE4h1TwMZSB3P1qzEKYIOVk2aQ6Bb7ofs9RYq5WDHDrHenmC8aa242Oi4OvNb8LD94
 UH9KQ4dGHQB8rO6rEXWQnpfrWbqWn/qakfw2SOAc3tmW4YcMOxNqPnrMH5LHW08Wj+DSKBudyrS
 2PlpmfIqOJHrDLm4OSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_01,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010057

Hi Bryam,

I noticed that this series has *not* yet been merged into the net tree.
Is there anything still pending or any outstanding concerns that need to
be addressed before it can be merged?
