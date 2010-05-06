From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/scripts/ibcheckerrs.in: emulate all
 ports if necessary.
Date: Thu, 6 May 2010 09:18:29 -0700
Message-ID: <20100506091829.dd275edf.weiny2@llnl.gov>
References: <20100505194720.6f9d434c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100505194720.6f9d434c.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Robert Woodruff <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Upon thinking about this a bit more, and seeing Mikes patch.  I think that the
patch which Mike sent some time ago is a better fix.  This will work fine for
ibcheckerrs.  However ibcheckerrors will run AllPortSelect and then go on to
query all the ports individually.  The patch below will cause a double read
for each port which will kill ibcheckerrors performance on a large cluster.

Sasha, what is the status of Mikes patch?

Ira

On Wed, 5 May 2010 19:47:20 -0700
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Wed, 5 May 2010 19:49:37 -0700
> Subject: [PATCH] infiniband-diags/scripts/ibcheckerrs.in: emulate all ports if necessary.
> 
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  infiniband-diags/scripts/ibcheckerrs.in |    2 +-
>  infiniband-diags/src/perfquery.c        |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/infiniband-diags/scripts/ibcheckerrs.in b/infiniband-diags/scripts/ibcheckerrs.in
> index 305379a..f4eb451 100644
> --- a/infiniband-diags/scripts/ibcheckerrs.in
> +++ b/infiniband-diags/scripts/ibcheckerrs.in
> @@ -153,7 +153,7 @@ fi
>  
>  nodename=`$IBPATH/smpquery $ca_info nodedesc $lid | sed -e "s/^Node Description:\.*\(.*\)/\1/"`
>  
> -text="`eval $IBPATH/perfquery $ca_info $lid $portnum`"
> +text="`eval $IBPATH/perfquery -a $ca_info $lid $portnum`"
>  rv=$?
>  if echo "$text" | awk -v mono=$bw -v brief=$brief -F '[.:]*' '
>  function blue(s)
> diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
> index 00ebfff..5d3b606 100644
> --- a/infiniband-diags/src/perfquery.c
> +++ b/infiniband-diags/src/perfquery.c
> @@ -525,11 +525,11 @@ int main(int argc, char **argv)
>  	/* ClassPortInfo should be supported as part of libibmad */
>  	memcpy(&cap_mask, pc + 2, sizeof(cap_mask));	/* CapabilityMask */
>  	cap_mask = ntohs(cap_mask);
> -	if (!(cap_mask & 0x100)) {	/* bit 8 is AllPortSelect */
> -		if (!all_ports && port == ALL_PORTS)
> -			IBERROR("AllPortSelect not supported");
> +	if (port == ALL_PORTS && !(cap_mask & 0x100)) {	/* bit 8 is AllPortSelect */
>  		if (all_ports)
>  			all_ports_loop = 1;
> +		else
> +			IBERROR("AllPortSelect not supported");
>  	}
>  
>  	if (xmt_sl) {
> -- 
> 1.5.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> 


-- 
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
