Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A3361DB4;
	Wed, 11 Mar 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773248589; cv=none; b=Mxg2gw1vInKwoIsQCuZPPpMTxQVGCts43hvKtjUZc4hsQeebxb4hzbxTB2oUHZkDa9qlYU6dVhmjz7FNFK2DDLVNJphvASLSHs2CPT/tTvy0CH6yjr16ZDG2wCmlbtJqnGB/OahTba0+DDe84Zgku8wr5WhV5fFAsd33z0FE/BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773248589; c=relaxed/simple;
	bh=wepTkFTeuLMnNmzVcpdcunpdQXpgY/IEnb2YM6QGnjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FijG++bFokusvXlwdX8klS/00X4V/wzVSmK5ebFbpYZihHxz24ZXzntodem6F2wopyvyva7XuHjOOnm6VyUIHDZWRXThPzYs3zCR0nVK++p3qOCfZYSmkUlMx9mHCvAzOzOjVRKeT1wgZjnZb7Cu8bADHJeQ2X00oTAK7jkey9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ki9QU2ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ki9QU2ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288DCC2BC9E;
	Wed, 11 Mar 2026 17:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773248589;
	bh=wepTkFTeuLMnNmzVcpdcunpdQXpgY/IEnb2YM6QGnjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ki9QU2ea0tTUxPPvaI7maUimZ3jVr3c+NH545xtI21jvWZrI0LZnprcu/57nd9tBN
	 FKHak8lD/cNkWp+iHz6IQNIfIrcxh3VizaBV6oqP4wyLotHGA9g7cmezOPUm1sOk5L
	 ge6nZIK6gUbAX7vIB3bT0f0W+H4NA4WSEqzZK/SDkR5Zw7sFSTX3O7DonFPfHYIzdj
	 yG44zv25Q4KkP7TfOb4NZtQtqJV3WLBxjIidvQ2/Rx/NvAvWTMwHibPwav3BVMIGXN
	 ljdYTlOBNN09vfDU+M/3HPySWAtin+SLzyhrhm/bAZiV/BRbxxecPj01rkdTpCCCkc
	 j7FtF6i5PcCqA==
Date: Wed, 11 Mar 2026 17:03:03 +0000
From: Simon Horman <horms@kernel.org>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: shirazsaleem@microsoft.com, kotaranov@microsoft.com, pabeni@redhat.com,
	haiyangz@microsoft.com, kys@microsoft.com, edumazet@google.com,
	kuba@kernel.org, davem@davemloft.net, decui@microsoft.com,
	wei.liu@kernel.org, longli@microsoft.com, jgg@ziepe.ca,
	leon@kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/mana: Fix auxiliary device double-delete race
Message-ID: <20260311170303.GT461701@kernel.org>
References: <20260309172415.688342-1-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309172415.688342-1-kotaranov@linux.microsoft.com>

On Mon, Mar 09, 2026 at 10:24:15AM -0700, Konstantin Taranov wrote:
> From: Shiraz Saleem <shirazsaleem@microsoft.com>
> 
> Make remove_adev() safe to call concurrently from the service reset
> and PCI eject paths by using xchg() to atomically claim the adev
> pointer. This prevents double auxiliary_device_delete/uninit when
> hv_eject_device_work races with the service reset workqueue.
> 
> Fixes: 505cc26bcae0 ("net: mana: Add support for auxiliary device servicing events")
> Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Unfortunately the CI was not able to apply this net.

Please rebase and repost.

-- 
pw-bot: changes-requested
