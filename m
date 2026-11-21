Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795294622;
	b=B5AfJEm9RUsjEGMQSWDiKU8EQcXgzpYvHMF3EPuSXIvxB5D0mxUMH7ZGeQAf8f6IkW6Q
	 qt5ZIjJPRowuWOQO8JnX5BIkS7ECZ6/l16vuth0/kSFHYCZQnn9VY8DvJQRf+NP+9KTfp
	 E/9sSBi4gvwPNt4emuKWed0H2PuDWpJmPrgHcuVdsmIIj9hfyk/msgjF/XY3xPx4LO0py
	 LUP7rYtnULv28seZ1aH3mgzGMf+Dhj66XYYzD2TcYfLsYLA/tq4c8Vb6oNMZ4YGcwlHbc
	 W7sNHroxO+q3cu59REciXyA1dAbBsXJMQjatYRfwA5QGH5Xf69p7+l5ngT3vSLVXqyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+f7+ztUOyhaovcSK8/cLlVw1Izw6zMt7sIYYHaQmuRQ=;
	b=aSmsdMjKH/Hk5wVOvRv0f2ukXGEkD5GlQiidBzTpOV+Kuz+zoNhwdDgXaNNqfALqjc1X
	 xuIzspZ/he8XNT9/FFpU170zYBISlRkt24s5oEJEY49xwcXGZk7I37TMPJalYfJzQ/tza
	 QWcrcAWxJjrJR+cjeruBlxJkIrqmv30q2pldiZE+4kfxzrb7G2rF8s6Z8BbHIE8dze2c1
	 J0jbT84XlrHK8VnJztEUF1qGYFR5CzbXOb278S3Js0nZQBYy0v3oH48P0j+lt845exr7k
	 P9s5m5ZHv3mUrEzjx1NWW2gQmELvJA570+OvOI0/UWViLGR3D8uZ/1txy+g9Tg7j5OA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L8TpTXAE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D91606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 20:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64D91606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L8TpTXAE
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67db35e7953so2204317d50.0
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 12:57:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795294621; cv=none;
        d=google.com; s=arc-20260327;
        b=c2MC07n2ZTinKJBjP2ZNLBQ4P4u1Q+tyeC2JxLTKSpWx6fXo5RxYEPqGcMMhNvBUou
         F/o/jxlGeVeO1uJQqbrRU0RcO9hnk/W2N8YR5lZ2u6U5C9YjIUnGcVVZu26otuAg7IJu
         r+WOjpodGX9fXBKs9r7Rdqb3tizWsU85HpSJdZF2APAD43CvPi4oKJmrC4kALsKBPy4B
         Tdl0MV60qlf79RSrhrnPSNuF5kC9kkDQyL1w6ZCQeaiJOKHAp//cY5jKVdYgJlqSt2YH
         xnHL1GBTPvEkaHr6GHkuqUP/IjU4tm60WV7y9kYSy06Nz93WINzYRj90GSrf/bXh3Bjr
         7PYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+f7+ztUOyhaovcSK8/cLlVw1Izw6zMt7sIYYHaQmuRQ=;
        fh=vM2RJCYgW3kj/A9VBSC1dfDjYw7b6/J4q4Dzq4tpDuQ=;
        b=j7/AnfO2yHQZhjIGHcLagUOIAS9/jV3QyxrJAGIBBNA5AG9WSmemujhmkHZcKk6ftt
         7toEA/QCQs8YVT8QRwMTeOvbZ/f4Tn3lwuaHqgjRbiE2q51R2+jwSL9yVKCClrrzBzkv
         sK3EXVAHXMUJ2oxGwWRFw60DaN7omSYqaVvrFu/Xv0ECnp3DtwzpQuqPXJvIBAI7tZqF
         bzMqZ8BkStM1eahs792jQWpBJNUaIs6BGqBTulJObtaQjZZHguaTwT5q1pRMcrGwG/PT
         86ebdbLlQb/KFHbCd0jmfqqotN7H5rJ3yutsNo3B/boWRvPULIciVUptdMa907Wn3RRi
         5Rjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795294621; x=1795899421; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+f7+ztUOyhaovcSK8/cLlVw1Izw6zMt7sIYYHaQmuRQ=;
        b=L8TpTXAEpiXgcy2GKVxQnFmBuJH6vl2ptnjqIEIRtCqzlUq1sVsLGGfoaV5bjJA7vt
         QA0lladoUwfZ90X//yMghSakFBIWC6KSCxJmehuZNTSpGV26w/lkvLis7LrBdN9X/ORd
         o/951mpQU/H7ATA+4LnTTK2TEOrI8WYLlMhChTjwLOxL8mxy85MwoLjEUTyHNLCxjdQm
         q1IlBMp4fSotbhCPl/XK2Cus/GMm/nrzzRxjLKU3+wyum+hSnGEqxWVPoNsMyxtiKUiH
         BsPV82qfwYn55bVTvSQSgjvRC7qFFcltwpI9n0dq1dhOffwHFu1bJHpa/Stszx49sJiD
         MgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795294621; x=1795899421;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+f7+ztUOyhaovcSK8/cLlVw1Izw6zMt7sIYYHaQmuRQ=;
        b=Yp7ZewwfdZGbbXfhSuyS+5plpTATGcSU61j/UyvnVTZTIhvMbujcW7ataUNSXINFnY
         ouoDcgNA7jaORgIOX/ezB6ipZFdk+UmWDy0lzzjplOnTamSOPoQdHT7Rf8D/ZTTCXH6h
         3jXbNEEmWAWrFLoKqfG3+ZrCk0KqN7gKM7D/uzxICVa6tehp2AFUp9zrUMm4GKDAllJS
         cwOJEPqTvQ6Ril5awMtaZLJlgZqlS8KoUTg8F1RqcnUdcxyC55ysieRGcQTMsXxaT5fH
         sf9nUKEE8GMnrKevtEsBdcxJe6rIcAmPVGgQ9RnmMH1wOndI0xW40fjtgxtM3R2kTB2i
         GhFw==
