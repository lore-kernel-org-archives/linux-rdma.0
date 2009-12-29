From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
 revert setting of init failure on QoS initialization failures
Date: Tue, 29 Dec 2009 16:54:11 +0200
Message-ID: <20091229145411.GT26940@me>
References: <20091224112036.GA32559@comcast.net>
 <20091224125601.GK26940@me>
 <f0e08f230912280808s31c09d46ndeb3586007507e40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230912280808s31c09d46ndeb3586007507e40-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11:08 Mon 28 Dec     , Hal Rosenstock wrote:
> >>
> >> A subsequent patch will reintroduce this checking based on an additional
> >> option which will default to not do this.
> >
> > I think that addition of such sort of options (eg "--workaround-bugX")
> > should be avoided unless it is absolutely necessary.
> 
> I was thinking something like --qos-init-error with a description.
> 
> > And even then more generic stuff would be better.
> >
> > In this specific case more generic option like:
> > '--resweep-on-failed-attr=11,15' (with reasonable default) will be more
> > useful for dealing with this and maybe another potential issues.
> 
> Where else do you see this as being useful ?

In this case at least. I had some questions in the past about how
to ignore some sort of initialization errors. Another potential use is
to extended this to SubnGet() responses errors handling too when
requested.

> Is such flexibility really needed or is this more "just in case" ?

See above. Anyway it is better than introducing '--qos-init-error',
('--pkey-init-error', etc.) and not much harder to implement.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
