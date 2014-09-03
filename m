From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] IPoIB: fix mcast_dev_flush/mcast_restart_task race
Date: Wed, 03 Sep 2014 14:06:54 -0400
Message-ID: <1409767614.26762.7.camel@firewall.xsintricity.com>
References: <cover.1407885724.git.dledford@redhat.com>
	 <e1dbcfc25d8930b281aad12699ebf8fa82485b0e.1407885724.git.dledford@redhat.com>
	 <CABgxfbHDuUrdHuLJT2oD07Cy3Ys4_rj-bJ6eR=9+uv0CuPH7_Q@mail.gmail.com>
	 <CABgxfbGJOdmAn1sokEtisDdnA=r_4mfP=PfqZVsP0cd_oL50dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Yau+DHD8RQFy+RyhpQ7L"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbGJOdmAn1sokEtisDdnA=r_4mfP=PfqZVsP0cd_oL50dA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Yau+DHD8RQFy+RyhpQ7L
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-08-30 at 08:39 -0700, Wendy Cheng wrote:
> On Fri, Aug 29, 2014 at 2:53 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> > On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> >> Our mcast_dev_flush routine and our mcast_restart_task can race agains=
t
> >> each other.  In particular, they both hold the priv->lock while
> >> manipulating the rbtree and while removing mcast entries from the
> >> multicast_list and while adding entries to the remove_list, but they
> >> also both drop their locks prior to doing the actual removes.  The
> >> mcast_dev_flush routine is run entirely under the rtnl lock and so has
> >> at least some locking.  The actual race condition is like this:
> >>
> >> Thread 1                                Thread 2
> >> ifconfig ib0 up
> >>   start multicast join for broadcast
> >>   multicast join completes for broadcast
> >>   start to add more multicast joins
> >>     call mcast_restart_task to add new entries
> >>                                         ifconfig ib0 down
> >>                                           mcast_dev_flush
> >>                                             mcast_leave(mcast A)
> >>     mcast_leave(mcast A)
> >>
> >> As mcast_leave calls ib_sa_multicast_leave, and as member in
> >> core/multicast.c is ref counted, we run into an unbalanced refcount
> >> issue.  To avoid stomping on each others removes, take the rtnl lock
> >> specifically when we are deleting the entries from the remove list.
> >
> > Isn't "test_and_clear_bit()" atomic so it is unlikely that
> > ib_sa_free_multicast() can run multiple times  ?
>=20
> Oops .. how about if the structure itself gets freed ? My bad !

Well, just like the last email, the code you are referring to is in the
original code, and had other issues.  After my patches it does not look
like that.

> However, isn't that the remove_list a local list on the caller's stack
> ? .. and  the original list entry moving (to remove_list) is protected
> by the spin lock (priv->lock), it is unlikely that the
> ib_sa_free_multicast() can operate on the same entry ?

Yes, you're right.  I had it in my mind that the remove_list was part of
the ipoib private dev, not local on the stack.  So you are right that we
could probably get away with removing the rtnl lock there (although it
would need to be in a later patch than the one you are reviewing
here...here there would still be a race between the restart task and the
downing of the interface because they all still share the same work
queue, but once we switch to the per device work queues in patch #6,
this can happen in parallel safely with the flush task I think).

> The patch itself is harmless though .. but adding the rntl_lock is
> really not ideal.
>=20
> -- Wendy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-Yau+DHD8RQFy+RyhpQ7L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUB1i+AAoJELgmozMOVy/dl1MP/0lvqSlr4UQUbDTQhNrwVoVX
xdLjL5TUhwW9j+MHu/980/C8xTLGeAoNJ1jj5uL53eyYgZ7W0GFth5dxGbPW07tD
lVoMy+3MPJt1mBr6Q5ag2atb0Z7eEup5Izmwk2qYi1XNZaU0RrwkjPOoAyw5htde
3px1zR9ipWXcY+3BLM9DWoMvt19Tq2osSLtm3T3GvulUxogfYjTaG3wVlf1o6lch
Acx5w3AU+JmL5/9wo4QqxpoM2xPryHem5ewYuivKPX0I8Msbni0//fE7PNMHt1P7
INB+zDIfcZ/nCm/wHSdNtGahlgy8m6GP08WDgCoOF2uNYQQmXARAl17hHgg6AxMh
SEE5RMaNntNOjPFL57wQ98awBv5mrAst+oQhN+eFWpbUT0gUTPNSq6lH2J2vhXxw
Zc/hgJTSdr2gLJdJlUuv5o5L8O+BLOo4D23ftfjQYg3DSGK8YNOdtI8ieHGBeet6
NevE2sMpltBeMLymuh26U7eByar32r7/fup7TVDBf+/7oao1jfp6GVygkGxOU59F
RjLL96Nk29JKsL/DsLWGHzj2T0qffdto3nbDJYOG4flnsAf1LjbxR90iiBGDIfQu
jNMlTElwEP4DJPrdY5z+ERVMvxtfFUzg7zj7Dd3WAUtXe4MPVtYo4vKucu7CshZs
0gbE0CfsOVsUptkMa01T
=BhfL
-----END PGP SIGNATURE-----

--=-Yau+DHD8RQFy+RyhpQ7L--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
