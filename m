Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793816327;
	b=L0yGCXdobl00oDk3KiHDy2ge++WvWSvvRB1hfNMzCbldIda6ivWdJDfLGGwUJH3HbyGj
	 MOT3WhTM5r+INuIW+Qd800G+Eu6W4eJu0884+Wx4470u5DT1uipfNQ/f93DcllGZfR/86
	 HMf35kipjWm0hPRnCixBdhb8fRw/CtJFrGvn327OmwMcjcLzXZQr9zLq7pBokGhcUG6tP
	 WqHzC5qy1hBIf515JdFvtnbTZ5C4xQAbAXicjpO0nSWiKCjrH0yS+tZaRNjLaHPA93Kfw
	 IC24SEE+j7Dge+BskLCl38CG+J3eSgKj4FvE16ETnQ8z58AzFjqPu2h9G9Y6+oSWmJQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=4GPzEeskCMuHN+9ELTAtP0YMdODZoiPzj+5M9PuL64Y=;
	b=c737oHQuikuicMQHalVlp9WTvDZfLzOuGzSZ5db4KKtKCVnjZU3rOusao8eT8wZX0QAy
	 NAMHg/ublHHLdH+DuaLQ3/ShCSer1ecl5O5rhzYlZRqEwdHhdTAs8Ryv24IMIfka7nHbx
	 VbPGhVySmjBPD41PCrs5e0tboTQg+9fhbb+iGYW9ckTg7lAsIqjr5BG7eCMD6TJgdK5aX
	 LPDPbW+xGyIdH9CoStXkN0R8Pu0M1RsQnW2BbWNzJO7PvSc3qaPQ8iRHPYu9+5+PdxAlA
	 oWFhJyImVr+FOJu+9DXiYnPKA1YC/q99Vcs8NRANKFx+WwBUFQ92WCTua7+VsQKegAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c68PXakd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41214606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 18:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41214606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c68PXakd
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3b094fb376cso154870a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 10:18:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793816326; cv=none;
        d=google.com; s=arc-20260327;
        b=VAGYtqwaTlIFyNPAxMzLPD2+6bTxey25YoTjK/LVJyPY1X2xJ7ruHHmCw5oMjOqMhY
         8GOcFurP8xFPF0Aij9aQej6L/3bZgtoebrBnpjEZbxBOghp35zujEh0zCIwvY71bmhgL
         1lHd/JoBSJxRZUgCXjnQv1T8l20jPGJ9sPyfumkRKIJHpOGvrTw8HOwI5ko+sI3e4NXl
         zw2TU0YsDgs5Gflx9eSNA4h79aDqBznWRuKwxi7SFN5CavU7OekoQy+cXVPs0A6FGmwG
         v4sB9Dcv56Uz8WAfIoc6HyZ6+jq4fo7OGCD5pHePvVv51q7rW53UtWqY8DnYo5t/9S9W
         6OMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4GPzEeskCMuHN+9ELTAtP0YMdODZoiPzj+5M9PuL64Y=;
        fh=Xa1mCvsgTtMrcpUaIchoOCEJNoBV0Ne0fjxXrx1X4O0=;
        b=ccVLDrWW4HAy8FXl97XZaGWrKo27dZCl8EGRQS0zGU6FZOq76Ht7dSPHQP4c56OyUQ
         jQwieUfA/ywzL4XAegtGaOw2OfMEL0yhM/uN+j4lMinXJtXrjFhnmJybe043+q7u1P+V
         5ZFGvUVuvR59lzaZIiWd4leVCEl7Aymve67ZlhOeRJ8pZdfMW7oki0WwqUOUJFcn6/tO
         mTAKRLPR9muDuxZBXyH/MxQmLk51Efbze6ohLi1MttIMVbsDUG4yrc8zl3YA5qjs/BFY
         b81vmTUaMYlAzrDQG+GBfS5f8ghvBwMafOEu1pS6RC8IOtrVQmUb7xDVYJSDHeiNNOhm
         3xqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793816326; x=1794421126; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4GPzEeskCMuHN+9ELTAtP0YMdODZoiPzj+5M9PuL64Y=;
        b=c68PXakdXhEO5dlYzvgscPLyWrKpe8P4Marnie+H4cl2bi2BHcIZJX+c9l+dBSiOt5
         qjiT8aXawR9AlJR66KOG7jquxhl7uANljiyCtXVsjqPIEh2GHIf9AVBNN0/+yL+mf3bm
         Yj9m/Hnru8VAaAS7KJsTr7xjVOR3FZCHXoSn0JufzuNU9oOzHtiASm77/UMgcXclMLC7
         tLM14EeCclvivKn9q9dQV9jxHtcRasNAlCihS92jc0/f+MeoVLGjc8xc0T+W2Z9gOkJy
         zFJx3B4sHRYCPA0Ns9eKfWMJ5Y5725Wy5Hlo1H9+3c9UQWNVNHSvrc2cSq70KX1oFKAY
         /gEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793816326; x=1794421126;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4GPzEeskCMuHN+9ELTAtP0YMdODZoiPzj+5M9PuL64Y=;
        b=rECJ21eNR86pWCMLES7QD99EGgqLLdggFG10Y7M26ZA78fle2SzOi+hdRypLBMR8e8
         /5lisXqpiPyT5DGL3R67+MDzU6uX/SEhD6NWCl386fmRCW/AwZVD6AmyklExMJGX+ess
         D6nVb+DDIl/LQzDguz+4WWqtlxDwXiau4W6Jv5OusB3jj+Tm9eN+3rxMBZBdx9pbRhWx
         TRVJ3vfYqlfjRh2VTMT/fzgoJmoi2PSmTTteLlmCzLlEvKJbeI/uxuw8ZicyPMI0G4+t
         MVnn+Zu/O4zNINzxeNjVYJabhAtoRbMGMh8C2RJwPD+2xXIqnoSskTn3+ghYnL1NIHcC
         nEfw==
