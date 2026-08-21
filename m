Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BD0320A34
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319243; cv=pass; b=fLkY6U1zjUkhkxEZL9I25evm5wuA/rKtZ/mcsxRnp1XNbq5Ezu43pexGHoJkAFOtc7N1M+QMHyHGuW2LrXwIXNKIk59tZnvlN0jvh+L7Hu56qv7WeK0YGh6Z9pv1bpWSn+HeCvqr0u3lbbdWCpTlpQrI4+FCI2ePUOSmXzmzNT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319243; c=relaxed/simple;
	bh=nYoghiuz9Kdd84pNDouWdj+ruzp0xFI/cFX1/gP+hvE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TfRNm2i/AWbTQE/UY7+VHGadJP3cv6ZnJK49S+uKiaUC0G+zweEMrVkzxLShtycYPVdUaXLhVXpatFMtjBwdqWKqkAjV+Lv58xLl3gGfkdut+APYw2FF4FK3LGwY7v3g/HpGZ51z53PLheyXzIB2lno6CyBcspZ/pmIC4N3sohU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L6lBhVqF; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6lBhVqF"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c0ecfaee7so6744141cf.0
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 06:34:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787319241; cv=none;
        d=google.com; s=arc-20260327;
        b=OJdYeMjIRcTKmLzHnFNGI9VVkAeMVfFRzpqIVqNIi+tA4sP+ttoRByCYBCjE5w79f9
         9JDf6IhhlvoVpSKRN3XlLpUNkXLjNoJHDmdvgD4asa8oq1e8AmoBOa2eUQAU2xqCgMwj
         1xoE95W70wqL6oH9PdyBdDDzZW0Vn0VuOCjuOWoAg8lOOj/oFZDDHfH+JSUdLV/KqvVq
         T346e8Jehj/qNw26NEoLHerzwhNc9GH6qZn/iK5C+3bH55S3Xlgg4uXOo3/wnxd3Mh1g
         Dy6/Sx4VOrU5f9OVJYbJeRk3TJbZo7TGav5sGdbr1Cv8ZnKoB8xgxU9qR00XHgmfDiwd
         YYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ss8Ivk3OqymC8x/f9L+J2Hz80x7W0eguZdcZDa7wz+E=;
        fh=Zzg4kJM/6O5SOJ0S/yjkFSxTWP7oynaWIN9T/RqhfcM=;
        b=dqSgzbtPl3rNicxSQkm7KeAIht5mfJ/QQDG5pMHHRpxZ4eGUvjjNTzIm/E/vn8333z
         wQ0O41kDgaMSpt18nOtyxgvqrGpKRYFyd+QlaRsNMQP4uD8Js3LPedPWe4k6fPJ7hIrY
         AobFCT83S32ScsKkV3j5zmUuGq2nbHHSoBWmffZo7NSm2EyCNc3XNaW2TZYf3l+2XzQ/
         2EnG2XYSOHrbig5WAekQaqWkN1BNMmATrPmnHcJHTBc+s6LZU+Uyi+pGM0F9YvU6HA11
         yX+dlkM0gSGxR6oZpNrXtZayT81iFVkwaDASaCST9jfmsU12APEKraxqV+m2O/FUDko6
         hHcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787319241; x=1787924041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ss8Ivk3OqymC8x/f9L+J2Hz80x7W0eguZdcZDa7wz+E=;
        b=L6lBhVqFS9NpZWa4D7h4mBqhfDtv/y56qf3cgAeXMxP2mJun/lAPx7yaxvdHlpwOHB
         rjEHojVLp6hyWIn+gekpn403abCkDS9hWlkEXW2SOlWK/zuUi504kAcDVhSek7ps30rx
         kGLnnT3uq4jL6PeI/2+cHhJ63PohWdjP9yOAOVlbRyoNo+vGS9FGrvCOrt2FshLBcDen
         zq0SvbG0csC0QjB5mHpMZFf9TMd9W7cinTGyLdL84kZfRiualNXSNs4GZlnWI5kpSB4N
         M+OxtWMgFuvEMJDglg55KxuRi3UKWNAX0yWDhE1GNjBke2RlQGdRzivbgHQcPSy7v7B3
         DB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787319241; x=1787924041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ss8Ivk3OqymC8x/f9L+J2Hz80x7W0eguZdcZDa7wz+E=;
        b=HoSYMUQCz/jtkwT05tZZ+Bfo9+6NNx11JSmwG9LxuxjGW6oOiPQjtTAvqLucEuFpf2
         A3FyzUWLsLXza/nOIT9g2P15ERXLI53CdkVDUm86rNyBCxqFXFE/j1u9ZQVYJ+UbDAKP
         Wqhzt9W9Wm1aaqrJFrfbq5mRLELUAy59nHtAaNSv0M8hHOZTCTqq0jh0EwZwhKXadt4m
         j3i81dteT/ihb2xMsOQaCKcB3TJl2PDJ/N1KjkuFmmUrhC4L0sWTVbAHbm1bsJJIeNzK
         DctXrkLrwtoyUi0ShBHbT3KK0RxPVWLhLEOF9tBzj34QxXvm+8JOiYZ+DBCZ8o1xHTaO
         aivA==
