Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794956107;
	b=xYKWd9I1dy8koo6dnaFLIEJI/wJoEsAix4vyczj+ScvvdLylH7CAumEdvUDZ/tbWBzSY
	 d4sjMCmN9IlFC2csJTaR+4YMFqBBm0jWxrGotgPo7dlFb1cPImFiS6x4ajklaMdYxph1w
	 Mlwzo/0gEcyVAxdQWDhjqowAo9UJKMDAHfLnV8m/Rzwn/wxDNRFoEUabV8tsq7C2di0Qn
	 dbwchDdM0mw4+gttoKlowImu9HAiEmJTthk7pWymqyCONX1DC+XBzyb7MJpYDQbUQif7s
	 ADsXIwiaiodC8E+7WNHb51mwVl2bcyhx/ua9AUJ4FWjfR0exmJBKyj6MyMsLg98xhIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794956107;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=XTWULvHY5M+9jFlLZATjLnhYmcapf/iX/XpM8N+MwzI=;
	b=GwWZ04QtQa1OKxKQA39+LK85ukQ2vjxCcfsgaAmcPTVfhVvF0O+P5HXOArMky03O1WB5
	 l/byExNRiSWGVoAOSZwdN0vYvJgix687beXO1hkb6aiPjxJAoB/HtsfMiWGFgxhtEOPx/
	 /qmSYHvPps8vsvjevq4AJLFzIhfR5eObHJIqlHRd1sHULn6xcbBQctwavKjTsYuT2iNCC
	 b4fAdmXWDRbV0saa9d+3LP3LJdQK2cZViYRac1N/ueQuPdD86QlQM+06mHDGbei7/mehA
	 jBWMWyjU8+vTreIF5P8nT3n7A2Eq+sqRYyX6B0XjN7bTWvkzP4YzvczrVfG8NIFOwNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NPDWNUn6;
	arc=fail smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A212A606A330
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A212A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NPDWNUn6
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHMfcIN1537444
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:55:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=XTWULvHY5M+
	9jFlLZATjLnhYmcapf/iX/XpM8N+MwzI=; b=NPDWNUn628COc0atYZ/CbMaWxG+
	0TNGfxRCGsv1WrYANoIZaC+tKoYjD5X8kNmyXR8dpBZayuNDuuUCja+hWrjMqbQc
	XxkpdvsWiVArTT9UJfikfZbnelRb/DRpVlYgtxXFa3XtPyVF0540TWjYmvrsqO+P
	R+hi3LRmruY6Y/3r56HGQKoFy0CaepMpMmZG4klMBviT1U+1fEaeySnvKUF8n+Z1
	Wfi1IZWcGzocGnaz/SNYLQqLT3qgJR8XlBsQ+qKgyEYQQVpJE2NW3vnlCVKHFSdC
	M3nFonl+TButab+DN9Vmtl2UIUTzMNzzvKDIVO34G60V2AXaydz6Pdka2IA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu5r5ux-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:55:05 -0800 (PST)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdb8931aeeaso184183a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:55:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794956105; cv=none;
        d=google.com; s=arc-20260327;
        b=cXs+pcOLQuC62QMKQOXtY81jYl/ChhSG8k2sKLqhWqhyKNqrpuN6PgJZjQnj/UxnDT
         w7PcjuWhYaN9FRCJld8BFtWZxGqkxltegwOvMXURlJ7p8eE9g5fPlIK1lAFSzxSCQIvX
         TO2khMXbXjEY8xCI4bjYxjo2r5HQtAgkPrHQsx9zl6wr4t55OMtPa5BmueSmO9m7VTyW
         i+nWESSdCr7NZn88/NWprbIRsCQB7HHWphZ+Xvjuwwu/Yvo/3WRnrDF0yj7QynWd7x4/
         p3X7Qh5ld7ge7om51ioO7cJFfrgyOAFPhIYJYEsC4OXurJSevX9ZmY1q5fWKb70YTiJV
         d3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=XTWULvHY5M+9jFlLZATjLnhYmcapf/iX/XpM8N+MwzI=;
        fh=pbZCQEPXz1q3AOpyVYzQZa7yE5I2EPVRaHUBorFsLFA=;
        b=X7JZLEjS1E+XBP75R/OP/v09WCSpebVoag5GBa4/+WTMRB5/CH267KrC5d6Z2Sw4j8
         nm8KETsY/SkCAZK/CxlgDOu3Q2zW4hZ3lv8XmzKElJWE4KkmUNZ9x/2w+BP4IWICBfPw
         2WlaNVxK31z5Im7SGqi+hXcX2bt6rapOJ1YLId+ZT2L127wbWtv7HoQY20YBYPiMCzLY
         CCoCS7eif4xJFOpx95gncIrvkeVlN4l6MykWvD7Cyp80csj1mSftg2zZ3SthAVZllTcS
         M+CUr7+IOcIv1NCmmBrmZOoRdn7PXhL3Xute+hmiQ1y0ukiounSDw64QCA7FfWXJDBdt
         O2iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956105; x=1795560905;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XTWULvHY5M+9jFlLZATjLnhYmcapf/iX/XpM8N+MwzI=;
        b=LriTmEovmBctYOA2sH+2YMy5L5aPc6Eied/JhCDIAzqlKv1ON8UbRvcyfdz5eyRhfz
         yAKoW2SDCdf9Pqm6JIsxhMTOFz0swREiKFWR5KZhzN7RxZDAxM6iD7YcVIDjbfiMj7Ki
         t/HSqlxmCvommPsTugn636OwdCCHXJLRe7pkIvavktouUwOQ0CiQpiVzHhkdf+cmTOQE
         RxsWdH2mquHjec23o8SIMSXayAUL3lTyiFAZMp2QPyQccAcHZe23492neVY6xXek870K
         VaRrEeyQb/yXaef/6ZEUMKkoXmL6F7jFTAjx8qXBNPqvFvay5EWlY1OzxHvEnyvYYW25
         V+2Q==
