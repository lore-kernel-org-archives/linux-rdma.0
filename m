From: Leon Romanovsky <leon@kernel.org>
Subject: Re: Possible rdma-core header conflict
Date: Thu, 24 Aug 2017 15:23:28 +0300
Message-ID: <20170824122328.GJ1724@mtr-leonro.local>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
 <20170821120310.GL1724@mtr-leonro.local>
 <20170821155729.GC4401@obsidianresearch.com>
 <CACTTzNar-qBRxkeWHL-gt4C9A6yTbY+GbkTT6tWKvJcnpK=J_g@mail.gmail.com>
 <20170822064704.GR1724@mtr-leonro.local>
 <20170824105007.GH1724@mtr-leonro.local>
 <CACTTzNYiYCg-hYX8WGYpn6Yg4QZ=XqgQcyB-m_9cSd5D+w0juQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="spzFwWfYKRzjK1rH"
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACTTzNYiYCg-hYX8WGYpn6Yg4QZ=XqgQcyB-m_9cSd5D+w0juQ@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Yigal Korman <yigal@plexistor.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, mmarek@suse.com, linux-kbuild@vger.kernel.org, dhowells@redhat.com, Linux RDMA Mailing List <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--spzFwWfYKRzjK1rH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2017 at 02:28:30PM +0300, Yigal Korman wrote:
> On Thu, Aug 24, 2017 at 1:50 PM, Leon Romanovsky <leon@kernel.org> wrote:
> > On Tue, Aug 22, 2017 at 09:47:04AM +0300, Leon Romanovsky wrote:
> >> On Tue, Aug 22, 2017 at 09:08:56AM +0300, Yigal Korman wrote:
> >> > On Mon, Aug 21, 2017 at 6:57 PM, Jason Gunthorpe
> >> > <jgunthorpe@obsidianresearch.com> wrote:
> >> > > On Mon, Aug 21, 2017 at 03:03:10PM +0300, Leon Romanovsky wrote:
> >> > >> On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
> >> > >> > Hi,
> >> > >> > Has anyone noticed that installing rdma-core (or older
> >> > >> > librdmacm-devel) package and then installing kernel headers man=
ually
> >> > >> > (make headers_install) removes the librdmacm headers?
> >> > >> > I actually see it in the make output:
> >> > >> >
> >> > >> > make INSTALL_HDR_PATH=3D/usr headers_install
> >> > >> >   CHK     include/generated/uapi/linux/version.h
> >> > >> >   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
> >> > >> >
> >> > >> > Am I doing something wrong?
> >> > >> > Sounds like the kernel rdma headers and librdmacm headers shoul=
dn't
> >> > >> > sit in the same directory...
> >> > >>
> >> > >> It looks like this behavior (removal of header files) was from th=
e beginning of git era.
> >> > >> =E2=9E=9C  linux-rdma git:(rdma-next) =E2=9C=97 git co -b tmp v2.=
6.34.8
> >> > >> =E2=9E=9C  linux-rdma git:(tmp) =E2=9C=97 cp ~/src/rdma-core/libr=
dmacm/rdma_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=3D/tmp/h h=
eaders_install | grep REMOVE
> >> > >>   REMOVE  rdma_verbs.h
> >> > >
> >> > > The user space files have also been sharing the directory with the
> >> > > kernel files since the start.. Not sure why, but I don't think we =
can
> >> > > change it now.
> >> > >
> >> > > Maybe someone can patch the kernel to exempt rdma/ from the removal
> >> > > process?
> >> >
> >> > Yeah, that would be a good possible fix for this.
> >> > I had a quick look at the kernel headers install scripts and didn't
> >> > see any mechanism for this, but I might've missed it.
> >>
> >> It is in scripts/Makefile.headersinst
> >> The change should be in the ...
> >>  66 # Work out what needs to be removed
> >>  67 oldheaders    :=3D $(patsubst $(installdir)/%,%,$(wildcard $(insta=
lldir)/*.h))
> >>  68 unwanted      :=3D $(filter-out $(all-files),$(oldheaders))
> >>
> >> And we should filter out very specific headers, because it is a good t=
hing
> >> to remove all other files to ensure that older headers are removed.
> >
> > Yesterday, I took a look on various distributions in order to understand
> > why we didn't see this issue earlier.
> >
> > Some distros install kernel headers into separate folder and not
> > into /usr/include, so rdmacm header files are not overwritten.
> >
> > And some distros install kernel headers into different from /usr
> > directory, prepare all files in advance and copy them to /usr after
> > that without deleting the old files.
> >
> > So, it looks like there is no need to fix anything, because installation
> > of header files with "make INSTALL_HDR_PATH=3D/usr headers_install" is =
an
> > easy thing to do for the development but is not right thing from the di=
stro
> > point of view.
> >
> > If there is distro which deletes rdmacm headers, it should be fixed the=
re and
> > not in the kernel.
>
> Thanks Leon!
>
> So for development workflow, I guess that the trivial thing to do is
> to make sure to first install the kernel headers and then install
> rdmacm headers.

For the development, I use ability of rdma-core to run everything in
place and I don't install anything. I compile with build.sh supplied
in rdma-core and adjust Makefiles to point to build/lib|include directories
without need to install.

Thanks

>
> Y
>
> >
> > Thanks
> >>
> >> > I'm adding linux-kbuild mailing list here, maybe someone there can h=
elp?
> >> >
> >> > Thanks
> >> >
> >> > >
> >> > > Jason
> >
> >

--spzFwWfYKRzjK1rH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmexUAACgkQ5GN7iDZy
WKeLAg//QeXUsa0qylAtRVDWnw6ANwgBgxd7uf7ut/lqiGyWoSETfuwYYWYJrbhl
WNCI5khOT/D7XSMZjghory2sQVutTa+WZv8qfNWRqnQm0DUROYJ45loXdryPiVpw
CJar3eygyPZuWUxALR5re5WvzH8VmQUz4C7A0hpFTwuUlEMgQkDmedgbAwrmK/zd
nDn0TQNeqWa0bE3SrpD39eEe2ZK2jgsmmd/Ci3okoXeloevRtgnHfhcCSNqZjiiv
o2LiSIktNX2mGymFys42Vo+2iElPoOQL1pP8pZ1SHChF+SX+8yshcmHq9JvkrZca
7EOAQ/azBg4Je8p88LNZUfm/f6wTtWMMSqnEZ6bjWKeqsi884TJx4NoV0svN+X1U
6nfIsodM2dzLj848xEe0ucP18+A89R0Q6/IjY3NDLsz8MlXHxw/ZyxgUQuhkGsZ1
IGeJ18rHrjWL0hhOcNhdYAq9lrEiNnmi3TJBVcyS3gSVxE7PulwCesmTOYArCN+H
gAwHWtZzhjn/O+vYqIDpXk2zJJnK1zfqAVruCtuZbIt61sHU0M5vZccIWFancEcb
C3khh3PxooUDe+ptS/+RApgjU5fcGantD6CG/ec3BtunHU1HQLChGuGKdeumYO4k
MnDHoWXzEzVVcEQdTZ4cmlGLBBONNA/NfFA+k17ze8+G3fuxCp0=
=0ftQ
-----END PGP SIGNATURE-----

--spzFwWfYKRzjK1rH--
