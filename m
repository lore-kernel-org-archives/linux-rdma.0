From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/4] nfs: Referrals should use the same proto setting
 as their parent
Date: Tue, 5 Dec 2017 10:36:20 -0500
Message-ID: <396baae6-8372-e7bc-97e4-d5c27b341f8d@Netapp.com>
References: <20171204190904.18629.70341.stgit@manet.1015granger.net>
 <20171204191338.18629.29071.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171204191338.18629.29071.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

On 12/04/2017 02:13 PM, Chuck Lever wrote:
> Helen Chao <helen.chao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> noticed that when a user
> traverses a referral on an NFS/RDMA mount, the resulting submount
> always uses TCP.
> 
> This behavior does not match the vers= setting when traversing
> a referral (vers=4.1 is preserved). It also does not match the
> behavior of crossing from the pseudofs into a real filesystem
> (proto=rdma is preserved in that case).
> 
> The Linux NFS client does not currently support the
> fs_locations_info attribute. The situation is similar for all
> NFSv4 servers I know of. Therefore until the community has broad
> support for fs_locations_info, when following a referral:
> 
>  - First try to connect with RPC-over-RDMA. This will fail quickly
>    if the client has no RDMA-capable interfaces.
> 
>  - If connecting with RPC-over-RDMA fails, or the RPC-over-RDMA
>    transport is not available, use TCP.

Won't this have the opposite problem if the client and server have RDMA interfaces, but are currently mounted over TCP instead?

Anna

> 
> Reported-by: Helen Chao <helen.chao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nfs/nfs4client.c    |   23 ++++++++++++++++++++---
>  fs/nfs/nfs4namespace.c |    2 --
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
> index 12bbab0..a3d5592 100644
> --- a/fs/nfs/nfs4client.c
> +++ b/fs/nfs/nfs4client.c
> @@ -1114,19 +1114,36 @@ struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
>  	/* Initialise the client representation from the parent server */
>  	nfs_server_copy_userdata(server, parent_server);
>  
> -	/* Get a client representation.
> -	 * Note: NFSv4 always uses TCP, */
> +	/* Get a client representation */
> +#ifdef CONFIG_SUNRPC_XPRT_RDMA
> +	rpc_set_port(data->addr, NFS_RDMA_PORT);
>  	error = nfs4_set_client(server, data->hostname,
>  				data->addr,
>  				data->addrlen,
>  				parent_client->cl_ipaddr,
> -				rpc_protocol(parent_server->client),
> +				XPRT_TRANSPORT_RDMA,
> +				parent_server->client->cl_timeout,
> +				parent_client->cl_mvops->minor_version,
> +				parent_client->cl_net);
> +	if (!error)
> +		goto init_server;
> +#endif	/* CONFIG_SUNRPC_XPRT_RDMA */
> +
> +	rpc_set_port(data->addr, NFS_PORT);
> +	error = nfs4_set_client(server, data->hostname,
> +				data->addr,
> +				data->addrlen,
> +				parent_client->cl_ipaddr,
> +				XPRT_TRANSPORT_TCP,
>  				parent_server->client->cl_timeout,
>  				parent_client->cl_mvops->minor_version,
>  				parent_client->cl_net);
>  	if (error < 0)
>  		goto error;
>  
> +#ifdef CONFIG_SUNRPC_XPRT_RDMA
> +init_server:
> +#endif
>  	error = nfs_init_server_rpcclient(server, parent_server->client->cl_timeout, data->authflavor);
>  	if (error < 0)
>  		goto error;
> diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
> index 8c3f327..24f06dc 100644
> --- a/fs/nfs/nfs4namespace.c
> +++ b/fs/nfs/nfs4namespace.c
> @@ -270,8 +270,6 @@ static struct vfsmount *try_location(struct nfs_clone_mount *mountdata,
>  		if (mountdata->addrlen == 0)
>  			continue;
>  
> -		rpc_set_port(mountdata->addr, NFS_PORT);
> -
>  		memcpy(page2, buf->data, buf->len);
>  		page2[buf->len] = '\0';
>  		mountdata->hostname = page2;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
