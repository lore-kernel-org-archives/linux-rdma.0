Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BB017993;
	Fri, 31 Jul 2026 01:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462821; cv=none; b=VkzF0/DB7GQRmjtZZpnpZZD9+I3rXGjGF00aY875Ied0+iWU+F0N/apH/atWAXDtFqO/QzE9XVLFDdFQEOAyUqGdmm08Exf/T1VIVkG56zzBbcclyy2W1Quv3uigAo2KGy4EtFKLU5czQ/GVPdfKAt0t5sWbdBJESYsf45h8t34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462821; c=relaxed/simple;
	bh=/O65CoT57pZJ4Zv6tAvOv6de7Gl1f9gXWHx4htlueTM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBn/H6ZjSJdtcOzZ9JAVnVubvM+7doq0HHKDrBbDFehi3cOWBYc1CgbqQ+xfVMFiy9Y8j6pmwU0xmkl3Rq0UjfEBUNZ6Q1mDFrXWnCIjU4lHUOg+XhMayJOLzkyLta3MfzH0qO2pT1ytcB3zMZWNIiToBLPtv5vKvJVTVPY3P+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQmLpLvw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQmLpLvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8EE1F000E9;
	Fri, 31 Jul 2026 01:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785462820;
	bh=6vjT5I0bYUPwxcLFsF8AqtUKmoBhHnlB9r4xBOGm2l4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UQmLpLvw0lJatkk6wMRdjccxrq9gKa09G7oWlMIKBy28u9tqGWrFrV6s59Do4mKhs
	 b3YzjM/dbDMleGk/6+GSWhgz/uh86fazdHu8eV7bXYhtCFLo+a+VGMtFfHNAgywEWw
	 ipZQkLlAE3KC19VGdbGMfvisoO4EJA6GVFOUTHELyNBO9dcmT8BLF4x4u52h4pkfEn
	 NszZMtrzF65m1OkNfXcPS2j5oa386JRU5mzzCJeOHJyIM0BBvFF8+cjQ6WRVEmQ9hy
	 fnLOBq6cUZ7t1238arctBssDcMPyji4TvsSem8DHAxweG8ivO3T/j5Y3+193ac+ONk
	 ftpz/FT6cm/KQ==
Date: Thu, 30 Jul 2026 18:53:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan
 Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
 <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
 <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Subject: Re: [PATCH net-next 13/13] selftests: drv-net: psp: Add a test for
 PSP with HW-GRO
Message-ID: <20260730185338.22ba94ef@kernel.org>
In-Reply-To: <20260730091756.2543777-15-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
	<20260730091756.2543777-15-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jul 2026 12:17:56 +0300 Tariq Toukan wrote:
> +    if gro["fixed"] and not gro["active"]:
> +        raise KsftSkipEx("HW GRO not supported by device")

XFail, this runs over netdevsim, SW tests must not skip.
