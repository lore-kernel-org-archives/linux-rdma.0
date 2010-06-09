From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 9 Jun 2010 06:27:21 -0400
Message-ID: <AANLkTimE6n2e6z1pUXQPmqX5GrdLVl2kp7bbPipDfhy2@mail.gmail.com>
References: <20100607124057.GA2060@comcast.net>
	<20100609060515.GL28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100609060515.GL28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Wed, Jun 9, 2010 at 2:05 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> Hi Hal,
>
> On 08:40 Mon 07 Jun =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> In order to better handle non responsive SMAs (when link is physical=
ly up
>> but the SMA does not respond), a rate based mechanism for SMPs is ad=
ded
>> to better enable forward progress in a more timely fashion. So rathe=
r than
>> wait for timeouts and outstanding wire SMPs to drop below some confi=
gured
>> value, there is also a periodic rate for transaction based SMPs. The=
se
>> rate based SMPs are capped at a configured maximum value.
>>
>> Two new options are added for this:
>> rate_based_smp_usecs indicates the number of microseconds between ra=
te
>> based SMPs.
>> max_rate_based_smps indicates the maximum number of rate based SMPs
>> supported. When this limit is reached, rate based SMPs are no longer
>> sent (until the number of outstanding ones drops below this limit).
>>
>> The rate based SMP mechanism can be disabled by setting rate_based_s=
mp_usecs
>> to 0. This is equivalent to the (current) algorithm prior to this ch=
ange.
>>
>> By default, this mechanism is disabled.
>
> I would strongly suggest to rework the terminology here to make thing=
s
> clearer.
>
> Actually we don't have here any "rate based" SMPs,

Doesn't the timeout value pace the second limit of SMPs ? If so, in my
mind, that is rate based.

> but instead two mad
> injection limits (regular and timedout) and timeout value (which BTW
> likely should be a function of --timeout parameter). Isn't it?

The separate timeout for this provides finer control over pacing the
higher SMP limit rather than basing it on the transaction timeout. If
it is a function of the transaction timeout as you propose above, is
there admin control over it ? If there is, then there is another
config param to express this anyhow. If there isn't, then what hard
coded function do you think is appropriate ?

-- Hal

> Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
