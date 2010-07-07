From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 01/17] opensm: Prepare for routing engine input to
 path record SL lookup and SL2VL map setup.
Date: Thu, 8 Jul 2010 00:03:42 +0300
Message-ID: <20100707210342.GO22860@me>
References: <1276631604-29230-1-git-send-email-jaschut@sandia.gov>
 <1276631604-29230-2-git-send-email-jaschut@sandia.gov>
 <20100707170630.GN22860@me>
 <1278525460.4812.22.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1278525460.4812.22.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:57 Wed 07 Jul     , Jim Schutt wrote:
>    
> So I think the end of the above chunk only needs to be
> 
> -
> -	str = strdup(engine_names);
> -	name = strtok_r(str, ", \t\n", &p);
> -	while (name && *name) {
> -		setup_routing_engine(osm, name);
> -		name = strtok_r(NULL, ", \t\n", &p);
> - 	}
> +	if (!osm->default_routing_engine)
> +		setup_routing_engine(osm, "minhop");

This makes sense. Don't need to resubmit the patch, I will fix.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
