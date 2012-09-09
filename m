From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Sun, 9 Sep 2012 17:09:30 +0300
Message-ID: <CAJZOPZLXktTREd3xmE=v14HpP1O+EgiqA54LHwQvPNXNX9Rr7A@mail.gmail.com>
References: <20549.47088.805176.786765@iinet.net.au>
	<CAG4TOxOQvAMFSTzM1vRS4XqMTiTPQ2Ofgbm7nEHPpPHD_tNwYw@mail.gmail.com>
	<20551.21182.486376.898809@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20551.21182.486376.898809-AFFH1GffN5hPR4JQBCEnsQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 5, 2012 at 4:25 PM, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org> wrote:
> On Tue, 4 Sep 2012 11:02:32 -0700, Roland Dreier wrote:
>
>  roland> On Tue, Sep 4, 2012 at 1:12 AM, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org> wrote:
>  >> What about races between radix_tree_extend and radix_tree_lookup?
>  >>
>  >> As far as I can see (even on newer kernels with rcu support) there is
>  >> nothing which protects changes to node->height and it is used to
>  >> decide how deep lookup must go to find the actual data.
>
>  roland> I assume things are ordered so that lookups that follow the
>  roland> old data can still find old entries, and that updates become
>  roland> visible in a consistent order.
>
> I honestly do see how - the height of the root node is updated
> indepedently of the slots, so if someone managed to get the updated
> height there is nothing from stoping radix_tree_lookup from going too
> deep into the chain of slots.
>
> Also most other places which call radix_tree_lookup do use some kind
> of lock around it.


same here putting your response on linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as it was
wrongly sent to linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org ...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
