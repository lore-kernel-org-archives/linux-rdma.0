From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] rdma/addr: Initialize ret to fix build warning
Date: Thu, 17 Mar 2011 18:12:03 -0700 (PDT)
Message-ID: <20110317.181203.193711655.davem@davemloft.net>
References: <20110318100418.6556c92c.sfr@canb.auug.org.au>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CCC10249@orsmsx501.amr.corp.intel.com>
	<AANLkTikB=ZQQG18sDbD2kfFMWdVuUqnzYWOf7KtuBKVc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikB=ZQQG18sDbD2kfFMWdVuUqnzYWOf7KtuBKVc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xiaosuo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 17 Mar 2011 16:56:27 -0700

> On Thu, Mar 17, 2011 at 4:35 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Commit b23dd4fe42b455af5c6e20966b7d6959fa8352ea (ipv4: Make output
>> route lookup return rtable directly) resulted in leaving
>> ret uninitialized, where it may later be returned.
> 
> Looks good to me, I'll merge this.

Thanks Roland.

Acked-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
