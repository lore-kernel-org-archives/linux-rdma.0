Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFAC3C09F7
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 08:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622292; cv=pass; b=InkCCBZzAY3jA8OfK6eFqQLm5CusjQ2xXEAZiMUcySVjYNTQnIdTfenn8boa5MxFSIzhPVeuEPwu01FsYjRUquIrZdYWmafIH+ZVxZbZXdzK3YHeXlacJru04VxptkkcpKFFqpzagxtVFVdGesJJenYNEHJUaPy0RYQfVzHZtNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622292; c=relaxed/simple;
	bh=u6d7SFXuP1ZVnuQoZ762H6ZqDSQEKstty+kgOiz1vSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gQzXzWaiMDz+ijpLTRKi6qKQ0czaFZSZUy8X6B6JcVV/IRAxBBvZoozZdwonHwEF/8CeKBWgjBQcUY0j2YubEBHDiksGlZwZvKfJ062bFTlZR7k7kFuHbUUUPnZR1eNntFAb2rUbIdAogYloazub0I/70zQDCUkdSl0ZggBjWwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvwAxthP; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvwAxthP"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6afac79b3a3so1420a12.1
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 01:51:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791622289; cv=none;
        d=google.com; s=arc-20260327;
        b=Z7Ko5Le9pYBZj1+wnYBK4oNLGgGM4aYCqPLEiI9mvzmoDh4jxwtdbokNp8XQ1vWXUv
         2IoamErFGuhTpMfqz1Indtv4sQqQG0FpmJZJ7RHXWaOJh92bMyTWpBPia39At2n4bwZ8
         Ef4Tq3No03vdl19yPldMO6SlfQqqzTd3dmTy2w8xo/OAoVw6jKHQ4Rm70L7mRxXUcbD9
         jJ2PO8zKKQCwhnuI+hbu/vbckdr8ousP6pX7JJSVXT0nLM4nxLgRmjq3kOHGuqFkBKZb
         IzN8ZG5p185gLEZbK8sWLOZiysy7r7/41kvPFWX+7iZvXioq3RRcysxWj3QovPgUrMNS
         LqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1qzTr0YbnBfbPj9+5K148QJC7O1RDLZnnS+cEO+oPi8=;
        fh=cFVAicxgWBOM1bd+6cu4g9pyGDQ6Sql9Ipiyj+Vv2W4=;
        b=YEqLl85fO+sK3Z3WkbEv9op+rA30Fqor0O9Rk8rfeQo13NZtpJA9k9jCPSg2JfuhRL
         GlIsOFx84D2IDQKJ3DcStlwcnqP7iIo86TVHQQj6Cq1Z/GBFB7EfZJPy4Zv+Ya8xtsYf
         Hi6cpE80acNv/8H/Ci/FYzZt76MSuxdmXnh5BKxD/PeGmAjZIwOByANREt6lA0kBULr7
         A6RIiQEisTZNdyVo24HEi2YGoYwD6UIzhZX+nXOGnOZ+FEy8m/cN98w85j5cUolskFYT
         kH4crZChofNEFXGf2a683M6s0ePYBi2YySNtVT+AQtbDMSy5ffDYgyDh1T9ZKJhE7BJs
         NYRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791622289; x=1792227089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1qzTr0YbnBfbPj9+5K148QJC7O1RDLZnnS+cEO+oPi8=;
        b=YvwAxthPJyhOL4eFMPj0oYntTOJvVIk9w6WH9Kt1na3Q8Wgx4rZMnn9dxOU49RjCKr
         CO0sEt9yZ/E7IjKLXwLT5Y83fZ3rqqiMxVfKkAXqAtusxKuuSC3RJxzOHeb3JfGiLciL
         KFXvToowiYRZkcD5JR9G8fThOogDpnD+lPlzyEScANN8zpz4f5jjHswzU7leUSYxVWQP
         yFnsGOluSCCxaSRpXhIqn/dOweHPSCbD1K9BOrQXQnRqGJYKCM1GUaf4cj8TkSN13ayP
         YNc8Yndp9eBUghyyjftch4P6OF/fGHjktFbAfr2FDPxvVSLNB20orh0BWXSJb6kD38Js
         GBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791622289; x=1792227089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1qzTr0YbnBfbPj9+5K148QJC7O1RDLZnnS+cEO+oPi8=;
        b=PQrllc+e++mu10t/IyVARYBfM5NSxzD+l857VNujXEkJeaJxGtfk3RBjuZG5QATl0r
         bMQvGKtKWJezeDG7u4ESg1OjSYccn8u4Ldr6N2OfkGzsfQT97A0mRiGCRmj13JU2BNeZ
         tUnXwB6m4Tl+wJcnKzef7pNk1jEW7v12cx4QTjsozP4OkJvgL8Vmwjt9TzHVG2dVuf0T
         Y+iSwWvzEdNPZggX6/reMnTyde+WMibaJ8VDMTHh/N7RYR4KXdXJSSdwQ47hadrvE6H3
         Caa38KzHQQ53g4H4lojXm75xrjZc1QSX8dLEic5Fakhy/bPDv0aN9rAbsh+WQDkmcqXe
         EVVw==
