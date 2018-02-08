From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2 infiniband-diags] smpdump.c: Print number of bytes returned by umad_recv
Date: Thu, 8 Feb 2018 01:20:40 -0500
Message-ID: <20180208062039.GA16888@phlsvsds.ph.intel.com>
References: <c0e1648e-06cc-9c79-05f7-4fc06dd3617a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c0e1648e-06cc-9c79-05f7-4fc06dd3617a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 07, 2018 at 12:05:40PM -0500, Hal Rosenstock wrote:
> 
> when debug is set
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Change from v1:
> Only print when debug is set
> 
>  src/smpdump.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/src/smpdump.c b/src/smpdump.c
> index bc8559a..efc522f 100644
> --- a/src/smpdump.c
> +++ b/src/smpdump.c
> @@ -281,6 +281,9 @@ int main(int argc, char *argv[])
>  	if (umad_recv(portid, umad, &length, -1) != mad_agent)
>  		IBPANIC("recv error: %s", strerror(errno));
>  
> +	if (ibdebug)
> +		fprintf(stdout, "%d bytes received\n", length);

To match the other debug output I changed this to stderr.

Applied thanks,
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
