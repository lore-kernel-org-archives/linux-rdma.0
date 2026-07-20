Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B18478E20
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784572278; cv=none; b=KLNPOknyYA3PR2mVboDWGKc5Mpifle4lstKeDY9oPME0p1K+POsTgkTzNUcGJXRFmKsxMHvgr+6PIEuGb72uqwEFdCxwijG8ddIcUAxXbC2Upxv/oynjq//WvkNwRSdpYbRWakROmPMwPbZPWGw+bC79t1Tyf3XgbADlkTjYPSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784572278; c=relaxed/simple;
	bh=tpIozQVuFz5YMT+/KaMPSJCm3XJPJ31NcVTMY/bvGWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN0MoVyoU4mHF1tCxGQvzUDHAYknN/F3oo0BnNtnV5RTlwQZKCcHhI0mSs83d4a+0YmfMKxRIpB0/hW3YoUMNCmUmN5d3rhn0Q+zM0k387y5OdKPBr2j3YNJ4KFEkV/8eZQy9xYP/qMdHUF6YjCGAH+/7wu9gCoaxW4ZKuSsMUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MWxEndbh; arc=none smtp.client-ip=74.125.225.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWxEndbh"
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-49242309566so20708795e9.0
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 11:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784572275; x=1785177075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K4HtwqqTFMH8KE+qtT7AThKAONYzcCFlt1fLH9nHfHc=;
        b=MWxEndbhXJa9KqXc2S2VfU4w8JM4Re+y1k22hJvpwE7vPlapvcO1FjJvd3K1CoCCC1
         5q9Y9aL8BjtZLsn3sus0bbtqt2F9GFgvXoFD+WgbFuWpLc47aixmCo1RPHBjJKdqp9RO
         Clq8TaAlxYoD7AG4aJzCipTICWHF8RcearzNBg6h8q7zP+akOalYUz/8Sr91xQjHLoVD
         SrgvIjRvWdd6QdrCNQEngcqORSb2JvOR3CbiImUSinxaCTyv0/HpoOW/J5V7ONrMhxeH
         MKzBooWHSACjWCtXR+ykO5eVJXlyGG5tpuEtuMaeRb0xWjXcz6QDUx7XRDJjo9C+nybb
         XQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784572275; x=1785177075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K4HtwqqTFMH8KE+qtT7AThKAONYzcCFlt1fLH9nHfHc=;
        b=a1AtLc7tmlziyK9ov8J+rxyFdnv4pL/cigFSqBnKM/Qyeb2xvpsuxKgxIzweqIztGw
         73ydfi29I0FSzsLvBy9Jrh+ubQNs/Qfq1BL9fF9mTuBLs7Q4ZD4TD/sh6rqyDDG4W1Gt
         KF7r3ysAba3KH3i3mQWXezSDjQ2r64Jtf1S1gxQX5i/rJ3NGy/m9kZacuBGFXIU3ppUT
         1cEqzOQkt56dVWRz+SPgsq38llzIbWdnV3F+lP5DczdMuUHZDSHJaBExUSCfTLtTJI9H
         itP2OS9soOicrOc6fpfTYwaKvvmFASmOhMcSbvqrc8ZqisQdNOZ4vUcQItb7HUpMAWzh
         5QdQ==
X-Forwarded-Encrypted: i=1; AHgh+RokEmRpC84c0GGswrUwEYP90ypqDrhVwOFU7eFWMpmBXM2kp6hDpXtPgudwTHxfrlHw9kBaoqTRqOXp@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf5Rqsy4BdnmXZ/kkgBn6zaFaD15/ELrd6As8N+5uEMDvhJeOs
	7B+eEnmtC9P5oJIa+S/lX8xXiKC5hUT+YKSIPupfC6M6XvrjtVGEjAED
X-Gm-Gg: AfdE7clQrauCjb13bdAqS7juMW3I8pcQX3hlVofg3cOrZbSXuIXbLBO9fQmlT5FnHc3
	Y6QMElgdiOlMbZbF3SmcQWKP38WsulGIuPd7lCOAAMJxaaFUGfg/8449yHxHtauTMqx7+3JMYu3
	wVmaxK1YF3YV5WQMobtpNSCU0/nDWwCjLndE7R0ebaq0/MkIVAkV/M+m3M3FYPFjm/IQREoK8OC
	VfdYyJ9xsO0xFl2Ck5KXuze7VnQoejyknN6lNqjT+OaTreDJK1sr8C/AnI47CbjAKgM3Dd/fJB7
	Olj917jTDvpua3QpD2cN9AZBaDeukh+PXRGUy+opU0hIIu7WarQdtdNJCfqOe5ta155s5WzDf78
	9zfnOybz1ZKsM+5IYb/COcKEVXHj9G6zMOD46wvCvmfNr9Vp2E+W/SbJtC2Pk2UjV7M4nWUAtLi
	Xtbg==
X-Received: by 2002:a05:600c:4ed0:b0:493:c634:952 with SMTP id 5b1f17b1804b1-4954a3d0872mr170031255e9.7.1784572275277;
        Mon, 20 Jul 2026 11:31:15 -0700 (PDT)
Received: from fedora ([212.253.194.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956546db7bsm6468745e9.3.2026.07.20.11.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 11:31:14 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Mon, 20 Jul 2026 21:15:51 +0300
Message-ID: <20260720181551.30322-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <19670ac6-ebab-4074-ab4f-3db06e1db291@linux.dev>
References: <19670ac6-ebab-4074-ab4f-3db06e1db291@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the trace.

> KASAN: null-ptr-deref in range
> [0x0000000000000000-0x0000000000000007]
> RIP: 0010:ip_rcv+0xeb/0x570

This shows that the failure is not a deadlock, but a NULL pointer
dereference in the IPv4 receive path.

To identify the exact source line and confirm which pointer is NULL,
could you also provide the output of:

  ./scripts/faddr2line vmlinux 'ip_rcv+0xeb/0x570'

My series does not modify the RXE IPv4 packet-processing functions,
but it does change the lifetime of both IPv4 and IPv6 UDP tunnel
sockets.

Could you please run the same selftest on the same commit and config
with this series reverted, and report whether it still crashes?
