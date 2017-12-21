From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 02/14] RDMA/core: Enforce requirement to
 hold lists_rwsem semaphore
Date: Thu, 21 Dec 2017 12:12:00 -0700
Message-ID: <20171221191200.GE20015@ziepe.ca>
References: <20171221181748.17126-1-leon@kernel.org>
 <20171221181748.17126-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221181748.17126-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 08:17:36PM +0200, Leon Romanovsky wrote:
> @@ -526,8 +531,8 @@ int ib_register_device(struct ib_device *device,
>  		if (!add_client_context(device, client) && client->add)
>  			client->add(device);
> 
> -	device->index = __dev_new_index();
>  	down_write(&lists_rwsem);
> +	device->index = __dev_new_index();

Isn't this hunk a for-rc bugfix??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
