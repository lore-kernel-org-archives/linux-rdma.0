Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194507;
	b=gyz6sMa8GJLkJHJ8Lu/u3JTZNQJA0pYlqFm7gA54WA4Wylrf2+snNveQv1CtygIQ1Ftm
	 KgTw7gEwqLRjhpkm93kvncWvvS4PnnR93LwU0Nr6ZxYgaFc4W6DMlq1KqGpp1ybuSFoFk
	 M5K8SwOmOlE0uCHPdN2/C7yO0P2PtlJwqpQOnMi+plUAOIl/xjZnqr2+qlSDnVbMYZdm/
	 1DMlFxWYlSZzTQRIN6iz5G9MCrcf+epIVxspRZoeAeX/WsTr2KwpFpEBuVO5sdU/AHXIf
	 1jJblsgibUVHjoDh8W1xs5JMnpWwaIm2G509/4WH60LejWCkelW6de8POXEsEYfU4eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194507;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:CC:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=fo5yAWaHY2Wl9L3ohP1f3r6FcFgomzTiHyB6CEvl0HQ=;
	b=jHuuy5hIa1V3rFxJ0CIUN/EJK235rtF+r/Cs2YyYl2pMm/ggy+v1MkC7Rvfg2aSaTVrW
	 Tma3gOVk4V3l73UyqfJy3IPKlpztqWpA8nXmC/zTFYoWaZoITh79Qw/D8w3hN98aSwT+p
	 UH9gz6xUbi3q2pLxF9FRygHjaknQ9jMERTGWP6R2FuzTSYD6sKMbMDTnujG92JzVUKOjR
	 xGbnNI9JNEBwivDvNfJ8zplWgcTQOCkpDZG9nzU/3hj7jrsUMS/7oWC9FsvLrspJ0hmhn
	 ow1sI3UND+IDuDNK6LmFG+Ad3eGI6BCtQPn0cyl0uCZH9AhlEllgWcIeUYCC2eqfucw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hisilicon.com;
	spf=pass smtp.mailfrom=hisilicon.com;
	arc=none smtp.remote-ip=113.46.200.227
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F92606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 03:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6F92606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jNFSV6z3hznTVt
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 11:21:46 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 1848D40586
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 11:21:43 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 11:21:42 +0800
Message-ID: <7e10ea80-0dc0-68c5-2d16-7ff816c5735d@hisilicon.com>
Date: Mon, 9 Nov 2026 11:21:40 +0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: rdma-core: aarch64 mmio_memcpy_x64() ignores constant lengths,
 and libhns relies on it
Content-Language: en-US
To: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>,
	<linux-rdma@vger.kernel.org>
CC: <tangchengchang@huawei.com>
References: <20261107231102.Horde.VTLAyGut_WGch71PWzwoxG_@webmail.uni-tuebingen.de>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20261107231102.Horde.VTLAyGut_WGch71PWzwoxG_@webmail.uni-tuebingen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/11/8 6:11, Dezhen Lu wrote:
> Hello,
> 
> At rdma-core master a70151dfec390eb5f7fc5b266f51d601da2a7778, the
> aarch64 mmio_memcpy_x64() in util/mmio.h tests
> __builtin_constant_p((bytecount) == 64). That is true whenever the
> comparison has a known result, so a constant length other than 64 also
> takes the 64-byte path and only 64 bytes are written. Both the macro and
> its libhns caller came in with 159933c37450 ("libhns: Add support for
> direct wqe").
> 
> Run from the repository root after ./build.sh, on aarch64:
> 
> ```sh
> cat > t.c <<'C'
> #include <stdio.h>
> #include <util/mmio.h>
> 
> int main(void)
> {
>     static __attribute__((aligned(64))) unsigned char src[128], dst[128];
>     int n = 0;
> 
>     for (int i = 0; i < 128; i++)
>         src[i] = i + 1;
>     mmio_memcpy_x64(dst, src, 128);
>     while (n < 128 && dst[n])
>         n++;
>     printf("copied %d of 128 bytes\n", n);
>     return 0;
> }
> C
> gcc -O2 -I. -Ibuild/include t.c -o t && ./t
> ```
> 
> Observed: copied 64 of 128 bytes
> Expected: copied 128 of 128 bytes
> 
> libhns depends on this. hns_roce_write512() passes
> sizeof(struct hns_roce_rc_sq_wqe), which is 32, and gets the 64-byte
> direct WQE write it needs. Fixing only the macro would pass 32 to
> _mmio_memcpy_x64(), whose size_t counter then wraps, so the copy never
> stops. I would fix it in two patches: libhns passes 64 (taken from the
> function name and HNS_ROCE_SQWQE_SHIFT), then the macro checks
> __builtin_constant_p(bytecount) && (bytecount) == 64.

Thanks for the report! The proposed fix LGTM. Once you submit the PR,
we'll do the test on real hns hardware asap.

Junxian

> 
> I ran the reproducer with Apple clang 21 on arm64 against the tree's
> util/mmio.h (stub Linux headers): 64 bytes before the patches, 128
> after, at -O0 to -O2. gcc 13.3 on Linux aarch64 truncates the same way
> in a copy of the macro. With gcc 13.3 the patches add no build warnings,
> leave .text unchanged in libhns, libmlx4 and libmlx5, and change code
> only in libefa and libionic. I have no hns hardware, so nothing ran
> against a device.
> 
> I used Claude, an AI coding assistant, for this report and the patches.
> 
> 
