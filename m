Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33EB221DB1;
	Wed, 28 Jan 2026 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769592064; cv=none; b=OSwUxRBKBcjc9gRH+QOK9v6/giQ3R6P0JUYLHIRwQOOxiIqYJPnH/pEM1lYX5XNkqiB1R9wPeAQbB9tjAi54vKhPBB01uzHA+7icyAbAhYxXckDSkNMYVrTtT+wdu9980/XmMZDrZOqU4e9O1cei0mYNu/+NehZkynXP481IWu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769592064; c=relaxed/simple;
	bh=qGYL5CXdMuNwNQRl6Uiafr57gwii2N73jtRm6IxCK5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YS7hleapRKTuzs/JWNgzLJgAJ+YuoTCgF+EZxOyb5j6dymkdFSL7JQJUVd+hhT2QeNN6TsGIbmMMewZJ3juDj2IcKis+bF124i4RhyLmhcC4upsAUzPBDSZxTQJqV4sq3ZG4946gwcfqRCmc1NDcBODfebL7QepsO5F9EKgudnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6RzYceK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6RzYceK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3A9C4CEF1;
	Wed, 28 Jan 2026 09:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769592064;
	bh=qGYL5CXdMuNwNQRl6Uiafr57gwii2N73jtRm6IxCK5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6RzYceKRbx9FdjqYP1hp9zBjNNuzEzChYhc5u7AdSjSi5fafL+AN9dvSuZ/sOZn+
	 L8RaBLUt+j89auH3oPJxDGPClHRn4vT5qsQfZehCUjA11ZQ4N5aPaP3mZaWqTWJ4Yp
	 h3iAGbY2AnupuYRuXrbV9c7STYH+5XYpvE7kZY5EZFsAacPvZWG84IwooGbIQOZdZn
	 u4jV0GwRzYgS3zdSP5LSMCR5bpcDYyIKxAhS/7qc7M8A8tvnwkplVfDGxNlxKWkMKx
	 iMRflWz+zzhNkSx4h12tAIktXu3AcyIdq2E6HlKYiBQP5dM8ZTv8ERxAjR4lhI41V3
	 5MjHqU4ZojZbA==
Date: Wed, 28 Jan 2026 09:20:58 +0000
From: Simon Horman <horms@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"donald.hunter@gmail.com" <donald.hunter@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"leon@kernel.org" <leon@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Carolina Jubran <cjubran@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Gal Pressman <gal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
	"krzk@kernel.org" <krzk@kernel.org>
Subject: Re: [PATCH net-next V6 07/14] devlink: Add parent dev to devlink API
Message-ID: <aXnU-klD1_rHY0D0@horms.kernel.org>
References: <1769340723-14199-1-git-send-email-tariqt@nvidia.com>
 <1769340723-14199-8-git-send-email-tariqt@nvidia.com>
 <aXjCf2iRC5VsRC5A@horms.kernel.org>
 <3a000e6a2fcdfb6dc8d18e24d6ee1e7f9f89bc0e.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a000e6a2fcdfb6dc8d18e24d6ee1e7f9f89bc0e.camel@nvidia.com>

On Tue, Jan 27, 2026 at 02:25:51PM +0000, Cosmin Ratiu wrote:
> On Tue, 2026-01-27 at 13:49 +0000, Simon Horman wrote:
> > On Sun, Jan 25, 2026 at 01:31:56PM +0200, Tariq Toukan wrote:
> > > From: Cosmin Ratiu <cratiu@nvidia.com>

...

Hi Cosmin,

> Hi Simon,
> 
> We had this conversation during v4, I replied then [1].

Sorry, I had forgotten about that.

> But thinking about it a bit more, I think it's indeed slightly cleaner
> to move the policy and the new pre/post doit handlers to the next
> patch, where they are actually used. The only bit is that the policy is
> used from devlink_get_parent_from_attrs_lock from this function, but it
> appears safe to use NULL there until next patch (the underlying parse
> functions tolerate NULL policies).
> 
> So I'll do that in the next submission.

Thanks, that makes sense.
And I'll try to remember this conversation when looking at the next version :)

> 
> [1]
> https://lore.kernel.org/netdev/3ec956ea1d0a1c6e56865b2ded6d83ed773ccd4d.camel@nvidia.com/
