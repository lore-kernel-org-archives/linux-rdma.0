From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: drivers/staging/rdma/hfi1/sdma.c:740: bad if test ?
Date: Sat, 12 Sep 2015 14:06:55 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC257C0165@fmsmsx120.amr.corp.intel.com>
References: <DUB128-W16C8F40B6E4A09D9F0E64C9C5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DUB128-W16C8F40B6E4A09D9F0E64C9C5F0-MsuGFMq8XAE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>=20
> Source code is
>=20
> =A0=A0=A0 if (count < 64 && count> 32768)
> =A0=A0=A0=A0=A0=A0=A0 return SDMA_DESCQ_CNT;
>=20
> Maybe better code
>=20
> =A0=A0=A0 if (count < 64 || count> 32768)
> =A0=A0=A0=A0=A0=A0=A0 return SDMA_DESCQ_CNT;
>=20
>=20

Correct and thanks!

I will prepare a patch.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
