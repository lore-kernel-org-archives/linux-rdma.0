Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794213257;
	b=lqa1JMFjl1erkPKta5vMCmYuMmWFuLoI+MUtK2UsUBcesxkpmzbIHJyBnJ8neAD7+4/N
	 hfKzCvbVrqXzu6qVATMDm+7xXj5Zrz4ee44253LryaM1l1yZf5JKxACtKpLpSgSDy1/lQ
	 9dBk2kCLblKwc3aHHLPz9+cDUzQi0DO5d7/CTykjATJGW4/jkRXswPqudoGFkq7TdvnG/
	 U21oitB6NMImxzI0VgeHt7OVaAy5Fi59dUbHhz6yG7CIxJJ8cR32FfJgyGnJ30cIVTtw8
	 Hcuw42ItvoaPReNzfJysSkcv0yO59pv0ZeEJuoXv3296ngoBxqLAB7oJfKXRBO2vgvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213257;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qxDyRTVG53tA4aLBA80+bjaYOvMrnDZCekBIwZecqWk=;
	b=vq7D+cCNgv8ShEnrVpYz9y2gQHLVe3gkqh5uLByOKpnjY7ilTjpuEJARBlI5eIhw4lcV
	 YgDvy9HUYAtlH+q2eG7VyvMQY0kua0GgCsrs6fHxhiAHkG5fV/viEQ1A7fi6COko5x6k+
	 +9/KG6vAymCSCvoZoPaQwckZEIFJHBtsRZK/uvbwSF5+dQespschg12kPTfurD233zxb6
	 B+3/bbs4a9kkwKezCPXCHQOw8YEOYR++YGo2TsUT09TxtvHjJi0pLu+dO8ei05ZK6DL+e
	 1VnL5DPA8FoIPUajuu5EjEwRX1HgVtyYdq6QtL23Vu72KBjTZ7jJ9i8yqc7X6vYCGDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQqd7cDu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33657606A322
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33657606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jQqd7cDu
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfbc67991cso361651e87.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 00:34:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794213255; cv=none;
        d=google.com; s=arc-20260327;
        b=NYOGPlddqwsu0SQUsX7OxsNis+TW16QDJuDGOXndDMqUOM5tskRulUUbIhyTIWNkNs
         oJQPq8oVG9dOsX95W0lfq6E3eCCdN1un2ZbqPQmNHRMmud0/7lXlOEIEx3FPZweAtMuc
         WGim5nPwRl9C0/VlHIguuqwI7F4lIIXsguCCPsYGWaLVstVso0e1pa2jPYNOJP0Rjo9T
         debAuJU91fHBg3QJB2ULiFDJa8LonEv71PQLc6mbqb6VeveCroDrYG5D+tfemITWep/T
         M7D0Ni0Y2SOGiCZOpb0KgGSTyeO13+dB1cVgYHo8bFqo4X2rBAigGCj5FOTcc96bq/9V
         edBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qxDyRTVG53tA4aLBA80+bjaYOvMrnDZCekBIwZecqWk=;
        fh=n3pfG2FHV2+IAofSS6HxRJ9X+qmdexYDZcvUfSH1MyA=;
        b=THFsHuCD0e14G3ODXYEHguXkrWfldsNtzIUy0yGmJ6Etsa5voLDt59zCe73bJbORDl
         3PFf5pN+xVHlcVuMYx5oJq3eSZjBsbYU/SMk7lGTHTFGQkh1tX/hFXb0d6kujoAtey6d
         Hu4Xl93zSyvshRZsjOkCViJZTvcjVqk12HtC4hc1lGWcR3swntw7vdYgz9k8TMxnr/yV
         KsFgLBex7+Cpxq00IKsaQfTnvLTiFo2rlZkNIWHYZrjJW20du24vqzk+WKJBz3Y9dZoe
         550hyuCSSvD9/CycyChaoyykq+gxDHGaZtiFFsexfcd26qHyJHJ95Y9cumNUFbiFXkpW
         8ZYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794213255; x=1794818055; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qxDyRTVG53tA4aLBA80+bjaYOvMrnDZCekBIwZecqWk=;
        b=jQqd7cDuoORypxcd2S8ADN/nlcDXPyOmdBHPxA/G1n4f0IsiW7kEc9wFg2tHuaiZiJ
         3Ew+hBDWtSWBmXChEpI+/BJwSBLUxbdwArGAxbiIoeLab7j49MeMlypyC+NX9Br/Px9Z
         Kz9ldjDxmvVH6xhB5QBf0DZeo+4fSVsDgH6MvvHGdK5GqHU0QuFGspJVpQBK/mCpuDiR
         8FIMjHOhqAzUaxF/P6WkfbDcW0rfnwrK6wPFgXNJ+5obw5G5raUouf/gXCfLqPcCpdSb
         3cMfuzAaPhSlS/m2i9G2Sr0P1UVQNjpbSGKTAox0sqFf4/UaXm2Izcv4zA9crXCLICmL
         hNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794213255; x=1794818055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxDyRTVG53tA4aLBA80+bjaYOvMrnDZCekBIwZecqWk=;
        b=EnC6bGhpWIDKQoLz1Pyr7ldjNbNnfy55T17uQAjdsfgeDCW56zk/Kr5RR25u2cDv5r
         KhX9xN0ZZPXXL/ubiOFDd1bRLZouzsv0d5DV5Gmo0dagzNB8uU34MFbmvM8X59kSMgnm
         8UvtR7i3DJU9tjZoiR2NtdTUczhF9RAo1NV2oQHnWOKjkWIEOh0ZrSOb1aPGK7+cEa91
         88pU7ZlxELsy2yXh01Pr7JnjfA1W3rU/xIwjj/8yKVjNcAemlTfLi2E7akiryZX7t0fr
         uKScv9mUrJV2BSz8PtLNBdUBtpi83vuDRBLTscGF7LjOBCFS9tBbhKr7u4Mg28e329Es
         uGnA==
