Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E0D64D
	for <linux-rdma@vger.kernel.org>; Wed,  9 Oct 2024 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728479292; cv=none; b=mVTTdcC9KCx8ZYdQgbWkKFpsk6KR8CaHYULMKQT0uFIIfXfBwkrNEqZvdNgxKgzFvvIgbzDaNwgSycs+Aj9YmFTeIc/8qlTT/AbnW/0fqhTTznOi7xSq7tFkI7vvfQiH2vPuf7H7tbykwDcnmF8s0dUCW6QhY6swq8AoPuWCwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728479292; c=relaxed/simple;
	bh=vCQMT4/OGh33l5VSSGRJ9d7C/T789iko1vgWGYbPl3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bx4I2vuAsmNYeTLVobVQMZ7g5e82COagxSVC4ZxkrEicx6IfNbkcgi/A8YC5BkGly3hcc+q5TIJYthOZ59PbGUqg12rf07Ade3JpLz5RpIEHzLqh4Z+Di9OMFJLLiAEVnrYW2wvAtMwXgXh/MjrCVNC0toevEjWP45vyN3sB7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i6Ev8wWy; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i6Ev8wWy"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c928e03ac7so750945a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 09 Oct 2024 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728479289; x=1729084089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCQMT4/OGh33l5VSSGRJ9d7C/T789iko1vgWGYbPl3c=;
        b=i6Ev8wWyrJJ0Yl0c1tbvd5CmJHJjJWPTrfBJb1pGNFjIepCCc7/a8hDS7cnDANcLP4
         HfExdkHtbZOImNku/VdHtl70314hhzYL/2FOeiUswb/7LNWofZ0Zes7g3YGn6CkvGKwo
         auzUAv6CswEdvouXHjR+60F7cUH06Rri5UWzKLJKu8IrzhtQFRB3WVWueJt666buz9Bm
         t/paGayUYqTD6Uxc9Zvl7dEOKqxa94w2UxrKno7377DrMNYdEL0QK1gBSXIiDMZ6bGED
         48fq921UWwAcnDG9+8u7WjgfKj+Hcn1GKAwE4CyGlkyAr7sdUVNzjAPkC73xm30zCYou
         i9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728479289; x=1729084089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCQMT4/OGh33l5VSSGRJ9d7C/T789iko1vgWGYbPl3c=;
        b=QaKTvJzzQoxg7hXweXLwFcdwurKCllLJutQIEpAkXiHwrkJnQg4cTT/9U26hkdiJuk
         sC9QPG5FxcrWZH433GdtQS92r1rjpw9jwgEwshEDHtcll/sky6mxKIBLRt8bXrkpJJTD
         uq66+ospUaaBS/MNDpKHaVmGtA74PyOE67N+LyeA4soRkw66xtUIZkU6BWlGCfMBeTtJ
         f8eQUFJPtkZ98EGTCjEO5rhYi4z3hwN828UMaVsUjdK/q06KrpgWwEs7yk/n3vvkPLXs
         THF+g6DJCRqaGDzZ97KGkSH3jJ9dq7NjJxmKa7AwAvr8c6xF/2YzKmwl3Cyzz4bBln7g
         ux9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWKBqhlHewFKHzSLciVcxkkmTNTQf6UP6/nGWeuCg0vqmQbq5FsN/bfrVgFNey/leDj4cfYXzp+jeSg@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ2XrkwSW+rGS91TNTdiDH4g654IXyNQuKJ26TTxG+wFR438xd
	LeTQ9s4F37n3jzm2sf2ZdD80kxL4xwCczfVb1cj78pmGTWEc3YD5BmuMGAfQnfO68f1L+gUqmFv
	pi0SmZsD07yMIkpYMyY46E6Wv3NUNays1kpvR
X-Google-Smtp-Source: AGHT+IFwK3xKFaDSSCvmmCWjZJRLZHvuDOCWYPKnAPbZzhaE0XDUbBsW+cRSZvarCC5CcONpOhTI9Gbt8lX1yJczGgs=
X-Received: by 2002:a05:6402:26cd:b0:5c5:c444:4e3a with SMTP id
 4fb4d7f45d1cf-5c91ce41ba7mr2845945a12.0.1728479288868; Wed, 09 Oct 2024
 06:08:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1728456916-67035-1-git-send-email-alibuda@linux.alibaba.com>
In-Reply-To: <1728456916-67035-1-git-send-email-alibuda@linux.alibaba.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 9 Oct 2024 15:07:54 +0200
Message-ID: <CANn89iLHwsKVQo_aVwVQAt3fpZ2E3SL3eM2-v+RacwbOdUqePg@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: fix lacks of icsk_syn_mss with IPPROTO_SMC
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com, 
	wintera@linux.ibm.com, guwen@linux.alibaba.com, kuba@kernel.org, 
	davem@davemloft.net, netdev@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-rdma@vger.kernel.org, tonylu@linux.alibaba.com, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 8:55=E2=80=AFAM D. Wythe <alibuda@linux.alibaba.com>=
 wrote:
>
> From: "D. Wythe" <alibuda@linux.alibaba.com>
>
> Eric report a panic on IPPROTO_SMC, and give the facts
> that when INET_PROTOSW_ICSK was set, icsk->icsk_sync_mss must be set too.
>
>

> This patch add a toy implementation that performs a simple return to
> prevent such panic. This is because MSS can be set in sock_create_kern
> or smc_setsockopt, similar to how it's done in AF_SMC. However, for
> AF_SMC, there is currently no way to synchronize MSS within
> __sys_connect_file. This toy implementation lays the groundwork for us
> to support such feature for IPPROTO_SMC in the future.
>
> Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
