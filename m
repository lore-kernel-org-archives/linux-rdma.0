From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Add a rate based mechanism for SMP
 transactions
Date: Wed, 9 Jun 2010 17:05:45 +0300
Message-ID: <20100609140545.GF20172@me>
References: <20100607124057.GA2060@comcast.net>
 <20100609060515.GL28549@me>
 <AANLkTimE6n2e6z1pUXQPmqX5GrdLVl2kp7bbPipDfhy2@mail.gmail.com>
 <20100609122905.GD20172@me>
 <AANLkTin1X450bG2WvV7y8wanYSBH4JyNgNiCsj2iugL8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTin1X450bG2WvV7y8wanYSBH4JyNgNiCsj2iugL8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:02 Wed 09 Jun     , Hal Rosenstock wrote:
> >
> > All those SMPs are equivalent in processing, etc., the only difference
> > is in MADs injection mechanism.
> 
> And that difference in the MAD injection mechanism is rate based.

IMHO it is not "rate based", but rather timeout driven.

> 
> > So trying to differentiate MADs itself seems confused for me.
> 
> I'm still not following why you say this.
> 
> >
> >> > but instead two mad
> >> > injection limits (regular and timedout) and timeout value (which BTW
> >> > likely should be a function of --timeout parameter). Isn't it?
> >>
> >> The separate timeout for this provides finer control over pacing the
> >> higher SMP limit rather than basing it on the transaction timeout. If
> >> it is a function of the transaction timeout as you propose above, is
> >> there admin control over it ? If there is, then there is another
> >> config param to express this anyhow.
> >
> > No problem to have this configurable for finer control, but in case
> > when requested smps_on_wire_limit_low < smps_on_wire_limit_high we could
> > want to have some reasonable default value for the timeout.
> 
> The default in the proposed patch is that this mechanism is disabled.
> Are you saying to change this to have it enabled with a default
> timeout ?

No, meaning that the default case is both limits are equivalent. The
timeout is less matter in this case.

Sasha

> I think it's better to leave the default disabled so the
> default is to behave same as today.
> 
> -- Hal
> 
> >> If there isn't, then what hard
> >> coded function do you think is appropriate ?
> >
> > timeout * retries ?
> >
> > Sasha
> >
> >>
> >> -- Hal
> >>
> >> > Sasha
> >>
> >
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
