From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libdmacm/rspreload: Avoid rsocket calls until after fork
Date: Sun, 26 Aug 2012 07:20:15 +0300
Message-ID: <5039A3FF.7060308@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A8AB32@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8AB32-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 23/08/2012 21:51, Hefty, Sean wrote:
> When an rsocket call is made before an application calls fork(),
> the forked applications can hang.  This can be seen by running
> netserver and two netperf clients simultaneously.  The second
> netperf client will eventually stop performing data transfers.
>
> LD_PRELOAD=librspreload.so netserver -D
>
> LD_PRELOAD=librspreload.so netperf -v2 -c -C -H 192.168.0.101 -l30
> LD_PRELOAD=librspreload.so netperf -v2 -c -C -H 192.168.0.101 -l30
>
> It's not clear what the specific problem is.  The best guess is
> that libibverbs or the provider library (e.g. libmlx4) perform
> some initialization, such as mmap'ing device memory, which does not
> work when fork is called.

Yishai,

I think you pointed me to that problem the other day, do you have a 
patch to fix that?

Or.

>
> As a work-around, avoid calling rsocket routines until immediately
> before they are needed.  This allows the process to fork before
> the libraries are initialized.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   src/preload.c |   21 +++++++++++----------
>   1 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/src/preload.c b/src/preload.c
> index 0645f6d..4ba38f5 100644
> --- a/src/preload.c
> +++ b/src/preload.c
> @@ -412,20 +412,21 @@ int socket(int domain, int type, int protocol)
>   	if (index < 0)
>   		return index;
>   
> +	if (fork_support && (domain == PF_INET || domain == PF_INET6) &&
> +	    (type == SOCK_STREAM) && (!protocol || protocol == IPPROTO_TCP)) {
> +		ret = real.socket(domain, type, protocol);
> +		if (ret < 0)
> +			return ret;
> +		fd_store(index, ret, fd_normal, fd_fork);
> +		return index;
> +	}
> +
>   	recursive = 1;
>   	ret = rsocket(domain, type, protocol);
>   	recursive = 0;
>   	if (ret >= 0) {
> -		if (fork_support) {
> -			rclose(ret);
> -			ret = real.socket(domain, type, protocol);
> -			if (ret < 0)
> -				return ret;
> -			fd_store(index, ret, fd_normal, fd_fork);
> -		} else {
> -			fd_store(index, ret, fd_rsocket, fd_ready);
> -			set_rsocket_options(ret);
> -		}
> +		fd_store(index, ret, fd_rsocket, fd_ready);
> +		set_rsocket_options(ret);
>   		return index;
>   	}
>   	fd_close(index, &ret);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
