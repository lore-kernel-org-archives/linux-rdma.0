From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 9 Jun 2010 09:02:09 -0400
Message-ID: <AANLkTin1X450bG2WvV7y8wanYSBH4JyNgNiCsj2iugL8@mail.gmail.com>
References: <20100607124057.GA2060@comcast.net>
	<20100609060515.GL28549@me>
	<AANLkTimE6n2e6z1pUXQPmqX5GrdLVl2kp7bbPipDfhy2@mail.gmail.com>
	<20100609122905.GD20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609122905.GD20172@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 9, 2010 at 8:29 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 06:27 Wed 09 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> Hi Sasha,
>>
>> On Wed, Jun 9, 2010 at 2:05 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> > Hi Hal,
>> >
>> > On 08:40 Mon 07 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> In order to better handle non responsive SMAs (when link is physi=
cally up
>> >> but the SMA does not respond), a rate based mechanism for SMPs is=
 added
>> >> to better enable forward progress in a more timely fashion. So ra=
ther than
>> >> wait for timeouts and outstanding wire SMPs to drop below some co=
nfigured
>> >> value, there is also a periodic rate for transaction based SMPs. =
These
>> >> rate based SMPs are capped at a configured maximum value.
>> >>
>> >> Two new options are added for this:
>> >> rate_based_smp_usecs indicates the number of microseconds between=
 rate
>> >> based SMPs.
>> >> max_rate_based_smps indicates the maximum number of rate based SM=
Ps
>> >> supported. When this limit is reached, rate based SMPs are no lon=
ger
>> >> sent (until the number of outstanding ones drops below this limit=
).
>> >>
>> >> The rate based SMP mechanism can be disabled by setting rate_base=
d_smp_usecs
>> >> to 0. This is equivalent to the (current) algorithm prior to this=
 change.
>> >>
>> >> By default, this mechanism is disabled.
>> >
>> > I would strongly suggest to rework the terminology here to make th=
ings
>> > clearer.
>> >
>> > Actually we don't have here any "rate based" SMPs,
>>
>> Doesn't the timeout value pace the second limit of SMPs ? If so, in =
my
>> mind, that is rate based.
>
> All those SMPs are equivalent in processing, etc., the only differenc=
e
> is in MADs injection mechanism.

And that difference in the MAD injection mechanism is rate based.

> So trying to differentiate MADs itself seems confused for me.

I'm still not following why you say this.

>
>> > but instead two mad
>> > injection limits (regular and timedout) and timeout value (which B=
TW
>> > likely should be a function of --timeout parameter). Isn't it?
>>
>> The separate timeout for this provides finer control over pacing the
>> higher SMP limit rather than basing it on the transaction timeout. I=
f
>> it is a function of the transaction timeout as you propose above, is
>> there admin control over it ? If there is, then there is another
>> config param to express this anyhow.
>
> No problem to have this configurable for finer control, but in case
> when requested smps_on_wire_limit_low < smps_on_wire_limit_high we co=
uld
> want to have some reasonable default value for the timeout.

The default in the proposed patch is that this mechanism is disabled.
Are you saying to change this to have it enabled with a default
timeout ? I think it's better to leave the default disabled so the
default is to behave same as today.

-- Hal

>> If there isn't, then what hard
>> coded function do you think is appropriate ?
>
> timeout * retries ?
>
> Sasha
>
>>
>> -- Hal
>>
>> > Sasha
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
