From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Tue, 4 Oct 2011 14:31:03 +0200
Message-ID: <CAN+0-cZ+c8tU7e7X9Cc_kB3c-pXRXYn8SVgLERrHxTY-ug0Ggg@mail.gmail.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A8237316E690F8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E690F8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,
The function ib_active_speed_to_rate  is used in the same patch by
rate_show function

Marcel

On Mon, Oct 3, 2011 at 8:53 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -77,6 +77,35 @@ enum ib_rate mult_to_ib_rate(int mult)
>> =A0}
>> =A0EXPORT_SYMBOL(mult_to_ib_rate);
>>
>> +int ib_rate_to_int(enum ib_rate rate, int *rounded)
>> +{
>
> I like this approach better, but I wonder if it still couldn't be sli=
ghtly cleaner. =A0Rather than returning 'rounded' and having the caller=
 assume that 1 means add .5 to the result, we could return the fraction=
al part directly. =A0I.e. rename 'rounded' to 'fraction' and return 5.
>
> Or if ib_rate_to_int() is only used to convert the rate into a string=
, we could just return the string directly.
>
>> + =A0 =A0 *rounded =3D 0;
>> +
>> + =A0 =A0 switch (rate) {
>> + =A0 =A0 case IB_RATE_2_5_GBPS:
>> + =A0 =A0 =A0 =A0 =A0 =A0 *rounded =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 2;
>> + =A0 =A0 case IB_RATE_5_GBPS: =A0 return 5;
>> + =A0 =A0 case IB_RATE_10_GBPS: =A0return 10;
>> + =A0 =A0 case IB_RATE_20_GBPS: =A0return 20;
>> + =A0 =A0 case IB_RATE_30_GBPS: =A0return 30;
>> + =A0 =A0 case IB_RATE_40_GBPS: =A0return 40;
>> + =A0 =A0 case IB_RATE_60_GBPS: =A0return 60;
>> + =A0 =A0 case IB_RATE_80_GBPS: =A0return 80;
>> + =A0 =A0 case IB_RATE_120_GBPS: return 120;
>> + =A0 =A0 case IB_RATE_14_GBPS: =A0return 14;
>> + =A0 =A0 case IB_RATE_56_GBPS: =A0return 56;
>> + =A0 =A0 case IB_RATE_112_GBPS: return 112;
>> + =A0 =A0 case IB_RATE_168_GBPS: return 168;
>> + =A0 =A0 case IB_RATE_25_GBPS: =A0return 25;
>> + =A0 =A0 case IB_RATE_100_GBPS: return 100;
>> + =A0 =A0 case IB_RATE_200_GBPS: return 200;
>> + =A0 =A0 case IB_RATE_300_GBPS: return 300;
>> + =A0 =A0 default: =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>> +}
>> +EXPORT_SYMBOL(ib_rate_to_int);
>> +
>> =A0enum rdma_transport_type
>> =A0rdma_node_get_transport(enum rdma_node_type node_type)
>> =A0{
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -207,6 +207,7 @@ enum ib_port_cap_flags {
>> =A0 =A0 =A0 IB_PORT_SM_DISABLED =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =3D 1 << 10,
>> =A0 =A0 =A0 IB_PORT_SYS_IMAGE_GUID_SUP =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 1 << 11,
>> =A0 =A0 =A0 IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP =A0 =A0 =A0 =3D 1 << 1=
2,
>> + =A0 =A0 IB_PORT_EXTENDED_SPEEDS_SUP =A0 =A0 =A0 =A0 =A0 =A0 =3D 1 =
<< 14,
>> =A0 =A0 =A0 IB_PORT_CM_SUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0=3D 1 << 16,
>> =A0 =A0 =A0 IB_PORT_SNMP_TUNNEL_SUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=3D 1 << 17,
>> =A0 =A0 =A0 IB_PORT_REINIT_SUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=3D 1 << 18,
>> @@ -226,6 +227,42 @@ enum ib_port_width {
>> =A0 =A0 =A0 IB_WIDTH_12X =A0 =A0=3D 8
>> =A0};
>>
>> +static inline int ib_active_speed_to_rate(u8 active_speed, int *rou=
nded)
>
> I don't see where this is used.
>
> The other patches in this series look good to me.
>
> - Sean
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
