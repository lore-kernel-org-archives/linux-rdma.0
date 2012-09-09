From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Sun, 9 Sep 2012 08:10:37 -0700
Message-ID: <CAL1RGDXZtqWcFhPXnit=O81wACdXsyDziv6ivkXMOcTf+8_X6w@mail.gmail.com>
References: <20549.47088.805176.786765@iinet.net.au> <CAG4TOxOQvAMFSTzM1vRS4XqMTiTPQ2Ofgbm7nEHPpPHD_tNwYw@mail.gmail.com>
 <20551.21182.486376.898809@iinet.net.au> <CAJZOPZLXktTREd3xmE=v14HpP1O+EgiqA54LHwQvPNXNX9Rr7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLXktTREd3xmE=v14HpP1O+EgiqA54LHwQvPNXNX9Rr7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 9, 2012 at 7:09 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I honestly do see how - the height of the root node is updated
>> indepedently of the slots, so if someone managed to get the updated
>> height there is nothing from stoping radix_tree_lookup from going too
>> deep into the chain of slots.

Please look at commit 7cf9c2c76c1a ("[PATCH] radix-tree: RCU lockless readside")

    Make radix tree lookups safe to be performed without locks.  Readers are
    protected against nodes being deleted by using RCU based freeing.  Readers
    are protected against new node insertion by using memory barriers to ensure
    the node itself will be properly written before it is visible in the radix
    tree.

etc.  Also the API description in <linux/radix-tree.h> is helpful.

Before we randomly throw in locking, let's please have at least a theory
about what race we're actually protecting against.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
