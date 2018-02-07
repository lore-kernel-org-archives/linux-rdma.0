From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 2/2] smpdump.c: Print number of bytes returned by umad_recv
Date: Wed, 7 Feb 2018 00:35:16 -0500
Message-ID: <20180207053515.GC25132@phlsvsds.ph.intel.com>
References: <499f1d77-7da6-2c00-e826-bf4d0809f48a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <499f1d77-7da6-2c00-e826-bf4d0809f48a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 09:57:23AM -0500, Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/smpdump.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/smpdump.c b/src/smpdump.c
> index bc8559a..bb304d4 100644
> --- a/src/smpdump.c
> +++ b/src/smpdump.c
> @@ -281,6 +281,8 @@ int main(int argc, char *argv[])
>  	if (umad_recv(portid, umad, &length, -1) != mad_agent)
>  		IBPANIC("recv error: %s", strerror(errno));
>  
> +	printf("%d bytes received\n", length);

This seems like it is more for debugging.

How will this affect any scripts which include this command?  Should we make
this debug output?

Ira


> +
>  	if (!dump_char) {
>  		xdump(stdout, 0, smp->data, 64);
>  		if (smp->status)
> -- 
> 2.8.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
