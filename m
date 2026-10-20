Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792535284;
	b=iH7WzaBtwThtmwN60IgCyNy/vA+Bu2GJZAXUO2uSxkrmRJGG862WmkTptanICHrb/OBt
	 L44yrFVNyPmevc70T9T/Uy8z2PR3WiwvHu1aWhekeIs0RQJsuHeI1+tb8MfPBeUag4G0T
	 Rl/Qij9iyScCVJ8f1AkwNcEby484oxVaJk92jOnle+wKYqzqnZMUtw+nf0WaN6efJb/Ys
	 VLB+Ismf57xn4OI3I48ZFRgnFEHuA4PjVCHpUs5R9YquNMqjRpM9V5s/4QmtDb9Xwee7S
	 5PjqnXA4BLrlrLaHXQ4+OdqeIXQ77Kbb7q5Ee1ac2xTl0f8nwPV65gqNBbkcBQcGt8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=G4ZO9/xaGwtst57VlOOA8l2P8QCQh7t0mTcJLRZEW7s=;
	b=xiJxyzNOsFWDfTKsSfsyurqlHrHgEXm0nL9mwLuMVSVSndxyYdzOCZgNtoMTnxBRYCiu
	 EF192yOeOxbCgSBMtqpcaI0esijQbKL9gjKT6Kwzo016aRteiTteSlJbtWtxCWaQesNkq
	 90s9zGgX4ih34YamZcZj7iG02sWqvrlyAGmqTVR7I7wywP0m8lwqrrvM1skaLgWBhP1Lk
	 YbWtr5cF0xRy5uM6W/x4feLB29MPDwoz0QiR6kfqZ2qfKNuSqW8XdPLvRdrGnvkta/MFh
	 lQyWl1oDGiccHBVRI4NSv9dmyafnxveaIFqfHb9XPuC7aBlpIwbx1g75VUe0ZsdCQ7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rmfEpk+f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C8606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 22:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C5C8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rmfEpk+f
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso2248a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 15:28:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792535283; cv=none;
        d=google.com; s=arc-20260327;
        b=gqxd3rdTq5T0iRPlCI1fWmMqsrpXtVjYATXSaSek04N8gQi/OraYiioJ28qetpi9aR
         25g25kiU9wXpldqMqWX6V0+YJJ461c9NH/M+NCZgWli8q16vuGwBvBaq/gGh42rliHl2
         s9k2hERFW3VjMfePwnbHne0C3w4tqnN+6QYLSv9CXFh1D1Wf3gWe+rVA7S9x6skKD4cP
         BPmqKxMbZZzp2A9DQTXx/gE2TfB5AHQJP+J7SsJQgpR3RkC4weu+vvuiRXeys1YhxVta
         WsNBwKCmYltSdlBt6q0ZczvHRJOAv5nmPpq6DVcRzUiTkcIdZPI1UZOYrDABwmq3wpuZ
         NimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G4ZO9/xaGwtst57VlOOA8l2P8QCQh7t0mTcJLRZEW7s=;
        fh=sanajBae0S1SBHq8tEGPo4Gwo0qI0loxH/Tr2YmYKJc=;
        b=OLxb8cg+UjbhQizfDvGM90aqvEvGx8g4WTUKVD1iGLFu0L2Zsz5jUkeYqXi1j5cA0R
         1TDLT1c3HIemVhcdBpvOBmaDAUsharkIIWK79dLgtDIgTTrIga/sKd+wr8JzOehfQjuj
         CE1PgOAmAVPfTfvgmD+u3hxS/nOXfzBRKvA97Y+zpI80dSEfWLt0ODcDBcww+PUZ7Wx5
         PyHU6HCjdQDFBhTWZLqZBOun98EV9O0NgjQeEX8Eoj78Jumoftc/F5CpTzQ+N0iNa9rx
         iZ6q6BRHyt5nAqqldsH6YQSRDiBjdbBrwqoMHAM3veMhIYbwg3KqE+Kl8+zNp0XO508y
         hfJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792535283; x=1793140083; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G4ZO9/xaGwtst57VlOOA8l2P8QCQh7t0mTcJLRZEW7s=;
        b=rmfEpk+fCkZv/kL89pFPui7fFmGk1n8reU/QsXYE74PD0EFucUW0hMf+IS4aStL0Q8
         nG8UsAS92tQv9D9ZQHsaoESspRJ/Zb/tLj8EXkHtFpS/b+Yv1XiiogGOoQF3SNlGVDbi
         VjAnWBFpIEg3G+6ql6HnSMNEeatAVsqUGblKkp4VLsG3Vl5mPo6Qjfzp7VqRcZCtcixG
         ZID0xGN14VQRGASeikykGdy6GBWJ9A0V6AFkxpNoT6/e09Wv+fXGPPohwmNppGmv7pGS
         v5JICbY+ElGsHORRCVuJuVcDfeCBoIeo53TU2c1aTQ4ePKBBopr0CzBIg003ZmACaLP1
         mCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792535283; x=1793140083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G4ZO9/xaGwtst57VlOOA8l2P8QCQh7t0mTcJLRZEW7s=;
        b=ivrkbGHt0bubUTnLiqs/o3CwXErYr2lubCvnXrwgT9yuyiUn8yklHJ2+8ul6svrgRd
         Mnn7ai2p6lJy0TxY+rkg7zTlZ4SHz4+OEYuU4N2bA2Bftf6dntPU6jY6Ox7nji/mIYux
         RbAtaLq/DCGdEEFk86Oq7GcZ9c3bw0VCnTtqdfmWiLEkQI4+7atsxOaKa/FtVsvW1KN4
         w+9WV1rSQUdHAVJkWM5SDGipm3axmF8xkJHg9LuseSvC+lwiOMR3DdJn1QrlEJZQMVPl
         u/pZ6IB/+4TaCUf5hfYQ0ytAEGwHQlhnhZG0OUdqNkARp4/VkH8Tb8g6wcnnQFYf+zdc
         Z3Dw==
