From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [rdma-next, 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Mon, 18 Dec 2017 15:40:48 -0700
Message-ID: <20171218224048.GA28327@ziepe.ca>
References: <20171114125218.20477-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:53PM +0200, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> If from some reason the SM responses to path query request with response
> that doesn't contain the exact SGID, ipoib should warn and change that
> part of the response before push it to the path record DB.
> Otherwise, new record will be added to the path record DB with no access
> to them from the ipoib.
> 
> Demonstration of the bug is as the follow:
> ipoib wants to send to GID fe80:0000:0000:0000:0002:c903:00ef:5ee2, it
> creates new record in the DB with that gid as a key, and issues a new
> request to the sm.
> Now, the SM from some reason returns path-record with other SGID (for
> example, fe80:0000:0000:0001:0002:c903:00ef:5ee2 that contains the local
> subnet prefix) now ipoib will overwrite the current entry with the new
> one, and if new request to the original GID arrives ipoib  will not find
> it in the DB (was overwritten) and will create new record that in its
> turn will also be overwritten by the response from the SM, and so on
> till the driver eats all the device memory.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 12b7f911f0e5..b173d618c59c 100644
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -775,6 +775,16 @@ static void path_rec_completion(int status,
>  	spin_lock_irqsave(&priv->lock, flags);
>  
>  	if (!IS_ERR_OR_NULL(ah)) {
> +		/* check there is no mismatch from the request */
> +		if (memcmp(pathrec->dgid.raw, path->pathrec.dgid.raw,
> +			   sizeof(union ib_gid))) {
> +			pr_warn("%s got PathRec for gid %pI6 while asked for %pI6\n",
> +				dev->name, pathrec->dgid.raw, path->pathrec.dgid.raw);
> +			/* overwrite the response from the sm  before copy to the db */
> +			memcpy(pathrec->dgid.raw, path->pathrec.dgid.raw,
> +			       sizeof(union ib_gid));
> +		}
> +
>  		path->pathrec = *pathrec;

I applied this, but converted the pr_warn to ipoib_dbg (it is not an
error for the SA to change the DGID), reworded the commit message and
comment:

		/*
		 * pathrec.dgid is used as the database key from the LLADDR,
		 * it must remain unchanged even if the SA returns a different
		 * GID to use in the AH.
		 */
		if (memcmp(pathrec->dgid.raw, path->pathrec.dgid.raw,
			   sizeof(union ib_gid))) {
			ipoib_dbg(
				priv,
				"%s got PathRec for gid %pI6 while asked for %pI6\n",
				dev->name, pathrec->dgid.raw,
				path->pathrec.dgid.raw);
			memcpy(pathrec->dgid.raw, path->pathrec.dgid.raw,
			       sizeof(union ib_gid));
		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
