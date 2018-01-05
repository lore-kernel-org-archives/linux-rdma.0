From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 06/14] {net,IB}/mlx5: Manage port association
 for multiport RoCE
Date: Fri, 5 Jan 2018 07:47:30 -0600
Message-ID: <4c06e3ac-dd00-d99c-ce93-e3cd391c0e8b@mellanox.com>
References: <20180104152544.28919-1-leon@kernel.org>
 <20180104152544.28919-7-leon@kernel.org> <20180104233334.GA18993@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104233334.GA18993-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/4/2018 5:33 PM, Jason Gunthorpe wrote:
>> +struct mlx5_ib_odp {
>> +	struct ib_odp_caps	caps;
>> +	u64			max_size;
>> +	/*
>> +	 * Sleepable RCU that prevents destruction of MRs while they are still
>> +	 * being used by a page fault handler.
>> +	 */
>> +	struct srcu_struct      mr_srcu;
>> +	u32			null_mkey;
>> +	void			(*sync)(struct mlx5_ib_dev *dev);
>> +};
> Well this doesn't belong in here. rebase error or something?
>
> Someone needs to go over these patches more carefully..
>
> Jason

Looks like a rebase error, it's not there in V0.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
