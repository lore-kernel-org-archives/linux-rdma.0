Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793286694;
	b=DS7tPWskLeFBmB/wkJ50s4ozu/C7H2lKlECEBIUOBT0m4DYpzGhxSCAqF0C0Prhkziuh
	 DlQ/c5KvknZsSXcY9JIcKhhpHVBLijgo7QFdnjbgBMq16X3VLYk9EYsV2pJwivQERJDX+
	 caMDQuOdV/o1w0i/AMaiRTYIzIv41/GFo/YfvI1P5nTJOfBFISKShvx5JKhupJE6FmxA8
	 uWZCy1yOBRs7LmM2n3ell1kZzelyZdTMtIMN7aS4NUa3qTwpa8JB1vPgzPWeCRGstUNhJ
	 WoSy5MXG0qAOPDoYMvS3nSB3nmY0o2j7s8ZQb3YH/Ja+HDg7gDXenRqz6CVzb+J4v/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793286694;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=yYGp7worVnCPGHf5o+Qio/3sLzdmXlqWp7TBfw5BhDM=;
	b=YsbUItNyLfm8vxLh31C/mfFUbyG7QUWD3ZeOv9ITdq9/HAgF5xCy8FOMT7pPZlrhZpnO
	 gseaye7rajnGwB611LjLUlriQ6UPcEEoXcWivrhd+UQtlQPF8P8Ylv72GDwM3k6WX+rho
	 kNh928xRYJz7fOd9jqm6hF8ArApvk5aqLklbkF+f7E8FFtzr0Ea+jDNBgG7OUv27BTBMu
	 +npWQfMv/SgR89+gZaARLueZhERoPtmUDjl77ExqE+MUaq/vy4b2VuvyBv7OnF4ciukXq
	 ALOR9jqjz1sgYjhwlodgl3f67pj9+ZCbQcvqg+aanCYYSAkClkSUa20ZLGoSW0Eav6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=DUZRJ0qS;
	arc=none smtp.remote-ip=209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5B6606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 15:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C5B6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=DUZRJ0qS
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-990835cec4bso1367063241.1
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 08:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793286693; x=1793891493; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yYGp7worVnCPGHf5o+Qio/3sLzdmXlqWp7TBfw5BhDM=;
        b=DUZRJ0qSvCyOP/xODEp5vWmKnQn5e8gBR/46YShx6NhGxSOAC30g4PFOllDVz9oYGO
         Elrxt7oeWSiEPNR9OLdmKFP/4BR27zIGiVw58glwxoNGUfS8O761Z7BBanpriTfVu+7u
         o248J9bOQ376eOKsJCw34zl+CkNCTViBs8l8lcF1IVJ18z9WFNRrAEz+cZiavEsn0gFF
         pPKO58WUDoim9a8d5pdTSmQZby2sd1WDJHKrB3aXX7O4L59vrGxBLYYNAAWECb4vG70C
         B1mD9OOKH97TRUPoCigaIhp+CHWlsXOeetUmSGW4dL16IvIAT7Yq/QU6dQMdmZc00x8f
         Seaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793286693; x=1793891493;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yYGp7worVnCPGHf5o+Qio/3sLzdmXlqWp7TBfw5BhDM=;
        b=iQK2zA9Zz55RmrOJzhgEypVHo3rbZDG6+4ndSl8qVMCtPlvxA244eC5IEUAOmvehbH
         ZaGflpgvbE8aTuVXQmhD99rn+ffQeCkautJ9FqnDmg+JsGG9Lify+bVuMsy/mwO803zw
         5JtKqVrehfcSBc/A8t6i5fChLod8DN8RnAh85kCm7xeogo3CzknM7WCM/BQkH6SB+FOa
         4MUj62oSL1QwyYiVvhk343orVu2Ex+tcyH4hn9Ee0+UuFgnmJcK4PVYv0VRaDZYsNtBy
         dSjuVgJkGaycBCVNe0O684CavtT8Bej/s4Aw3DtY9Qx51BidY21yjHcK0a5uSOE8bBqI
         i6sQ==
