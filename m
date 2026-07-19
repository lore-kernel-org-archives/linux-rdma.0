Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEDC3B2FF1
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484840; cv=none; b=HLj+euWu3qCzzU13v2JqEcD0eNzZU75R/Xrn9M6kc7iaYFE7yXYyeU0t0PSh0grN4zgL1G7SOH7yFExaQ541aNIagWzkJ8vT5jXlmvVskGH3SZIuj55/r8q5c+D47gS9uFH+uitQOukL8hPpKvYoVxeSluvoeh4a7e2Iro3w5tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484840; c=relaxed/simple;
	bh=3YWMa6Tdi07wjaonknTwQWF1etydIJ8Jvb8Tg47AmrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7PBiy2K/sKQSoHzkhgndEQ2EwyCs8YHDpb5Kf+kmucx4sdsdVP/lfJNaa6EwTilBkapVKo4mo46Ip/PKYzKTB07zYnwDgCLX3oa1X7YPO2+4sBGLVuy4H0GOubl7UDpDJVRKEZrF2WS33S+Tqznjoy88GFiPTyxye8NDEPZOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLEKygbz; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLEKygbz"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-46e260f9e57so2072864f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484835; x=1785089635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3YWMa6Tdi07wjaonknTwQWF1etydIJ8Jvb8Tg47AmrI=;
        b=XLEKygbzGvW9h2KimbCivMFs4cWQTQ+k1otEpyL6zLCb62y3sDoLQd9m5ukjdmD3/U
         HV0Cn/qcpRuFE1Td82yuqGTif/Zz/vUk9D6VCdFfyK669SqDTc/fuElWxXoCpE67qi8S
         GpMJ1FZl+WHe2MVVz7/aavdk5y86ZCyeg4ryifxvU5u7c4CE7FSkQuNCkIbPq3cVzplI
         Zo60nraUXd0BeIIWv+XdjRU6GUfhmziCdMQlT05G9LQsgOExfIvHQJ5dGEI9PMDx4jjx
         qUqe3sM8BCAIGsFwiWP7isp8aLS6/MwiRiusIH/J1YoRAZEYZzNPmwq5U3B3/Vv/Npgd
         gd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484835; x=1785089635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3YWMa6Tdi07wjaonknTwQWF1etydIJ8Jvb8Tg47AmrI=;
        b=gXwl/08Ec5uJiTgvrbzDSzLIltiDCel1TVt6rEO+9Y3ob0aDdv7KjKQhseJjzrcw93
         w8gRaTXFJZdgurc8/b29g9XJ5gWoEdVKAPrzFEeqfrRUw1lrFlGtg90N+Ah/3YtTJANv
         ENpQkf/mWS2qte8tKuuF7zLkGinIa4NtxXqWZE78/2j1HfqhxISej1fhxnkur8ClGjK4
         J0IKAztNX74hG8s0Vzhe6PtgmngZ+jDFCe1dDda2OFNNckfXlpzouNX/NiD27ByDfPRY
         ZvcHgNhuVjF6xg1OMcCjgC07DylGC9fXFbF5DeyWZ6DGy8GzfMu+heUuLTlRhExV+NxG
         xk0Q==
X-Forwarded-Encrypted: i=1; AHgh+RryrNW3BbLtcJ0wsDamq017KkcRqR2vAudmV7F6HjVIYT/Awb9ymuUv4lHWbkT0POe9077F7ax3j/Lz@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnrx2q7OTErB4Ed2DgMeoDwRa1dHfAqgT+N9rs/Xt7ECvib1qJ
	TkznWufenwD8bBnXA9kXak6Ky3q33VjAz6Vl2SZRL8dw0RkH8h4fDakm
X-Gm-Gg: AfdE7cmjzGuNHJIEyrX9dbdl9f6YoEdAfzO7ILSdmX7G4MRjXHqyQCGnWx1MlJIlT+s
	iC/eUFOIH4Eg5DgNOn1pmIUMn074WTtkzc45tOZzWP5DocpcBT6ivNzvmvX61QT7FT9oibmQ+UE
	6cTmmPrAkYOMubEaGSG8VuyP2gFBeigheLPmztxBN+BbAOWSnqwuFZutXWki5o3HFwVp26fe6Ga
	hW8+eNkm4xpxeK3n5Vk23hJI9HU2gyBc4uciYq8NAjeo237LniIiKPQM2vJFsExhyZUuDOI4vOH
	652XQ1X37FIsTmcHmeUCXfXIrH7wvDzDXsGWozVM+ubJ4yNtq1OoTkrO9fEH8yKReo8xQM6Tx6Q
	9BMKaD97h/g41Q6vD51coWC4BB1cqYsKGXAQjRAkWUoomf3fvdPdvKgwXsL9GAczN9jv3na/2gw
	KC
X-Received: by 2002:a05:6000:2dc5:b0:47f:73dc:c5aa with SMTP id ffacd0b85a97d-47f73dcc5d1mr2608566f8f.30.1784484834517;
        Sun, 19 Jul 2026 11:13:54 -0700 (PDT)
Received: from fedora ([212.253.209.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496afsm23601948f8f.1.2026.07.19.11.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:13:52 -0700 (PDT)
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
Date: Sun, 19 Jul 2026 20:59:19 +0300
Message-ID: <20260719175919.196814-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <59a73ba7-52f3-44bc-80b9-98ff2a6aa771@linux.dev>
References: <59a73ba7-52f3-44bc-80b9-98ff2a6aa771@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could you please run this selftest in your environment to see if you can
> reproduce the deadlock/hang and capture the stack trace?

I could not reproduce this.

I ran the exact sequence from rxe_rping_between_netns.sh, including
its cleanup order and module unload, on arm64 QEMU with KASAN,
lockdep and a 30-second hung-task timeout. rdma_rxe was built as a
module and the test used rdma-core's rping.

I ran it 15 consecutive times, followed by a variant that unloads
the module while the netns and RXE devices are still alive. The
rping transfers completed, the unload succeeded, and there were no
hangs or splats.

The series was based on b21d9bf627dd. Could you share your exact
base commit and .config, and confirm whether the same test passes
on that tree without this series?

The script redirects stdout to /dev/null, so could you also identify
the command at which it stops, for example by temporarily removing
the redirections and running it with bash -x? If it hangs again,
"echo w > /proc/sysrq-trigger" and, if possible,
"echo t > /proc/sysrq-trigger" from the console should provide the
blocked-task stacks without requiring kdump.
