Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792513398;
	b=w7J8t0iQZ8lILbwnFYsEnviXaDjkvDgkldF8N3ONKzpE/aqm78U+HeQQcFZdjrAj/ZE/
	 1acI+TjXh4y93hDZxfuK+rpr0aBSkzAAdGEwPS8etnYmNyQsUmJxoVOfBDCvpJ3P2Kv0s
	 bG+9eSrABjS+lqaI5QJOJiVjU72wkov4jJWPfPBT2FOs7RP0SMv2sy4ssZes4X8vm71jZ
	 Z4WkAhPaMRmoOCuExETuACnWOVj5waRy0wHm1/hc/27kkejObLGJIrmFRyP4S9xBdIEeT
	 zlktAcIQouL8D/RN1xhsfkLSfCVbeCdxdyAc8xa4T7ZYVmGXt8wo0dVn6LBN0iZkOdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792513398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0jCj2axNyxSFURiXpH7V4N8DE8GNJe9dPnJmhT9P0cA=;
	b=ba2MPMmY/D/9+Z4HMFO2twC2LK1/AtPGlkOQMrDTclyVtoe1/fQ+IJ947s04+z0w6dUq
	 /OWqYjW9Okq04i34YQ5p9jVSHC83+/BT+eQOdqC0Y2rhFMbP7APyR/Sl3X87RUgqhNs6r
	 zJ9NR6ObAWFzz0QrI9ppQFGRhsIFWj4hpXJ9CBsUeGAuSU6muGHkvSJg95ZzYtVLqNm5K
	 Rn3RiHiYIdHTRY32qvMgcy6RUIJ4PwsiISTQxNS1TJwwIpd85ililBQ11nUJiEAOn9PNp
	 +er60gtH4kxeebefAaN0WnlmV3MdndpbYFcu+yr1p8QDg+6c0emB+Aus8d+wpUcbAVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Xua+F94x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDAC606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 16:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEDAC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Xua+F94x
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b1b12de661so14909a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 09:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792513396; cv=none;
        d=google.com; s=arc-20260327;
        b=ITCSyg3LbpOSle/1OqkSlU4w9/fou9wOH9HyHpNEEQWtRcJr8di33EPS5iZtvXcDHe
         t4hARqgc+g2W9M6TA4RvGr7DtAArZJ+iu/Z6jDNkb/AApm2StML58sYtnWqpcEvjQDV4
         hP6ZVnwR7f+NNXI2/lTm6muGoA0k0aIultVlxJ4Qr1PokuBQcDGJgA1JjvM4Adv/UlAT
         MHNZqY/8mWMqqeNuBlSiSm6iSEJWT75hQcSPRWrBjmpj0y0d5Kl8CIAgQWNEnmRdI5BA
         EVxFw84TAD+l02MiWOuRS7Wa+knvMkbHBChVxgB0bgKdBUmJZXOg5bNH0oKfwi/LkdDM
         2uEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0jCj2axNyxSFURiXpH7V4N8DE8GNJe9dPnJmhT9P0cA=;
        fh=+H58cC6q24JbQmYLjY/yxr37WO0YlirUSZpE2mRcQW0=;
        b=NzRU1mKROy6YmBczeoeQquLe231Okt4Kdug9kL2NaNf3h2M5MZpIwEBgErOonAAI/u
         e4Sqh8rt5IFpGaCoUvUVmUy1AW8vEZJmzwGv19O5+xYwZASAXNRQGmeUiWaIevb4Aigo
         PlABTdCcOs82538mzV0LMd3+4qVJQYdvBUeFpcidT958NzqGXeM73LdBG7EdWeLAu2vH
         xO+ZyQvQS1wEAY6m05F9ki7TjerJKxE0Vm5y9kQDRwrVcbgntB73PqzUhXqNY8T3mVKb
         AT9yIdmsuD6UBGACjROrFfMsAv0AZmhb67usTk+uG/m/JtGzx9QyvKRL9jXiGw0ew3kr
         r2pA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792513396; x=1793118196; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0jCj2axNyxSFURiXpH7V4N8DE8GNJe9dPnJmhT9P0cA=;
        b=Xua+F94xPs4SLRFvPHZvf8ENdD6xQkEFYVjamT9EZRzYSfJtvS7XDtwmZyz1gTEJ0Z
         /WkxlqQ5rxEvkZKLXwDC4ALxhuuf3lvKENwOAe2FrlDflythScAJ0Tn5Atp7/sUdwsFJ
         E5biZmC8UmGgW0KNyTHjULGeLnoa0QbAm6UUD7R5xj70LVhv4dsixEwE51Pjds0Owm/s
         yh4EPRS7zc5XwowJlsvmHsNHogBe1Cs3eCTy7l+wjYHJVHHx8KQKzvWnrNZKclhTNIQm
         ckqTqXGWGJiMJjLhtJ75lQ1ZbkeOSru9OrP82Q8PUanZ2j0r8yLVhiS2BLjqoKfeus8q
         kXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792513396; x=1793118196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0jCj2axNyxSFURiXpH7V4N8DE8GNJe9dPnJmhT9P0cA=;
        b=GquMk2/rQ6fOD7RzH4Ry8sRALw1UUb/FFQAvFYNW8r2emlMmHO+sRBqYwCEs4WDJv3
         JgzouTYXQj2s86slt8m5sE0yHOJWZrMPOne0NWArxMPyTTpVnMIzngsHAlgCQuV4m8Yu
         qC3qNMZ3HV3t/6Iz6w9u/SLfzCadsWgAHoMzdGYyuPf3O3NvjwHqe+vbWDpitlLi5DhK
         lLzee7rJ50/XenGtiIrOwK7N0o0TRHebongVlRlqtFSmhwtDmNO8+otJgl3h0w4t4mqk
         vIIdwC6ZtHx5NOhrrwVKLPKQUcERpxzeQVuWpWl7Iaf+DEePifPEqZRFEHm8cIxSCOfN
         q3CQ==
