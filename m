From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: iser-target: introduce fast memory registration mode (FRWR)
Date: Sat, 19 Oct 2013 11:29:10 +0300
Message-ID: <20131019082910.GK5550@mwanda>
References: <20130903111436.GA15230@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130903111436.GA15230-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

What ever happened with this?

regards,
dan carpenter

On Tue, Sep 03, 2013 at 02:14:36PM +0300, Dan Carpenter wrote:
> Hello Vu Pham,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 12050ce23475: "iser-target: introduce fast memory 
> registration mode (FRWR)" from Aug 28, 2013, leads to the following 
> Smatch complaint:
> 
> drivers/infiniband/ulp/isert/ib_isert.c:622 isert_connect_release()
> 	 warn: variable dereferenced before check 'device' (see line 598)
> 
> drivers/infiniband/ulp/isert/ib_isert.c
>    597		if (device->use_frwr)
>                     ^^^^^^^^^^^^^^^^
> Patch introduces dereference.
> 
>    598			isert_conn_free_frwr_pool(isert_conn);
>    599	
> 
> [ snip ]
> 
>    620		kfree(isert_conn);
>    621	
>    622		if (device)
>                     ^^^^^^
> Existing check.
> 
>    623			isert_device_try_release(device);
>    624	
> 
> regards,
> dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
