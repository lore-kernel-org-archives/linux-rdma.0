From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v4] IB/core: Make device counter infrastructure dynamic
Date: Fri, 20 May 2016 16:53:35 +0000
Message-ID: <VI1PR05MB1391B8F7E83C21B653BC0C92D24B0@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ecc98d137bffc959e6459d9ffd0fe53da0d84c9d.1463760487.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, May 20, 2016 7:15 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Subject: [PATCH v4] IB/core: Make device counter infrastructure dynamic
[snip]
> +static struct rdma_hw_stats *iwch_alloc_stats(struct ib_device *ibdev,
> +					      u8 port_num)
> +{
> +	struct rdma_hw_stats *stats;
> +
> +	/* Our driver only supports device level stats */
> +	if (port_num != 0)
> +		return NULL;
> +
> +	/* Guard against buggy edits of the names array */
> +	BUILD_BUG_ON(ARRAY_SIZE(names) != NR_COUNTERS);
> +
> +	stats = kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64),
> GFP_KERNEL);
> +	if (!stats)
> +		return NULL;
> +	stats->name = names;
> +	stats->num_counters = NR_COUNTERS;
> +	stats->lifespan = -1;
> +	return stats;
> +}
[snip]

> +static struct rdma_hw_stats *c4iw_alloc_stats(struct ib_device *ibdev,
> +					      u8 port_num)
> +{
> +	struct rdma_hw_stats *stats;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(names) != NR_COUNTERS);
> +
> +	if (port_num != 0)
> +		return NULL;
> +
> +	stats = kzalloc(sizeof(*stats) + NR_COUNTERS * sizeof(u64),
> GFP_KERNEL);
> +	if (!stats)
> +		return NULL;
> +	stats->name = names;
> +	stats->num_counters = NR_COUNTERS;
> +	stats->lifespan = -1;
> +	return stats;
> +}
[snip]
> +static struct rdma_hw_stats *i40iw_alloc_hw_stats(struct ib_device *ibdev,
> +						  u8 port_num)
> +{
> +	struct i40iw_device *iwdev = to_iwdev(ibdev);
> +	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
> +	struct rdma_hw_stats *stats;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(i40iw_hw_stat_names) !=
> +		     (I40IW_HW_STAT_INDEX_MAX_32 +
> I40IW_HW_STAT_INDEX_MAX_64));
> +
> +	stats = kzalloc(sizeof(*stats) +
> +			I40IW_HW_STAT_INDEX_MAX_32 * sizeof(u64) +
> +			I40IW_HW_STAT_INDEX_MAX_64 * sizeof(u64),
> GFP_KERNEL);
> +	if (!stats)
> +		return NULL;
> +	stats->name = i40iw_hw_stat_names;
> +	stats->num_counters = I40IW_HW_STAT_INDEX_MAX_32 +
> +		I40IW_HW_STAT_INDEX_MAX_64;
> +	/*
> +	 * PFs get the default update lifespan, but VFs only update once
> +	 * per second
> +	 */
> +	if (dev->is_pf)
> +		stats->lifespan = -1;
> +	else
> +		stats->lifespan = msecs_to_jiffies(1000);
> +	return stats;
> +}
Just a little nitpick, what about creating a function that allocates the rdma_hw_stats struct?
Something like:

static inline static struct rdma_hw_stats *allocate_hw_stats_struct(const char **name,
								         int num_counters,
								         unsigned long lifespan)
{
	struct rdma_hw_stats *stats;

	stats = kzalloc(sizeof(*stats) + num_counters * sizeof(u64));
	if (!stats)
		return NULL;

	stats->name = name;
	stats->num_counters = num_counters;
	if (lifespan == -1)
		stats->lifespan = -1;
	else
		stats->lifespan = msecs_to_jiffies(lifespan);

	return stats;
} 

And putting it in ib_verbs.h?
I feel like that copying this piece of code across drivers (3 with this patch, adding mlx5 + mlx4 makes it 5)
makes little sense, also I don't feel the drivers should care/know about how to allocate it.
Specifically: kzalloc(sizeof(*stats) + num_counters * sizeof(u64)) seems out of place inside a driver,
It should be part of the infrastructure.

Other than that, it looks really good.

Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
