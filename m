From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Wed, 11 Jan 2012 19:30:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373256757DB@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111856160.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marcel Apfelbaum <marcela-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -213,12 +213,18 @@ static ssize_t rate_show(struct ib_port *p, struct
> port_attribute *unused,
>  	}
> 
>  	rate *= ib_width_enum_to_int(attr.active_width);
> +
>  	if (rate < 0)
>  		return -EINVAL;
> 
> -	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
> -		       rate, (attr.active_speed == IB_SPEED_SDR) ? ".5" : "",
> -		       ib_width_enum_to_int(attr.active_width), speed);
> +	if (attr.active_speed == IB_SPEED_SDR) {
> +		rate = (25 * ib_width_enum_to_int(attr.active_width)) / 10;
> +		return sprintf(buf, "%d%s Gb/sec (%dX%s)\n", rate,
> +			       (attr.active_width == IB_WIDTH_1X) ? ".5" : "",
> +				ib_width_enum_to_int(attr.active_width), speed);
> +	} else
> +		return sprintf(buf, "%d Gb/sec (%dX%s)\n",
> +		       rate, ib_width_enum_to_int(attr.active_width), speed);
>  }

This function ends up like this, with my comments inline:

	rate = (25 * attr.active_speed) / 10;
We set rate here, but...

	switch (attr.active_speed) {
	case 2:
		speed = " DDR";
		break;
	case 4:
		speed = " QDR";
		break;
	case 8:
		speed = " FDR10";
		rate = 10;
		break;
	case 16:
		speed = " FDR";
		rate = 14;
		break;
	case 32:
		speed = " EDR";
		rate = 25;
		break;
	}
The above switch statement changes the value for 3 of the 5 cases, with 1 case not covered.

	rate *= ib_width_enum_to_int(attr.active_width);
It is modified again here

	if (rate < 0)
		return -EINVAL;

	if (attr.active_speed == IB_SPEED_SDR) {
		rate = (25 * ib_width_enum_to_int(attr.active_width)) / 10;
And we override it in this case, which is the missing switch case.

		return sprintf(buf, "%d%s Gb/sec (%dX%s)\n", rate,
			       (attr.active_width == IB_WIDTH_1X) ? ".5" : "",
				ib_width_enum_to_int(attr.active_width), speed);
	} else
		return sprintf(buf, "%d Gb/sec (%dX%s)\n",
		       rate, ib_width_enum_to_int(attr.active_width), speed);

How about just setting rate (possibly as a string value) one time in each switch case?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
