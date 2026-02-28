Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA963176EF;
	Sat, 28 Feb 2026 23:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772319793; cv=none; b=mfy19BHGICOQnTTfEhXX7m5zNA68D3pFM38w42yFSXWwi1wv+8B9T0Ykh0dIUrBB6qMnM5tYQ77TEmWJSW1S2OpBd24pEciDC+pKcBv5sAnR72qOOeiBH3SBZ0IBJHmDtdbg/Q66tYrhKBhMN5BSOIHYnvP4/8WqGfGGfxbu5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772319793; c=relaxed/simple;
	bh=XAmYS0SfODrg1XPDl6AADcpqQeng3ZTSgu8ko+uE+AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jI+/Uzj+kUWOXY6ljouBKQZn+Xt1CwE0U3nrdiKi7l7NKbg9HJY2PU6/LYq9+HjgOM0JhlE9bX6pXcwHCZiHVTnKBOg9T2MGiwri/QckWML4wgx0BJqQcdpefnzGlJdkRwv8XKjci7nWi8pXGq0RYjezUuLMmN/faUiCjTPukos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQzVym2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQzVym2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FBC116D0;
	Sat, 28 Feb 2026 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772319792;
	bh=XAmYS0SfODrg1XPDl6AADcpqQeng3ZTSgu8ko+uE+AQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dQzVym2dAvOtJ70Kq9OfEgb4o2GP7rZ54HZzxh5ZuiF5Vu9Wo8zsCd3bPZBouiYLp
	 cLK7YsUyxsy9MeoCOXrS6M9WTGSAZK2habv81eW5/6NlKgtdQOWXXv/ExYmAStNufp
	 C+qqXMYvIk9DnQsoGiQF6zUwq0pU+8ZG484Wxs93kEqUmsqlLUijJ6Bs8IMdMhr5Gd
	 7Es862K1SGvbwzuhmoZPTxXcrUwYsylAdjqehT5081G4beyvKBVNc1B591o1zJqrKV
	 udGv3ha3wVSAadEg/aaZT1IPGmJ/8adOlneN7zWJaHszI+JUVkVKmnimwtj+CPegj8
	 Yqe8N7T1L9GJg==
Date: Sat, 28 Feb 2026 15:03:11 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 przemyslaw.kitszel@intel.com, mschmidt@redhat.com, andrew+netdev@lunn.ch,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 chuck.lever@oracle.com, matttbe@kernel.org, cjubran@nvidia.com,
 daniel.zahka@gmail.com, linux-doc@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/10] devlink: introduce shared devlink
 instance for PFs on same chip
Message-ID: <20260228150311.1a1ded74@kernel.org>
In-Reply-To: <20260225133422.290965-9-jiri@resnulli.us>
References: <20260225133422.290965-1-jiri@resnulli.us>
	<20260225133422.290965-9-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Feb 2026 14:34:20 +0100 Jiri Pirko wrote:
> +struct devlink_shd {
> +	struct list_head list; /* Node in shd list */
> +	const char *id; /* Identifier string (e.g., serial number) */
> +	refcount_t refcount; /* Reference count */
> +	char priv[] __aligned(NETDEV_ALIGN); /* Driver private data */
> +};

As pointed out by AI you promised a size member and a __counted_by()
annotation :)
-- 
pw-bot: cr
