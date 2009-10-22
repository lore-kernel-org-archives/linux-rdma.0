From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] [RFC] rdma/cm: support option to allow manually setting IB path
Date: Thu, 22 Oct 2009 10:54:14 -0600
Message-ID: <20091022165414.GH26003@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B7E97540810E4A2785FF1FC8CB96F453-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 22, 2009 at 01:10:09AM -0700, Sean Hefty wrote:

> +static int ucma_set_ib_path(struct ucma_context *ctx,
> +			    struct ib_path_rec_data *path_data, size_t optlen)
> +{
> +	struct ib_sa_path_rec sa_path;
> +	struct rdma_cm_event event;
> +	int ret;
> +
> +	if (optlen != sizeof(*path_data))
> +		return -EINVAL;
> +
> +	if (path_data->flags != IB_PATH_GMP | IB_PATH_PRIMARY |
> +				IB_PATH_OUTBOUND | IB_PATH_INBOUND)
> +		return -EINVAL;

This should accept an array here, to aid easing in APM support:

if ((optlen % sizeof(*path_data)) != 0) return -EINVAL;

for (; optlen != 0; optlen -= sizeof(*path_data), path_data++)
   if (path_data->flags == (IB_PATH_GMP | IB_PATH_PRIMARY |                                  
                            IB_PATH_OUTBOUND | IB_PATH_INBOUND))
       break;

if (optlen == 0) return -EINVAL;

Could you do basic APM support right now, exactly with the same
capability as ucm has?

> +enum {
> +	IB_PATH_GMP	  = 1,
> +	IB_PATH_PRIMARY   = (1<<1),
> +	IB_PATH_ALTERNATE = (1<<2),
> +	IB_PATH_OUTBOUND  = (1<<3),
> +	IB_PATH_INBOUND   = (1<<4)
> +};

I like the PATH_PRIMARY/PATH_ALTERNATE idea,

But I think IB_PATH_OUTBOUND_REV is still required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
