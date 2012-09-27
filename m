From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Wed, 26 Sep 2012 23:46:43 -0700
Message-ID: <CAG4TOxPBOMQW1XeB-CNjq+RHix3Rk-ZqfB_6d5YscMQKDOumtA@mail.gmail.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org> <CAJZOPZKoMorYPBqUPbmUcsw1GcXOYo8oE-u2gA6HB6sb3eo1iw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKoMorYPBqUPbmUcsw1GcXOYo8oE-u2gA6HB6sb3eo1iw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2012 at 2:51 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> What exactly did you mean by saying "for unlucky configurations"
> above? what value did you use for mlx4_core's port_array_type module
> param?

I didn't set the parameter at all.  What I meant by "unlucky configs" was
all the conditions in the following code in mlx4_dev_cap():

		/*
		 * Link sensing is allowed on the port if 3 conditions are true:
		 * 1. Both protocols are supported on the port.
		 * 2. Different types are supported on the port
		 * 3. FW declared that it supports link sensing
		 */
		mlx4_priv(dev)->sense.sense_allowed[i] =
			((dev->caps.supported_type[i] == MLX4_PORT_TYPE_AUTO) &&
			 (dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP) &&
			 (dev->caps.flags & MLX4_DEV_CAP_FLAG_SENSE_SUPPORT));

		/*
		 * If "default_sense" bit is set, we move the port to "AUTO" mode
		 * and perform sense_port FW command to try and set the correct
		 * port type from beginning
		 */
		if (mlx4_priv(dev)->sense.sense_allowed[i] && dev->caps.default_sense[i]) {
			enum mlx4_port_type sensed_port = MLX4_PORT_TYPE_NONE;
			dev->caps.possible_type[i] = MLX4_PORT_TYPE_AUTO;
			mlx4_SENSE_PORT(dev, i, &sensed_port);
			if (sensed_port != MLX4_PORT_TYPE_NONE)
				dev->caps.port_type[i] = sensed_port;
		} else {

I'm beginning to think it might be that I had nothing hooked up
to my adapter initially, which seems to lead to the fatal SENSE_PORT
call here.  I notice that once I bring up the link, the stream of failing
SENSE_PORT calls (which don't ever work in SR-IOV mode
AFAICT) stops as well.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
