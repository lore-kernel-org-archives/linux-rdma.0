From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 07/16] ib/mad: create a jumbo MAD kmem_cache
Date: Fri, 5 Dec 2014 21:25:18 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBD3CC3@CRSMSX101.amr.corp.intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <1415908465-24392-8-git-send-email-ira.weiny@intel.com>
 <54770FF4.3070807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54770FF4.3070807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 11/13/2014 9:54 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > @@ -773,7 +782,12 @@ static int handle_outgoing_dr_smp(struct
> ib_mad_agent_private *mad_agent_priv,
> >   	}
> >   	local->mad_priv = NULL;
> >   	local->recv_mad_agent = NULL;
> > -	mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
> > +
> > +	if (mad_agent_priv->qp_info->supports_jumbo_mads)
> > +		mad_priv = kmem_cache_alloc(jumbo_mad_cache,
> GFP_ATOMIC);
> > +	else
> > +		mad_priv = kmem_cache_alloc(ib_mad_cache, GFP_ATOMIC);
> > +
> @ minimum (if you really think that one kmem cache for both jumbo and non-
> jumbo mads isn't the way to get) lets have one pointer that is directed to the
> cache you want to use and this way all branch as the above one and it's such
> can be avoided, right?

That is a good idea, however, I'm going to address your other comments before changing anything here.

-- Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
