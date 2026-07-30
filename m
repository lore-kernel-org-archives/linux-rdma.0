Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C90438757C;
	Thu, 30 Jul 2026 20:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442393; cv=none; b=SLpT0JtO5WKFWQzs4xk3CrcImByUxnF9Q3SF+j9z6gLoQlwPUADc6PTLvHMhGjAM8HrNQ2+WSc89snaJvwP5ofFgvTddJPUG2+r9RiEz8IhmNUA+9g/2KU1wLlEssgG3B5IxmIUvDUKtY4PJO1kHr69fWsXP9+WSEWF6BQu8i90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442393; c=relaxed/simple;
	bh=4JXKWABCRw8ktBnzJUvFz1gfjrwaVinTbE68vFeeI9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=soAL7/pDEmYXBDiRrG3N5T0OPpLgC5Hfa3Q+07kM5ARNhkJmztM7gFgECMCF9C3WvUr6XZI786CsbdBX4Na6pmNMISV2pGJrRwBHV8Zmjtvd5V7Pz074NToaKlZDlh0kYu+iNJ11FPorkmQv48Dj9Wfcil/2XJE8utI7f1G4BpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEZAPKQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEZAPKQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F1E1F000E9;
	Thu, 30 Jul 2026 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785442391;
	bh=4JXKWABCRw8ktBnzJUvFz1gfjrwaVinTbE68vFeeI9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WEZAPKQsFs0JcaAkzNyNiousiKXZcUitZqPGLCvV4JjU2EB3zhEYiPRXnY6O4ZyqT
	 fgp23ejOXwndloa42GegzDV6iuoJw1zShT18Yzyl2Z3BZ9gFS2pGJje0NspILa1mDC
	 4+ySAd1CFxLeLquNJymLpA8UgXHbo9QxHq1pyc/UB9G12lUh9U5RuHcuEYc30kavh4
	 3kXwiMOIccvlmAMMRPs4tucULC1+F8clFC1rKXMlrTbfBQQt7T5EgLsE5k4cIJn4RM
	 nicF48qX663n2LNrtVRWanQa2D68qQd6xlKDrHouaxo20U1bR4xuD/erfn6BdSvt8Y
	 oEp2U0FvCM9hw==
Date: Thu, 30 Jul 2026 13:13:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
 <sd@queasysnail.net>, Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin
 Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan
 Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
 <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
 <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
 <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul
 Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
Subject: Re: [PATCH net-next 12/12] net: psp: Add a self test for PSP with
 HW-GRO
Message-ID: <20260730131310.43308d17@kernel.org>
In-Reply-To: <d90068b2-8c88-4675-9e51-62f1ce72966f@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
	<20260730091756.2543777-13-tariqt@nvidia.com>
	<d90068b2-8c88-4675-9e51-62f1ce72966f@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jul 2026 12:58:07 +0300 Tariq Toukan wrote:
> Oh, please ignore this one. Sent by mistake.
> It's a leftover I had locally.

Ack, looks like patchwork did the right thing so all good
