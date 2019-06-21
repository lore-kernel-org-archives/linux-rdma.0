From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/core: Fix race when resolving IP address
Date: Fri, 21 Jun 2019 11:56:04 -0300
Message-ID: <20190621145604.GS19891@ziepe.ca>
References: <1561126156-10162-1-git-send-email-dag.moxnes@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1561126156-10162-1-git-send-email-dag.moxnes@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dag Moxnes <dag.moxnes@oracle.com>
Cc: dledford@redhat.com, leon@kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Parav Pandit <parav@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 21, 2019 at 04:09:16PM +0200, Dag Moxnes wrote:
> Use neighbour lock when copying MAC address from neighbour data struct
> in dst_fetch_ha.
> 
> When not using the lock, it is possible for the function to race with
> neigh_update, causing it to copy an invalid MAC address.
> 
> It is possible to provoke this error by calling rdma_resolve_addr in a
> tight loop, while deleting the corresponding ARP entry in another tight
> loop.
> 
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> Change-Id: I3c5f982b304457f0a83ea7def2fac70315ed38b4
>  drivers/infiniband/core/addr.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 2f7d141598..e4945fd1bb 100644
> +++ b/drivers/infiniband/core/addr.c
> @@ -333,12 +333,16 @@ static int dst_fetch_ha(const struct dst_entry *dst,
>  	if (!n)
>  		return -ENODATA;
>  
> +	read_lock_bh(&n->lock)
>  	if (!(n->nud_state & NUD_VALID)) {
> -		neigh_event_send(n, NULL);
>  		ret = -ENODATA;
>  	} else {
>  		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
>  	}
> +	read_unlock_bh(&n->lock);
> +
> +	if (ret)
> +		neigh_event_send(n, NULL);
>  
>  	neigh_release(n);

Can we write this with less spaghetti please, maybe:

static int dst_fetch_ha(const struct dst_entry *dst,
			struct rdma_dev_addr *dev_addr,
			const void *daddr)
{
	struct neighbour *n;
	int ret = 0;

	n = dst_neigh_lookup(dst, daddr);
	if (!n)
		return -ENODATA;

	read_lock_bh(&n->lock);
	if (!(n->nud_state & NUD_VALID)) {
		read_unlock_bh(&n->lock);
		goto out_send;
	}
	memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
	read_unlock_bh(&n->lock);

	goto out_release;

out_send:
	neigh_event_send(n, NULL);
	ret = -ENODATA;
out_release:
	neigh_release(n);

	return ret;
}

Also, Parav should look at it.

Thanks,
Jason
