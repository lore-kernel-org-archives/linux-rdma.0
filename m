Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA983446BEA;
	Mon,  7 Sep 2026 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770691; cv=none; b=h4GD0frLl7FgFQ+0yxdIxni24s7tbdyGuVqyWM/0jdMK4D5GDoiN51sIAKz3oApEVKShhB6Xee+4LjH/NZYwgWB2QuLMHIulOj5fF5Vf0U6ccj2z6fF1MJe4LWHe24CvscemJz+tFXr4f7x+58YK0oQLYhcCdDUW3iX/d8ACFSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770691; c=relaxed/simple;
	bh=XXR4CdSOCQVaEWh/J/sOK4i5cim+nXOfmdVGqWCXSHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIBAUbMrVfGoWF+XDCtvFR1+8DqeYqwMIf4sjM880av0BICbKG6B5FfNlFXvoBQ3JVD2ScrgLzIkLHCmSyN61B/FPukQFdB4wQpQheOr8gAzEoOEy3hF6nDCrjpb9Nnn3VCxH4doR7NkEfE2e4wDJ+t28wGRvtqe/Uu6CC5ZxUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GJUje829; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GJUje829"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6877VbJD1321163;
	Mon, 7 Sep 2026 08:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EAfw4d
	96C9QBb2fWVi/UeCpZirm/U+Gfs/73M9rpazQ=; b=GJUje829Qg2okkFJcX8V5Y
	eRPKRnvBzyI/uyClZ4I+S/3u+CIzW890DeC/hOw7HfBsvcb8zWix51AoVsWSMf77
	iomgCF9xri1cJRn2Nu5GQGGk5cbyHaurDSMK57w0gw0CwHeBvDY+FHKIQKub3yz6
	M3ucL2c3kj9TUTBuC7qszpmm1fTi6vkwMR8p8S4SjK8tXxthvGCp4F9Mx7Pd57jp
	SNjq9C2VpSD6252cDdXRn3wy6D8fuxV78TRtQYt4c2tbi6NAP4NHrtOanMLiog2m
	bH55WWIn0DCCZz2+Q34ygExbNhdNb4Bc3xlCTFiZYaaX913t//XDZ/Qrkk4E1O7w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbheqgn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 08:44:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6878fMqd030062;
	Mon, 7 Sep 2026 08:44:34 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggymg4q08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 08:44:34 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6878iWAD18481900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 08:44:32 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F8A258053;
	Mon,  7 Sep 2026 08:44:32 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDA4C58043;
	Mon,  7 Sep 2026 08:44:25 +0000 (GMT)
Received: from [9.111.200.229] (unknown [9.111.200.229])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 08:44:25 +0000 (GMT)
Message-ID: <fc1eb33d-f9da-427c-9e0c-c2ff79d2a1fe@linux.ibm.com>
Date: Mon, 7 Sep 2026 14:14:23 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
To: Jakub Kicinski <kuba@kernel.org>, hexlabsecurity@proton.me
Cc: hexlabsecurity@proton.me, Sidraya Jayagond <sidraya@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        "David S. Miller"
 <davem@davemloft.net>,
        Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Tony Lu <tonylu@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Simon Horman <horms@kernel.org>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
 <db896915-5858-4fc3-a56c-77b626980284@linux.ibm.com>
 <20260901162012.602cc62e@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260901162012.602cc62e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: sn1HUWt12Rt2VV8QcIsYcPlNZwOtMDAI
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6a9e7973 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=oaOSjWHYWp1lFbvcr-AA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA5MiBTYWx0ZWRfX0uHFajoQP/6V
 xpU3yYlH4kOeEb+GYaZi62p8NyDIYYAAgmakUgHuUMexjhgUElzDLN53DnLUw9dstv1oCK57YU0
 Lm2iyEqiyGPtb4uTWCjI5Ons7R+Mrdw=
X-Proofpoint-ORIG-GUID: kOxnBZaBb7HhVYlTyBAa0J70dqPcLZaP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA5MiBTYWx0ZWRfX9mgXC+SYhJay
 +jYYZ3qpy933/G7F9I5B5ISjsLo8pgCMbsaXN9zydhwgH7UKxAHWQhDI5647ZPy5E6yRM5XpYRZ
 SqtyN9LI0lbStK+zbwuD6lZsCBlscA0Ynji2A0fHr8XHRpsYe/w4IVLcS7UlsVt7Yq/+W5ulomi
 tDWa7dFZrrMyWx3SEuxaqA5yaQsKZfmlszdza+dNF/9Y03BC+TQ57pb+PMDnsLwVkcycYKHHOoy
 xIpgkpNWd2ajoCI4SIoeg48K38kdeasu9joDp2DxlqUnze2TNMYjxbCRBAJ82AptjtxL10mfkYe
 A/763S5wyc6oeubFVvIAuReK4XPGkTWDKpQ5aoP/48Qz7Ggw7XHm4+dj7Hm81DY20AspnEtnTvY
 Sja9mh9T6n9IkAyBNHY0Tq+wjyHubNcz3bue8cQ4sTIfB1Z5aWJI2UXe21j5Rm7ZEFu1Sjc2EvZ
 AD14MHduvkWmE7ALb+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070092



On 02/09/26 4:50 am, Jakub Kicinski wrote:
> On Tue, 1 Sep 2026 12:10:35 +0530 Mahanta Jambigi wrote:
>> I noticed that this series has *not* yet been merged into the net tree.
>> Is there anything still pending or any outstanding concerns that need to
>> be addressed before it can be merged?
> 
> FWIW it needs to be reposted to be considered for merging since it's
> over a month old at this point.
> 

Hi Bryam Vargas,

Could you please repost as requested by Jakub Kicinski?
