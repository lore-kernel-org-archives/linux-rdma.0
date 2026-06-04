Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5599547DD76
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780580499; cv=pass; b=uaNXsuqDo1qTgjLvWOoS/RT6+tmMAQFvRxMpobGPVZO2MR8HsQrC5BCaYrOndr1Y4Ir/qbAd3Qg74stcB6TF7Ijh5r7acYjM0hGkGrYSF9HbnLRRVe/rU8L3o4TvjfElyqaBJ68yBha6rjpyeQuTagioyAoNAseH1Ruq0SJS8Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780580499; c=relaxed/simple;
	bh=0pZ6UEG5LYJ2YTzqm9HzuN5LHI1/FoEeBB4ApoRRDfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U6IIU6HnPVp0mUUo2knPQ+DYPKevbISft0YsAqg1IN1Hr83c+jhbhhIlYptAcit3V7Lp5I+iglBLsRt5BU5tilxc7csLSUuUEClNSirpfW61bJNgo7n/WzAoWhv4TAussIHX251DMj1hDmpchRgalBpCG/YwkP4H2dhIwQALhoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HJq/ShRq; arc=pass smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HJq/ShRq"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43d3427401fso585878fac.0
        for <linux-rdma@vger.kernel.org>; Thu, 04 Jun 2026 06:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780580496; cv=none;
        d=google.com; s=arc-20240605;
        b=H/hsLe72sdg2nn5TJ8GjlMWFqFwH1gdR1IgPCiEDjkIGHjoP7JWNCB6Dwyc1uIlG1Y
         +yvtrgLUmzqD012WqUXZHx2W3bNMgSqj64uTNTcUIaNp83dIhGeLzGcxC+fBCRddOwTC
         X5/UqdONweecWMqlAUVUCpbPY0KV8XzLffk4C4DZD2/c1G082p6qWD6wNtAbekbFt++A
         tSsCVBx0eSqItYJ5treoYW7oIjLU8ty+kmh0JlvIYS6wNvfbZw1qHoaeCf2EWlh/Ltuw
         YGEx72gsz5PPmKbLYNbHRNmp+2E0c7O5QoLHuvz+aL8j+WyMnZy4K67aM9cer/KCpuVz
         ZSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0pZ6UEG5LYJ2YTzqm9HzuN5LHI1/FoEeBB4ApoRRDfY=;
        fh=+EOQFc/7//xrV564wYFm3A2Klq/kZOPyk0StXp5JL3A=;
        b=A3bgKgXaXwLl9j7zMVTC9I2p4qtTRo6n6KGuJD12vbqC1q5sOqqgPK+/fTgHqWD/Pn
         +1vKhdBaijgpJvZhhJWAKWMy24/hvfZsQLmzlOIDkSLaxVxC1lFHccb6ZiRJBkOvUWq9
         GjwUcfEhavKdbC1SlQbee9OUAkJ0qPSouFORPi9FEC16vpkss3+ztmvYo8uUpEBKFy+J
         6VLStshaQjeenEe4A4sAMGNtNIi+He+YAWEFDuqOMrsibcCuhN8oFNFd0aZwJFdruS8Q
         CcHHubgZWF9Sn4a8ERjyVt5KyRa3CXCqsbrhb7vXpP4tAzv/RhuNP4CJeafgkPjGoIOi
         1l4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780580496; x=1781185296; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0pZ6UEG5LYJ2YTzqm9HzuN5LHI1/FoEeBB4ApoRRDfY=;
        b=HJq/ShRqKeyTaLg8EUJMtku4GrpZYUTADiuUjV7gD2JXPy9rd2zLssFVrc0AelG3Te
         tzLIpG5kZyIlNwU8FByw+mY7KWe/6LS0A5fPHYDW9pXgX8tLxjwMU76cYvu8sVZ8+WMF
         7hhaJozmnhPZ4PCs/eYDGRc3lz0SiEru1kKzGoqDVY2mFIM7YAEJRjVm5Zb0Un9vAfZ1
         vnWnuqxn8osOp/DMyqul7jqCz0hrKrd8avivgkPug1NeNvS7TX+uzgb/W2FZAYaAfx2H
         wft4hu8DVw8yKlwIyI73O/w9KuJYof/pOWJHpo9uj72c8/vXO/RNw7IRCc1YV837iHen
         csFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780580496; x=1781185296;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pZ6UEG5LYJ2YTzqm9HzuN5LHI1/FoEeBB4ApoRRDfY=;
        b=Tarv74jNLC/57Wj8zGgT4gk6JsvQW9iyZXCETQTmShwc0FLB7WoVZnSGRNoVEVGbPF
         J89z0QW0dfoEFPe1ZyHRURrfZkzuZqDzsATUUY1TSbTPg6ZIlaDVOH337xAvS9iJUV2r
         Cf4VVdTxjv8a9znVE+dB7OHft0fgXlIGtSAvyS2sMPPt/+yGAd69vIqCI2yU9xzl1QgP
         znThhocKOmfl2P6VLjEcLBYF2zk/QnXyvov66iS3NZ9hESDju+BbM7TyuGDaf0YC3FIT
         /zl65BOAYK2MKqICpq49TTb/ihPTY0+EvzeHTI5EyTKZ1iznJOauCy1NMc+RSrjHmDXC
         TOYg==