X-Forwarded-Encrypted: i=1; AL+hErHJeadqMnyOu4e85a7R0Sp6g5hXyzKHSgggHWeB86qMm+XvbSzcUJwsAF/wdIcvfvbowkl6DR2kHrH0@vger.kernel.org
X-Gm-Message-State: APuU4Z+DCTaYWIqclBvEUV80KFPgR4Tp9ubzTv6orwpFpIxFtFzPpntP
	scJDGk69G2L/QnVXR2DV32rgelD+3C+dqB1aqJqQhvogQd6G6R/hnmqJ8titnY1YYddIvM2iUVL
	tGks4ey/CacLwZ1xRyDMVkvVU4Kl91MctpWmkDtAQVO82NAuIyFXfeNsglsReaAhio72zDaSbVA
	6I78iYfSJC6yOp8GJhE1vlPQ0zhJBzHrHRTsIA
X-Gm-Gg: AZFdTZfEojCxZml109Q5FXN1CVDej/FAz29trTse5uCqW49dphbcWA3ftfHSZYk1zgj
	fd+gLpRkeM6XXJ3NmH/SEfIjlAw2vdb12xDNzBUlIARGEmyBJjr9GxMj+1szkmxFd76yxawP8bk
	Ulr7eNB3FHgl1DNDKDSDAR1f879pOt/FZZbuU++aZ3CIq3dFpOi/eeeZlVLn+gGfUlmkicgdffY
	ZsoVnkPIvfVYwpLUepoEgbWQSVzOOzmr8RXVxHxwBomUr1G/os=
X-Received: by 2002:a17:90b:5390:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3b3d0640f3bmr891169a91.6.1794956105267;
        Tue, 17 Nov 2026 14:55:05 -0800 (PST)
