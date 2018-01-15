From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] RDMA/cma: Introduce API to read GIDs for
 multiple transports
Date: Mon, 15 Jan 2018 16:04:04 -0700
Message-ID: <20180115230404.GE2206@ziepe.ca>
References: <20180109111058.29534-1-leon@kernel.org>
 <20180109111058.29534-3-leon@kernel.org>
 <20180115222215.GA18795@ziepe.ca>
 <VI1PR0502MB30082F945F147FF434835DF3D1EB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB30082F945F147FF434835DF3D1EB0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 15, 2018 at 10:43:31PM +0000, Parav Pandit wrote:

> > And the prior patch makes a bit more sense after looking here, but the series
> > seems in the wrong order -> the patch to break rdma_addr_get_sgid should go

> rdma_addr_get_sgid() worked only in very limited case.  Since all
> patches are in same series, I don't see order breaks anything. But
> changing order is fine in revised series.

When you order the patches in a series you are trying to tell a story
to the reviewer. It isn't just a random collection of related patches.

Here the story is fixing the few places that are hard wired to use
GIDs to have sane GID information for RoCE.

Every patch should advance that story withou outgoing backwards. In
this case the first patch totally breaks the GIDs in RoCE which breaks
the understandability of the story - if you had put this patch at the
end of the list and said:

 Now that all RoCE users of rdma_addr_get_sgid() call rdma_read_gids()
 we can remove the sketchy RoCE specific support from
 rdma_addr_get_sgid()

Then the entire story makes a lot more sense, and the patch becomes a
conclusion, not a confusing starting point.

This also aide bisect-ability - we don't want to see patches break
working functionality in the middle of a series because 'git bisect'
does not know about series boundaries.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
