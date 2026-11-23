Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442787;
	b=R3n6dwK8JC/yuMqYXKBu9fBqOqMR0qnNlnB9tdxmsTJYJ8m1cadYhI5Z6N7p99DNJvSP
	 N4Lb9lQ0fZOl440RDuYvOko/+Is0FXDtfbl/76T/3pS3s76VGVd5/HGx8ons8Zz2BJNGr
	 VeQkGBbWAd8wQhLvrmnoFBw0ARMebEkIaPYwv/rzByrwjRgvKglHUSvd/VgmIMlNnpkqD
	 lB9aaElEIHqfSpODiwriSRe3bkWgOCGiRF5HgBYXWtcEku7WF9MwtIosrgTw9DFmdYogd
	 GAaZxtQTLD/RBiYznn9m/C5NMLGR2muJ7EY8tdlrbAUKPiTzTtH1OZ8aquL2FWJRO2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442787;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jrb5fUsOngtPTzC22BJAsemxm+H2DBi4a3HxR8uh170=;
	b=U+iqxQDyYMI5lgEv9tVKszwBRHps4DcPkk29li31FNC9c5hylcmKkxDlV5f22bfZ9NuQ
	 un8cjVLSmzY0ntNuFm/sCm57PwwAnwauuCwzOKnfmlExB2nf95RFg2P1H2eH+q0sYTjlH
	 CfBN5Zbf719k0rl2dYZYsiTSdpVnwafGtchO9emlye0vtvAlqll6wCSL8czBUGH98PKGt
	 NwoyP+Rd4gGFQiZJug7izT9le0zsHuSCChfGbYQtCOiCEXcMFq9DvjrThIgzzVe6VTDSc
	 QnYfbMPw/CXZclcEx1yDZsd9ynhHm7zs7ptzmPwuzBiH05fK9EAaJA0puMjCxJh7Pwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y4yz00N+;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18C606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C18C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y4yz00N+
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55bd96affd2so57499971cf.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795442785; x=1796047585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jrb5fUsOngtPTzC22BJAsemxm+H2DBi4a3HxR8uh170=;
        b=Y4yz00N+PbrIRD1bJ5rBgnwNetfiXb7ub1BVy8U2gtjlG/C8Q+4/HiPM9n/SRbaY0K
         ZVccXyuWhr/x+xpBJXeCk3htxdYzvSyD8I2hR/10pThxxNF2uQSWwjQ3LJk+7AZPaIUd
         4GkS44HmnXEsDoVSGLEXiB3dOvnkungB0Jw3rx9Gxi60bbwCs88rRmELBJRqwiN7bt1H
         pbZL1X/XuUKOkn5c06g3IsoRtITna9Tv/CS5yXRjY1EVTjTZgqYYjHWVqArkc8JRS+0l
         ss3nn/iGsExctm0nh6WBgpIxyVrgI+fVbCAyPPIjwzNBNwOoL30rZCt2XDhahYyz9ZLP
         vb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442785; x=1796047585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrb5fUsOngtPTzC22BJAsemxm+H2DBi4a3HxR8uh170=;
        b=DQKI7d3EqkPGvCg6jZf9OGANcP5QLmIVtzZwYfluSqKwI001dMhvwrjfpWMbhMikuQ
         tgh2ulq0DMMThutMjvCKgTXNthx6i1FonzULv6OpJ7TTKX14sONo5SoF7cKjnXg1KpYs
         ZPbYEd/MD90U0Mr2TberBq9zldU04aT3vgushhEzwgAkiZPMwyMviPkcJ+xs+Xn90GxJ
         x/j02cJeEDEonPGQq2UJsX0Az5qkyvFfMBxV80Ec+b17D3DvLEb16RXkorHKPf45OwgA
         BYaaHsnGB0swAeqcrLlwqjK1da0HOwp2X/s9B21l5hrM99eSy6GVHsiG3+7ZmR2yQVXI
         xOyA==
