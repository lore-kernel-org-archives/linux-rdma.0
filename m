From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add configurable retries for transactions
Date: Fri, 30 Oct 2009 17:49:53 -0400
Message-ID: <f0e08f230910301449p60741d8ave796a62c35919c6e@mail.gmail.com>
References: <20091024140538.GA5213@comcast.net> <20091030025541.GU20136@me>
	 <f0e08f230910300848i3a36ceedh4472478b6f492a7d@mail.gmail.com>
	 <20091030201738.GC5829@me>
	 <f0e08f230910301351o3f81d787g5e177be10da72319@mail.gmail.com>
	 <20091030214826.GG5829@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091030214826.GG5829@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2009 at 5:48 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 16:51 Fri 30 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Fri, Oct 30, 2009 at 4:17 PM, Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
>> > On 11:48 Fri 30 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >> >> @@ -819,6 +821,13 @@ osm_vendor_bind(IN osm_vendor_t * const p=
_vend,
>> >> >> =C2=A0 =C2=A0 =C2=A0 p_bind->send_err_callback =3D send_err_ca=
llback;
>> >> >> =C2=A0 =C2=A0 =C2=A0 p_bind->p_mad_pool =3D p_mad_pool;
>> >> >> =C2=A0 =C2=A0 =C2=A0 p_bind->port_guid =3D port_guid;
>> >> >> + =C2=A0 =C2=A0 if (p_vend->timeout =3D=3D -1) {
>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->timeout =3D=
 p_user_bind->timeout;
>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->max_retrie=
s =3D p_user_bind->retries;
>> >> >> + =C2=A0 =C2=A0 } else {
>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->timeout =3D=
 p_vend->timeout;
>> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_bind->max_retrie=
s =3D p_vend->max_retries;
>> >> >> + =C2=A0 =C2=A0 }
>> >> >
>> >> > Hmm, shouldn't we respect user requested data? Something like:
>> >> >
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p_bind->timeout =3D p_user_bind->tim=
eout ? p_user_bind->timeout :
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_vend->timeout;
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p_bind->retries =3D p_user_bind->ret=
ries ? p_user_bind->retries :
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_vend->retries;
>> >> >
>> >> > ?
>> >>
>> >> The -1 is for the new ABI.
>> >
>> > Could you elaborate?
>>
>> In order to be able to deal with combinations of old/new opensm/vend=
or layer.
>
> I see, you are trying to protect old OpenSM <-> new vendor case.
>
> Such combination will not work for many reasons (we changed OpenSM/ve=
ndor
> interaction couple of times in past few years, including configuratio=
n)
> and it is better to avoid such usage.
>
>> >> >> @@ -392,8 +393,7 @@ ib_api_status_t osm_opensm_init(IN osm_ope=
nsm_t * p_osm,
>> >> >> =C2=A0 =C2=A0 =C2=A0 if (status !=3D IB_SUCCESS)
>> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>> >> >>
>> >> >> - =C2=A0 =C2=A0 p_osm->p_vendor =3D
>> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_vendor_new(&p_osm->log, p_op=
t->transaction_timeout);
>> >> >> + =C2=A0 =C2=A0 p_osm->p_vendor =3D osm_vendor_new(&p_osm->log=
, -1);
>> >> >
>> >> > Why to not make p_opt->transaction_timeout as default for newly
>> >> > allocated vendor object?
>> >>
>> >> To support old and new ABI.
>> >
>> > What do you mean? OpenSM will run against older vendor?
>> >
>> > Even if so how '-1' is helpful? Likely it will break things, no?
>>
>> -1 is not a valid timeout so can't this be used in this manner ? How
>> will it break things ?
>
> Old vendor will not work with '-1'. OTOH this enforces all vendor use=
rs
> to set all parameter explicitly, and ignores those values when a valu=
e
> other than '-1' was used in vendor creation. In fact it enforces usin=
g
> '-1' and effectively makes it to be mandatory part of vendor API. See=
ms
> too messy for me.

OK; I'll update the patch then.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
