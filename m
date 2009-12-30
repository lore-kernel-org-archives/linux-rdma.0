From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
	revert setting of init failure on QoS initialization failures
Date: Wed, 30 Dec 2009 11:14:15 -0500
Message-ID: <f0e08f230912300814h1c6ad213j2b8a343403e2744e@mail.gmail.com>
References: <20091224112036.GA32559@comcast.net> <20091224125601.GK26940@me>
	 <f0e08f230912280808s31c09d46ndeb3586007507e40@mail.gmail.com>
	 <20091229145411.GT26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091229145411.GT26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2009 at 9:54 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:08 Mon 28 Dec =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> A subsequent patch will reintroduce this checking based on an add=
itional
>> >> option which will default to not do this.
>> >
>> > I think that addition of such sort of options (eg "--workaround-bu=
gX")
>> > should be avoided unless it is absolutely necessary.
>>
>> I was thinking something like --qos-init-error with a description.
>>
>> > And even then more generic stuff would be better.
>> >
>> > In this specific case more generic option like:
>> > '--resweep-on-failed-attr=3D11,15' (with reasonable default) will =
be more
>> > useful for dealing with this and maybe another potential issues.
>>
>> Where else do you see this as being useful ?
>
> In this case at least. I had some questions in the past about how
> to ignore some sort of initialization errors.

What (other) initialization errors should be ignored ? Isn't this
dangerous and slippery slope ?

> Another potential use is
> to extended this to SubnGet() responses errors handling too when
> requested.

That would require additional changes beyond what is being discussed
here and might not come from the same attribute list so it's unclear
to me whether or not this is related (in terms of configuration).

>> Is such flexibility really needed or is this more "just in case" ?
>
> See above.

> Anyway it is better than introducing '--qos-init-error',
> ('--pkey-init-error', etc.) and not much harder to implement.

Sure; the question was it's necessity and not it's implementation "diff=
iculty.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
