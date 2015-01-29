From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/4] IB/core: Check mad_agent in
 ib_unregister_mad_agent before dereferencing it
Date: Thu, 29 Jan 2015 10:42:21 -0700
Message-ID: <20150129174221.GE11842@obsidianresearch.com>
References: <1422522871-11216-1-git-send-email-ogerlitz@mellanox.com>
 <1422522871-11216-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422522871-11216-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 29, 2015 at 11:14:29AM +0200, Or Gerlitz wrote:
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> When ib_register_mad_agent fails, it returns a pointer with error which is not
> NULL, therefore when calling ib_unregister_mad_agent we need to check that the
> passed mad_agent is valid and not erroneous.

This seems really weird, it is not idiomatic to randomly sprinkle
IS_ERR checks for function arguments.

The proper place for the IS_ERR check is directly after a
function that can return an ERR_PTR, then the caller shouldn't call
unregister,

Ie ib_sa_add_one already has this arrangement:

        for (i = 0; i <= e - s; ++i) {
                sa_dev->port[i].agent =
                        ib_register_mad_agent(device, i + s, IB_QPT_GSI,
                                              NULL, 0, send_handler,
                                              recv_handler, sa_dev);
                if (IS_ERR(sa_dev->port[i].agent))
                        goto err;
[..]

err:
        while (--i >= 0)
                if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
                        ib_unregister_mad_agent(sa_dev->port[i].agent);


So it never calls ib_unregister_mad_agent with an ERR_PTR.

If there is a bug, then it is at a call site, not in the unregister.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
