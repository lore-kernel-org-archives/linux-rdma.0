Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794732638;
	b=JnEkXFmZ0nBH08/nz8X2Ili6P2u5vuF2+J09Asbq7OXfJxyQWR5tVsv/iJiO+ST6o4B3
	 SkXLpW1oHiwzTGdwNhiJ/9dWj/wC4E3OVFathrRSCDtmSpLtLathxLuOmppNgvmSmVIEO
	 DVWgkm6SNHzTfcW+7rpt61/HFuR6yZ3V9+sPYfp8OLVQNDDXKjFfQxLs36n+ff8w511UE
	 Nb7iUEfVOhW6hzhZKaf8Y7TmKimI6sGEYDmCz8jEbWjdeGTYTaAMuojEhXa452E7MFEeb
	 WlewnX/M1Qtnm8kzBJ8japIaNXSH87VTWN6zvjj18ZAofMnaoWdVKZjLobzXxJt5tAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794732638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BSudoDAzqHaGR189O1a5tdJwfEHf52x6doylx62juzI=;
	b=VhytWLiyIUh6XCOgdqwHTTNWOWF0V0N6/Iyx1TBKiqtMFMU/4f10LYX7gaAlpevjDzuu
	 jfhen1aOv3ic1llS6pNPej25hVeNEpHg9yAUkatsYwgY4yj656Zr0dN3353O473zlCuDU
	 +DnHiXuae/tZBcpWK85RhQMwqbT3D+ECPL6t/n8D0H/rF9i4+9zt2gtxo5IEn861S06YO
	 6AmDk64qf5XOksyXbQ0Xq7cNAQiBcquCvbQZnKkZ+NRv8NagOUoIj58gKFnWpuwTYvon8
	 fplpktp7U1uNud7qRp4JSX5vDXifRZMCxo7lGkFLjbNLbVk245Qr41VH1XiSu28I4Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wAFhHn99;
	arc=none smtp.remote-ip=74.125.229.9
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF6B606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 08:50:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CF6B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wAFhHn99
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-377f12217c7so2567809eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 00:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794732637; x=1795337437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BSudoDAzqHaGR189O1a5tdJwfEHf52x6doylx62juzI=;
        b=wAFhHn99GgnWRUJDBbEX42Qy7iXWej3j0ODFz4q2JznoTF3+T/EnMGL73tTr9z9d55
         1AlyN33Y8XKtG+3Lzb50b0276Ly4YaAnQ247xrCrU4xp4AcxwGSCrTj9COEvLdZ7nasI
         IuIY/GyJQNwHkI7ahQKFyr3zcJ4gYxLoNScr4LzmByFDch6qJSEfoqNwNBLCICDQfY3e
         7RUOKI73FR0PXUli98bOe8SY6dCGyfQw3ZBIr8OyBZlwSV9DTrLJoC1an0rlDQvxRG6K
         qpaPrFySrAY3Td6uzmWkmJMcQK7VPVRgUTlf24peGAdW76eqH0dHvKOyFI/vRtPm7WV5
         Yg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794732637; x=1795337437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BSudoDAzqHaGR189O1a5tdJwfEHf52x6doylx62juzI=;
        b=LojzUsb5+KWu3+5lv3A2rbzhPS1fQbSaMtNTZ4+vbSWtecfIJ6hlZ/m+xfE+V45z9g
         zwqw3RvrzVkK1mjacY8Xh4L//KFRSZNLoKnjVYoDx0EIBI+kHFx9kofpPwFL9SDGmwDQ
         lLYJV5Z2MBqn2nVuk9XTndFVcdPltmdHSAcwyBJSDvAEIfxlsFYQnTO1KcnjyWZaN2SM
         4W7uW9f1HhNfOtG0pP0bnNCzLy/RrlnkKId2dKFdL0yW7Kjwk50oTfrE0WbUIx8P0q81
         HMgBf5F3UaLJZ+/WJSiXNefWHo7CJ3oN6H2wR9jTrO/SsenrXgYunvsfv0lAV7zFL4i4
         I4sQ==
