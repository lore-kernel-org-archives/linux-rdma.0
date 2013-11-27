From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for v3.13 2/7] IB/uverbs: remove implicit cast in
 INIT_UDATA()
Date: Wed, 27 Nov 2013 13:18:34 +0100
Message-ID: <1385554714.21498.9.camel@localhost.localdomain>
References: <cover.1385501822.git.ydroneaud@opteya.com>
	 <471895ee06633a624e934cf501c7a460755fe4a4.1385501822.git.ydroneaud@opteya.com>
	 <5295AB98.8080205@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5295AB98.8080205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Matan,

Le mercredi 27 novembre 2013 =C3=A0 10:21 +0200, Matan Barak a =C3=A9cr=
it :
> On 27/11/2013 12:02 AM, Yann Droneaud wrote:
=2E..
> >   	INIT_UDATA(&udata, buf + sizeof cmd,
> > -		   (unsigned long) cmd.response + sizeof resp,
> > +		   (void __user *)(unsigned long)cmd.response + sizeof resp,
>=20
> The response field is already __u64 and casting to (void __user *)=20
> should match the machine's pointer type size. Why do we have to cast =
to=20
> (unsigned long) and then cast to (void __user *) ?
>=20

On 32bit ABI, u64 is not matching the size of the pointer.
Without the cast to unsigned long, GCC complains with:

  warning: cast to pointer from integer of different size
[-Wint-to-pointer-cast]

So the cast is required on 32bit platforms.

Regards.
--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
