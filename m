From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
 revert setting of init failure on QoS initialization failures
Date: Wed, 30 Dec 2009 21:37:01 +0200
Message-ID: <20091230193701.GA26940@me>
References: <20091224112036.GA32559@comcast.net>
 <20091224125601.GK26940@me>
 <f0e08f230912280808s31c09d46ndeb3586007507e40@mail.gmail.com>
 <20091229145411.GT26940@me>
 <f0e08f230912300814h1c6ad213j2b8a343403e2744e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912300814h1c6ad213j2b8a343403e2744e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:14 Wed 30 Dec     , Hal Rosenstock wrote:
> >> > '--resweep-on-failed-attr=11,15' (with reasonable default) will be more
> >> > useful for dealing with this and maybe another potential issues.
> >>
> >> Where else do you see this as being useful ?
> >
> > In this case at least. I had some questions in the past about how
> > to ignore some sort of initialization errors.
> 
> What (other) initialization errors should be ignored ? Isn't this
> dangerous and slippery slope ?

This is what we have now:

	    (p_smp->attr_id == IB_MAD_ATTR_PORT_INFO ||
	     p_smp->attr_id == IB_MAD_ATTR_MCAST_FWD_TBL ||
	     p_smp->attr_id == IB_MAD_ATTR_SWITCH_INFO ||
	     p_smp->attr_id == IB_MAD_ATTR_LIN_FWD_TBL ||
	     p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE)) {
		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3119: "
			"Set method failed for attribute 0x%X (%s)\n",
			cl_ntoh16(p_smp->attr_id),
			ib_get_sm_attr_str(p_smp->attr_id));
		p_ctrl->p_subn->subnet_initialization_error = TRUE;
	}

Of course ignoring an errors can be dangerous, and useful for debugging
and sometimes to workaround buggy hardware issues.

> > Another potential use is
> > to extended this to SubnGet() responses errors handling too when
> > requested.
> 
> That would require additional changes beyond what is being discussed
> here and might not come from the same attribute list so it's unclear
> to me whether or not this is related (in terms of configuration).

Correct, it would be yet another addition, but in the same direction.
You can see this as not immediately related to the change in discussion.

> > Anyway it is better than introducing '--qos-init-error',
> > ('--pkey-init-error', etc.) and not much harder to implement.
> 
> Sure; the question was it's necessity and not it's implementation "difficulty.

Whole point was to not introduce a new options like
"--workaround-buggy-feature-X". But instead in cases when a quirks
avoidance is impossible at least to make it in more generic fashion
potentially useful for another things too.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
