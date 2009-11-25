From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] uDAPL v2: scm: client side setsockopt NODELAY fails if
	data arrives before setting
Date: Tue, 24 Nov 2009 17:29:14 -0700
Message-ID: <20091125002914.GQ6188@obsidianresearch.com>
References: <E3280858FA94444CA49D2BA02341C98361B96A62@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E3280858FA94444CA49D2BA02341C98361B96A62-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2009 at 04:16:16PM -0800, Davis, Arlin R wrote:

> -	return ioctlsocket(s, FIONBIO, &nonblocking);
> +	int ret, opt;
> +
> +	ret = ioctlsocket(s, FIONBIO, &nonblocking);
> +
> +	/* no delay for small packets */
> +	if (!ret)
> +		ret = setsockopt(s, IPPROTO_TCP, TCP_NODELAY, 
> +				 (char *)&opt, sizeof(opt));
> +	return ret;
>  }

You probably need to initialize opt..

TCP_NODELAY is not a POSIX feature, and the common UNIX/Linux behavior
is to allow it to be set/unset at any time. Strange the Windows would
be restrictive in this way.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
