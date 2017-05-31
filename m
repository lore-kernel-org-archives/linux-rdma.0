From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: How do I generate and set a GUID on an Ethernet VF with
 ConnectX-4?
Date: Wed, 31 May 2017 08:28:19 +0000
Message-ID: <847B5D33-D362-40F1-82B6-DB2F7B2BA1AA@mellanox.com>
References: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 30, 2017, at 8:55 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>=20
> One problem we found with rping is that when the GUID is '0', it
> fails. However, all of the VFs that are created are created with a '0'
> GUID. How do I generate a GUID that will not conflict for the VFs?
Hi Robert,

IIRC, once you set a MAC address for a VF, the node guid will be derived au=
tomatically for it. Also, it can be controlled using iptool.


> Once I have a generated GUID, how do I set it on a VF using the inbox
> drivers? I can't find a /sys entry that will allow me to write it and
> the one mentioned in the Mellanox OFED doesn't exist.
>=20
> I'll need to find a way to script this as part of my udev rules that
> adds the VFs.
>=20
> Thank you,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
