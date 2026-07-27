Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C94137750;
	Mon, 27 Jul 2026 03:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785121934; cv=none; b=kBc8ydtZ3xv8DGaRtz0sAMrp1RbfxsAURbNheBURmG/pfHX5CWK6fUStIGTOd+QHUqU1nfpKYMBVREddCibTIXSZJ+3PGQ7h6aNVZ7XEyGmTGOuG7yAynVrSio0qNR24FWrJR1fQZtfpJqYQewdwO9QLCvaTU26CTB5M6zgDEUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785121934; c=relaxed/simple;
	bh=3Z+txs0At9OOkKkdnsZp+Yda2BoMg1Dkbhfwt37Uyt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8yhLR3u69MiM7Zt+jjqS9LwJ9GiAgB2wy6VLdtgmMX54d6ZV1dm15Gwi+mv2xKmA+/6t4lHsZ6E4K7YEBD5OUtfbIkyGT/xYQD/y/Quy5rMP2qYx/xDAfnSCZw9o6H8ubA4KpsGaiJW0n1jUpa9K2S/yNTRTI5HzniG3yFb+NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=U6pinBBT; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="U6pinBBT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785121917;
	bh=jJpzWOd2AQ0qcTlQZVOnkgLY7Mxhg/fTu1TETcsiZ1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=U6pinBBTnEn78WNoXzH55+/WK8ShoNgzkuXLS511LYBpVdPDaBTmxAr3QF7mI+evI
	 Q2M1u4nDX6bJDENCxbZWxrBBCUdra5TPLMxgOi+65Gl1npYwUlSj6CjsBFx3gYu0Q5
	 QV1dicw0oF1yvBnv52qwglWJc4Z76p9UUXr+p0OQ=
X-QQ-mid: zesmtpip4t1785121908t349a5306
X-QQ-Originating-IP: eeOVjjpr6h1nN30mzWPlymvg2gXH398TA2mHByZ2jLo=
Received: from [IPV6:240e:659:1b0:640::113:101 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 11:11:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12037815108902466553
EX-QQ-RecipientCnt: 25
Message-ID: <AEAA5D0F00F603DD+457fbbba-bb97-42f8-afbd-3dd9c2dacd6e@uniontech.com>
Date: Mon, 27 Jul 2026 11:11:44 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, jgg@ziepe.ca,
 leon@kernel.org, akpm@linux-foundation.org, namcao@linutronix.de,
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-2-gouhao@uniontech.com>
 <3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org>
Reply-To: 3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org
From: Gou Hao <gouhao@uniontech.com>
In-Reply-To: <3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MWCWULdTTL/UL96dkeyad7kkR+8QThrxMuw09uC+Bvw4YbdtH3WAb+ht
	FSy++KMEXBY2iWUcbGOsEr3bUWK/zxtjDSQfU03AmFVjDKSyUyzV3qrvG3OtBANyP17Ac+m
	P/GpptPnd2OgBuwSB4WTqjaz9qmS5jbmc9wW2vWhQR5s57uxzUPwn0ihDAMbcwxXTGwOnVw
	Ln2Jh2jMaf5HRTGXj517mQmUGGoYuXcDUsOaETrqKcws0uYt+hZUY+NdiL6cIW5lUPU8+6l
	SXUbJt9yJFm7zB0chyz9kDis/BWUDRFRBrN0oIOjra2/ga/l/hO0InEhPe14aU/mtKqL6ti
	3/H9DgFU8id5GeXVMWMRFG2iTWt7F9o3JziAoWU2wmRyocKjitjA85Rs9yElb+bcAeeeUF1
	M/K4aXyETU0dTFyqSA3wzdBfg4JbljzUCkIDDSgObg9ZYFdOm5Si+3gDG3mIGMpMBqPwTFw
	AJTNArZHGAjtgEAGNsNw2FLxKEPHSGss3L7zmoz814qSCZrzLh1tIbPZunsLS5i3z7VPT+r
	25sgua/dKUewXECRsL0CDE05pkqGiQZRKrB4SadMtamgROypPefD/SlVu0aT8Ii1MTjOSIV
	3gfjkmFVA541y5955Zd7Fo+OfP9TTt2/PdjIvPAskbeSwKIMbu0ug14V5H6d+KPrOUnkvpF
	C6JOBnWMAMbAmtzg5dmE1Taw8N6RfMnRGzZ3PazBoh4EoRZOGFcb4lxtLY8fF961jDKhv0Q
	Gi68RIyGJtnkbW+oKWw3eWZsEiyXcUSoNTYzrHL8G4PDcsp9kmkyUEAsMFiY6ezDtXSQJgR
	HaDnEadS48SVbATVMTvPXjBKjcU8xm5H/kYiTm3t4Zg5KYIP1v/sykvVZh2p2WKODj6LbDu
	JXT9kf13InpTvgw06VWp6Tw7xSBcMJ82MJiWiY0wFEau9E/WideXj/5sPvsoiqVNSx3M+qP
	hbGVbgbaUqilmL2AWXCSpMXYqiVmOnUt9Pz77fkIJvwNjQCBfodR6sj03PaOKWYiQr92wau
	TkrSxbJDLams8qyU0vy8YtaMeeG9XJxOYDM7OfwGJKJxaH5y3US7BYAj526PgA2R1aBqhk1
	14G8KeKpJzJ
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

On 7/27/26 01:04, Cédric Le Goater wrote:
> As suggested by Andrew, let's change the approach and remove entirely
> __GFP_NOFAIL instead and make all xive_ipis access paths NULL-safe.

Yes, that's better.

> On 7/24/26 04:28, Gou Hao wrote:
>> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
>> subsequent NULL check is unreachable dead code. Remove it.
>>
>> Signed-off-by: Gou Hao <gouhao@uniontech.com>
>> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
>> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
>> ---
>>   arch/powerpc/sysdev/xive/common.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/ 
>> xive/common.c
>> index dadd1f46ec939..f2904a5c2b7bf 100644
>> --- a/arch/powerpc/sysdev/xive/common.c
>> +++ b/arch/powerpc/sysdev/xive/common.c
>> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>>       xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>>                    GFP_KERNEL | __GFP_NOFAIL);
> 
> So let's remove __GFP_NOFAIL here.
> 
>> -    if (!xive_ipis)
>> -        goto out_free_domain;
>> -
> 
> Let's keep it now that allocation can really fail.
> 
>>       for_each_node(node) {>           struct xive_ipi_desc *xid = 
>> &xive_ipis[node];
>>           struct xive_ipi_alloc_info info = { node };
>> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>>   out_free_xive_ipis:
>>       kfree(xive_ipis);
>> -out_free_domain:
> 
> and keep the out_free_domain label
> 
>> +    xive_ipis = NULL;
> 
> and yes we should add 'xive_ipis = NULL;'
> 
>>       irq_domain_remove(ipi_domain);
>>   out_free_fwnode:
>>       irq_domain_free_fwnode(fwnode);
> 
> 
> The prepare_cpu() path is broken. To fix, we need to check xive_ipis
> is not NULL in xive_setup_cpu_ipi() and xive_cleanup_cpu_ipi(). It
> should be a straight forward local change. Nothing complex.
> 
> You can test with QEMU. The pSeries and the PowerNV machines are well
> supported under emulation. Ping me if you need help.
> 
Thank you for the review. I will fix these issues in the next version of 
the patch, and test locally.

-- 
Thanks,
Gou Hao

