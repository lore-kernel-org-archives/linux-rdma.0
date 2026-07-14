Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E371F43FD0E
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033920; cv=none; b=XYORRSpnqAnp95XQ2yf49QHIZv/mXXvuzX1p06sx9QYHDaej15fScHheeGT4ufANI5ri6ERO2N0myNwP/DKLOblnUhB7IO3renatMaKprNs7Yd6VmCGhFyx80bLLWlfG6sd14Iq5PULbKQY98/2JicMjwLeqcQBxzEoGRTK3TXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033920; c=relaxed/simple;
	bh=zodWS7rv1aDgcuPkzbqACdUmH3WWZLSmb9HJQdCdNTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XT6cqC7R0Hc6K9OrCiMcd8B1KsDLqsmyupr4Py9WOIT6wRQ/Ma1NRPGOa+XgoIe/QcH7y6Hh53I1RnOEV35MIzQK5xTR61TxkJZFsteYFD9mL2vnrdIsSuCgYfiEZr9f72QyYhsqe9UrE4FzCaK4cCsq2pX9U2VUnCUCkweyjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=sNKcInuH; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="sNKcInuH"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b021916bd3so3388497e87.3
        for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 05:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784033915; x=1784638715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LFB0TEAvMFCr6jHr2OUldXZ9xrpx3f7gJBKNTJaTmYM=;
        b=sNKcInuHSrzfnMZNWQ7jrzoaZYi7udGugtrUx7kAsLngaOINg4VMEz3QZm59ETPbkP
         G4jN3WG+zF2WKM1WJorX93KPeO5lt8meIqO4NNWYOo3lCdd3mHIjXdcKARocpNw9idmr
         gAp0RvZm51j+xsHH40AQFHPKKspveEPQc4sdZNZmpzJHS73PCY84qFWZ6h6xLa17Xhav
         CMFcDyJ77ivh4UFHEMsxejeF5eMN+pDSE6RLHFfWmhrZxc6d17bH+yOO4jJ97TSqPs0G
         9je/EXDV6Z7qcoAO+qHNXV8va1Quo2xfiv46DWiM14VrmC8bBH++KdyBALOPqRGh6lw0
         0KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033915; x=1784638715;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LFB0TEAvMFCr6jHr2OUldXZ9xrpx3f7gJBKNTJaTmYM=;
        b=TItc/Bd1sjlYMiWjZ/ZnDO7GxP/Iglvdvs1hD/WWt6troOWvPYtKz0BYsNVqX/qEAs
         ynqY8k0T+5moC/1cLjmiuIbE5BPXPySFBVkE/GS0Oz3EQSeZPxT+Lg1UFLNk/YhGxzEc
         i+ss0kHrmXg64xqefaPeyA4MbrxOfKPhZSLsEPY17B8rM1Wgi2LCgDSquhJrHQWxuAoY
         UkvFe/rI0+Qgfu5s1yBHFYfCGGwY+M99N0+N/nul5eV/zlBLW5dF7RrcrGaDOhxNLq9T
         T0ZGKGbRuOwqEEIF5A6yTYI6ZTBnHme39D6ErkzD0r28g/BEaL7+fsXYFQRboB6wYq7I
         j6SA==
X-Forwarded-Encrypted: i=1; AHgh+RpUJY6e6iMsqAcArAevZA7ZPSDUVcrhbzWbmpp5wHQm2EsBZzSvlkokWH4fr9iFcvvRxKoH/6sONwOD@vger.kernel.org
X-Gm-Message-State: AOJu0YwLJoY7FS4USrNbcaRGYQzk3iPJK5ZM2PsJQo+qDwpi9F64B3qy
	sfR9pho0JBnrdRai7iRWto+w7ySR1Ln0DUTcNWDS9KbWRrdTj1I0jIAU/8/CQl3UG6o=
X-Gm-Gg: AfdE7ckgtAvvnIlxcrLcAVHpWy2K7kXzL3tUJY1DrvUTHv5sa4+psOV5/lsnl8zp2Ru
	5QOohCbXx7yCTfEzW0QkSZNZ+P26YMhcZmAzqkYDsT58VMFjySV8fH8FefWgPW3NtcsQIJi+Q2p
	6XmKnxjj51QKKs6oYaCC7fDd9DYF0l2gRz+5SX/U45vF4Xr+5rlEOoTFjie4T8pXIK3VimF8ng2
	HwTpQfmWKrnPwPgaYlHiTfUMJ2nEXnB7Z0uTIumubs0K+1Z/W3b9/vO0FKVJR2/xpjhkUu1j+Y5
	D/qNU6YwvMsMezNGLyEUrUl2/nn9ujw7uUPmb0lxbSjDNggMsITxs86SoNR/Op4oPsL/v3DUx8a
	xTtXtJiRuLTSFW94exJpbS4lVqaGz4KayjAZX0uYUP7nRkElqitJ6So5Rl/XCx9sxfZrneFNvBm
	BsQ+fmcra5rbfU+wwiFZSm8xw=
X-Received: by 2002:a05:6512:8395:b0:5b0:1760:fabe with SMTP id 2adb3069b0e04-5b0236651e9mr1956976e87.15.1784033914770;
        Tue, 14 Jul 2026 05:58:34 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b01caa66cbsm3482896e87.61.2026.07.14.05.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:58:34 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:58:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Mark Bloch <mbloch@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next V6 3/4] devlink: Parse eswitch mode boot defaults
Message-ID: <alYycEavj752bHjD@FV6GYCPJ69>
References: <20260714061731.531849-1-mbloch@nvidia.com>
 <20260714061731.531849-4-mbloch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714061731.531849-4-mbloch@nvidia.com>

Tue, Jul 14, 2026 at 08:17:29AM +0200, mbloch@nvidia.com wrote:
>Add devlink_eswitch_mode= kernel command line parsing for a default
>eswitch mode.
>
>The supported syntax selects either all devlink handles or one explicit
>comma-separated handle list:
>
>  devlink_eswitch_mode=*=<mode>
>
>  devlink_eswitch_mode=<handle>[,<handle>...]=<mode>
>
>where <mode> is one of legacy, switchdev or switchdev_inactive. All
>selected handles receive the same mode. Assigning different modes to
>different handle lists in the same parameter value is not supported.
>
>Store the parsed selector and mode in devlink core so the default can be
>applied by a downstream patch.
>
>Document the devlink_eswitch_mode= syntax and duplicate handle handling.
>
>Signed-off-by: Mark Bloch <mbloch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
