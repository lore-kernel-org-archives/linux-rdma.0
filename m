From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 11:51:53 -0600
Message-ID: <20170612175153.GA13677@obsidianresearch.com>
References: <20170612162917.GA11993@obsidianresearch.com>
 <VI1PR0502MB3008EA451DA9ECEBECE27362D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612164343.GA12435@obsidianresearch.com>
 <VI1PR0502MB300831A1560531E67B29589DD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612165536.GB12435@obsidianresearch.com>
 <VI1PR0502MB30089EDC828A142338B1EE06D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612171436.GA12739@obsidianresearch.com>
 <VI1PR0502MB3008304F8465C19ACCFF3D68D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170612173221.GA13302@obsidianresearch.com>
 <VI1PR0502MB30081FD74492E97043F45BD8D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30081FD74492E97043F45BD8D1CD0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 05:46:34PM +0000, Parav Pandit wrote:

> Too many flags just confuses end-user for
> read/write/requester/responder etc.  Also there isn't well
> established use case either where user wants to do only certain
> things.

Your original discussion said this optimized cases on Rx when the
fabric went out of order, eg repath, etc. That seems well defined
enough to be a dedicated flag, default to on, etc.

Sending packets out of order is an entirely different beast, and
sounds like it would also require additional configuration, as IBA
doesn't even have an existing way to describe a set of paths to choose
between.

How are the TX paths choosen? That need to be documented before this
could even be considered for the common API.

This is why I think one flag is a bad idea.

> > Perhaps it should be in libmlx5 instead.
> 
> We think that its best usable through ibv_modify_qp because it's
> really simple enough and well documented which will address inputs
> given in this discussion.

That isn't really the criteria to be in the common API now that we
have the libmlx5 approach.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
