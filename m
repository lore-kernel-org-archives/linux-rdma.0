From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Sat, 1 Mar 2014 11:00:22 -0500
Message-ID: <20140301110022.417eb088@tlielax.poochiereds.net>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
	<53110287.9000400@talpey.com>
	<CABgxfbHwo13ma=-Xn+S36WwD8LVNLdw6UHztFe8EkCA_=NBenw@mail.gmail.com>
	<CABgxfbHg0B02c2zpYdCB4pUZZhhA4aKRuyh4Kx=NE1yAisFLLQ@mail.gmail.com>
	<B83B4DA6-E9CF-4DF3-9227-5EF9B4D25F4D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B83B4DA6-E9CF-4DF3-9227-5EF9B4D25F4D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 28 Feb 2014 21:59:00 -0500
Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Hi Wendy-
>=20
> On Feb 28, 2014, at 5:26 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>=20
> > On Fri, Feb 28, 2014 at 2:20 PM, Wendy Cheng <s.wendy.cheng@gmail.c=
om> wrote:
> >> ni i...On Fri, Feb 28, 2014 at 1:41 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org=
> wrote:
> >>>=20
> >>> On 2/26/2014 8:44 AM, Chuck Lever wrote:
> >>>>=20
> >>>> Hi-
> >>>>=20
> >>>> Shirley Ma and I are reviving work on the NFS/RDMA client code b=
ase in
> >>>> the Linux kernel.  So far we've built and run functional tests t=
o determine
> >>>> what is working and what is broken.
> >>>>=20
> >>>> [snip]
> >>=20
> >>=20
> >>>>=20
> >>>> ALLPHYSICAL - Usually fast, but not safe as it exposes client me=
mory.
> >>>> All HCAs support this mode.
> >>>=20
> >>>=20
> >>> Not safe is an understatement. It exposes all of client physical
> >>> memory to the peer, for both read and write. A simple pointer err=
or
> >>> on the server will silently corrupt the client. This mode was
> >>> intended only for testing, and in experimental deployments.
> >=20
> > (sorry, resend .. previous reply bounced back due to gmail html for=
mat)
> >=20
> > Please keep "ALLPHYSICAL" for now  - as our embedded system needs i=
t.
>=20
> This is just the client side.  Confirming that you still need support=
 for the ALLPHYSICAL memory registration mode in the NFS/RDMA client.
>=20
> Do you have plans to move to a mode that is less risky?  If not, can =
we depend on you to perform regular testing with ALLPHYSICAL as we upda=
te the client code?  Do you have any bug fixes you=92d like to merge up=
stream?
>=20

Also, given that ALLPHYSICAL isn't considered safe, we should at the
very least require some sort of explicit opt-in before allowing it to b=
e
used. Perhaps either a Kconfig option, or maybe a runtime switch like a
module parm?

Wendy, would that be acceptable?
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
