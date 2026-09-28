Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BD138F624
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576193; cv=pass; b=ACxJV8mRtCfHzFQbPLZL/7a3j+RJATtJWH9cV63/jfFCHEbifYb5rgXgq0IsjUOHI74LZ/vrptNV2fjh65utI7RF4UCS8aFSatQ30MSB7sbnuhLKMIuhIS15cAMuTGaCMs4g2DkLU9YJRw5UTrzEdcMmIUFndqRUAT0TxJopgZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576193; c=relaxed/simple;
	bh=UjLMTkNUsMTAhppS3VjvlrSLbd3vV2p7wtKDBinOEwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0uJbF8WeLxvztln8lN1uHLqckfVtAOsMaXGesLKv1OksnNoGZiyImei8JQhQ9BxyAdr57XPsG0j+sq4BMkQVZel8p7gXVZfyfELaT/K+hDrJqGcuTqCDdy9EyWt2PDB43wf5ItFF99xdC0ffSg8wDwXlSdJGUF+dCR2pmBPYnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KXDR2pEM; arc=pass smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXDR2pEM"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a9a26ce219so419857a12.3
        for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 23:16:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790576190; cv=none;
        d=google.com; s=arc-20260327;
        b=P9vvV8Mpi1g+Ks+m8YsaIOSaaze2xTmknqd+GB+elOU++I5nfvqJsrbPKvCgY+W3lI
         AINvDGkiojh3n15tYJsux15rlqNkNX8gj0bQW/CsY/VDSt435ZiSaVTxE4KNUtnlBs21
         B4A3FEv6SIsZ9THbGbGSgKmQBfRSOO4lwswJnSnyP8XY3rH5N5E/XBz9vcwck/qYkUR7
         /Yyq4mV+InOZrvrc4JFZlmKQZDeK8DVJuFFWNoNZI2+qQIc2V0WCBnaxQiqccxIKxbdS
         yRdKOyKDzixJqi7ktVIfL2DMCLY2erbHCqz6n/hrMyy4EbO2Yl2cI2SP0L5Cm6UXEzk6
         /mTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UjLMTkNUsMTAhppS3VjvlrSLbd3vV2p7wtKDBinOEwQ=;
        fh=HaIhJ48nWL3YTBhn/mHlMssOJAjlPoRXkaJra8lX0Ms=;
        b=Lmyd7B3Ujyni0MAPFq7ukbuKT/NIYV5d2pl1UCGLewrLVpgOF6ewNQDZmFK/OmyEZ1
         IyPhF+6VvhfUL2pcln7xgQaEp7OssF5s3gvqEb4KbxT06EUIo03Cg0cG6Wm56gSBF/It
         0W+1CrDgdnYMQonqYFfiILVpRxl5XfSP59zfracmsiwqpNe7JzcVEn+IWjCMCd0aBpdZ
         hG2Ey/bjoFA74Kf5N3BhxOUQDbDnlc1HXxkKXFaYUSJpQTNCn3VO0ts9J/mXALwI+o+H
         v5aSmG79CRKxU5KGj9fPLK0dBQXST0BRFxHZgsH+i16vx0g/m61+QQKw89FMzWnkWSxp
         ovDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790576190; x=1791180990; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UjLMTkNUsMTAhppS3VjvlrSLbd3vV2p7wtKDBinOEwQ=;
        b=KXDR2pEM1JTLSxBj3wu9/o164MNmf454aZ44Thf2vTM156Ks03aMOJq5qhUWpydv7w
         36dX8Lb++kFHLk7kqmqu4aABQ/f4OruhsYjcBE8lrUwl8ksmWOruS+UZtlJzfC/seFZr
         HavIZXgr0de1ONBuIegYb4ZJM0v0ZtJMGZscsKr/vfVkd41aD/PVymcPgi/6iGTud0Fq
         DLNJpmxvWn50jAkXnKdPy+zJw6rcz5Xy//6P/Js/ftYPFJl2M2R9Rpd+HW9RCE/Tc0xB
         g+qNzwzqph/No56lN78rZ05898pllNfOGRguS5ZYQLXjj5+/cFR16gM1lQ+An4Lxfc7f
         b2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576190; x=1791180990;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UjLMTkNUsMTAhppS3VjvlrSLbd3vV2p7wtKDBinOEwQ=;
        b=RJr0gNWScyBtbeaeI1eLzXPvf3+2f17M4oExE2nc1YzRBh+Blj4Ik2+khXv7aZc8vP
         pgNfk7ZHEGxIZCJwBzcFdDuOGfs+1jL7W25DpxaXTLgYAeuzXpSx4EQ59lUU4m2P4VvW
         9VoL6ECIrdM2AkTyk50VP6icnvo9+BiEm8YnmQ94P3tIId5SWBPDFLLgaWqBVe9/K1oe
         IfZNkXNKkEQYQa09FJ3ggWF0mmy8AaUscewcUCowaW8A4LbYKqBW319q78RG91VheKhU
         3P6t+fsuXThmAFTwmfi7xE+7NHsBax3zIqXJ1vXroJx4qoBNEkMWQlXOgEpYKOHIclnr
         Pj3A==
