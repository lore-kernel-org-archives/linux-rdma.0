From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Tue, 31 Aug 2010 11:15:43 -0400
Message-ID: <AANLkTikXY_xS4EPn39epwNSFrkGqvMP5WV9_JDTVO5vg@mail.gmail.com>
References: <4C6B9A42.9020505@voltaire.com>
	<20100824040354.GH5837@me>
	<4C73B34A.4080508@voltaire.com>
	<AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>
	<4C73C8BC.6010702@voltaire.com>
	<AANLkTime9OX4EPS_c+pKwnchuVfyLqeLcuX0rXDjOCgR@mail.gmail.com>
	<20100825170656.GM5837@me>
	<4C7D0F46.1030305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7D0F46.1030305-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 31, 2010 at 10:18 AM, Eli Dorfman (Voltaire)
<dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Sasha Khapyorsky wrote:
>> On 09:45 Tue 24 Aug =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>>> What about the flag? do we still need it if we pass the output aft=
er the comment?
>>> I wouldn't think so. I also think we've made commentary changes to =
the
>>> ibnetdiscover output format like this before. If we wanted to be
>>> absolutely sure it wouldn't break anything, we'd keep the flag thou=
gh.
>>> It's up to Sasha.
>>
>> The '-f' flag could make sense since those information actually
>> duplicates previous 4xDDR, etc. and used by ibsim's parser only.
>>
>> Also it would be nice to make ibsim's parser to understand both
>> possibilities: s=3D2 and speed=3D2 (Or even to parse "*x*DR" strings=
 :))
>
> Is it valid to assume that "*x*DR" string is always the last token?

Not always but for most cases (other than Xsigo devices).

-- Hal

> If so, the patch should be changed
>
> Eli
>>
>> Sasha
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
