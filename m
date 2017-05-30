From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 30 May 2017 16:24:31 -0500
Message-ID: <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170529082423.1180-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170529082423.1180-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 29, 2017 at 11:24:23AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>
> 
> The commit cea05eadded0 ("IB/core: Add flow control to the portmapper netlink calls")
> changed netlink to be blocked for all RDMA clients. This workaround
> worked perfectly for portmapper, but is not correct for the whole
> NETLINK_RDMA family.
> 
> The request/response should always be blocking and asynchronous
> notification should always be non-blocking.
> 
> It is library and user-space application to chose how to handle recvmgs,
> as an example see nl_recvmsgs() and nl_socket_set_nonblocking() calls of
> libnl library.
> 
> Send timeout is not needed too and can be configured with SO_SNDTIMEO socket
> option.
> 
> This reverts commit cea05eadded0d4eb59f7be6e1f1560eb6bfde2bf.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This commit was accepted with much feedback from you.

https://patchwork.kernel.org/patch/9235137/

Not clear from your description to determine what your trying to fix. 

Simply reverting a commit that solves a real problem is not acceptable.

Please come up with a solution without breaking portmapper.

Shiraz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
