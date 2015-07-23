From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 00/43] New fast registration API
Date: Thu, 23 Jul 2015 02:28:57 -0700
Message-ID: <20150723092857.GE32592@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <20150722171023.GA18934@infradead.org>
 <55AFD608.401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AFD608.401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 08:42:32PM +0300, Sagi Grimberg wrote:
> We can do that, but I'd prefer not to pollute the API just for this
> single use case. What we can do, is add a pool API that would take care
> of that. But even then we might end up with different strategies as not
> all ULPs can use it the same way (protocol constraints)...
> 
> Today SRP has this logic that registers multiple SG aligned partials.
> We can just have it pass a partial SG list to what we have today instead
> of building the page vectors...
> 
> Or if we can come up with something that will keep the API trivial, we
> can take care of that too.


Supporting an array or list of MRs seems pretty easy.  If you ignore the
weird fallback to physical DMA case when a MR fails case the SRP memory
registration code isn't significanly more complex than that in iSER for
example.  And I think NFS needs the same support as well, as it allows
using additional MRs when detecting a gap.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
