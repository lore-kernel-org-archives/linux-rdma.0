From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 5/6] ibtracert.c: Uninitialized
 variable
Date: Wed, 12 Jun 2013 14:31:14 -0700
Message-ID: <20130612143114.cb1ec063664802418c609202@intel.com>
References: <51B87DE4.3040707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87DE4.3040707-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 12 Jun 2013 09:55:48 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Thanks applied!
Ira

> 
> Reading from uninitialized variable
> 
> Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/ibtracert.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/src/ibtracert.c b/src/ibtracert.c
> index cc0ac98..9699ccc 100644
> --- a/src/ibtracert.c
> +++ b/src/ibtracert.c
> @@ -250,6 +250,13 @@ static int find_route(ib_portid_t * from, ib_portid_t * to, int dump)
>  	int maxhops = MAXHOPS;
>  	int portnum, outport;
>  
> +	memset(&fromnode,0,sizeof(Node));
> +	memset(&tonode,0,sizeof(Node));
> +	memset(&nextnode,0,sizeof(Node));
> +	memset(&fromport,0,sizeof(Port));
> +	memset(&toport,0,sizeof(Port));
> +	memset(&nextport,0,sizeof(Port));
> +
>  	DEBUG("from %s", portid2str(from));
>  
>  	if (get_node(&fromnode, &fromport, from) < 0 ||
> -- 
> 1.7.8.2
> 


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
