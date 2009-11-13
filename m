From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] opensm/main.c: opensm cannot be killed while
 asking for port guid
Date: Fri, 13 Nov 2009 04:55:27 +0200
Message-ID: <20091113025527.GE7192@me>
References: <4AF46DEB.7090105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF46DEB.7090105-sJ/iWh9BUns@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sammy Wilborn <samm-sJ/iWh9BUns@public.gmane.org>, Jeremy Higdon <jeremy-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:41 Fri 06 Nov     , Michael Reed wrote:
> opensm enters an uninterruptible loop when the user enters
> "-g 0" on the command line.  The only way to kill opensm is to
> background the process and send "kill -9".

The reason is that the port chooser is running in code section where all
signals are blocked. Which is bad in general, but resulted by not
perfect opensm/vendor/complid inter dependencies: sub threads are
activated (complib_init(), osm_opensm_init(), osm_opensm_bind()) with
blocked signals. The port chooser should run in the middle of this chain
after opensm vendor initialization (osm_opensm_init()), but before opensm
vendor binding (osm_opensm_bind()) - it requires a GUID value.

I don't immediately know how to improve this without significant
complib/vendor/opensm interfaces changing.

> This patch provides the user an out in get_port_guid() by
> introducing "0" as a valid selection.  This patch also changes
> the "Lame choice!" error message to something a bit more, uh,
> "professional". main() is modified to test the return code.
> This was probably a bug as a return of 0 is returned under a
> number of different circumstances by get_port_guid().
> 
> Applies to 1.15 RC2.

Please next time generate patch against the current master branch.

> Signed-off-by: Michael Reed <mdr-sJ/iWh9BUns@public.gmane.org>

Applied with minor change (see below). Thanks.

> 
> 
> --- /tmp/OFED-1.5-rc2/main.c	2009-11-06 08:56:59.089100487 -0800
> +++ opensm/main.c	2009-11-06 09:42:34.698963811 -0800
> @@ -434,15 +434,19 @@ static ib_net64_t get_port_guid(IN osm_o
>  			       i + 1, cl_ntoh64(attr_array[i].port_guid),
>  			       attr_array[i].lid,
>  			       ib_get_port_state_str(attr_array[i].link_state));
> -		printf("\nEnter choice (1-%u): ", i);
> +		printf("\n\t0: Exit\n");
> +		printf("\nEnter choice (0-%u): ", i);
>  		fflush(stdout);
>  		if (scanf("%u", &choice) <= 0) {
>  			char junk[128];
>  			if (scanf("%s", junk) <= 0)
>  				printf("\nError: Cannot scan!\n");
> -		} else if (choice && choice <= num_ports)
> +		}
> +		else if (choice == 0)
> +			return (0);
> +		else if (choice <= num_ports)
>  			break;
> -		printf("\nError: Lame choice!\n");
> +		printf("\nError: Please try again.\n");

"Try again" is good, but it is useful to provide a reason too, so let's
do it even more "professional":

	printf("\nError: Lame choice! Please try again.\n");

Sasha

>  	}
>  	choice--;
>  	printf("Choice guid=0x%" PRIx64 "\n",
> @@ -1039,6 +1043,9 @@ int main(int argc, char *argv[])
>  	if (opt.guid == 0 || cl_hton64(opt.guid) == CL_HTON64(INVALID_GUID))
>  		opt.guid = get_port_guid(&osm, opt.guid);
>  
> +	if (opt.guid == 0)
> +		goto Exit;
> +
>  	status = osm_opensm_bind(&osm, opt.guid);
>  	if (status != IB_SUCCESS) {
>  		printf("\nError from osm_opensm_bind (0x%X)\n", status);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
