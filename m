Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBBC392C20;
	Sun, 18 Oct 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792335829; cv=none; b=kckSbRI0R2wXc04oaRHUCdwFudlMEObFQCryWJCnMJuNeGltVSKaa2DtskX8pm96j9/Juxn5rQ3ocfC10kFfLld6x2qAvA7ATZN/CWsF7yCUoTJCMIHUClnC3qMSCS5sMYgPyZXMS3J9kXJ9meP3r/DLUStJZ5SGOihuV2Bbv34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792335829; c=relaxed/simple;
	bh=J34du2KwO5kFYXsI7Ma+wxYs9zoU8JcLzMXfohakjzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DASUBY2VWhtRfJxXMancIhfLUflhUAInSTIGdS5FCPvHoRFNwanoGcF2FH3F0JJg7XJSGj9xgwVmiiEXYx7SafAw5dEhNxFYMgO5sAP52+dxhzUMX+hxwwZ3dyNb/6EkEwMtmDO3pcw8KY2iES//TsxFdlk8vzaKPmJ6Sim1k/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eaemv+0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eaemv+0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FA01F000C4;
	Sun, 18 Oct 2026 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792335828;
	bh=3idvbpRPPNNuOsbOHfSvGH2iKq6CKm7NL5PxAHJRj2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eaemv+0yb9JRqQQUtw83fvQYjarjbAygT/PDSXl/aKsoQsQFXMprbIWsjSimBJuZ7
	 WfHNhA55WS3Iz+vZQRD18Ft5wKvzb1pwlsiZBe05GeV5RkNSMHxMQb9AjJGFf9KuMi
	 KtMpM6inkurLfii7KGy0V6pmzDR5Za/4JlK1h5iSDrfyltawhnED5I7ljtYfZE/+At
	 sEPG8ZGyc4q8yPT8DUxJEYsOTQ0AtMvXKzfp7jA0xFAsDEGRlmKWLNxlt3jDltWauC
	 vP4B7nwaLL8kazcdnAdUToNHZL/I/KJIF4+oGEdugd9+gXsjiz3WEqAZQm/scg1Kxd
	 xVxtpvqUMVj/g==
Date: Sun, 18 Oct 2026 16:03:43 +0100
From: Simon Horman <horms@kernel.org>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Hamdan Agbariya <hamdani@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix modify header pattern
 compare on big-endian
Message-ID: <20261018150343.GN503057@horms.kernel.org>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-2-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012101937.1335231-2-acassen@corp.free.fr>

On Mon, Oct 12, 2026 at 12:19:34PM +0200, Alexandre Cassen wrote:
> mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
> compare only its control dword. On big-endian this keeps the data dword
> instead, which HWS clears from the pattern of set and add actions. Two
> such actions writing the same value into different fields then share a
> pattern and the second rule modifies the wrong field.
> 
> Read the first dword of each action from memory instead. Little-endian
> behavior is unchanged.
> 
> Discovered by an AI code review agent [1] and confirmed by code
> inspection. Not reproduced for lack of big-endian hardware running HWS.
> 
> Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args handling")
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.135825-1-acassen%40corp.free.fr [1]
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Reviewed-by: Simon Horman <horms@kernel.org>

