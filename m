From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/2] svcrdma: Remove extra writeargs sanity check for
 NFSv2/3
Date: Thu, 10 Jul 2014 15:43:49 -0400
Message-ID: <20140710194349.GD26561@fieldses.org>
References: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
 <20140710174435.3734.69638.stgit@klimt.1015granger.net>
 <20140710181944.GB26561@fieldses.org>
 <3BA364F8-E5ED-45A1-8662-E5F91AA7AF0A@oracle.com>
 <20140710184948.GC26561@fieldses.org>
 <B89AB7AC-32E1-4944-9287-73958A569A8E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B89AB7AC-32E1-4944-9287-73958A569A8E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: swise-UeZzRo20aYc@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 10, 2014 at 03:07:34PM -0400, Chuck Lever wrote:
> Hi Bruce-
>=20
> On Jul 10, 2014, at 2:49 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> w=
rote:
>=20
> > On Thu, Jul 10, 2014 at 02:24:57PM -0400, Chuck Lever wrote:
> >>=20
> >> On Jul 10, 2014, at 2:19 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org=
> wrote:
> >>=20
> >>> On Thu, Jul 10, 2014 at 01:44:35PM -0400, Chuck Lever wrote:
> >>>> The server should comply with RFC 5667,
> >>>=20
> >>> Where's the relevant language?  (I took a quick look but didn't s=
ee it.)
> >>=20
> >> Sorry, I listed the wrong RFC when I wrote the description of bug =
246.
> >> It=E2=80=99s actually RFC 5666, section 3.7.
> >=20
> > Thanks.
> >=20
> >>> So I think you just want to drop the round-up of len, not the who=
le
> >>> check.
> >>=20
> >> I=E2=80=99ll try that, thanks!
>=20
> Works-as-expected.
>=20
> > Actually, I'd really rather this get fixed up in the rpc layer.  Th=
e
> > padding is really required for correct xdr.
>=20
> How so?

Well, to be spec-lawyerly, rfc 1832 3.9 defines opaque data as includin=
g
the zero-padding; a sequence of bytes isn't legal xdr if it just ends
early.

> All of NFSv4 and all other NFSv3 operations work as expected
> without that padding present. There doesn=E2=80=99t seem to be any op=
erational
> dependency on the presence of padding. Help?

I can believe that the code deals with it now, I just wonder if this
check may not be the only case where someone writing xdr code expects
total length to be a multiple of four.

The drc code also depends on the length being right, see
nfsd_cache_csum.  I don't know whether that will cause a practical
problem in this case.

(What about the krb5i case?)

> > The fact that RDMA doesn't
> > require those zeroes to be literally transmitted across the network
> > sounds like a transport-level detail that should be hidden from the=
 xdr
> > code.
>=20
> The best I can think of is adding a false page array entry to the
> xdr_buf if the last incoming page is short by a few bytes.

The padding just gets added to the end of whichever page the write ende=
d
on, and you only use another page if you run out of space, right?

I don't know, if that's a huge pain then I guess we can live with this.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
