From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 05/25] IB/ipoib: Support ipoib
 acceleration options callbacks
Date: Wed, 15 Mar 2017 10:46:52 -0600
Message-ID: <20170315164651.GA1931@obsidianresearch.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-6-git-send-email-erezsh@mellanox.com>
 <20170313201049.GB2738@obsidianresearch.com>
 <CAAk-MO8-bnWRu7BDtYDhNePj+76X4Vb7gFNhED8irLNtqR7tCw@mail.gmail.com>
 <20170314160616.GE3244@obsidianresearch.com>
 <CAAk-MO96BbTnn=gzdZhRpQUENn=AVUJv1JhPbrSYrNHOrbFVeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO96BbTnn=gzdZhRpQUENn=AVUJv1JhPbrSYrNHOrbFVeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2017 at 06:27:23PM +0200, Erez Shitrit wrote:

> > Move things like priv->napi into ipoib_rn_default, only the stuff
> > under rdma_netdev should touch NAPI.
> 
> When no accelerator is around, ipoib should work as before, and the
> struct struct ipoib_dev_priv is the one who does all datapath and
> control.

The point is to make the code maintainable, by moving everything that
is only used by *_default out of ipoib_dev_priv we can use the compiler
to prove it isn't being used improperly by the core code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
