From: "Brian J. Murrell" <Brian.Murrell-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: compiling against lustre 1.8.2 kernel
Date: Mon, 17 May 2010 14:10:03 -0400
Message-ID: <1274119803.396.360.camel@pc.interlinx.bc.ca>
References: <AANLkTil_7L_cbglOcaHKPRmrrntXew9jwxvSrTkxNcnF@mail.gmail.com>
	 <1274113630.396.41.camel@pc.interlinx.bc.ca>
	 <AANLkTikwu0pcBUNaxJQvTJdBDi18KpcQiUeyM3d_YhSi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dts2HUUkCgVbqjMD8bK9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikwu0pcBUNaxJQvTJdBDi18KpcQiUeyM3d_YhSi-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-dts2HUUkCgVbqjMD8bK9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-05-17 at 13:32 -0400, Michael Di Domenico wrote:=20
> it wouldn't appear so, guess i should have checked that. sorry...  i'm
> little baffled how they can claim it supports ofed 1.4.2 on a
> 2.6.18-146.11.1 kernel if ofed doesn't support a 2.6.18-164.11.1...
> but i digress, that questions for another list...

Indeed, it is, so any followups should be CC'd to
lustre-discuss-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org and should likely drop the linux-rdma
list.  Anyone interested in following, can subscribe to lustre-discuss.

But to address the confusion regarding 2.6.18-164.11.1 and the statement
of support for OFED 1.4.2 in the Lustre release notes, the list of
supported OFED releases and supported vendor kernels is not intended to
be a complete and exhaustive matrix.  We can of course, only provide
support where there is upstream support (i.e. intersection).

I have Bcc'd our release manager to have some verbage to that extent
(i.e. that the matrix is not complete) to our future release notes.

Cheers,
b.


--=-dts2HUUkCgVbqjMD8bK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvxhngACgkQl3EQlGLyuXAkCwCgtWtyTqYlcHfZHEtr6cu9YcK8
GUcAnjAWpIVbFrh1S+t5EionEu6Ahlq8
=tTzp
-----END PGP SIGNATURE-----

--=-dts2HUUkCgVbqjMD8bK9--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