X-Forwarded-Encrypted: i=1; AL+hErEg1V3MTTyCCy64bHcM0epfP5JatHKVshWfvhha4FQtFzcnMCS7xECkAkTOITi9MhAjVzfZCPGmjhSd@vger.kernel.org
X-Gm-Message-State: APuU4Z+IRlgLCT69a2l0Hg5OjKCZCMpkCEwNizQ5zpSp+9TWB6jBEU2s
	BeZJefmw+zfyHp8L7yUhh1r5cKUiF4qWmW+Ts9TzuiF4mC2DIN8ZzNTZ
X-Gm-Gg: AYBFou0gxdyZkfWz8VPxzhFzJmWtp2eIccTuvfwVRW/HGjEZAFHCB/XfA+28WKBIvVH
	6SfJhNy0OlM4BfZ5C2emRTM8BneJpgsfHRNNyHxSBcFZeceev6AMTnq43+2RGcjYIivF7qhr5Cr
	Mpj75eOMg4w91KKBGkC2rTHEf7Mz/vdTWf35vf56t+5ANUS5r6jQditbK0QFl3WhXaa+JzUoJSa
	ph7proAAO2qYjyh3I+OzMUfTQaYX4DAt9n/rF4glN83I4OWBhPwYW8KTSJ1ohR7qaVHP2CvdhCu
	sMhiWTWYC4kba3cMl+JIsJg7fA1kZddzJBUu8tDGiZAqiPmanmKoxPfN0Je2g8RMeQow24PR3i9
	HIyzsS8kul1xDMTJSl/OuSlfcCYIeD0nlz5sEEzfnIs0TkfLd8w3igQ+J6baUfWejLBYhIS64QC
	+nhJYhissWcp3v4KlcKxxhpQwMbQ8evS4jOhIM+DLgQ4oupQn+SpGdc31NMY5xRyc025SrBLBLr
	La99ZZnlYm8Ivyq8MPzDIGWo1IuFaI4pi9C8ObqCjdS0soh7SwL5CfRGMpSpv6RyDaeSBGVt33M
	rEIgXhJaQDe5U5OFVhiVhoRz23Z/rOwWGoQ3CRm7Bc+ltdoRJeqct14GDAxzS6A5e3DdZFaEWGn
	jrY+ls5+N7YWOnXlVrEplfi8a3WonTbaT3ZhnfA==
X-Received: by 2002:a05:701b:2092:20b0:193:9aa3:474c with SMTP id a92af1059eb24-1b5030fb812mr8000339c88.21.1794732637137;
        Sun, 15 Nov 2026 00:50:37 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm30130933c88.9.2026.11.15.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:50:36 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	raeds@nvidia.com,
	yishaih@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] RDMA/mlx5: Fix cntrs_max_index overflow when binding flow counters
Date: Sun, 15 Nov 2026 08:50:25 +0000
Message-ID: <20261115085025.53203-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

counters_set_description() stores the highest counter index supplied by
the user plus one in cntrs_max_index. Both are u32, so an index of
U32_MAX wraps cntrs_max_index to zero, and the entries after it can only
raise it to their own index plus one.

mlx5_ib_read_counters() uses cntrs_max_index to check that every bound
index fits in the output buffer before it runs

	read_attr->counters_buff[desc[i].index] += ...

With the wrapped value the check passes whatever the buffer size is, and
the entry with index U32_MAX is added to memory almost 32 GiB past the
start of the buffer.

Reject an index of U32_MAX in counters_set_description(), so that
cntrs_max_index is larger than every bound index.

Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 1c25b825d0bd..742bb10adc57 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -1038,7 +1038,8 @@ static int counters_set_description(
 	mcounters->ncounters = ncounters;
 	/* each counter entry have both description and index pair */
 	for (i = 0; i < ncounters; i++) {
-		if (desc_data[i].description > IB_COUNTER_BYTES)
+		if (desc_data[i].description > IB_COUNTER_BYTES ||
+		    desc_data[i].index == U32_MAX)
 			return -EINVAL;

 		if (cntrs_max_index <= desc_data[i].index)
--
2.43.0
