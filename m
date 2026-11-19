Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079145;
	b=SlJflyVK/nVdfpQjsRwiLD3a88/tLCHSAO7Ho63jZKlIDC3EoQvu/itnCJg1hn8TUcyq
	 eQoREyXyGnXApddZcxiXXJAELdUhOA881qTHw+UAmQZgtUKo2Zpf/7eTz8jE9rsoQ2qEr
	 GhccebrMz0uohsYMtVDjqgnEngT7Ok4teS78nxPYeUBoCzRwFF3+euDDFm0QMDbpMmwDK
	 V7L/KRMi/6caijuJ70uaDAsziFYW2sZicC2/pGJFM2Z6ROt1/BVIOYxuTs4DuT7y7xTWi
	 QgBPsJi4kJOceT0rqmtFVmuNsU60lC5bmvC6pPFcIfH/pPHyrsRvuGEwMtj8Dax9wdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079145;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=h9mrY5VPxLzLNJtknNwlkIizrrzBB2S+plhJgJ/iXWA=;
	b=k6gny7/+GbxbA5vhilGRvP+kZjHqD26RdbyzXNWmlTqKZ4fk8mRWxFMuTjlp+kKHWqBS
	 wRxOLfAgZPAjTmQgzLUnlSrbhYy2OJaR1cirAWdbKg+3Xy5EiTzEp7j6VtPPpT6jyD+NO
	 vZMvXYnAL2suqtnktC9PUJWC8w6OoSZsjlvJa5Ib9bJfl+GWn39rZv+QRURHfhY0oGM5I
	 7/c7STwGRK7YufW3doWKMeGy9Sn40j+K+DpIVxff7ud7MwHkTuGooQDTkT7J3pjCegsNU
	 8jGU4vBBCJAhGAogA4JBAInFpRvToiDpIIXCmY8fIJNwdZOKzTXUvYsUGXcfUGmZx9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Xwova4Lk;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB560A260A;
	Thu, 19 Nov 2026 09:05:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64EB560A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Xwova4Lk
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ6uqjK3422902;
	Thu, 19 Nov 2026 09:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=h9mrY5
	VPxLzLNJtknNwlkIizrrzBB2S+plhJgJ/iXWA=; b=Xwova4LkdbApeipzD/myca
	3nK4kyG6j6u9ah2pMwkd7lPTzr+tePEiCbo0GJDWsdG+DdpuwnS3mE8I75kN946Z
	Ds4cv2QY8D4C5i4iYbcaC/Ztz35HMDDHbEXVAo6mhkmiqPCxls0Z4MwbC0jIaEiN
	QtMKG5jKUzTPs2G17Me6ZkoZNE/lQn9nwwDRZ0DaagUjnE9QLi2NwrjafuwbQw6U
	zy6K9YFWw+ejBV0Q+JFGr8sBKsuuQ+RJg9IPfZWdg6mqJspkBKoF9qDhYjeGOj17
	MEuovzUCTETZ7R8EEm7sTTMCh1gPyPAVFclI/h/pxZAFnc1zescOiSmccrV2IChg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105wyksp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:05:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ7JpnI2580300;
	Thu, 19 Nov 2026 09:05:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hy2bvpjgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:05:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AJ95L0r47841594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Nov 2026 09:05:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D08092005A;
	Thu, 19 Nov 2026 09:05:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 862912004E;
	Thu, 19 Nov 2026 09:05:21 +0000 (GMT)
Received: from [9.68.25.8] (unknown [9.68.25.8])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Nov 2026 09:05:21 +0000 (GMT)
Message-ID: <32421feb-4d8c-43bf-9307-9dddd0210cf0@linux.ibm.com>
Date: Thu, 19 Nov 2026 10:05:21 +0100
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
Subject: Re: [PATCH net v2 1/2] dibs: loopback: reset the client id when the
 owner unregisters a DMB
To: hexlabsecurity@proton.me, Dust Li <dust.li@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
 <20261114-b4-disp-4e6374c2-v2-1-3b7050bddef7@proton.me>
Content-Language: en-US
From: Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-1-3b7050bddef7@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: D4WqWhorBzS6N49eKkbHLSXUS39zaQ-_
X-Proofpoint-GUID: bmXfIfar8wPAHBGwKGyoHkvu--uMVthe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAzNSBTYWx0ZWRfX9LY20ek8rRmF
 uBCmqLmd68IeZr8UmLA+fXIPzpfbNwCEsk6g6fKxvOpwrljWS+gSuo02MFOCnlvoVieoYT7NPJs
 XbL2ropAmccft6WY6cw92nR4UdvxJFu74/Oe+yHsA4RRKG0f2GaQJ+04dkapgBtMNqJNo/skzz2
 mtQjmAoV1rzWPnS2J7Hm8EYV8+m1XJSnSDQImBvGRnr/iiXoyfZWYHtvNiVPf5A/Ulagu4BfVJ3
 rURZwFI+2PJ3EhmYsPZN5JEfiDEjQ2bt1gBYCVMLCKOQEpvH+JfX7UvDAU8CFnwoOkLf/kkvte2
 O4enzvQtL/HcktJvkdoZZkgKwCz+D7BwgSgYAODdtPkxZ+dL8hmbzKpeHSCl6LFnrkXRfELKR8f
 6LMsKjFzZavSuhf216NQYn5JFybdH4codggz1DOatgYLnfJ4QE/OXRzsI1OwfoBfvTBCLTiDdno
 OX2LXOX2MWQoL7dzkCg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAzNSBTYWx0ZWRfX3pcEQnvq8S1m
 ApkiB7/i6f1hrfN7XxnPlPg989ykOwhssMIkXvSVg6s3Ho/afuGKpeOwybgVepviQ2VrrDBb25g
 NMBwjM1UutuCjLZbIjX5H9K7+2QiS4Y=
X-Authority-Analysis: v=2.4 cv=K+m3jCWI c=1 sm=1 tr=0 ts=6afebbd7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=aOMzDuweHAdLCSDsqTsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_02,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611190035



On 14.11.26 20:09, Bryam Vargas via B4 Relay wrote:
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

As this is unchanged, my R-b from v1 still holds

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
