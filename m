From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Thu, 28 Apr 2016 14:56:53 +0300
Message-ID: <20160428115653.GB21343@leon.nu>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5721F149.1090004-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
>=20
> >What is the status of getting RXE included in the mainline kernel? I
> >saw a post from Kamal Heib on 22 Sep 2015 with a patchset for
> >inclusion [0], but there didn't seem to be any discussion about it. I
> >diffed the kernel tree with the RXE tree on GitHub using the
> >rxe_submission_v8 branch [1], but there was over 10 million lines in
> >the patch file for the same kernel version. I'd rather patch into the
> >vanilla kernel tree so that I can see the differences rather than just
> >building the tree that someone else provides.
> >
> >I will probably go through all 32 patches anyway, but thought I would
> >prod here about the status as it can be very helpful for
> >compatibility.
>=20
> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
> some patches to contribute for it.

We are planning on submitting it in very near future.

>=20
> Cheers,
> Sagi.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIfqFAAoJEORje4g2clinm8cQAIPAuJarBEupTO7QuyXgtcIx
WROteiNlQnPVM0Arf9b6fDRkCYQrfcXuA4/ToyFnj8ai/UkfSbKXUlfRIlRNpFxQ
6zml1Vkx7zIlrCTCilBMjs0s0LLQgBW9hZk7AjSW5Nx7+tmIY/6CQnUWBZiLy7iX
hSxpIXoPkbMKA3NaKs2AX6aqI/ds+x1VAs21Ybq4VQt7RR2gfr/D71x0SaAKiLNB
h5McdXsaUlMgKdofx+9dTKbR4C8eTFuBL1/xhgCFag8IQ8H6qTyuQ2FRkLBk5oFj
Jpj2NTbG5P8JKzm59XCvgdXXu6gt7qZPWqN4yt1RiPaMcI7ogr6hXordYTs8KFZZ
qupjI+kZ8oXV9QpfPIdsx6DDlfg/sCAOFe5ClU5yCkMMbIlDZjd5JbYF44wqbMaQ
dGC3lV2OVynIu1vGOUVhfmNHL/BGip6Rkj1oVccK5HltxvZ9Zb4J1z1b2KpnMLEp
ysd5RSoMXFELFYrY6D1aHG6kokZPAj7fKWs+nFRlp/52yCBZlCox8+bBX8n7T9F+
vKKV2BTpsHk/dJuCoCl28pabZWbAAYG8nkNsCq190S4Zi+rI4DhsH1jyfe5t9s8s
Xos8HN9bpdPOi0VzJ0UaxTKHnzgTX+0nWiSNNd3cXaupcGAt8gfFR3SudCLuvXOO
b4Czs6UgLfHhKsmk55Fk
=yFTr
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