X-Forwarded-Encrypted: i=1; AKwUvBx3wqh4JY3LZXBBK+0PhVrcvBNpbSuFeNMlkYEbtMtsZHnZbWhLNsNzKU1olaGu3K5MKHxllMcRlXVr@vger.kernel.org
X-Gm-Message-State: APuU4Z//2Hj7ZuOTjLd9ee+e1yHucsN6sFrSRkgLM4CpBxjRVa/ERCDl
	0FNDDf9cRPHOstzBzbPGPghkdxGDod48mvrGjaLqzVJ3EmxqXfV9Ys18nGfJMrzuDbyXEt/Kequ
	/TmyqoC7j9CfS0nPP/OuqvXkKiktGpyI=
X-Gm-Gg: AYBFou3lpsRBQy6utn2rOSDRsjpHqnh/jMQ/A4X8nZusn3Eru83BCC/i3brJZkV5n+I
	zeVPJiqfo/muM3X5Y60TFV/52QaWQZOofgp4laf6MM8nEudgdI0M9DV5yiM9MfA1/RUNB2g+THz
	gNH24e6AnPbncOY32tRRk3unS9goRp8hvic+l9ve0tb2rgQ3r1afpnd4E9N/oZudaLRzVSszgNo
	QoxTnhzps3nXKbXR+uyp6vqH170uFg06T7HMGzVQc5W6ZsNRu05Jt3wAhAlqFHM9c8F82cYbcOB
	61xpb5EVAo4s/g+81wgogIi0RI0OAf9mRprJpVs/kZRNdsgaXeIEhHHecdHBawsdyvsbnpxs1Uh
	nkTMiLgwwuVms/Kp1Vw0WwTzIsZk4XqOmYfjfUr1t2Jvb6Hq6lzPfHulO8Ww=
X-Received: by 2002:a17:90a:fb8f:b0:3b0:9e2f:cfc5 with SMTP id
 98e67ed59e1d1-3b09e2fd7f7mr2261179a91.1.1793816326501; Wed, 04 Nov 2026
 10:18:46 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103170703.1600310-1-lui2012qwq@gmail.com> <20261104140608.GF478286@unreal>
In-Reply-To: <20261104140608.GF478286@unreal>
From: Chengyu Liu <lui2012qwq@gmail.com>
Date: Thu, 5 Nov 2026 02:18:30 +0800
X-Gm-Features: AclHuK_OH9O0hxjTTaAz9x62fRlwS-_o5uMRpIReHTKZ5ae0puZ_WpbvlqiHt_0
Message-ID: <CAE=Q7=5iOdUgPsD7dg722e55_1wNR2Uh9LnCT524wiFAD6=sHw@mail.gmail.com>
Subject: Re: [PATCH] RDMA/ipoib: cancel the AH reaper work synchronously
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 04, 2026, Leon Romanovsky wrote:
> Please revisit this once you can reproduce the issue with real IPoIB code,
> not code that merely resembles it.

ok.  Reproduced on stock, unmodified ib_ipoib running over a Soft-RoCE
(rxe) transport in QEMU - the harness shims sit below ib_ipoib and the
driver itself is untouched.  The escaped reaper re-arms and the timer
fires one second after the teardown on the destroyed workqueue:

    BUG: KASAN: use-after-free in __run_timer_base.part.0+0x80c/0x900
    Write of size 8 by task swapper/0/0

v2 is posted as a fresh thread; it carries the full harness diff and
reproducer inline.  Changes vs v1:
 - cancel_delayed_work_sync() -> disable_delayed_work_sync(), so the
   work stays disabled past the teardown instead of being re-enabled;
 - the misleading comment above ipoib_stop_ah_reaper() fixed (the final
   ipoib_reap_dead_ahs() never touches the work item).

v1: https://lore.kernel.org/r/<20261103170703.1600310-1-lui2012qwq@gmail.com>

Chengyu
