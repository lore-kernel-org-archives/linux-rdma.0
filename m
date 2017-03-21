From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB
 driver
Date: Tue, 21 Mar 2017 10:15:30 -0600
Message-ID: <20170321161530.GB22216@obsidianresearch.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com>
 <20170321114955.GB2079@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170321114955.GB2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 21, 2017 at 01:49:55PM +0200, Leon Romanovsky wrote:
> On Mon, Mar 20, 2017 at 02:59:27PM -0600, Jason Gunthorpe wrote:
> > On Mon, Mar 20, 2017 at 09:08:22PM +0200, Erez Shitrit wrote:
> >
> > >    TODO:
> > >         1.change the send api in order to move it to the ndo start_xmit (unless it hurts the performance of the default driver)
> > >         2.Take out the ipoib_ah from the send signature and use ib_ah instead, no need with including ipoib.h
> > >         3.Check if/how to add rdma_netdev layer to the default ipoib
> > >         4. splitting out the bulk rename of ipoib_priv into a single patch
> > >         5. change the name of the header to be ipoib_rn.h
> > >         6. no need to pass qkey, it is in the ah struct.
> >
> > So.. why are you resending the series? Are these going to get fixed?
> 
> Sure, he will. This is why he added them to TODO so nothing will be lost.

Well.. if I assume everything done wrong in this series is fixed, then
it seems fine :)

It looks like the only difference from what Intel started with was the
attach/detach_mcast which is basically how I expected this to look.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
