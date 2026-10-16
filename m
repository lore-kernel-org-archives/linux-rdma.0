Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99D148DB39;
	Fri, 16 Oct 2026 18:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792175777; cv=none; b=FeuIp8TN+FmUQM5eJdRS3Stu9omoKVM32T/TSfx3wKXNDdiCZejG4OSDBxXK6QC1FBTJaJyomVHIzuX1TJBn4Mg9M9sCdlEZ1jStpRxiviqYLMKhVxIQb7nFKjAO/CqX0NGxYYciW11/xaAgUHJera/RJzdT2zkza+SEpL7goW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792175777; c=relaxed/simple;
	bh=HTzZI6mAMlXzEP7meSO/k2+Na8M5iOG5404X8vxnt0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpYBbz+w2rmoC8H072si6Pxz9B5U1qdw1qB5CM8/VQ4Kaf73Y0Y4j7EGMw0POd13VoSlIMI1L6ikF/HAPzn1e7MD0znlK5m2UxJiVOZ+JqrAYpHdzs4XX5BziThBB+rk3XGxJ6fGEeEJXxYuzn+Z8voemt2Etktx5K0qQ8QTo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D23yUEoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D23yUEoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC1B1F000C4;
	Fri, 16 Oct 2026 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792175776;
	bh=cm8mnV94gF2ml40bQYfePT+4ayAcDw6RHhOxfuMz/kA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D23yUEoE+p5nN9LU7GHfL+11o/RJzpTZzqkpY8t/6w14DNmF/Lj2mfrNBIgT2xArC
	 7VfGdI3NAdkmAKkJ0p/mu2cUSTjNjaIz91R4IeUMooRuOHk2Z+5VYw6drYaVSK7DB6
	 4TeM141lWqSl98xTnNF54S7f5LgBvlPvk5TDBu3XXMF8uIdUztsHohM5QdgTvIPmDj
	 7nsD9Gu0kBmnUESE0UPwALfRm+zaSkpmve7heky5y9XqzEyxU7tMi3W40NwyX3EWRA
	 7UFzjGRFzYcRN+3DifhdLaIc9yypIK9j9nXNUx5GhHo8yntXZ3dsX0CKrLfLjxiUIq
	 DD/GGhecPtk6g==
Date: Fri, 16 Oct 2026 19:36:09 +0100
From: Simon Horman <horms@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Jiri Pirko <jiri@resnulli.us>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	linux-doc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH net-next] net/mlx5: Remove max_external_SFs device
 resource
Message-ID: <20261016183609.GN363352@horms.kernel.org>
References: <20261011093828.784454-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011093828.784454-1-tariqt@nvidia.com>

On Sun, Oct 11, 2026 at 12:38:28PM +0300, Tariq Toukan wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> The device-level max_external_SFs resource is redundant now that
> per-port max_SFs resources are registered on each PF port representor.
> Users can look up SF limits per-port directly via 'devlink port show'
> to correlate with controller number and pfnum.
> 
> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Simon Horman <horms@kernel.org>

