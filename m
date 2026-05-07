Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56024728F;
	Thu,  7 May 2026 01:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778117625; cv=none; b=Kb9prStcAcFWSkdrqSqaPfgeh/uIpw2HfngYzRA4u+6y6wmBFMv8co3Y0xVMOwjBmI1m+KCIgpHhtDt8fRnTOirrLDd7SS11OhR51pPYxAn6bvzjHV/EeB4zKduoAqDrDTtxNMEaeWqiQn99mOWCP0GTfTrgstnyPn7lBthcwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778117625; c=relaxed/simple;
	bh=XLKH7WaHBP0XLooJ86aMJ4Ej/10y46n1cv9vNbKP/cY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nbfn4ibsVfNxISwKKBht6KvtzKf/YLotSFsIik6h+seOz1+WErK+CO1MNOHGuNS2F5Ng+MLZrNzeG+SCCL/ZCJVJhV8JO9hdThLq4iIRd1Kj/vTEyqRYiYZYUnWOS8gGrtIvn340KqugZhRu49WR6dLZG6eaP0Clze+DA3I3CiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N63ywpGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N63ywpGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10A2C2BCB0;
	Thu,  7 May 2026 01:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778117624;
	bh=XLKH7WaHBP0XLooJ86aMJ4Ej/10y46n1cv9vNbKP/cY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N63ywpGgAXjpiFVbJE1f6b1mUc5fj3avyPenVVPfVPA5cwrirFZjuj5NsSwNELENE
	 FDCepGOFFfZwVw4xmyoP6sfBqPASY63mKT8pD3M27xiUJTaahbEl7+ThBnutviWmIX
	 4kOEZ6evLwspTqmw/A9DAm2nanZfzhUcX8NpKf9O9NReQsD+MdJUlBRdd/zqfjrvBF
	 QLXgslxz+VZ9M71KjIfX8nXHV4DHP8Ozpwn0I+3XbHTjlbJHx5V3a29HSelY7wppJm
	 +gxWhzu2J8kxRBnwGn49ZkPpNPPPqMGLL/cgVNj/2oHaCPiOLdtRoWkUcbmUkFTO68
	 UxzZc94gHI7QQ==
Date: Wed, 6 May 2026 18:33:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ivan Vecera <ivecera@redhat.com>
Cc: netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, "David S. Miller" <davem@davemloft.net>,
 Donald Hunter <donald.hunter@gmail.com>, Eric Dumazet
 <edumazet@google.com>, Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky
 <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Michal Schmidt
 <mschmidt@redhat.com>, Paolo Abeni <pabeni@redhat.com>, Pasi Vaananen
 <pvaanane@redhat.com>, Petr Oros <poros@redhat.com>, Prathosh Satish
 <Prathosh.Satish@microchip.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq
 Toukan <tariqt@nvidia.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] dpll: add fractional frequency offset
 to pin-parent-device
Message-ID: <20260506183342.767b5fbc@kernel.org>
In-Reply-To: <20260504155340.411063-2-ivecera@redhat.com>
References: <20260504155340.411063-1-ivecera@redhat.com>
	<20260504155340.411063-2-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 May 2026 17:53:39 +0200 Ivan Vecera wrote:
> +          At top level this represents the RX vs TX symbol rate
> +          offset on the media associated with the pin.

Isn't this a hacky hack? I'd think that pin is in or out.
Having a freq offset between two pins or pin and parent's
ref lock makes sense. This new interpretation sounds like
we are trying to shove a difference between two pins into one?

> @@ -299,6 +299,10 @@ zl3073x_dpll_input_pin_ffo_get(const struct dpll_pin *dpll_pin, void *pin_priv,
>  {
>  	struct zl3073x_dpll_pin *pin = pin_priv;
>  
> +	/* Only rx vs tx symbol rate FFO is supported */
> +	if (dpll)
> +		return -ENODATA;
> +
>  	*ffo = pin->freq_offset;

It's easy for driver authors to forget this sort of validation.
We should fail close, so it's better to have some "capability"
bits or something for the driver to opt into getting given format 
of the call.
