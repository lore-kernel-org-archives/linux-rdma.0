Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE1E38E8D4;
	Mon,  8 Jun 2026 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780950632; cv=none; b=qAUf6ntDygVV1PP6aIYD8VEOqwm6jbq7dADTPIBuC+UStkjuxsdYvy1cK+0lwcEehjNaOYOQlt/PMOUagPmr9SZQXwVdgJFM3NCqPSCDkrSnCzFoj+Qu3MhdP/muPoCfEN4cP2WNzrfw400x1b3AkX4SEXT3H/5/2h54MXssOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780950632; c=relaxed/simple;
	bh=ro13X8bYyZN635AsD1TAc0Se21/nyspGsLYa8UAWjSw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3ER+b8z8I9camCrZ2uD6imXHw06An2RhxJV0O4Y6bmBQ0lxh600XEg3P2VtL8MOIXwedK+0VyhqDhnQvTYbfDLD2OOwk4bbpDUwpqDy+Yv4bL8pQDeFRovrYO3/e1i7ocDYhujEBcv8FUFEHIZEeM2hf+ls/KMCjlcqORiiq48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+RR+km9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+RR+km9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9B41F00893;
	Mon,  8 Jun 2026 20:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780950631;
	bh=BDDI0zZ85tZ3dra1dzCyCbAmBdm/ZjszTpTSBf91ICk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=H+RR+km9F27/4FtD/nDVbbsskwOtzC3R+aaRnoK93RfDjLtT0P1d0+Vvj/oIZ7Ytx
	 4Yq94jO7XGV2gcXKD4cl/8tcnEF6f6HuMrgHtevN41QbQ7T63wcm38+7Py0yNWpktj
	 pwX/PwCeEYUO0L7oUu97Yj73OKH7CpIbY7bd2bZrICfzfNrv4sy5GkCNiAZFhvpOZ9
	 Ntu5+0aRb6a5VoJeI0XntIfSNP4diIMlz8UD36rhBprJUcmtc+sRbx2QtCVVGBSqIF
	 fDE+FDl7eU3HTyBklFfw4cORoaHSVqt0QlCHpb8kMh6teJ8vIJUaUDGNgNtQYb2mvZ
	 eYFxS98Gok2BA==
Date: Mon, 8 Jun 2026 13:30:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Simon Horman <horms@kernel.org>, Donald Hunter
 <donald.hunter@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Saeed Mahameed
 <saeedm@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, Mark Bloch
 <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>, "Matthieu Baerts
 (NGI0)" <matttbe@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 Carolina Jubran <cjubran@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Daniel Zahka <daniel.zahka@gmail.com>, Shahar Shitrit
 <shshitrit@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Jacob Keller
 <jacob.e.keller@intel.com>, Parav Pandit <parav@nvidia.com>, Adithya
 Jayachandran <ajayachandra@nvidia.com>, "Shay Drori" <shayd@nvidia.com>,
 Kees Cook <kees@kernel.org>, Daniel Jurgens <danielj@nvidia.com>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net-next V5 00/12] devlink: add per-port resource
 support
Message-ID: <20260608133029.3e1ef109@kernel.org>
In-Reply-To: <20260407194107.148063-1-tariqt@nvidia.com>
References: <20260407194107.148063-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 Apr 2026 22:40:55 +0300 Tariq Toukan wrote:
> Userspace patches for iproute2:
> https://github.com/ohartoov/iproute2/tree/port_resources

Hi! As far as I can tell these iproute2 patches have not even been
posted? Please try to get them upstream ASAP, we have to manually 
carry them in the CI right now.
