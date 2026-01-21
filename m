Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD55E20DE3;
	Wed, 21 Jan 2026 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768954735; cv=none; b=LDuuddYKHm4r+PgORBOI0bg9BujX9eHNcNfcXLxY/I1TtAej0JHwcW91ubgdw5ksdKSc7Zo0rkq4K0XzNiuueZfE+tRauKjakeQY7Zv2whlaedbb65vEmxyNmGsO+439wNFnNVkjODNMHE1RzMgjV0I2AiXvpIJkbBpmfBmNBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768954735; c=relaxed/simple;
	bh=nIteDBTn2kAmgBvtRuDy38cJr4xlonSC8wjke3vr638=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhV/ijtdh3DcFDeP5PX/XsbIasyyxJegR4Lrzgeol3ZlvjFxyEz5x70igI5oVycPx64Qap8JJKabOOxFjW4I0PRx+n404nxyovnC60VCYG+nvzgjDTswHKANiRYa0yqC5cjeylnja3KpJUk8UVu2oHvb2b8/OQmeVv7b3jE+jLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvXaxdYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvXaxdYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ABAC16AAE;
	Wed, 21 Jan 2026 00:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768954734;
	bh=nIteDBTn2kAmgBvtRuDy38cJr4xlonSC8wjke3vr638=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvXaxdYGqxzhDl4dlVgxDbHwn2ArnJYr1SHXf4bO+g9xDUPPXzUwTzGch79P8hiAm
	 vJRWW0Q27ZnkuqCa8D0+e4oC6WIvAlaGbHoWoqeY6ecYlNW+bT3LYKjcxlH9EgbNo7
	 MKA/0HmG2iU3dVeBqcbYUlqHCvlVue37XUicvgeU5587Q9sFqomwXcYPx1hthyeqOd
	 kfMfFTl/8qonrKdrVPRydWSMVMJrcnyypokRo0BHIKoUjnHMxK7xtLkGtKrU6GdU1i
	 ttYt2SvGkYb6SjMlZZb78IfxzoHK1QNbGO61ACekjv0iTQNgHhN+EifBPEuvYD+Y5I
	 PnvLP5a3+70Ew==
From: Jakub Kicinski <kuba@kernel.org>
To: ivecera@redhat.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	conor+dt@kernel.org,
	poros@redhat.com,
	anthony.l.nguyen@intel.com,
	linux-rdma@vger.kernel.org,
	tariqt@nvidia.com,
	robh@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	aleksander.lobakin@intel.com,
	mbloch@nvidia.com,
	jiri@resnulli.us,
	Prathosh.Satish@microchip.com,
	krzk+dt@kernel.org,
	saeedm@nvidia.com,
	devicetree@vger.kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	przemyslaw.kitszel@intel.com,
	arkadiusz.kubalewski@intel.com,
	jonathan.lemon@gmail.com,
	saravanak@kernel.org,
	aleksandr.loktionov@intel.com,
	mschmidt@redhat.com,
	edumazet@google.com,
	leon@kernel.org,
	vadim.fedorenko@linux.dev,
	grzegorz.nitka@intel.com,
	intel-wired-lan@lists.osuosl.org,
	richardcochran@gmail.com,
	andrew+netdev@lunn.ch
Subject: Re: [net-next,v2,08/12] dpll: Enhance and consolidate reference counting logic
Date: Tue, 20 Jan 2026 16:16:51 -0800
Message-ID: <20260121001650.1904392-2-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116184610.147591-9-ivecera@redhat.com>
References: <20260116184610.147591-9-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch.

Dunno if there's a reason for having this fixed by a later patch,
if not let's fix. I'm sending the review mostly because of the
comments on patch 12.

For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
---
dpll: Enhance and consolidate reference counting logic

This commit refactors DPLL reference counting by introducing centralized
__dpll_{device,pin}_{hold,put}() helpers and updating dpll_xa_ref_*
functions to automatically manage references when adding/removing entries.

> diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
> index 156f95de8e8e..f2a77eb1b991 100644

[ ... ]

> @@ -155,6 +194,7 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
>  	reg->ops = ops;
>  	reg->priv = priv;
>  	reg->cookie = cookie;
> +	__dpll_pin_hold(pin);
>  	if (ref_exists)
>  		refcount_inc(&ref->refcount);
>  	list_add_tail(&reg->list, &ref->registration_list);

The new __dpll_pin_hold(pin) call is added here for the success path, but
looking at the context above this hunk, there is an early return path when
a duplicate registration is found:

    reg = dpll_pin_registration_find(ref, ops, priv, cookie);
    if (reg) {
        refcount_inc(&ref->refcount);
        return 0;
    }

This early return path increments ref->refcount and returns success, but
does not call __dpll_pin_hold(pin). Meanwhile, dpll_xa_ref_pin_del() always
calls __dpll_pin_put(pin). Could this cause a refcount underflow if a caller
attempts duplicate registration and then later unregistration is attempted?

Note: This appears to be addressed by 934c22045c2a ("dpll: Prevent duplicate
registrations") later in the series, which changes this early return to
return -EEXIST instead of success.

[ ... ]

> @@ -236,6 +277,7 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
>  	reg->ops = ops;
>  	reg->priv = priv;
>  	reg->cookie = cookie;
> +	__dpll_device_hold(dpll);
>  	if (ref_exists)
>  		refcount_inc(&ref->refcount);
>  	list_add_tail(&reg->list, &ref->registration_list);

The same pattern exists in dpll_xa_ref_dpll_add(): the early return path for
duplicate registrations increments ref->refcount without calling
__dpll_device_hold(dpll), while dpll_xa_ref_dpll_del() always calls
__dpll_device_put(dpll). The same fix in 934c22045c2a addresses this.
-- 
pw-bot: cr
