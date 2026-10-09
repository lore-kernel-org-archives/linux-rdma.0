Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80553E5A32
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590191; cv=none; b=gxntqR8ElJ7UFznZ/HIB2hBkIS7vgQzWidA6u6koEzbmh4E76nE8kk4MM12EECVJ+9IkWJ8rUeM0cna074wpzC/BRQVuuauw2xfR2X34XBR6uDji9EwGBw1b2DnDG6c2cqbQGbBC84/rjk5aJ+CcnjLUD+T78nbeiZItB8PfoWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590191; c=relaxed/simple;
	bh=c2p/8s/u1+M4DT4S4RPozf9b1gNSNBk+bGyW0+gQ3Rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LxfRKaSzJXkpcpP9kNA3/VX/T/udAcdn2nVD51fxZOtMhsteMr7ZbWB8gBVXRHUysMZ5BJU7tA8Pmr7plJMBl7A8ei7+iu6HXsVX2PbqzQDVRD+VpPTU50l5sZ9nxyjD5U8V0s8IFvsc476R4jdIRJcEFlYj2UXgJ1L0WORKlvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txZgsE8r; arc=none smtp.client-ip=74.125.82.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txZgsE8r"
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-313d1015161so697548eec.1
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 16:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791590190; x=1792194990; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJTxzhnYs9hhRpF1VB7va1Wtd9L8csRH9tcezUL8KaI=;
        b=txZgsE8rF6lBUsJm+MtwyrwqvLN4vJGr8PvjdzagwSGPpt+MKy5drOxOm9WFq410RY
         lW3yDhL0XczD0V/TbD2IZEoNYOM16bjTSh2+gCXLnYdwT0EPubFWEoXOBBds8jhmBffF
         jz8AQA4NRgrSPHe9cvNS2xtv5WEoyk8ghhT5YJD9fW9A+bedBBru9d0s6I+cBI/F4EW2
         tdQLkEbdCywOgWiCJInL6VHOFxa+xoAI/J/vs1QFI0yphsG1gkRQ8qLA/NfvNiqXiOLs
         4ydnLQOtEM5rnTUBZ+R+FvgCDjNH+Wszn3UoZS3JSQytX/7Kemcx6MegkYXIkAhNh8xy
         MeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791590190; x=1792194990;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PJTxzhnYs9hhRpF1VB7va1Wtd9L8csRH9tcezUL8KaI=;
        b=ai/zIe+lH27uewyK8x7pB9bZfvCxm/uUsCm8WdRfrSZnwxfX8DWbRFc9qzzGKaWnkK
         6Y3Zk6tdHNcYpbCRcMzhpkMrgsayTbsclrVb4mZ3M3raeX7B3wAc0yPFgB7FS9EZctih
         filx2Mxc0koU+5b2o9TKR5c/TGhVVEZvQVTvc4cB51i7GKtrQi60o+cnIRALwoH8aSEG
         676X0YAiEqLIpukPK5Hjwf/RuIXh8VyQkygbSPrMw8Jd2D3lMyZzRe+oYsWiQ6nY5ZP3
         udRGemrUp1MEsQxlNLcS9j1WbWM6ftmhM/RRRXq7CbAU5VxwatSM291L51vN4hGMeyWZ
         T32Q==
X-Forwarded-Encrypted: i=1; AKwUvBxzLAD8y937Z/DrZ1Ti724Ua+FdUdg9zopAss1XDCAsK1pUW7yhTEeMI7n7M1OXAvWrx4QMX37FHyiB@vger.kernel.org
X-Gm-Message-State: AFq9FYKds9Mtb73NZLEPiQbBUN2Zo1db4Wcxdk+uucsLtJJr6/x/O0Sl
	OIOYveUeyVL4ly7z8HTAAyUfxFuNs6uvQ6M89Pg6RVlEZF31jq0+24fO+RpxuxOdOGF2EQcfCKD
	Qxikw8NP1+s0a/Em3jHqWsfOCTg==
X-Received: from dyclv4-n2.prod.google.com ([2002:a05:7301:6184:20b0:339:7118:d1b6])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:26c3:b0:34a:cb0e:f4e5 with SMTP id 5a478bee46e88-3537e24a01cmr4661674eec.40.1791590189372;
 Fri, 09 Oct 2026 16:56:29 -0700 (PDT)
Date: Fri,  9 Oct 2026 23:56:28 +0000
In-Reply-To: <20261008132815.654147-11-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261008132815.654147-1-tariqt@nvidia.com> <20261008132815.654147-11-tariqt@nvidia.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009235628.3827386-1-almasrymina@google.com>
Subject: Re: [PATCH net-next 10/10] net/mlx5e: Enable the data direct netdev feature
From: Mina Almasry <almasrymina@google.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Mina Almasry <almasrymina@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park <byungchul@sk.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, 
	Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>, 
	Yue Haibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
>
> +	/* Changing the flag reopens the channels with a different DMA device,
> +	 * which would break any dmabuf currently bound to this netdev.
> +	 */
> +	if (netdev_has_dmabuf_binding(netdev, NULL)) {
> +		netdev_err(netdev, "Can't change data_direct while dmabufs are bound\n");
> +		return -EBUSY;
> +	}
> +
> +	new_params = priv->channels.params;
> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, enable);
> +
> +	return mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, true);

(Note: LLM-assisted review comment below.)

set_pflag_data_direct() is called under rtnl_lock() only, whereas
netdev_nl_bind_rx_doit() and netdev_nl_bind_tx_doit() serialize bindings under
netdev_lock(netdev) without holding rtnl_lock().

Should set_pflag_data_direct() hold netdev_lock(netdev) across both
netdev_has_dmabuf_binding() and mlx5e_safe_switch_params() (just as
mlx5e_data_direct_event() does in patch 08/10) so a concurrent bind-rx/bind-tx
cannot race past the -EBUSY check while channels are switching DMA devices?

-- 
Thanks,
Mina
