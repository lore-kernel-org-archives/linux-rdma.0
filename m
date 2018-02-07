From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 1/2] smpdump.c: Minor fix for when umad_recv fails
Date: Wed, 7 Feb 2018 00:29:39 -0500
Message-ID: <20180207052937.GA25132@phlsvsds.ph.intel.com>
References: <bf63fe27-d04e-140c-6ed2-61a7c719d2ee@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bf63fe27-d04e-140c-6ed2-61a7c719d2ee-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 09:57:03AM -0500, Hal Rosenstock wrote:
> 
> There is no SMP and hence no SMP in this case.
> Error displayed should be based on errno.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


Thanks applied,
Ira

> ---
>  src/smpdump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/smpdump.c b/src/smpdump.c
> index 6105ec8..bc8559a 100644
> --- a/src/smpdump.c
> +++ b/src/smpdump.c
> @@ -279,7 +279,7 @@ int main(int argc, char *argv[])
>  		IBPANIC("send failed");
>  
>  	if (umad_recv(portid, umad, &length, -1) != mad_agent)
> -		IBPANIC("recv error: %s", drmad_status_str(smp));
> +		IBPANIC("recv error: %s", strerror(errno));
>  
>  	if (!dump_char) {
>  		xdump(stdout, 0, smp->data, 64);
> -- 
> 2.8.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