X-Forwarded-Encrypted: i=1; AKwUvBwoCleFpFXbELELyq/AmVK5JYpeg05xLNYNu3OWnwI+IF4WazfEUV7Q6ylWxdMDqjY/dSL74IcGwwNG@vger.kernel.org
X-Gm-Message-State: AFq9FYLDgsU9lZNt9Fy6pQk6S+zMkiG+p1MNetNEC9/6SvRY9JQFsn1Q
	qye2pup4vCaML5YQItFKZBTUkY7+f1ly97782HoEbN+FXR1TFVTsI1s51E5WtwPTgBEEDHqFPz9
	dVAuzNittCOdQp7WLeDbakWYX6V22LAYYY1U/LtKC
X-Gm-Gg: AYBFou0cGP3i64rhGo/AxzUkjxweWzhzhS7Ad88RZYwQQ0Mgi07wZH+/2RYiyhJNSGD
	QLEjyKBlsjllgqBSrEn5HH9kK8S3OpRO50LlPDX9rJ+bmZBbAJMBdXxyJ78giKdFposWj05mSiy
	vyHEmYmVB6+g6gKTGYpb1VoAqvq1Qks9Rf3VikwKjlZPjfbJ6F53fwzeJISjp+eWgS8pwn2VVZV
	swaM1MSGhAQXekTsF4oxr0/VyglpVg9opz1xr31lCoBlE9p+uzJXctbHggxf7unuXe+1fpTAQp3
	DCmDZltTFWlncptY3bMC6qJkctTsvsMUOi9iXEtkj/0Y8qEgso6ThQ==
X-Received: by 2002:a05:6402:c4ce:10b0:6af:97a9:224a with SMTP id
 4fb4d7f45d1cf-6b19883993fmr15040a12.2.1791622288658; Sat, 10 Oct 2026
 01:51:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com> <179162194176.2527009.17837283221529280785@kernel.org>
In-Reply-To: <179162194176.2527009.17837283221529280785@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Sat, 10 Oct 2026 01:51:17 -0700
X-Gm-Features: AclHuK_yiP687Fitsz3qcW8jp5keSTQlvPwHmngAicI8BRA9_47JLCvvHXQHfsY
Message-ID: <CAHS8izO=MW1Hy0k0yjm4HbJ0P9F5_oOQieLvFA5T4SzBDdDP1w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/6] net: unify symmetric netmem and page_pool refcounting
To: netdev-bot+sinfo@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Michael Grzeschik <mgr@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>, 
	Petr Machata <petrm@nvidia.com>, Arend van Spriel <arend.vanspriel@broadcom.com>, 
	Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 10, 2026 at 1:45=E2=80=AFAM <netdev-bot+sinfo@kernel.org> wrote=
:
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
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.
>
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

I was reminded what I complicated mess skb frag accounting currently
is when I looked at this patch:

[1] https://lore.kernel.org/netdev/xfrm-iptfs-pp_ref_count-underflow-v4-1-9=
12fa72106f0@secunet.com/


And saw that the author was trying to write their own skb frag helper
inside the driver because core didn't provide one that made sense :/
code inspection + LLM written tests for accounting confirmed the
issues. I worked with the LLM to fix the discovered issues. Not hit in
production or reproduced organically. Only code inspection and
artificial tests.

--=20
Thanks,
Mina