X-Forwarded-Encrypted: i=1; AKwUvBzpUP6CJYqbhCagyM7MtgVjTWUkcXkHK1y8P2k+xj5BVFfehKtz1CJJyuehMFHs4Y1c6CjmMu9YPlKF@vger.kernel.org
X-Gm-Message-State: AFq9FYIQAqYGqN7ecoVlV8Pg9jsAvIUSKKsKLutvYb8/3AhyXg9cX21s
	ZHceA6+4WwTsd2strj+c+hcBP07D7biCE/drblJDc2kyTX6jm7meBSFGEJoTotnG1rMQKpEFa6L
	4Msp9ChdJQWMXvLvFPeLCbMATMTPEPCLjSa5S4dEH
X-Gm-Gg: AYBFou3n8FAMXBodZHp6yhNsjO59q2FMoF7cJz0lpbDSPNEmM2q0ZTy8bANxokz1F7z
	tSYUzHbA2Yj/QRw4r9nEfmcumrB5AzN5p9j54GmfCFSSoY756fAfGmC6oJLzZR/UG3XVgSV2EDc
	hQz5gQqBQgY2vsvdMrun8M07MxDc3wMY8avzbSGeYzZAhQcJl6R7gQKdP/RePMAb0Q6ZGxmIoX+
	iSFGNyRc3jpHtSHvW40C1h+gUntl9yaoKU8PcLKiixr+CLcj3CYLmo0r0LHfv3bU8j7N5rnFKdI
	q3eofOHpGcW5Y3JkQ1VG0eGvBj+yz7pnSIfHkLVyCduW8iklSNKHerT7qVgHU1E=
X-Received: by 2002:a05:6402:a593:10b0:6aa:babf:adeb with SMTP id
 4fb4d7f45d1cf-6b3e59e5999mr93600a12.4.1792535282334; Tue, 20 Oct 2026
 15:28:02 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com>
 <179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
 <CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com>
 <20261020150307.258b00e9@kernel.org> <CAHS8izPZ18v_1CnRkaAAA=d94wutJhoOZdOFO_1CEXSexd_=EQ@mail.gmail.com>
 <20261020151352.794bf03b@kernel.org>
In-Reply-To: <20261020151352.794bf03b@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 20 Oct 2026 15:27:50 -0700
X-Gm-Features: AclHuK9dUEuy9FSTZ5UcXIu_nwM1X5COPAnL8H94zeKVggsnQ3YuXniy9SKSJgk
Message-ID: <CAHS8izPOqgG-LffZtN8rmuEt0dS1YZOmWALM9Le8F+rLbVA-sA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and page_pool refcounting
To: Jakub Kicinski <kuba@kernel.org>
Cc: patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	ayush.sawal@chelsio.com, andrew+netdev@lunn.ch, davem@davemloft.net, 
	edumazet@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 3:13=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 20 Oct 2026 15:10:03 -0700 Mina Almasry wrote:
> > > You should have followed more modern naming patterns tho
> > > get_netmem() is pretty bad IMO. PP naming is object_action()
> > > so netmem_ref() or netmem_inc_ref() would be better, no?
> >
> > Ah, I didn't know about the modern naming. I made get_netmem mirror
> > get_page. I now notice it's folio_get not get_folio. I can follow up
> > with a cleanup when net-next reopens. I assume that will not be a lot
> > of code churn. I was also going to try to look into deleting and
> > consolidating some of the now-redundant ref-ing functions anyway.
>
> If you do it soon I think we can try to squeeze it into this merge
> window to avoid unnecessary burden for backports.
>

Let me try to get it on net-next in the next hour or 2.

> > I can also make it one of the design pricnciple in the page_pool docs
> > so that the LLMs pick up good naming practices moving forward.
>
> I don't think it's needed. I mean, if at all we should perhaps
> think about naming guidelines for all of netdev, but no time for that
> right now..

Yep, honestly, maybe even just general guidelines in an even more
global place like linux/agents. One thing that has been working well
for me is coding rules or designs in Markdown; agents inevitably pick
them up and try to code in accordance with these rules. Just spit
balling ideas, nothing concrete right now.

--
Thanks,
Mina
