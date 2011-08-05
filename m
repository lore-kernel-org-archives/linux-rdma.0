From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 01/37] add slice by 8 algorithm to crc32.c
Date: Fri, 5 Aug 2011 14:24:02 -0500
Message-ID: <027f01cc53a5$3c61e6a0$b525b3e0$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.154338911@systemfabricworks.com> <CAO+b5-rFs79znwVcG42Px2i351vhiz9hFyCJV5qg77of8Y6P5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-rFs79znwVcG42Px2i351vhiz9hFyCJV5qg77of8Y6P5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch has been submitted to linux-kernel and is being reviewed and
changing. When that is done I'll replace this one with whatever comes o=
ut
there.

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
> Sent: Friday, August 05, 2011 1:40 PM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 01/37] add slice by 8 algorithm to crc32.c
>=20
> On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wro=
te:
> > -#if CRC_BE_BITS > 8 || CRC_BE_BITS < 1 || CRC_BE_BITS & CRC_BE_BIT=
S-1
> > -# error CRC_BE_BITS must be a power of 2 between 1 and 8
> > +#if CRC_BE_BITS > 64 || CRC_BE_BITS < 1 || CRC_BE_BITS =3D=3D 16 |=
| \
> > + =A0 =A0 =A0 CRC_BE_BITS & CRC_BE_BITS-1
> > +# error "CRC_BE_BITS must be one of {1, 2, 4, 8, 32, 64}"
> > =A0#endif
>=20
> It's a little unfortunate that Roland's macro
> BUILD_BUG_ON_NOT_POWER_OF_2() can't be used in the above - that
> would
> make the "CRC_BE_BITS & CRC_BE_BITS-1" part more readable.
>=20
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
