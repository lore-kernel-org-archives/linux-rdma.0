Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F633B6E0;
	Sat, 28 Feb 2026 23:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772319701; cv=none; b=nkeHZYQRLVqBkWhCXUY0C/SK0p3J1/AZnudund0hoq4v9JUH3yOvxn/nnO54F4Bt604soJKc59A20gTEPorbnIxMQ/gjoKHOf7nwc+TtULyjOyfm1Z4E4Fs+HzLLltYGyqV9jOmmrY4Wb2quyT76wxGyjlR6LnYPJOoLTz0tndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772319701; c=relaxed/simple;
	bh=MqqasWg3JHrbA1uVAhFFc1wBQLaZ8HY7uBk+lc+Nkrs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HmjTLsqfrguTH6ypBk5OIznJ/tI/byaRulEW5stFqQvoQcbdH52Cd8OL4wl0OKj4MifqCNc38ir4lw0S1ZniiAhkNkh/pO9koHO5xaca4+xt9Ig9v81A4nmATDT2pfyd7Y/Q0nFZPB5m1rw6guaivvbY00oxSdd7aO2qR44/VOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGvDXCIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGvDXCIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4E7C19421;
	Sat, 28 Feb 2026 23:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772319700;
	bh=MqqasWg3JHrbA1uVAhFFc1wBQLaZ8HY7uBk+lc+Nkrs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZGvDXCIJDduIIZnyU29uspufH2o45ggbkmBZrT2xvyIGChc7cwK0kntXm7WY90l3u
	 0smcx42hCwLlDC2PmbrP2V7q8t+APVW8051NBzB0Q8UBQ6HSy10ZVBNHG1aKZlcw59
	 18Ye3WWx8esC7//Ws76NTetm6kKUm1iQKAmwmdm410nrhNThMhFqNzh5rL5CtlCv+9
	 5mDMlrtfKoOULnc/VUGj+JfZVBmSqx6UspFS2/9Kq/m2j/oHS/QVWpSOpY0m0rMod6
	 i0oOnQ6Y1ha2aHuGc1YcEdYHvBRsuLNLsZMolQay4x+jd/jnAMQk/7zqX3AjPVRgWJ
	 wRsWO0cMnjDFA==
Date: Sat, 28 Feb 2026 15:01:38 -0800
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
Subject: Re: [PATCH net-next v2 07/10] devlink: allow devlink instance
 allocation without a backing device
Message-ID: <20260228150138.14e35ee7@kernel.org>
In-Reply-To: <20260225133422.290965-8-jiri@resnulli.us>
References: <20260225133422.290965-1-jiri@resnulli.us>
	<20260225133422.290965-8-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Feb 2026 14:34:19 +0100 Jiri Pirko wrote:
> -	dev_warn(port->devlink->dev, "Type was not set for devlink port.");
> +	if (port->devlink->dev)
> +		dev_warn(port->devlink->dev,
> +			 "Type was not set for devlink port.");

since I'm already nit-picking - maybe we should have a helper for this
case an pr_warn() the message if dev is NULL?
