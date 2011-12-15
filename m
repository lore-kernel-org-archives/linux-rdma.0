From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/14] ib_srp: Disallow duplicate logins
Date: Thu, 15 Dec 2011 14:08:21 -0500
Message-ID: <1323976101.16703.42.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011958.17339.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011958.17339.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 19:58 +0100, Bart Van Assche wrote:
> Currently the ib_srp driver allows to log in multiple times to the
> same target via its sysfs interface. This leads to each target LUN
> being imported multiple times at the initiator side, something that
> should not be allowed.

I'm of mixed opinion on this one. It seems like we're working around a
broken target -- we request single RDMA channel operation in our login
requests, so the standard says that the target should disconnect all
other connections for that I_T nexus when it receives a new login
request. That should keep us from having multiple instances of LUNs from
the same target over a single srp_host (HCA).

In the past, we've seen connections having issues but not going away,
and the only way to kill them was to create a new connection to the RAID
controller, which would then kill the old one. It's been a few years
since I've seen this, so the details are a bit fuzzy, but I recall the
current behavior being useful.

However, I'm not adverse to going beyond the standard if it makes sense,
and your later patch to allow disconnecting channels without removing
the module would fix the use case above. What problem are we solving
here other than a potentially confused admin?


> +	spin_lock(&host->target_lock);
> +	list_for_each_entry(t, &host->target_list, list) {
> +		WARN_ON(t == target);
> +		if (target->id_ext == t->id_ext &&
> +		    target->ioc_guid == t->ioc_guid &&
> +		    memcmp(target->orig_dgid, t->orig_dgid, 16) == 0 &&
> +		    target->path.pkey == t->path.pkey &&
> +		    target->service_id == t->service_id) {

The spec discusses the I_T nexus defined by the initiator and target
port identifiers as the unit for disambiguation when running in single
channel mode. The initiator port identifier is controlled by the port's
GUID combined with target->initiator_ext and the target port identifier
is defined by target->{id_ext,ioc_guid}.

>From the standard's perspective, why should we care about pkey, dgid (or
orig_dgid as above) or the service id? Those don't change the I_T nexus,
so the target should disconnect previous channels appropriately.


>  static ssize_t srp_create_target(struct device *dev,
>  				 struct device_attribute *attr,
>  				 const char *buf, size_t count)
> @@ -2133,6 +2161,10 @@ static ssize_t srp_create_target(struct device *dev,
>  	if (ret)
>  		goto err;
>  
> +	ret = srp_target_exists(host, target);
> +	if (ret)
> +		goto err;
> +

We need to tell the user that we didn't create a new connection because
one already exists.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
