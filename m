From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 3/5] IB/core: Call ib_unregister_mad_agent()
 only for valid agents
Date: Thu, 5 Feb 2015 10:43:37 -0700
Message-ID: <20150205174337.GB31711@obsidianresearch.com>
References: <1423131138-19060-1-git-send-email-ogerlitz@mellanox.com>
 <1423131138-19060-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1423131138-19060-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 05, 2015 at 12:12:16PM +0200, Or Gerlitz wrote:

> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index 82a7dd8..6be0d2c 100644
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -907,7 +907,7 @@ int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
>  err:
>  	for (p = 0; p < dev->num_ports; ++p)
>  		for (q = 0; q <= 1; ++q)
> -			if (dev->send_agent[p][q])
> +			if (!IS_ERR(dev->send_agent[p][q]))
>  				ib_unregister_mad_agent(dev->send_agent[p][q]);

This doesn't really address my comment. I said the check for err ptr
only belongs after ib_register_mad_agent, I'm also not sure why these
few call sites were picked for this change ...

It didn't take long to see that mlx4 already does:

int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
{
	struct ib_mad_agent *agent;
	int p, q;
	int ret;
	enum rdma_link_layer ll;

	for (p = 0; p < dev->num_ports; ++p) {
		ll = rdma_port_get_link_layer(&dev->ib_dev, p + 1);
		for (q = 0; q <= 1; ++q) {
			if (ll == IB_LINK_LAYER_INFINIBAND) {
				agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
							      q ? IB_QPT_GSI : IB_QPT_SMI,
							      NULL, 0, send_handler,
							      NULL, NULL);
				if (IS_ERR(agent)) {
					ret = PTR_ERR(agent);
					goto err;
				}
				dev->send_agent[p][q] = agent;
			} else
				dev->send_agent[p][q] = NULL;
		}
	}

I can't see how send_agent can ever contain err_ptr - and the above is
a good idiom.

I leave checking the rest up to you.

[The set to null is either redundent or there is another bug here
 because the err unwind blindly unregisters everything]

Again: err_ptr checks belong after ib_register_mad_agent - not at the
unregister, err_ptr values should not be put into long term storage in
the first place.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
