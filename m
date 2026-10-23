Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792764516;
	b=yZpzOBfWYSNpR8idZvYOhrz3a1Ef4m75ANMTwQIET7Cxb1vHfELGZA85D+W6vEjJbgfR
	 0lUGN8Mnfcv1KIGOYrBSi5Qrq77WWLIIWcIWJCkFMpFn2LYd44l924VL8ZnuPjrThqWL2
	 QJikJAvMG+cGTRvE4QDflNMb31Yts5EZDM3BEtJAotNOxJzkJvW0LT7gmCPZhbSZPsg/B
	 qJStykJ9GByFwJHjVQH2+ZIu2tiSIcMB1LUrMKJnY8/ZS8dhNX6jH/6MhAUoXefJ4UXBX
	 njU3Mj3bYrr2alF9sRFBibu5jY9ePhuLbhHwrLGO5+jTKCd46t09rA29+PgqjcxnQ1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792764516;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=S2REWJ/GvPB6717oRRTOl7lftZMNqJJK4+idsMBqa34=;
	b=Sxe0lBc9KPqoAYNZkVkhuIFxUkweIctL6GC4v/t6XAMfaRPSmn7/TiMnVRQ1mE7UDy0X
	 x4mMO//ys7QHy0oqZRsi97FAt0V5WzuE64dU1EjAL7PKsPQ/vfhSeDcOuuypeyl0J77yV
	 8OZcgLyMMfURILLJIYvUpHkE1XQhDMnxahh3Mtq0sctYb9EBmDKsl+uOJT4N3+T7y5tfG
	 RKAOPE0a7MO1jL522bUuZYJ/leDFtDCQYc5ovzOIzGTD3E0hgEgdS71z/8TttbKACz4r0
	 QO8EfvkQ769wx3CKJAhKZMCkB1M5NCrEjBEaP5aWIZThBTzHUlrqlwpDgBgGz5ZyCmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=juxs7H9d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.47
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB1A606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 14:08:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEB1A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=juxs7H9d
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6faddda49e7so803871eaf.3
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 07:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792764515; cv=none;
        d=google.com; s=arc-20260327;
        b=RvKJVNqGyRHJpR2c2j58nPt3SHjPYH5t9HhmD/3U4VfYPVYNG0JpUYzA5oYNUf8chZ
         8ZyzQr8M1rp1BmYaYQjlyjpGnvZvLS3xq95lDLGdi/cgopOyV8YdFPzJyWV45YhspCgR
         UPVqfGFUpSsP6TXACv2L1whiB8nvAYM3815t3TrAA/mjiS1Xr+iVNENkXWmfpnGOptq1
         b7O4rq+2Ps21vmjbCwsW0S9lQlh/CTC6tgjLbaGTsBqRlKP71Q+btGs1cfP6ft0wF1YG
         WTqRi+EDfP1BV4TN3Mntv+YkvocqtW4+36q007RpwnsiBDNSGjhrGfDS6N+FKk4tZkqr
         HP9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S2REWJ/GvPB6717oRRTOl7lftZMNqJJK4+idsMBqa34=;
        fh=DTiImflfmqOTGPMfFOnXATj4q7/BAhn1l/uuwha82RQ=;
        b=QufmtZy7206yl6Gz1oLG876Gnlg2q3S13Hq88ywc3t0pFk94H7UMITCXd100aBxA08
         2NmLfo+4zSNZOfQyix7aWUE5FABmIAiDKZ4DDo1VR3p4X0PXbZT1zOx6lQP/T0NLzUBa
         IxKsEqGWzJLKIQgKiqK8ofwvthUIq61t0njgdwydoj/sDe7r/YKnMisop3yd6v74wWBT
         f43/UVvC07ddGl5GI1P7bzqSzGVTRCutsmshO8ctrIst2JcfQ+KOEqUlK2ym7PO4/89F
         1iR90ppL+Z5xx5ev5wDpT0Zjv/VFzf4nBevbiw34fe3p5DI8CAWwpih8rTR2JEab5CaF
         bglQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792764515; x=1793369315; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S2REWJ/GvPB6717oRRTOl7lftZMNqJJK4+idsMBqa34=;
        b=juxs7H9dLJSa8dQz21+iLajiQ3GOniiUswoPVMJb7ShaVdvVrtZWqQ4plXIt+WfdaS
         xsYFuenmrFSHDHKuQZQNeMWckMNQq6szVAyWbEet/emB8jHw9MNi2iJyBCPvRHT+9OZd
         EOXc+xe/SwI2yjBTDQxpJ1sA66saKLgUR4v1qbTmOcTx7uJKg53VeFjTLcv4w1fk0nU0
         ucoEjPv1GSIvuKYOroFiITvGc1T+qoOguJiKqdJcfrd2VPr3eS7nznbF0+Eg90FJdDV6
         5YVDaeUgyNJfFJkgse4DlJla+7poCHdQD5tnRtsVZhKtomvcPR2V5hkT0C2nUWLAGMl2
         mDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764515; x=1793369315;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S2REWJ/GvPB6717oRRTOl7lftZMNqJJK4+idsMBqa34=;
        b=mFgTpYRR3vwiSzpzQUjCqNaEnDaHVNFmva3JsW03pzNxGX4EWkJI7F9F6EY7IVpF0b
         COdJRP3PR8fpsNyQ0FlLX5ZkUDLRgiAJEFKHkj6RJtvMWD+thp5BjolHzw6X1tl/fpOI
         UIHdPc9d431TfjEziVWaPdNR0fnLQrIte6uoKy3csFOAui6XQurjb4guExV2M9We+UuU
         P2QWeFD4mYAnTLYEtTvBrIbyCPdsped5OEvZBsiNfbHSuw6OPpGpKV6dXRsxWXFOIlqX
         JrGzfW+DNkDbA/uyujxP0N/yCw7NuW6nF56TEcr4ELJ7Ib5czZqWXM5GHItSzD2vzWuN
         eLEw==