X-Forwarded-Encrypted: i=1; AL+hErEi4huuJ7h1l46hKDvZP98sI8d5L+7g7PQ02qag9ERB7sgZzOzizlQvKjietEsKRkV4Wjo5PrqhBEnN@vger.kernel.org
X-Gm-Message-State: APuU4Z/fAXEC0qOS9JU71m2lyxHqtH77cHQhpak7+Rbx3nLzMIzlMDLi
	wuTXDtsCWHMpVvF6G5n01m1fHWpStcWasDnCIckZ6ZkHpYwhBkubsz30axMF7caaxgmrbCFsfPo
	sNXgApu+hplJ9vbOgJQ5eKZiMN9P544A=
X-Gm-Gg: AYBFou0TuOpzSniZvrypDJtrL/Dl3bP/BrOBYFY/Ag1G8PXTFfonR4AgqTDgCHH550h
	JaEjCCNaCcU1qcJWfwk1paPLnzApw/O4RH4lXABq8dmTy95fYLJyIqu0GXktjonLlfJKX2fbx41
	+ntWloHy7Q5NRXfpGyZvMhlm8nQOSYm190/csuOIudpeUg3c+R7k8VkVbrhpy+HA3cRAsQpLUL7
	35TFV1uTlKCpoS6CtB0N6FSIOeF4J23h/zZRUpM/8iQs6/I/wq4THGItwN9FfOsUx/HZ8YbF8Bw
	a82L9Ts8+u2q/LaYGr2dLtbKTFAE7Cp/csjtEJ27UMaUq/UdrCKjA94l/vJWCt6d62a2SLFWmM/
	qJuS5SuQoLgm0X9DdvU+CbwAlCDUgrF1EvBS4O44=
X-Received: by 2002:a05:6512:1395:b0:5be:4386:806d with SMTP id
 2adb3069b0e04-5c14c03c34emr815392e87.53.1794213254943; Mon, 09 Nov 2026
 00:34:14 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
 <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com> <CAJ3xEMiG55XUPtt7Zs2xON=EZtJ7Oriwt5m6qbsL-s2cVgZHyQ@mail.gmail.com>
 <0f042520-b1c7-494a-9044-7970e78d35c3@nvidia.com>
In-Reply-To: <0f042520-b1c7-494a-9044-7970e78d35c3@nvidia.com>
From: Or Gerlitz <gerlitz.or@gmail.com>
Date: Mon, 9 Nov 2026 10:34:02 +0200
X-Gm-Features: AclHuK-epz8ZrHg83KNkPlOdGLACbHbB5OHOO8IoPhvKvAVL2Vpd30kht3szURs
Message-ID: <CAJ3xEMjpMKX0yPizrgy0UQQ4Ovon4eSYj-ZQ5qBxHmqJB71Xag@mail.gmail.com>
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Mark Bloch <mbloch@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, "huangjunxian (C)" <huangjunxian6@hisilicon.com>, 
	Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 1:40=E2=80=AFPM Mark Bloch <mbloch@nvidia.com> wrote=
:
> On 05/11/2026 19:23, Or Gerlitz wrote:
>> Well, in the env/lab I am working we are not really have the means or
>> allowed to change the kernel..

> I get that, but I'd feel better knowing the patch actually fixes your
> issue before submitting it. Can you try to find a way to test it?

mm so the env where I might be able to deploy a kernel of mine is
virtual which means
RoCE LAG doesn't come into play there.. we have a user of 2nd driver
admitting this
fixed the problem for them - sounds like we can move from RFC to proper pat=
ch.

Or.

Also FWIW if there is regression testing for RoCE LAG in Nvidia they
can easily add
a case for active/backup with ib_send_bw or a like and see it breaks
before works after.