X-Forwarded-Encrypted: i=1; AKwUvBx91zLchUt69G7qIITwdaHWP74zP30b0i3GWOoChmQ5faDP0AXK23LR7Ew/zyszPCcBcCzSPVjgVgpP@vger.kernel.org
X-Gm-Message-State: AFq9FYJsLOK66EklxJyrNVlELbnEyKxL2+ZQcvvvZKzvz7Vg6YSZMSbY
	/4RVQ5zN0UDDsq7WHGL2LXoIAqMoNoSGNDjGDlv2eFVnTcw6D1IqJFX2+ajyZAJvKs8=
X-Gm-Gg: AYBFou3ko40s8a6dxBkyKkHY85Tl+s9RwAUbVK99vP5f8Maz4BO2XIiOPUp1Bn3Z1Ii
	KgAog45SX3xc8/kp1lgpaXGUA5ffQGq9Fxs8EGyPye4cIye65sYqnubmYfodzVhaBPihJxr8U0S
	gIjkZzJESiorFA7PZ7otOduCYgEsn2BpgVikuBm5+MyEiJ0HKjZAeZqM1LW8Wf4kRYOOfYHzd3t
	Z12n52nAH/QK2bCnMge8W5BcDpW8iorUbcVY20c7NQZEgj/9ENG1ptxYrwvenShbkseubEK8/al
	RoGnE/tUxPSKCNk7dBkuT8EhZzgc/UkpoaH5cWM1ez5CnKFDluM9DX9zsPgNrNLPD20Z+wcsGkw
	Dv4UbeY9iURtL9L8x8CSv23/UMcvNzb3zjHooawzgvyTckwjhvBfMfmBh37ycWA+n67U7lkVkDp
	MwapMMbpCSkCH/BoBGlNjaaa4NMYNGDQuN8z5NqML/JcRGseKHdJAT/Ni3/qriKVYZelZXujL3z
	cgJpKsfoJs9CwQAzOVuwscN+bCSsiVYWEnY5hDYPpP6zvw80KXzHK8NlNXlXvzCzmksmVJfAU+y
	dlXbRgmtpO/DRW9E0j5oWpgsmfl9ULcVZYyJecdqwC94/w==
X-Received: by 2002:a05:6102:50a3:b0:7c3:2b19:6267 with SMTP id ada2fe7eead31-7d03a541d57mr2928287137.32.1793286693044;
        Thu, 29 Oct 2026 08:11:33 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca2904af7sm165316d6.14.2026.10.29.08.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 08:11:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jakub Kicinski <kuba@kernel.org>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
Date: Thu, 29 Oct 2026 15:15:00 +0000
Message-ID: <17932869000000.4.mlx5e-threaded-napi-stall@toxicpanda.com>
In-Reply-To: <1a26c186-bba5-40f9-8cd9-3967b2b268bf@nvidia.com>
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
 <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
 <17926738093796.1.mlx5e-threaded-napi-stall@toxicpanda.com>
 <bf7ecec5-8bf4-47b0-bbf5-6dc8fa4e64d4@nvidia.com>
 <1a26c186-bba5-40f9-8cd9-3967b2b268bf@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, Oct 29, 2026 at 02:52:06PM +0200, Tariq Toukan wrote:
> We confirmed it on the device, on ConnectX-6 Dx (the generation in your
> report) and on ConnectX-7: an arm raises an immediate event only when
> the CQ holds a CQE newer than the last reported event. A backlog the
> last event already reported raises nothing.

Thanks for checking that.

> Please hold your v2 until these are out, and rebase on top: your patch
> then stands as what it is, saving a complete-and-rearm cycle per budget
> with threaded NAPI.

Will do.  Please Cc me on them.  On top of your fix it is no longer a
fix, so v2 will drop the Fixes tag and go to net-next.

What changes in v2 besides that: the test moves into
mlx5e_channel_no_affinity_change(), as Jakub and Bjorn asked, and it
tests NAPI_STATE_SCHED_THREADED instead of NAPI_STATE_THREADED, so that
it follows who is polling and not the mode that was asked for.

> One request for the code comment when you reword it: today it reads as
> if arming never raises an event for pending CQEs, "only for a new
> completion".

The comment in v2 only says why the CPU of the NAPI thread tells
nothing about the interrupt's affinity, it no longer says anything
about arming.  The changelog will use your wording.

pw-bot: cr

Thanks,
Josef
