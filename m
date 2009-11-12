From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM: reporting traps 129, 130, 131
Date: Thu, 12 Nov 2009 11:38:51 -0500
Message-ID: <f0e08f230911120838w2f824a4dnc6b51a68b25bbffd@mail.gmail.com>
References: <4AF6D78E.6080600@dev.mellanox.co.il>
	 <f0e08f230911120546q5aa0ed72oc6811cbd2471bc44@mail.gmail.com>
	 <20091112154213.GH7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091112154213.GH7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2009 at 10:42 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 08:46 Thu 12 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >
>> > Any particular reason why there's no reporting of these traps?
>>
>> AFAIK it's been this way for at least the last 5 or 6 years.
>
> Yes, this is what I found too tracking down git/svn history.
>
>> A practical consideration in changing this is that these traps are t=
he
>> ones for which babbling port was implemented since they do not obey
>> the trap rate so there's a large downside to adding the reports for
>> these. If that is to be done, then perhaps this should be done based
>> on some option.
>
> I don't think that we need new option for this, instead we should car=
e
> that OpenSM is not overloaded by such trap floods.

We've cared for several years now (babbling port policy was introduced
into the master on 7/6/09) but this issue still persists. Are you
saying no reports for these traps until the trap rate is obeyed ?

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