X-Forwarded-Encrypted: i=1; AKwUvBxQMiPg20dVNGl8cx5Vx6iulB9uY3HQnz1VgIW0gVt74lZJBnPiLpIQ0A6VWNqFu4kpvW3SF4cEhzIH@vger.kernel.org
X-Gm-Message-State: AFq9FYIbvlDFtgOz0OCYIe2EgJXNWaEPMJbAqqWXwFARoi3cboaJguyk
	RLAbhZ0D6oYZBYminEiAzZ/W9qShLWj7Wwg3B0EuRcj3aGMdQhUUhezKkR1hBw4nXWvaFVvJZgV
	bGo5VuA2lFOWvBXlW64aevszEqu0Fv4vsDluTD3kH
X-Gm-Gg: AYBFou2e1Sg3JDLWYZPpCUsmteCcL5hfB+JPon2Jswe5nTa5xi2U1fIzAcLCZ3xELaB
	QnrouPSJd3ZrkbojZUEe1+kt1sGnLrUBV9+LyB/geeAWzMU5EuW4DkuMpWJQTTB1Cf7I2kksm3v
	g63NOLXWKjd2HtIzcPpeOpagSZsMYlHMnqflbaO7OManWd/IQMtUzkleWxSsjVHr2ifE9hT99KP
	b39BPEqtKA5fDjlxCb+aJY5HvHRHOVKV0cw39yiMvD88JTY0PVHi9cG7DLDP5FX0b9qyHBtoBDS
	D0vF40XUBKHCFROcqIdVOd+OZcPK3I/atHJSZJv6FO3a2Ck8vqfH
X-Received: by 2002:a05:6402:a593:10b0:6aa:babf:adeb with SMTP id
 4fb4d7f45d1cf-6b3e59e5999mr68410a12.4.1792513395686; Tue, 20 Oct 2026
 09:23:15 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014173945.373295-1-almasrymina@google.com> <179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
In-Reply-To: <179249101026.3632927.6502845375265155678.git-patchwork-notify@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 20 Oct 2026 09:23:03 -0700
X-Gm-Features: AclHuK98NB_XkoOPCMHRm8iUlfrFJ_YYRk69JLvIRXvJ8G4hhuCyWlkE4iWtFOw
Message-ID: <CAHS8izMRSU3AyVf+sP5uXShiSKuLumZwT=fsgW+bhJz47UoPRQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] net: unify symmetric netmem and page_pool refcounting
To: patchwork-bot+netdevbpf@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 3:10=E2=80=AFAM <patchwork-bot+netdevbpf@kernel.org=
> wrote:
>
> Hello:
>
> This series was applied to netdev/net-next.git (main)
> by Paolo Abeni <pabeni@redhat.com>:
>
> On Wed, 14 Oct 2026 17:37:14 +0000 you wrote:
> > netmems (pages and net_iovs) have two independent refcounts: a non-pp
> > refcount (page._refcount or binding->ref) governing backing memory
> > lifetime, and pp_ref_count governing recycling within a page_pool while
> > page_pool holds a single backing non-pp reference. SKBs with
> > pp_recycle=3D1 own pp_ref_count references on page_pool fragments; SKBs
> > with pp_recycle=3D0 own non-pp references.
> >
> > [...]
>
> Here is the summary with links:
>   - [net-next,v3,1/6] netmem: rename __get/__put_netmem() to get/put_net_=
iov()
>     https://git.kernel.org/netdev/net-next/c/a868720467d9
>   - [net-next,v3,2/6] net: skbuff: add napi_pp_get_page() and use it in t=
cp_recvmsg_dmabuf()
>     https://git.kernel.org/netdev/net-next/c/729a47b803b5
>   - [net-next,v3,3/6] net: skbuff: replace skb_page_unref() and __skb_fra=
g_unref() with skb_netmem_unref()
>     https://git.kernel.org/netdev/net-next/c/4d688084070e
>   - [net-next,v3,4/6] net: skbuff: replace __skb_frag_ref() with symmetri=
c skb_netmem_ref()
>     https://git.kernel.org/netdev/net-next/c/1f6f88105e1d
>   - [net-next,v3,5/6] net: skbuff: use skb_frag_ref() in skb_try_coalesce=
()
>     https://git.kernel.org/netdev/net-next/c/447f58db3505
>   - [net-next,v3,6/6] net: kunit: test netmem, page_pool, and skb frag re=
fcounting
>     https://git.kernel.org/netdev/net-next/c/2285346afc99
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>

This is awesome. For years the skb refcounting annoyed the hell out of
me. I couldn't fix it on my own; there were too many edge cases I
didn't thoroughly understand and could break. LLMs made this possible.
Thanks!

--
Thanks,
Mina
