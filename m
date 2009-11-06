From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for PortInfo:McastPkeyTrapSuppressionEnabled
Date: Fri, 6 Nov 2009 14:35:30 -0500
Message-ID: <f0e08f230911061135x4117c1caj311139e1bc8799c2@mail.gmail.com>
References: <20091106141034.GC19678@comcast.net> <20091106180217.GP7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091106180217.GP7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 6, 2009 at 1:02 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 09:10 Fri 06 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Per published MgtWG erratum RefID 4576
>
> Please describe the change.

Not sure what else you are looking for here. Is it a description of
the new field or a description of the patch which is trivial:
"Add support for new field to PortInfo"

> Reference to private tracker's RefID number
> is not enough.

It's not private as I've tried to explain before.

-- Hal

>
> Sasha
>
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/in=
finiband/mad.h
>> index b82b0d5..ed8fd71 100644
>> --- a/libibmad/include/infiniband/mad.h
>> +++ b/libibmad/include/infiniband/mad.h
>> @@ -357,6 +357,7 @@ enum MAD_FIELDS {
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_QKEY_VIOL_F,
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_GUID_CAP_F,
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_CLIENT_REREG_F,
>> + =C2=A0 =C2=A0 IB_PORT_MCAST_PKEY_SUPR_ENAB_F,
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_SUBN_TIMEOUT_F,
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_RESP_TIME_VAL_F,
>> =C2=A0 =C2=A0 =C2=A0 IB_PORT_LOCAL_PHYS_ERR_F,
>> diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
>> index 98a0c60..c2f9585 100644
>> --- a/libibmad/src/fields.c
>> +++ b/libibmad/src/fields.c
>> @@ -162,6 +162,7 @@ static const ib_field_t ib_mad_f[] =3D {
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(384, 16), "QkeyViolations", mad_dump_=
uint},
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(400, 8), "GuidCap", mad_dump_uint},
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(408, 1), "ClientReregister", mad_dump=
_uint},
>> + =C2=A0 =C2=A0 {BITSOFFS(409, 1), "McastPkeyTrapSuppressionEnabled"=
, mad_dump_uint},
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(411, 5), "SubnetTimeout", mad_dump_ui=
nt},
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(419, 5), "RespTimeVal", mad_dump_uint=
},
>> =C2=A0 =C2=A0 =C2=A0 {BITSOFFS(424, 4), "LocalPhysErr", mad_dump_uin=
t},
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