X-Forwarded-Encrypted: i=1; AFNElJ95bSqBjQOIx5J5T58TR2FXjn/UksjHf8i77zxk3lfIwlIrjIafpqMw9JmLiXmbzztaFlc8c4EcwaAL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6rjAvaoANfcbMP0bo/BT4ndT20Us8i35P+HRI1oV0TSKHaKem
	1c/PwYzx/ZKawzdSELXi9IkS/x5j6NtYkmbgkAkS0JP+f0HTd33SjwcjSs2URH7dnNTqhz3mWXD
	kUqMlG3jzNMUpTnOJMRAPzTrs7qwoFX2iJh2a/t7l
X-Gm-Gg: Acq92OEvtTYeyDTHGZTRg1IpMAk/fsG/97CbYsrS7r1Lz6I134AbnN9Yc8nFqW4ca+F
	FU5mRO3oA1qz/YpJP48GlN4CgFg7hNskcHVtbBRD9V0nTw7xxCYmuhFoMSBVG7bADrmcH/n33DY
	WoavV973PtzJfqimJV1b7nnPh0PZPhN5MwwvNs8mq0n7psWAlLu3Aj8aIeIK/lUVAWsoxt+IdCR
	6cwrHFlkIbkXeBHjxfMyI264RrEmBTbcENPUmUo4oISY4d0EUeWGlUKC5W87Yw3U5dye3C/PFj0
	UZZ3hvhZIBXQKf0BF376LEcQSpc86ecJ8xARhRK3wbZmzRkd82eh
X-Received: by 2002:a05:6871:8906:b0:424:6f4:fd12 with SMTP id
 586e51a60fabf-440db591034mr4897698fac.3.1780580495748; Thu, 04 Jun 2026
 06:41:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260604083440.426033-1-hanguidong02@gmail.com>
In-Reply-To: <20260604083440.426033-1-hanguidong02@gmail.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Thu, 4 Jun 2026 09:41:24 -0400
X-Gm-Features: AVHnY4LnnOFQwtcHl3MpBS-iyHtALRrvE9c-bpLAjwX2-AA-1ATT9WbikfSY-Dk
Message-ID: <CAHYDg1R=wPOwZnC3XnnrTB0DjkBoiD++ihV9Ts6k8zDYaXkwQg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Use acquire/release for CQP request completion
To: Gui-Dong Han <hanguidong02@gmail.com>
Cc: krzysztof.czurylo@intel.com, tatyana.e.nikolova@intel.com, 
	linux-rdma@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, 
	mustafa.ismail@intel.com, shiraz.saleem@intel.com, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

Makes sense to me.

That said, I wonder if we should just get rid of the wait queue + explicit
flag and replace it with a completion?

- Jake