X-Forwarded-Encrypted: i=1; AHgh+Rr6aV4iRgeFFhzKmLBhRHK4uypM/2zXFTY2oOOJglTEVGrzM2tunIZl+1hL65H04/9vBgpu00eZD8By@vger.kernel.org
X-Gm-Message-State: AOJu0YxSWSOPti+eJBH8onzD3Y6VvL85hgT8zMoAAIG47sqsLCn+DW8i
	SJnxkoBwKcY5pWwVM7Heb8vtbnGTDEvyZQK+iRZdvSzqC4OsYNRJFiB9LhDHVdQr84xe6PeqA+H
	JZqq20fTRSmF8bdRpM0a89e1Et3vDnuFawMVcNaZ0
X-Gm-Gg: AR+sD10l9o2st4rfo1bOUNkALiG9heR/z1cQ/GHlYz4CkusW+SICvnUfX8MoFO/RvFO
	gk5xr00MrC+75evRJMn9fWjW6A289ngTppDpwS2ey3MOlyZ/RFmfSK/dMCpeemS+T3Vx5Twril2
	RKwpK6yjaOQkdtWA8ULBKDFLXkt52p8vzY1bwDkBHI9vJOejtMz8YUMcNXcf6hurr5opaqZJeQM
	RpqHx7uc8UqO48jmm5flG2fi8EfBRABnSuZ8ldZ4Iqi9NOHcC8cLjvZXI/5TcBHZZMvKM6n9HcC
	AFqxGurJF/hiUyGxIt1Np38SknlgL4E9AcJaLR+x37hs3VhzizdZq23xqm+trLRZAlW41wqyEeX
	XBr+cPrDL4gSHBuhtPuY5KjaeXelx2k49utGdnNz3bBbaoPdFnq1j3eJsN37Xv1ApYhTY
X-Received: by 2002:a05:622a:8a:b0:528:17d9:2d99 with SMTP id
 d75a77b69052e-52df5a748c7mr56019081cf.43.1787319239877; Fri, 21 Aug 2026
 06:33:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821070512.3122442-1-edumazet@google.com> <20260821132600.GA1114497@ziepe.ca>
In-Reply-To: <20260821132600.GA1114497@ziepe.ca>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 21 Aug 2026 15:33:47 +0200
X-Gm-Features: AcwNN1V6oNdvFwAAv3HY3JcQlXjx8ONj-vvgS2EgMpIJf3AFwislXa6y7fMMyxw
Message-ID: <CANn89i+qesZmW6tO6tOPriGYYqpxr+c2L7Tdvb2OG-GX0H_ODg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/core: Fix use-after-free in ib_get_eth_speed()
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 3:26=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Aug 21, 2026 at 07:05:12AM +0000, Eric Dumazet wrote:
> > In ib_get_eth_speed(), dev_put(netdev) is called before inspecting
> > rc and dereferencing netdev->name in pr_warn(). If dev_put() drops
> > the final reference to netdev, netdev->name accesses freed memory.
> >
> > Move dev_put(netdev) after the warning block so netdev is kept
> > alive while its name is read.
> >
> > Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed=
 from netdev")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  drivers/infiniband/core/verbs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> I was intending to take this patch next cycle:
>
> https://patchwork.kernel.org/project/linux-rdma/patch/20260812081708.3246=
8-1-krystianmkaniewski@gmail.com/

Ah... I missed that.

>
> Which has the same change embedded?

SGTM thanks.
