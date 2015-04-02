From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 02 Apr 2015 15:30:31 +0200
Message-ID: <1427981431.22575.21.camel@opteya.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
	 <1427969085.17020.5.camel@opteya.com>
	 <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM3PR05MB0935AA4898B4B519D2DAA3C4DCF20-LOZWmgKjnYgQouBfZGh8ttqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 02 avril 2015 =C3=A0 10:52 +0000, Shachar Raindel a =C3=A9crit=
 :
> > -----Original Message-----
> > From: Yann Droneaud [mailto:ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org]
> > Sent: Thursday, April 02, 2015 1:05 PM
> > Le mercredi 18 mars 2015 =C3=A0 17:39 +0000, Shachar Raindel a =C3=A9=
crit :

> > > +	/*
> > > +	 * If the combination of the addr and size requested for this
> > memory
> > > +	 * region causes an integer overflow, return error.
> > > +	 */
> > > +	if ((PAGE_ALIGN(addr + size) <=3D size) ||
> > > +	    (PAGE_ALIGN(addr + size) <=3D addr))
> > > +		return ERR_PTR(-EINVAL);
> > > +
> >=20
> > Can access_ok() be used here ?
> >=20
> >          if (!access_ok(writable ? VERIFY_WRITE : VERIFY_READ,
> >                         addr, size))
> >                   return ERR_PTR(-EINVAL);
> >=20
>=20
> No, this will break the current ODP semantics.
>=20
> ODP allows the user to register memory that is not accessible yet.
> This is a critical design feature, as it allows avoiding holding
> a registration cache. Adding this check will break the behavior,
> forcing memory to be all accessible when registering an ODP MR.
>=20

Where's the check for the range being in userspace memory space,
especially for the ODP case ?

=46or non ODP case (eg. plain old behavior), does get_user_pages()
ensure the requested pages fit in userspace region on all=20
architectures ? I think so.

In ODP case, I'm not sure such check is ever done ?
(Aside, does it take special mesure to protect shared mapping from
being read and/or *written* ?)

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