X-Forwarded-Encrypted: i=1; AKwUvByikVQ4nbgomVdCIYd9CK4AnaZWGbMktPsmsfdBaqll2C2NgGvB+Vw3gIHMvnCb6w8V+3numWzSWTfJ@vger.kernel.org
X-Gm-Message-State: AFq9FYKwQ7aQezNvHzG8HouIRcX9o3ULy/2kqy+TNxsonj8v1ghEUNZU
	jMchmEKceQOqPSVVjP3nE8RFS68L9g92QLnHYHIxhEufbolHt3yNlssOaiSvKfU3IY7OrBPzFks
	nIZEwKq479I0GXG8uG7v/Xb5EwRqEyAk=
X-Gm-Gg: AYBFou0lQx+aEMcybuZxDizGwgGcG6jVsENfADHnVtWNTjFguk/54OZkLCz3utBFJYO
	kTvoWTBX5j+mGCwjxbNgqHZK3YtFcHo9Xtlw9CZkLYDCOKjKSTQ8nIyyZSs7FgaSe+P76dTOSFj
	QXhuGQaEl3pejVeqbYeIVuWZEztze4gKlC/ZmIcYGCzhC+qoWUc1zUXZW74+VtTK/prRMW/JoGw
	TC/GNfx7nmsu9ckkLmRiOqmr+jUUPzzM3q22nqyQw7rtNnMQyvqFQtDnDjt55SBQccaOaoMgPJo
	rop/i/oqX48iVtyIrp91asC7I/eU+kTWPb7xiOHg0Wi/c2tAg/7alo94LNHDeWdsixLVBAisKuf
	Y2gTvTDAO1UeaNX+CR0HqgL5j/J+AjsCXpMv5IDOOOlqRnV3ALhjSh4WtsBKKDRfiJCpltSLZ4W
	Zej2QkP0X3UWtpBa3WANOJYAoOEjX+dorVXFSmTjG9PctSUH4FFctf2fet8yqEdrLOpY+rvQNFF
	xwXxBPAB+opnT5CQ23Em2ESFMocLP7K9JcS
X-Received: by 2002:a05:6820:4a90:b0:6df:5b31:f4b7 with SMTP id
 006d021491bc7-70b88ac3f67mr1281880eaf.88.1792764514641; Fri, 23 Oct 2026
 07:08:34 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020164239.3808903-1-pdmorrow@gmail.com> <20261022101915.GD708417@horms.kernel.org>
In-Reply-To: <20261022101915.GD708417@horms.kernel.org>
From: Peter Morrow <pdmorrow@gmail.com>
Date: Fri, 23 Oct 2026 15:08:23 +0100
X-Gm-Features: AclHuK8R07txa0xm0_-np_t35olNW-DUc3QolGlTZDQiIjd3HXrAI5wxtlVE198
Message-ID: <CAFcZKTyrRKS+A1cb4ZrjgbEwJpEHMVNCW=Bx+emzrBdC8H-mug@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary devices
To: Simon Horman <horms@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Yishai Hadas <yishaih@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Eric Dumazet <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Oct 2026 at 11:19, Simon Horman <horms@kernel.org> wrote:
>
> Thanks, this looks good to me.
> And I think the minimal approach taken here is appropriate for net.
>
> Reviewed-by: Simon Horman <horms@kernel.org>
>
> I do, however, wonder if a follow-up is warranted.
> It seems to me that the is_supported callback could
> be removed entirely. Leaving either:
> 1. struct mlx4_adev_device with a single member, .suffix
> 2. mlx4_adev_devices as an array of of strings
>
> To explore this idea a little further I tried coding-up approach 2.
> Which lead to the following (compile tested only):
[...]

Thanks Simon. Agreed, a cleanup here would be nice. I'm happy to test
and send your suggested patch to net-next once/if the reviewed change is
merged, unless you'd like to send it yourself.

Thanks,
Peter
