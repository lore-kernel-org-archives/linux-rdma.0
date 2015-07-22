From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 00/43] New fast registration API
Date: Wed, 22 Jul 2015 20:42:32 +0300
Message-ID: <55AFD608.401@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <20150722171023.GA18934@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722171023.GA18934-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 8:10 PM, Christoph Hellwig wrote:
> Thanks Sagi,
>
> this looks pretty good in general, various nitpicks nonwithstanding.
>
> The one thing I'm curious about is how we can support SRP with it's
> multiple MR support without too much boilerplate code.  One option
> would be that pass an array of MRs to the map routines, and while
> most callers would just pass in one it would handle multiple for those
> drivers that supply them.

We can do that, but I'd prefer not to pollute the API just for this
single use case. What we can do, is add a pool API that would take care
of that. But even then we might end up with different strategies as not
all ULPs can use it the same way (protocol constraints)...

Today SRP has this logic that registers multiple SG aligned partials.
We can just have it pass a partial SG list to what we have today instead
of building the page vectors...

Or if we can come up with something that will keep the API trivial, we
can take care of that too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
