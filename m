From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Tue, 12 Nov 2013 09:08:16 +0200
Message-ID: <5281D3E0.70203@mellanox.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF6F78@ORSMSX109.amr.corp.intel.com> <00000142485f86e5-c3027528-9892-4d5c-8d72-0ed5f98666c4-000000@email.amazonses.com> <1828884A29C6694DAF28B7E6B8A8237388CF6FD0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF6FD0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/11/2013 20:46, Hefty, Sean wrote:
> Yes - something like this patch should help, but I don't think this is the correct behavior when the IP address is 'any' addresss.
>
> Retrieve SGID after calling rdma_bind_addr
>
> From: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> A change was made to rdma_bind_addr when AF_IB is enabled
> to only retrieve the resulting bound address.  Previously,
> rdma_bind_addr would retrieve the corresponding SGID as
> well.  This breaks some apps which were checking the
> SGID after binding to an IP address.  Revert to the
> previous behavior of also retrieving the SGID after
> calling rdma_bind_addr.
> ---
>   src/cma.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/src/cma.c b/src/cma.c
> index 4f41879..0cf4203 100644
> --- a/src/cma.c
> +++ b/src/cma.c
> @@ -753,7 +753,10 @@ static int rdma_bind_addr2(struct rdma_cm_id *id, struct sockaddr *addr,
>   	if (ret != sizeof cmd)
>   		return (ret >= 0) ? ERR(ENODATA) : -1;
>   
> -	return ucma_query_addr(id);
> +	ret = ucma_query_addr(id);
> +	if (!ret)
> +		ret = ucma_query_gid(id);
> +	return ret;
>   }
>   
>   int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)

Sean, how do we continue here? the patch worked for Christoph, so are 
going to merge it into librdmacm or it needs more work?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