X-Forwarded-Encrypted: i=1; AKwUvBzmVTggreIOXrnnWYg+cGO/9BhSFSXiuac1PFoJ1o1cmIx8YpRvll1/ANdPrgSWNUo+50V+w0dJ7Obz@vger.kernel.org
X-Gm-Message-State: AFq9FYLTp7EYIS8lkgRToEI8Z9WL6W8vxhbeuG3lh/wfWu1X0VFbfWeW
	REtoYyoXbenLspQ4ZRtBe3SmBqJxj8EGcUFi4Y2pNEfsbAYj5z3249EgzYVXP9r31Wumi5V+KCb
	4egZyoPm9SdKUr9mFnQq84nDOMVrCuJw=
X-Gm-Gg: AYBFou3SdiGfEte8PtrnDZEbJA5ACTfAEbf8B8ttpbTygilXcwivVIx10oPCaf6GaO6
	ZI5YY//4HFzQwBMhWG4wQs4OpglzTpYqftyrnlty9Swl294F2TILXjkj2n+fuY5CeyS88E5AX91
	+DGRgJ5vR2EmaWg7wMP7+B5086AJ3Sr1jeuFgsj3YL780AhPTsFavh4r2j4MqAQZekPDZDbQz4B
	BT8h44YJmiqJoqvff2KJ8l7lZlsYun0vJgJYDOfmikP5UG4G8505J00cSWb0nag3ySQVF4jf51F
	GomWkcuWe6KQnM9T4sq7JFg2jtqqHnbVuQm+0Q4XdPxi3sjt2kt/YHufKX38bjh3g87q71Km6Zf
	4zASHivm4Xj4=
X-Received: by 2002:a05:6402:400b:b0:6aa:91c2:63b0 with SMTP id
 4fb4d7f45d1cf-6aae1fb697dmr8189174a12.2.1790576189556; Sun, 27 Sep 2026
 23:16:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260927073203.3694279-1-nicoyip.dev@gmail.com> <7960d73e-e316-4853-8398-144742e866d3@linux.ibm.com>
In-Reply-To: <7960d73e-e316-4853-8398-144742e866d3@linux.ibm.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Mon, 28 Sep 2026 14:16:18 +0800
X-Gm-Features: AclHuK96mTZ2XsqOn0lcw6M7Xfg64Z655RWGZWQn7KbinRvEPkfuuOyZHISF2wk
Message-ID: <CAAo+4rU=hCYRfhQLf4DS-_5xsYqfVfQ0YYEgBj1OLdbbMPccrA@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: serialize sndbuf descriptor release with
 diagnostic dumps
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, 
	Wen Gu <guwen@linux.alibaba.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, linux-rdma@vger.kernel.org, 
	linux-s390@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 1:57=E2=80=AFPM Mahanta Jambigi <mjambigi@linux.ibm=
.com> wrote:
>
> Agreed. This is addressed in v6[1] by unhashing the socket at the top of
> smc_conn_kill(), before smcd_buf_detach() runs, so no hashed socket can
> have its sndbuf_desc freed under a concurrent diag reader.
>
> [1]
> https://lore.kernel.org/netdev/20260926065023.1629497-1-mjambigi@linux.ib=
m.com/
>

Hi Mahanta,

Thanks for pointing this out, I didn't notice there was a patch
working on the same problem. Please drop my patch in favour of yours.

Best Regards,
Chengfeng
