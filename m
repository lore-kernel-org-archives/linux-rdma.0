Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F883DA7ED
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387927; cv=none; b=eXFu3XgMpbktp/33sLAnKxWNYNLsW5KRxxSienjOwfPnU412ewuDrPx4oLAp5lyO411qvquaq1cRPu2j4GNoaPe8KBHxD6N1poc10cVka4aOyOvxd9oxtHG6JHBBXU0+e57Zx9XKkqu2aEnDz0dGSazm9STeX9v0Tf6yHB8p6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387927; c=relaxed/simple;
	bh=dMiO4dOD/vIiMeabHVo0bAzr5ifDt0MEbglqo/V5daQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4GVXQ6HMbOavUbgnfMrneoJCixloy0QiFtG7mbB+uZExWNcrsOs0hWo7cifbZjX204byw2zY+WUCavyKgYxJiUD3oI6ggmbORTomqoZKoQ3PdU3AspQwoODeDYiFpfOC7Qo6Z1avE5giKW+01KLglvPviy8qJXS9tUoplg5OXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqgSrocS; arc=none smtp.client-ip=74.125.228.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqgSrocS"
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-cbb818e57c9so1313272a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 11:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786387926; x=1786992726; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l3aQ3yKkswTs7S/iYzRYJHZ1Z5dQCtJeegu/4/CsFd8=;
        b=MqgSrocSaUowH2gjxBr3netAVwSMrI7Y5fWNlfPyDbKyU3Zt3TUFLgNEGm9fBchld+
         yEDMnSn6dXAZRToOExw98d25lzrKILAH9CYR+pGW/lfkXBAqv0EzxYu3xKrNhkU8FEiU
         k3Muzt2Gx8XiQfyW2sbJyMtmrAAAqm0m6ek+Gk3No4ueOQwD+eLpo+bD2Zl5JiDa79NZ
         KAiz5dvwC0w9pMUVR45fMf4AFxWfF/iE1inp47Q6B8jFp+/82N93D510xX7+B9NsmHmr
         06OscIhFWILFBmWuQG5DuNlM7cO62XjT/0Hfh40GWt2SQWGs2Y/p4/df/xEj+n40bSTn
         1FfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786387926; x=1786992726;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l3aQ3yKkswTs7S/iYzRYJHZ1Z5dQCtJeegu/4/CsFd8=;
        b=ceshWwzcxRgU8MSIWXWRf1xQYjrwmkQ6MGPJct4gX6xlRdfp6dx5FJL/OS+HhGE5kZ
         T9W5S/RnAoMh8hMsN7fHh2q/Ncti/t4bnenVcr9oORMaZEFhP7ALct7O8vUeE0WE7r3p
         xmZ2zU49uZsFfL2N2aQf5oXL31Ydugeu5gmVmi/0X+9Yr3HZNwi2HrxjOG+XKlxAB5jV
         b6m6I++Gt5KSUbkfns7IZEpqbEM4PKnDUUycoe7zatFIMDiIvT52Pqg49Gcww3tDo2dS
         K/6JuDZjvKaRyzZDxtxeu1dAYQ9a4mypWZo6edoET3xhD4iBb6fEwxVqaHE2BYV8vGT6
         a6kQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8aqPK+Vd9+I/HVEOosUN+grDBV0tg3OruS7+PnBn9a3c4C9TTjofUpGFiqe3/daUZXugz9T4DE5sG@vger.kernel.org
X-Gm-Message-State: AOJu0YzcCB0Dten0FPsM7Q1HYRSFFWixfEQ61/pKn28nxYZo27RXzIFJ
	f9cZdQDn73kYaiU/wWWLe6Zt1dJWTTzBVR1qJG6uctBOV9Ezm7zD8QCp
X-Gm-Gg: AR+sD13IYV2wpUxOkJWYgVIFeotMZtkqxkoPC9O394q3wR9fvLZjD40dn4QCXi2kGHK
	aQRIi+h6XJ2g7xBvM8qgSW7txdg/7ThFa7z36kY9XEru0axw2D8w0vAXEgE3SYFO5muiVu18XYt
	VNLJ5jzkb6Bwac1nhDAut5nEzXQcS7sWeNp9sV+i2bP2mgXO3Am9Sp9zGsyBC6njAi12CyHsny6
	9occldmjauKshke/1zXz4XHtpa+Uaw1rHrsy1Iom8c4Rd7alFfF6/ohGI4/tDYOHjEWeJwe84tD
	Euzq27MJeW8VkqyO4QAzII8955N/u1TRnOK8/yj6tR0/NXD2QCxSuFYeMDaau7gkH09iV/Gazwo
	B87Yf5DQd9TSiupgJvrTmuc83jatr8c/Gn8xcE6kNPpcdmBLH+BjOMFR/VDNK04FLu91Y/ue7/E
	od8TiokCMSwIZom+PIR9srFI+L1Rq84Yp7n6bEBLrRYlTXafKMrMluRw==
X-Received: by 2002:a05:6a00:12ca:b0:84e:2722:5d9e with SMTP id d2e1a72fcca58-84f9c8da5a1mr3553132b3a.1.1786387925682;
        Mon, 10 Aug 2026 11:52:05 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:52::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a58e6c4sm4386298b3a.59.2026.08.10.11.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:52:05 -0700 (PDT)
Date: Mon, 10 Aug 2026 11:52:01 -0700
From: Stanislav Fomichev <sdf.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com, 
	andrew+netdev@lunn.ch, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, 
	maxime.chevallier@bootlin.com, mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com, 
	aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com, 
	maciej.fijalkowski@intel.com, sdf@fomichev.me, ast@kernel.org, daniel@iogearbox.net, 
	hawk@kernel.org, john.fastabend@gmail.com, alice.kernel@fastmail.im, 
	dtatulea@nvidia.com, witu@nvidia.com, martin.lau@kernel.org, 
	yoong.siang.song@intel.com, rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
	leon@kernel.org
Subject: Re: [PATCH net-next 0/3] xsk: pre-existing AF_XDP TX metadata fixes
 from Sashiko
Message-ID: <anodof8GsDZHZb-S@devvm7509.cco0.facebook.com>
References: <20260810184753.135756-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260810184753.135756-1-sdf@fomichev.me>

On 08/10, Stanislav Fomichev wrote:
> A few fixes to address pre-existing issues from Sashiko review.
> 
> Stanislav Fomichev (3):
>   xsk: align TX metadata layout across ABIs
>   xsk: honor XDP_TX_METADATA in zero-copy path
>   net: stmmac: skip queueMaxSDU check for AF_XDP

Ooops, this should've been targeted to net tree. Will resend in a few
days in case there is any review feedback.

---
pw-bot: cr
