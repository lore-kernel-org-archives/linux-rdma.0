From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3 v2] opensm SA DB dump/restore: added option to load
 SA DB once
Date: Sun, 13 Dec 2009 18:23:05 +0200
Message-ID: <20091213162305.GO5262@me>
References: <4AF15EBD.6010307@dev.mellanox.co.il>
 <20091126133037.GA28564@me>
 <4B1B883D.3080508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B1B883D.3080508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:32 Sun 06 Dec     , Yevgeny Kliteynik wrote:
> >> @@ -1096,7 +1106,15 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
> >>  		}
> >>  	}
> >>
> >> -	if (!rereg_clients)
> >> +	/*
> >> +	 * If restoring SA DB is required only once, SM should go
> >> +	 * into the usual mode right after that, which means that
> >> +	 * client re-registration should be required even after
> >> +	 * the restore - there is a chance that OSM died right after
> >> +	 * some MCMember joined MCast group, and his membership
> >> +	 * didn't make it into the SA DB file.
> >> +	 */
> >> +	if (!p_osm->subn.opt.sa_db_load_once && !rereg_clients)
> >>  		p_osm->subn.opt.no_clients_rereg = TRUE;
> > 
> > Hmm, if you are going to request clients reregistration unconditionally
> > then what is the reason to restore SA DB?
> > 
> > Maybe you wanted to switch this flag off *after* first sweep, but I'm
> > not sure following your comment.
> 
> We have a dump file with mcast members, and OSM is loading
> this file. Suppose OSM has successfully loaded the whole file.
> But this does not mean that there's no need to request client
> re-registration on all the hosts. Consider the following case:
>  - Heavy sweep - SM dumps current SA DB to a file
>  - Client asks to join some mcast group
>  - SM gets the request and processes it
>  - The request is OK - SM sets the 'dirty' flag and
>    responds to client
>  - Client gets the response
>  - SM dies
>  - SM is restarted - it loads the existing SA DB, which
>    does not includes the latest client's membership
>  - Loading of the whole SA DB is OK - no client re-register
>    request is issued
>  - Client remains disconnected from the mcast group

It is easy to think about such or similar scenarios. But OTOH if you
are going to request clients reregistration, why to preload SA DB?

> I want to be able to tell SM to request client re-register
> after loading the SA DB even if all was OK.

So my question is when preloading SA DB buys something for us when
clients will reregister anyway? Bugs?

> So there are 3 options to do it:
> 
> 1. Completely rely on 'no_clients_rereg' option only.
>    Do not alter this option, doesn't matter if the SA DB
>    reloading succeeded or not.
> 
> 2. Combine 'no_clients_rereg' option with loading SA DB
>    result: if loading succeeded, do whatever 'no_clients_rereg'
>    option says. If loading failed at some point, turn off
>    the 'no_clients_rereg' option (turn on re-registartion
>    requests, don't you just love the double-negative logic?)
> 
> 3. Add new option for this particular case.
> 
> I'm all for option 2, and this is what I'm implementing
> in V3 series patches.

IMHO this is better than what was proposed in the original patch. Think
that we can make it this way.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
