From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 2/2] IB/umad: Export mad snooping capability to userspace
Date: Thu, 14 Oct 2010 11:56:50 -0400
Message-ID: <AANLkTi=UzCnpfKSgvc4mpVBcNA5wO4P+nytsvYTWNx9j@mail.gmail.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA129@orsmsx501.amr.corp.intel.com>
	<AANLkTimGjm9ZzWsav91CHSqgftxTzZW3iZN1fAp+EWd5@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5E984@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5E984-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 14, 2010 at 11:20 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
>> > Export the mad snooping capability to user space clients
>> > through the existing umad interface. =C2=A0This will allow
>> > users to capture MAD data for debugging, plus it allows
>> > for services to act on MAD traffic that occurs.
>>
>> Should it also be noted that snooping of RMPP'd MADs occurs at the
>> reassembled packet level with the last header being indicated ?
>
> I thought that the mad layer ending up reporting snooped MADs before =
reassembly and after segmentation. =C2=A0It's been a while since I've u=
sed madeye, but that's what I remember. =C2=A0I guess I'll find out dur=
ing testing and make whatever adjustments are necessary,

Yes, you're right; I recall this now.

> but I agree that this should be documented.
>
> On a side note, while writing up this patch, it looks like madeye han=
dles the data portion of sent RMPP MADs incorrectly. =C2=A0It doesn't r=
eference the data portion (beyond the RMPP/MAD headers) correctly. =C2=A0=
See the snoop_send_handler for how I think this needs to be handled.
>
>> > diff --git a/include/rdma/ib_user_mad.h b/include/rdma/ib_user_mad=
=2Eh
>> > index d6fce1c..0c40861 100644
>> > --- a/include/rdma/ib_user_mad.h
>> > +++ b/include/rdma/ib_user_mad.h
>> > @@ -165,10 +165,36 @@ struct ib_user_mad {
>> > =C2=A0typedef unsigned long __attribute__((aligned(4))) packed_ulo=
ng;
>> > =C2=A0#define IB_USER_MAD_LONGS_PER_METHOD_MASK (128 / (8 * sizeof=
 (long)))
>> >
>> > +enum {
>> > + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_QP0,
>> > + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_QP1,
>> > + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP =3D 0x80,
>> > + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP_QP0 =3D IB_UMAD_SNOOP & IB_UM=
AD_QP0,
>> > + =C2=A0 =C2=A0 =C2=A0 IB_UMAD_SNOOP_QP1 =3D IB_UMAD_SNOOP & IB_UM=
AD_QP1
>> > +};
>>
>> typos above: s.b. | r.t. &
>
> yep - thanks
>
>> > + * @qpn - Queue pair number; must be 0 or 1. =C2=A0If the upper b=
it of the
>> qpn
>> > + * =C2=A0 is set to 1, then the registration will be set to snoop=
 traffic
>> > + * =C2=A0 over that QP.
>>
>> Should this take half the qpn space or be two specific values ?
>
> Two specific values is probably better. =C2=A0Note that the umad inte=
rface specifies the qpn using 8-bits, so we're definitely limited on th=
e qpns that we could ever support. =C2=A0I know there's been discussion=
 about possibly adding more reserved QPs, so I'm not sure what the best=
 two values to reserve would be.

Me neither. Maybe the top two values ?

-- Hal

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
