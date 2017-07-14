From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core soon in Debian
Date: Fri, 14 Jul 2017 18:16:47 +0300
Message-ID: <20170714151647.GC1528@mtr-leonro.local>
References: <1500041591.3563.31.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uXeYlJRvy4f2YhXS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500041591.3563.31.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uXeYlJRvy4f2YhXS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 14, 2017 at 04:13:11PM +0200, Benjamin Drung wrote:
> Hi everyone,
>
> a few weeks passed since my last status update regarding rdma-core in
> Debian. We made good progress in getting it ready. Only three items are
> left:
>
> 1) I sent three patches for the ibacm and iwpmd service to the mailing
> list. They need to be reviewed and accepted:
>
> $ git log --oneline master..bdrung
> c3654500 ibacm: Add systemd service file
> 562d5a00 iwpmd: Support Debian/Ubuntu in sysvinit service
> 9744e8d2 ibacm: Fix service start_daemon call on Debian

It will be merged on Sunday, depends on lack of objections.

>
> 2) Common infrastructure for auto loading rdma modules: See the "Add
> rdma service for kernel boot support" thread on this mailing list.
> Jason Gunthorpe made a very good proposal were I made some comments on
> it.
>
> 3) Get rid of openibd and rdma service dependencies:
>
> $ git grep openibd
> ibacm/CMakeLists.txt:set(rdmascript "openibd")
> srp_daemon/CMakeLists.txt:set(RDMA_SERVICE "openibd" CACHE STRING
> "init.d file service name to order srpd after")
> $ git grep rdma.service -- ibacm/
> ibacm/ibacm.service.in:Requires=3Drdma.service
> ibacm/ibacm.service.in:After=3Drdma.service opensm.service
>
> openibd is not part of rdma-core and rdma.service will go away with the
>  changes in point 2.
>
>
> I expect to see progress on these points in the coming days / next
> week. When all changes are in master, will we create a new release?
> Otherwise I will have to base my upload on v14 and cherry-pick all
> relevant changes.

Usually, we are releasing rdma-core, a week or two after Linus's -rc1
release. Let's see how the progress will be and decide then.

Thanks

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> Web:=A0https://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Achim Weiss.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--uXeYlJRvy4f2YhXS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllo4F8ACgkQ5GN7iDZy
WKeRVA//UYgDo0vujjpBW0PaegXcv9StAkk163xw4VI19ILgC+Wcf0TXUGmhJNqY
srvLIGSuPXVFsEw4Jr65gplQ5h+Kvg6RYtzthswTBE0K26zynr/ZIr7sj8HUA0TE
RADyTO8Sdu0nH9rs9SyYssrKoM/nOlaDRx4ecLHwiK5MsSlj40gbOA1zQxG8+Mrq
AHnTuilZq/KuwPyheASg2J4Az+FUtkqveQna3qwHRXkC3+5ZoacxobeTM+1QDS+s
W5sWLnS/azMy4kQDccsQyAR/3IkW5nf00D3BliiLCa8Ss2ZHgJFiGK8zKhdeknc7
awcd2XvJQFcGnVmpN2c68zhtiHGIzMxNrunlKuDP1Z7nz3C0OEaRDiIIx/HBA/3C
N0u1KKXS/TYEEdafueSA0tWNhV8yTEeAzJx8YNHGMOljnko6DCEQcd12vUyDlsHZ
xfkVE4s4EYNUXu8TX5Gric3wqkrvgxVA00tB/YBcP+AaQSBNir4mLgv4pTWFYqF/
POEHuImusWr7uG/ykPN+OuJmwQH7hnlXBPnZzkc6sr2YE0S+cx0ApcnrHy5VSwQt
X0kZ27n5Plr5GS4mhrDsB7eLws2J4b6se0M+udtUrr6Rp054eIjRJ0aBnnYzZorf
fS6OJKQ18a1Tv0Nrq3aboIzPVSdp5Eo+wvB0ehX9zTDyAhvgtqo=
=09cb
-----END PGP SIGNATURE-----

--uXeYlJRvy4f2YhXS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
