Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BCD35AC17;
	Wed,  6 May 2026 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778108396; cv=none; b=EO1YA3YfsjkXvS6v5IcfGda8syRlwszrypfrchzvV2ardZhKcLcCf2Lq+vxVXQBxSvRaFfsujuBWdIlU9C3NKl3ESNepoPvFUW8NemiJrJSz8msTs8Oekz9oOKAGdrhXDR+pmBOD1onbi2KIgEG9zf7SUVDJGHI9QQhY0IegSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778108396; c=relaxed/simple;
	bh=r5Q+Ds2JoT4aJB1aVs4yY/mgwsf3hOF+TnKDvKgCx4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGlbVNxlor5AmjfiEfzIm0bcamP+md8RvIyhlDhq68V/tSa90RLDRHbewR4N8sIDP9V/MOjv5tMbcD6p6n3eDHmfjcaU415KqU4BTT3WbS2Zsd9aQ+tR5B208YpyU/RTymz/nKmx6H4miPQYxVkffx4WPfQl7qeQ34lWktZrUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fs1yCpp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fs1yCpp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D04C2BCB0;
	Wed,  6 May 2026 22:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778108395;
	bh=r5Q+Ds2JoT4aJB1aVs4yY/mgwsf3hOF+TnKDvKgCx4Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fs1yCpp0kDmKt0JKDaVhrCEK2f4p6Gm5sQW/EO6YznR8KMt+Of9Z81rR8kxYSUWwX
	 WM4nzaozr3l27tstrrZOSqsuN3t6p/stvlx7kMqYLcOSRbeNI3nBw2RNlspmdksOlr
	 2hSJVyejNQlg8CumTFlCqiegqWrg9fAira+SVIsVCMJPo1J3ruIgYIYxw7SHY0VzSu
	 I/BIZF7LuBpEIEvbS42W/gNIb3tc5fbjSjH6m4ylEMwNQJ84CY3ZR7Ow7ZLzonhFjv
	 /qHmyQnHjPfHsvz3ubUJmbLIMLTOfk2e7YJGtHqbaRwPt2YM6Tnh5LBTpZHhYLCFrf
	 OpqV+za7yn1EA==
Date: Wed, 6 May 2026 15:59:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Joyner <eric.joyner@amd.com>
Cc: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Brett Creeley
 <brett.creeley@amd.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Abhijit Gangurde <abhijit.gangurde@amd.com>,
 Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 0/4] RDMA/net/ionic: Misc updates
Message-ID: <20260506155954.17e984c6@kernel.org>
In-Reply-To: <20260506041935.1061-1-eric.joyner@amd.com>
References: <20260506041935.1061-1-eric.joyner@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 5 May 2026 21:19:31 -0700 Eric Joyner wrote:
> Other smaller additions add a devlink parameter to the ionic ethernet
> driver for enabling and disabling RDMA,

My understanding is that the devlink param was expected to change 
the configuration of the device. IOW user can enable/disable RDMA
to save internal device resources. You seem to be purely preventing
the auxbus device to be added. So there's nothing gained here compared
to simply not loading the RDMA driver. What am I missing?