X-Forwarded-Encrypted: i=1; AL+hErE0hFyqAnm96pRmzjrsspLKahZJxC4iA+N4tHXfWhMEGnaoL1eBCRkP74fDP6vJcX9klPGcGAWjmriC@vger.kernel.org
X-Gm-Message-State: APuU4Z8KJVmv6bCw7IX4Sc8nmmS6+tJAL2KAdtnqIgRAagrV39w/3bPA
	lZ1guB0CDUVvIF/piAYUi+cyIFvYc6iTByAJ35e4OqqAOnKCYGsDPSm2jHSpGBZQwbWWaFDOjJJ
	kyEcgKr9/qh1zrxrr2oy1BdKPj0HeE/8=
X-Gm-Gg: AZFdTZf7qMdFtshS5A8Mx/NX9jlsPpf6DOEVQF5io9sjVCNpnYEPZVQFETiTQpiS7Gy
	HN8IOGYd1ooiXl/Kr/btz30TSV1al3saCAWItf8K6qtNsNEpXaBH3sjGs7vm0GEQsIh/1+7/nb2
	55U6xIrT5JfjT9SR+ZwlpuPEX6PvUV/F1C/jf8sIGY5sDQuML+El1+l9iJ3q/uEZsTFgfwdqhSq
	FPhCBUZG+geS3qfXhcXDgJF44H/W54w7MFEqioZBCOuBC137C292TLiCT2elyG1iubKcasJQLoF
	flPTUlFon9MJX6FxweECoGSyqw4K3m9nbe2tSH0lHNn9KW+vy4VDLhYIak7VG03fKd5gPpZhuFC
	9/RfoCKCbH/Si7vpIXAic+CesP7R28RsTFaVVndFyvfISK4+v6g2A/qo01i/vnlgmWh1AtoUn3W
	VkH7uuylD6QF8Z2GqsQQ56zkXpSdlD
X-Received: by 2002:a05:690e:47c9:20b0:67c:6e6b:2b58 with SMTP id
 956f58d0204a3-67df442352cmr1473959d50.29.1795294621418; Sat, 21 Nov 2026
 12:57:01 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261121001414.724236-1-ralerrdirsardx@gmail.com> <179522023307.3294.6067722832080574797@kernel.org>
In-Reply-To: <179522023307.3294.6067722832080574797@kernel.org>
From: Artemii Mashanov <ralerrdirsardx@gmail.com>
Date: Sat, 21 Nov 2026 23:56:50 +0300
X-Gm-Features: Aa3M54rI9vOhz5FwN5wgejilnXxYc_imK086uF8S01hpRCkqWw3qDXtfbHw3p0s
Message-ID: <CAGHp__ZrFmXW82R9hpyzRGL0ORdFF=Q-yvcNMFELRyHrfJMzJw@mail.gmail.com>
Subject: Re: [PATCH net] net: mlx4_en: report the actual RX classification
 rule count
To: netdev-bot+sinfo@kernel.org
Cc: netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I found this while auditing ETHTOOL_GRXCLSRLALL handlers. Reading
mlx4_en_get_rxnfc() showed that the original loop used rule_cnt
as its stopping condition and could return success without
reporting how many rule locations it had copied.

The ioctl behavior described in the commit message was inferred
from the original code. I did not reproduce it through an ioctl
on a running kernel. I tested the patched handler in a standalone
harness with ASan and UBSan, checking the returned rule count and
the -EMSGSIZE return when the buffer was too small.

An earlier revision also built as mlx4_en.ko against Linux
7.4-rc2. I did not test the change on real mlx4 hardware.

Thanks,
Artemii

=D1=81=D0=B1, 21 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 03:1=
7, <netdev-bot+sinfo@kernel.org>:
>
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
>
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account.
>
> *IMPORTANT*: If you do repost (for other reasons) - please include
> the relevant info in the cover letter or commit messages.
> --
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