X-Received: by 2002:a17:90b:5390:b0:3ab:2d17:51c5 with SMTP id
 98e67ed59e1d1-3b3d0640f3bmr891106a91.6.1794956104611; Tue, 17 Nov 2026
 14:55:04 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-11-toddfreed@meta.com> <179471270629.2199510.9480561958902023552@kernel.org>
In-Reply-To: <179471270629.2199510.9480561958902023552@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:54:52 -0800
X-Gm-Features: Aa3M54pEdqPp10DAjnIjgsYaaHWMRisY79HeZKYFQbRbnu5DENxcJuo9y0o8SvU
Message-ID: <CADh2yMxPrJZNtVdCgQWkHsKBk0cnAZ-0RiVaCMquQNSH8K32Mw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 10/15] net/sched: flower: add psp_spi,
 psp_ver, and psp_dev matches
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
        bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        john.fastabend@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, martin.lau@linux.dev, pabeni@redhat.com,
        saeedm@nvidia.com, horms@kernel.org, tariqt@nvidia.com,
        weiwan@google.com, willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA5MSBTYWx0ZWRfX/mqAcrL1HB7+
 gxlKYOlRUDFuBqAjwwED9FdEHXyhbmp8ewYpYWRBnewT0CNLH81qVyJxL9Moe7x6YSQOoH6vvwt
 ENV9HX7HFBPk4ndd7UGEN6Vh3cLqQjM=
X-Proofpoint-ORIG-GUID: n-jez63BiCGEN2NSj7fG35g9DWRnskbp
X-Authority-Analysis: v=2.4 cv=JeApPkKV c=1 sm=1 tr=0 ts=6afcdb49 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=e8l9bKk9WhIOE85pT1MA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA5MSBTYWx0ZWRfX+CrW1vprQ0ck
 7XIenlpWV2po9/xc5CBJ1RuHJysOIVo0dTN93Yjk1oVsqqLZuLe+F2AUGlCMBXrRQgVYHl7FoH6
 jwmpzs7y5oqumzLvAK3bGeygvWO2FnGnpB/+8BOEQApbELj0nsIUawxWkfLiJNMP0os2tggqTE6
 /eakJQY68xQ9+Uuqb8os+ew0xg/TbdiLDXOiL9AkMN5Lsr6YkoTpzFDV3UT8nKQoANuZxv/e348
 vhsx8ZxhzoAWM3MgjDxSCTEGHu72cgyK12/zmnv+OTjXW5y3Mtn53+GAnZi/zh+gi+SI+RPs2r+
 ZumiyproK/lhrYgieUjTT7IoPm+Z8ictXuW+Lmh0XdGSzEzWeoNdLsYIY0bdeHZQ6p2tI5pxlrm
 2t80ijKZGkuZ1gSOcqcsqZ+ahIPOGjLEptt460YM9nruA+yy0QHRluRIifvvj3/2vCCGKZfiF1E
 Ky+SLAK1v2JZLHAftGw==
X-Proofpoint-GUID: n-jez63BiCGEN2NSj7fG35g9DWRnskbp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_05,2026-11-16_01,2025-10-01_01

> [Severity: Medium]
> Does the commit message describe the right failure mode for rules that
> are still installed after two key rotations?
>
> The commit message says:
>
>   Together these matches tie a rule to one association, ...
>
> and:
>
>   this means that a rule matching packets that correspond to an rx
>   association which is stale (two rotations have passed), can still match.
>
> The "Socket-less associations" text that a later patch in this series
> adds to Documentation/networking/psp.rst has the same gap. It only says
> userspace should replace such rules before two rotations, and it repeats
> that the matches tie a decap rule to one Rx association. No later patch
> in the series adds a generation match or any enforcement.
>
> Could the commit message and the documentation say that a stale rule can
> end up matching a different association that reused the SPI, rather
> than the stale association itself?

In v2, there are no Rx associations. It will be more clear that matches tie a
rule to a SPI not to an association. And the reliance on userspace to replace
rules before that SPI could be re-used, will be further highlighted.

-Todd
