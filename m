From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Using RDMA CM without IPoIB?
Date: Fri, 22 Oct 2010 16:00:09 -0600
Message-ID: <20101022220009.GB15514@obsidianresearch.com>
References: <AANLkTino+6q_o_U=eOett8MzthBF2hH95yMkDwyWBi5L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTino+6q_o_U=eOett8MzthBF2hH95yMkDwyWBi5L-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <adit.262-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 22, 2010 at 05:25:25PM -0400, Adit Ranadive wrote:
> Is there a way to use the rdma connection manager library without the
> IPoIB up and running?

Sean has been working on some stuff to allow for GID addressing with
RDMA CM's API but I don't think it is finished yet (?)

The only other CM choice is libicm, which does allow GID addressing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
