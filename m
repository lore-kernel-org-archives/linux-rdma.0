Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.2.5.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794089473;
	b=iOh28THE3JlXN9wYrjoL5c6IU557UMVN5bxXrMfbexPill6gwyrfbdbTDlQlR5oPxn8g
	 8K2c03MI4RilgLVWvg5wXw/VZrTgc7ymn3sRDmkITqwxPdKRcgfT3oldmUuVFEo5OKCEZ
	 KX4kWAeN9BtblQq1g7D4PJ9HyouWls5Z1a4jGJLd0HJ7A1ynRyqi79ZeqMpDImZhdBIHK
	 jF4mbO6EgHzAcYKrOHKO1cDPr09Hn6O7KpW0Jcbs/6I38uFSesHd2il4DKS/3HJF0jK8v
	 AY2P4CQBQ5d0kwalV4Z+ZNvmrCqmz4IIUAKAww33x4EIKiiB99eqaOPunnaV78Fxf+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794089473;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:User-Agent:Content-Type:
	 MIME-Version:Content-Disposition;
	bh=1y2KEO9H0fAP3VEF9szmBFs6F6Xc0bbtVRC5J3NwA3I=;
	b=V2i1cKp+2E7RjYTe1xwQV+G5wefg/yWW2BF2hFUascrcrQ7yEptMaIHfwKFP09uOTEUe
	 VQnWyCdWyHuUjCC+0JhTKdvZjY5ieOYjrmbaKBCqCoXcKJ+ymHpnmtXbzA7TLoc9S3izR
	 9W70r2fZOxDRY4saoJA0xmVV7hBRSlpiZJRxJxGUrHrHilbk1w6YhXD2LQVTxJHKOAt33
	 tdEv2fY1Im9CwSSDYKR1afvUMiRfdB7e4OilLmo3YXZPJPQjKFXeGPyizwpDxJZMNqgeK
	 Lm5g9d76/9xx4jhWF2cmYHtsslDpNsEMTWoj34PMRWMkZ+vuV7qqfx9WVsV2dlslJRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.uni-tuebingen.de;
	spf=pass smtp.mailfrom=student.uni-tuebingen.de;
	arc=none smtp.remote-ip=134.2.5.213
Received: from mx03.uni-tuebingen.de (mx03.uni-tuebingen.de [134.2.5.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A304F606A33D
	for <linux-rdma@vger.kernel.org>; Sat,  7 Nov 2026 22:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A304F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.uni-tuebingen.de
Received: from webmail1.uni-tuebingen.de (webmail1.uni-tuebingen.de [IPv6:2001:7c0:300c:3105::8602:5c2])
	by mx03.uni-tuebingen.de (Postfix) with ESMTPS id 879F720C6EA5;
	Sat,  7 Nov 2026 23:11:02 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx03.uni-tuebingen.de 879F720C6EA5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-tuebingen.de;
	s=20211202prod; t=1794089462;
	bh=1y2KEO9H0fAP3VEF9szmBFs6F6Xc0bbtVRC5J3NwA3I=;
	h=Date:From:To:Cc:Subject:From;
	b=rUZEVD5cZYudj8WdYZREgc844rsl0MiZtwG/e/snXz6iC2z0Vw0p+Ah76+K2Kj6oB
	 ue4icUTOKKGvknJh17evGVAi16wK0OwlmuqW/GB/C66sRYuLwxWybPhebk5AFVoAqx
	 tNeMKvjpBdGnmCYtSi89KY8NnRusUmssAbryOXRsHik5jPguwZvMxdF2Z+ZMiSnINo
	 o78uAcKMQFED7n7Tmt4snqjdCJMN4iTEkFClvVoBN6h26yN1Mho7EFfXiLmo3ZPdg1
	 klZT0Xu91SuWDHrES2FckSJwBWPm/UEFbETF5h0sDfnoIZr/4Qhd7PS5HzqAHFcx6m
	 SKMDagcFee7PQ==
Received: from webmail1.uni-tuebingen.de (localhost [127.0.0.1])
	by webmail1.uni-tuebingen.de (Postfix) with ESMTPSA id 4822560AE18E;
	Sat,  7 Nov 2026 23:11:02 +0100 (CET)
Received: from ipservice-092-209-235-033.092.209.pools.vodafone-ip.de
 (ipservice-092-209-235-033.092.209.pools.vodafone-ip.de [92.209.235.33]) by
 webmail.uni-tuebingen.de (Horde Framework) with HTTPS; Sat, 07 Nov 2026
 23:11:02 +0100
Date: Sat, 07 Nov 2026 23:11:02 +0100
Message-ID: <20261107231102.Horde.VTLAyGut_WGch71PWzwoxG_@webmail.uni-tuebingen.de>
From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
To: linux-rdma@vger.kernel.org
Cc: huangjunxian6@hisilicon.com, tangchengchang@huawei.com
Subject: rdma-core: aarch64 mmio_memcpy_x64() ignores constant lengths, and
 libhns relies on it
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Disposition: inline

Hello,

At rdma-core master a70151dfec390eb5f7fc5b266f51d601da2a7778, the
aarch64 mmio_memcpy_x64() in util/mmio.h tests
__builtin_constant_p((bytecount) == 64). That is true whenever the
comparison has a known result, so a constant length other than 64 also
takes the 64-byte path and only 64 bytes are written. Both the macro and
its libhns caller came in with 159933c37450 ("libhns: Add support for
direct wqe").

Run from the repository root after ./build.sh, on aarch64:

```sh
cat > t.c <<'C'
#include <stdio.h>
#include <util/mmio.h>

int main(void)
{
	static __attribute__((aligned(64))) unsigned char src[128], dst[128];
	int n = 0;

	for (int i = 0; i < 128; i++)
		src[i] = i + 1;
	mmio_memcpy_x64(dst, src, 128);
	while (n < 128 && dst[n])
		n++;
	printf("copied %d of 128 bytes\n", n);
	return 0;
}
C
gcc -O2 -I. -Ibuild/include t.c -o t && ./t
```

Observed: copied 64 of 128 bytes
Expected: copied 128 of 128 bytes

libhns depends on this. hns_roce_write512() passes
sizeof(struct hns_roce_rc_sq_wqe), which is 32, and gets the 64-byte
direct WQE write it needs. Fixing only the macro would pass 32 to
_mmio_memcpy_x64(), whose size_t counter then wraps, so the copy never
stops. I would fix it in two patches: libhns passes 64 (taken from the
function name and HNS_ROCE_SQWQE_SHIFT), then the macro checks
__builtin_constant_p(bytecount) && (bytecount) == 64.

I ran the reproducer with Apple clang 21 on arm64 against the tree's
util/mmio.h (stub Linux headers): 64 bytes before the patches, 128
after, at -O0 to -O2. gcc 13.3 on Linux aarch64 truncates the same way
in a copy of the macro. With gcc 13.3 the patches add no build warnings,
leave .text unchanged in libhns, libmlx4 and libmlx5, and change code
only in libefa and libionic. I have no hns hardware, so nothing ran
against a device.

I used Claude, an AI coding assistant, for this report and the patches.


