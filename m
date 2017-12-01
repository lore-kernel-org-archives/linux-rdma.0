From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Debian 15.1-1 changes
Date: Fri, 1 Dec 2017 11:28:06 -0700
Message-ID: <20171201182806.GL7754@ziepe.ca>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
 <20171130174750.GD7754@ziepe.ca>
 <1512066118.4246.2.camel@profitbricks.com>
 <20171130185822.GE7754@ziepe.ca>
 <1512079788.3878.1.camel@profitbricks.com>
 <20171201055732.GC8126@mtr-leonro.local>
 <1512151985.9183.4.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1512151985.9183.4.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 01, 2017 at 07:13:05PM +0100, Benjamin Drung wrote:
> GitHub does not allow to rebase & merge the pull request. Is there any
> reason to not allow the rebase & merge workflow? My commits are atomic
> and the git history is cleaner without the merge commits.

We have been using the merge workflow. I'm not sure this was every
really discussed which is best or not.

The git history is simpler with rebase, but merge preserves the 'what
did I test' and preserves the series boundaries, which are also useful things.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