X-Forwarded-Encrypted: i=1; AL+hErFLqOC4PkseerK9E/5RTgvMgb8gVoj4zTSqlGqGrWjAMmcS+mgNRX1e/AQ+KiD2OSqAOJaVNCeyynON@vger.kernel.org
X-Gm-Message-State: APuU4Z90eUtzA9qSVtS7SkwsJSo4/xZ7KyHOmP3Hpi0IVet+k0B/e/O2
	UoYIdL+/wvQ0QgwE49kSymBkD5VVy1X9kTV/KYxqH79O49f/yXhi8fUK
X-Gm-Gg: AZFdTZdNpRel54F2pGucI/MlY/Bqjf9sGC07T9ROd5N1ivjaoy8REWGz5E77IEj4pN1
	iIldZ3oJ4vl+9g0QW7+vk1a9nCIrm+iuhE7S4FurvS2paNELfVw23N1+YjlXaV1x5EuA5cEpb4l
	cJ1EoFjEBFZvMoj9wOFYpZ6CW3Wo/BAaMdRNxfwHo7VL5gkE6fo9qj8iBLF38CxEkFdjYLMjK51
	WfuNDSwZ6Ptxq4LvOd8/LBd2J9WYeYx+7DQ1NMr18guKgN7juHhdaM/9O3F8qYdn3pbiBAtiEYO
	hFiWwfwkv38JCcAMmBwXxBgD/qHOVg7x/MuAWktxwBYQwc344NpcZYgbkG1l5J8pA2E3Xw0navE
	Pho4hPGjOTNQxtEWX+FLr7FfRmHSGR0I1+Ip9VwnRZr+0Xg7Td8eYjQQ1AiEq0qT56POIMVaudY
	168vicXJm+hU3128g7TQMQDCFUx7cbRzqcBWHYgn6+OpK6ztinYzCw+d1JhdDgTBapI9wc/k4Rs
	qYt9SON4cwZsjtleqPnIF77A80WjvkYXoX94unI8YB2R84ftAVlWZRRC2V8iigOKkXBINixbWeZ
	nU0L07Z4OK+8FqSec/sw0GKr5Ol15NSLfSrFjDv5M5zK340hSVtWwgV1kISnQpr3CbhRNTxkLvd
	ne4o1Qs39SXqGGgItdGMQ5BS5TuFtl2xPU6zjPE3NciLt5gXXYV/r0GV2O7XAexgRJfX/HDI8PZ
	axBeAxhUcpNKjmld+GYd7FbrcRg3k=
X-Received: by 2002:a05:622a:1aa8:b0:55d:2737:ccc2 with SMTP id d75a77b69052e-55d6fd24195mr215979821cf.34.1795442785163;
        Mon, 23 Nov 2026 06:06:25 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c1e4:47d6:99db:6f6c])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55da87b3ba8sm3313581cf.1.2026.11.23.06.06.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:06:24 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/rxe: Zero struct rxe_mmap_info on allocation
Date: Mon, 23 Nov 2026 09:06:20 -0500
Message-ID: <20261123140620.64393-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rxe_create_mmap_info() allocates the structure with kmalloc_obj() and
does not set info.pad. do_mmap_info() copies ip->info to userspace with
copy_to_user(), so the 4 pad bytes of struct mminfo come from
uninitialized kernel heap memory.

On x86_64 v7.4-rc3 under QEMU with init_on_alloc=0, an unprivileged
user (CapEff 0) issued 300 CQ_CREATE ioctls on rxe0 and read the driver
response. After the guest had run ls -lR on /proc and /sys and read
/proc/*/status and /proc/*/stat, 101 of the 300 pads were nonzero. In a
separate boot with slub_debug=P, all 300 pads were 0x6b6b6b6b. With
this patch, all 300 pads were zero in both configurations.

Allocate the structure with kzalloc_obj() so the pad is zero.

The issue was found by Claude Opus 5.5 running Quality Playbook, an LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Sonnet 5.5 and reviewed by me.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
A reproducer is available on request.

 drivers/infiniband/sw/rxe/rxe_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index a4ead89cc..ac851f245 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -102,7 +102,7 @@ struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *rxe, u32 size,
 	if (!udata)
 		return ERR_PTR(-EINVAL);
 
-	ip = kmalloc_obj(*ip);
+	ip = kzalloc_obj(*ip);
 	if (!ip)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0

