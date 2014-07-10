From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] svcrdma: Remove extra writeargs sanity check for
 NFSv2/3
Date: Thu, 10 Jul 2014 14:49:48 -0400
Message-ID: <20140710184948.GC26561@fieldses.org>
References: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
 <20140710174435.3734.69638.stgit@klimt.1015granger.net>
 <20140710181944.GB26561@fieldses.org>
 <3BA364F8-E5ED-45A1-8662-E5F91AA7AF0A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3BA364F8-E5ED-45A1-8662-E5F91AA7AF0A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: swise-UeZzRo20aYc@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 10, 2014 at 02:24:57PM -0400, Chuck Lever wrote:
>=20
> On Jul 10, 2014, at 2:19 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> w=
rote:
>=20
> > On Thu, Jul 10, 2014 at 01:44:35PM -0400, Chuck Lever wrote:
> >> The server should comply with RFC 5667,
> >=20
> > Where's the relevant language?  (I took a quick look but didn't see=
 it.)
>=20
> Sorry, I listed the wrong RFC when I wrote the description of bug 246=
=2E
> It=E2=80=99s actually RFC 5666, section 3.7.

Thanks.

> > So I think you just want to drop the round-up of len, not the whole
> > check.
>=20
> I=E2=80=99ll try that, thanks!

Actually, I'd really rather this get fixed up in the rpc layer.  The
padding is really required for correct xdr.  The fact that RDMA doesn't
require those zeroes to be literally transmitted across the network
sounds like a transport-level detail that should be hidden from the xdr
code.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
