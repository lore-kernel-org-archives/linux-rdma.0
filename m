From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Add a rate based mechanism for SMP
 transactions
Date: Wed, 9 Jun 2010 17:22:39 +0300
Message-ID: <20100609142239.GG20172@me>
References: <20100607124057.GA2060@comcast.net>
 <20100609060515.GL28549@me>
 <AANLkTimE6n2e6z1pUXQPmqX5GrdLVl2kp7bbPipDfhy2@mail.gmail.com>
 <20100609122905.GD20172@me>
 <AANLkTin1X450bG2WvV7y8wanYSBH4JyNgNiCsj2iugL8@mail.gmail.com>
 <20100609140545.GF20172@me>
 <AANLkTinOqJRYEev6Iz0EJyuAN_N8bP1OcSEFMprMkY4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinOqJRYEev6Iz0EJyuAN_N8bP1OcSEFMprMkY4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:14 Wed 09 Jun     , Hal Rosenstock wrote:
> >>
> >> The default in the proposed patch is that this mechanism is disabled.
> >> Are you saying to change this to have it enabled with a default
> >> timeout ?
> >
> > No, meaning that the default case is both limits are equivalent.
> 
> Equivalent in what way ?

By value.

> 
> > The timeout is less matter in this case.
> 
> So 3 configurables rather than 2 ? max_wire_timeout_smps (for the
> second limit), max_wire_timeout (along the lines of what you propose),
> and mechanism enable/disable (default disabled).

maxsmps (already exists)
maxsmps2 (default - = maxsmps, so the mechanism is disabled)
maxsmps_timeout (optional for both disable/enable cases)

Something like this... Maybe with better names :)

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
