From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Tue, 4 Oct 2011 15:14:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E692EE@ORSMSX101.amr.corp.intel.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
 <201110041427.23819.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110041427.23819.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -186,16 +187,30 @@ static ssize_t rate_show(struct ib_port
>  		return ret;
> 
>  	switch (attr.active_speed) {
> -	case 2: speed = " DDR"; break;
> -	case 4: speed = " QDR"; break;
> +	case 2:
> +		speed = " DDR";
> +		break;
> +	case 4:
> +		speed = " QDR";
> +		break;
> +	case 8:
> +		speed = " FDR10";
> +		break;
> +	case 16:
> +		speed = " FDR";
> +		break;
> +	case 32:
> +		speed = " EDR";
> +		break;
>  	}

We're already switching on attr.active speed above.  We should just merge ib_active_speed_to_rate() into this function, so we can avoid dealing with its 'rate_rounded' parameter as well.

> 
> -	rate = 25 * ib_width_enum_to_int(attr.active_width) * attr.active_speed;
> +	rate = ib_width_enum_to_int(attr.active_width) *
> +	       ib_active_speed_to_rate(attr.active_speed, &rate_rounded);
>  	if (rate < 0)
>  		return -EINVAL;
> 
>  	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
> -		       rate / 10, rate % 10 ? ".5" : "",
> +		       rate, rate_rounded ? ".5" : "",
>  		       ib_width_enum_to_int(attr.active_width), speed);
>  }

Thanks,
Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
