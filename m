From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] cbuild: Properly create tarball for SuSE
Date: Thu, 2 Nov 2017 19:57:35 +0200
Message-ID: <20171102175735.GE16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-3-leon@kernel.org>
 <20171102171738.GP18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6Rpt4tnX3EsKWamm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102171738.GP18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6Rpt4tnX3EsKWamm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 11:17:38AM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 06:55:53PM +0200, Leon Romanovsky wrote:
> > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The tarball was not created at the expected path by SUSE scripts,
> > causing rpmbuild to fail with the following error:
> > error: File /usr/src/packages/SOURCES/rdma-core-16.tar.gz: No such file or directory
> >
> > This patch fixes the issue by adding ".rpmmacros" file to root's home
> > folder and sets "%_topdir" to the path where we place the source tarball.
>
> Alaa,
>
> I'm not certain what this patch is about, I don't see these errors
> here:
>
> $ buildlib/cbuild pkg opensuse-42.2
> Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.JSkP2f
> + umask 022
> + cd /home/jgg/rpmbuild/BUILD
> + cd /home/jgg/rpmbuild/BUILD
> + rm -rf rdma-core-16
> + /usr/bin/gzip -dc /home/jgg/rpmbuild/SOURCES/rdma-core-16.tar.gz
> + /bin/tar -xf -
> + STATUS=0
> + '[' 0 -ne 0 ']'
> + cd rdma-core-16
> + /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
> + exit 0
> Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.rzpkKs
> + umask 022
> + cd /home/jgg/rpmbuild/BUILD
> + /usr/bin/rm -rf /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> ++ dirname /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> + /usr/bin/mkdir -p /home/jgg/rpmbuild/BUILDROOT
> + /usr/bin/mkdir /home/jgg/rpmbuild/BUILDROOT/rdma-core-16-0.x86_64
> + cd rdma-core-16
>
> How can you be getting such a significantly different result?
>
> Are you running cbuild as root or something? What is the docker
> command the script uses?

For me too, it doesn't reproduce, most probably Alaa run it as a root.

Thanks

>
> Jason

--6Rpt4tnX3EsKWamm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7XI8ACgkQ5GN7iDZy
WKdvSA//ZmhEoApXwf+KintHBm0ndjKhOk+mDPvatOmQXZ/3L91xjO3m2evDTEQw
kM1WPsmAofPU4ZZzoC39VTjhVw6v+FgPs+Ke94rX/X/RoLOEDtojAJ+TdXHasQy5
XodFWA9SUt6cIzAMu+JH3LiKpwyQ7+89IRKxS1sr5288vUO6DuZ+0ZeTx3Co5v2e
PyI1oXAPIoPrn+573xgjgzqXJ34wj2nHGGeSx6SOlu6gIHBWLCKDAij+1EwV4JR+
XeSkKlniDntDLGV1R9icoqqp04TPe5EO8KSI5WaH0oAud7+1uBoKaPzCoe8CI9E4
q5HyES8WzLkYG2lyEwSI5qWCkziBFIThufoMclq4TVH8t6uYt/B1AudCeZegwl8R
w6NS08NB+v3GF/VinGiqsstRhFmPZmU7p2j7k+FnAUXhdszuTC59vmkLJ1pApJ/I
GeLh7Id52SQDORmXE1ars7+T11MSy8HRnKfH7GdEGwT6kxSmMOaSnOaHa/0Zrso3
UJ55HdR/NSr/q1370SYG+KUmUWNAw1Se96ZrEdjVj8tj9fGGlXrgAcm50qPUrLZO
toLJ0ZKEN5cRWCzjrkUIDIBj7ITkq04Jq6fF8sYxdFcib9elXTyuWsOLc+BbhHUh
Y6UnD7Wj9D18DzKCCdw9JEzhrWtqlHuKux/We753FAElgIjE938=
=kSAq
-----END PGP SIGNATURE-----

--6Rpt4tnX3EsKWamm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
