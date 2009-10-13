From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add infrastructure support for PortInfo
	IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 15:21:10 -0400
Message-ID: <f0e08f230910131221o6107e55cg2a0e934f90bafa89@mail.gmail.com>
References: <20091013181037.GA8839@comcast.net> <20091013191701.GV13830@me>
	 <f0e08f230910131220g49462559u8070ebb43832e682@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230910131220g49462559u8070ebb43832e682-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 3:20 PM, Hal Rosenstock
<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Oct 13, 2009 at 3:17 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> On 14:10 Tue 13 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>>
>>> Per published MgtWG errata RefID 4576
>>>
>>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> Changes since v2:
>>> Changed ib_port_info_set_client_rereg similarly to ib_port_info_set=
_mcast_pkey_trap_suppress
>>>
>>> Changes since v1:
>>> Don't reset reserved bits packed with subnet timeout
>>>
>>> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_=
types.h
>>> index aa566f7..79e5f53 100644
>>> --- a/opensm/include/iba/ib_types.h
>>> +++ b/opensm/include/iba/ib_types.h
>>> @@ -4431,7 +4431,7 @@ typedef struct _ib_port_info {
>>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t p_key_violations;
>>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t q_key_violations;
>>> =C2=A0 =C2=A0 =C2=A0 uint8_t guid_cap;
>>> - =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), resrv(2b)=
, timeout(5b) */
>>> + =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), mcast_pke=
y_trap_suppr(1b), resrv(1b), timeout(5b) */
>>> =C2=A0 =C2=A0 =C2=A0 uint8_t resp_time_value;
>>> =C2=A0 =C2=A0 =C2=A0 uint8_t error_threshold; /* local phy errors(4=
b), overrun errors(4b) */
>>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t max_credit_hint;
>>> @@ -5281,7 +5281,7 @@ ib_port_info_set_timeout(IN ib_port_info_t * =
const p_pi,
>>> =C2=A0{
>>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(timeout <=3D 0x1F);
>>> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & 0x=
80) | (timeout & 0x1F));
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & 0x=
E0) | (timeout & 0x1F));
>>> =C2=A0}
>>>
>>> =C2=A0/*
>>> @@ -5315,8 +5315,7 @@ ib_port_info_set_client_rereg(IN ib_port_info=
_t * const p_pi,
>>> =C2=A0{
>>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(client_rereg <=3D 0x1);
>>> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 subnet_timeout & 0x1F) | ((client_rereg << 7) & 0x80));
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & 0x=
9F) | (client_rereg << 7));
>>
>> I don't think that you wanted this - 0x9f will reset newly assigned =
bit.
>
> You're right...
>
>> Guess it should be:
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) (p_pi->subnet_timeout=
 | (client_rereg << 7));
>
> Shouldn't this be:
> (uint8_t) ((p_pi->subnet_timeout & 0xBF) | (client_rereg << 7));

Doh! 0x7F rather than 0xBF

>
> -- Hal
>
>>
>> Reapplying...
>>
>> Sasha
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
