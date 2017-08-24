From: Leon Romanovsky <leon@kernel.org>
Subject: Re: Possible rdma-core header conflict
Date: Thu, 24 Aug 2017 13:50:07 +0300
Message-ID: <20170824105007.GH1724@mtr-leonro.local>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
 <20170821120310.GL1724@mtr-leonro.local>
 <20170821155729.GC4401@obsidianresearch.com>
 <CACTTzNar-qBRxkeWHL-gt4C9A6yTbY+GbkTT6tWKvJcnpK=J_g@mail.gmail.com>
 <20170822064704.GR1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rq18dCD+oSRtyKma"
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170822064704.GR1724@mtr-leonro.local>
Sender: linux-kbuild-owner@vger.kernel.org
To: Yigal Korman <yigal@plexistor.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, mmarek@suse.com, linux-kbuild@vger.kernel.org, dhowells@redhat.com, Linux RDMA Mailing List <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--rq18dCD+oSRtyKma
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 22, 2017 at 09:47:04AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 22, 2017 at 09:08:56AM +0300, Yigal Korman wrote:
> > On Mon, Aug 21, 2017 at 6:57 PM, Jason Gunthorpe
> > <jgunthorpe@obsidianresearch.com> wrote:
> > > On Mon, Aug 21, 2017 at 03:03:10PM +0300, Leon Romanovsky wrote:
> > >> On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
> > >> > Hi,
> > >> > Has anyone noticed that installing rdma-core (or older
> > >> > librdmacm-devel) package and then installing kernel headers manual=
ly
> > >> > (make headers_install) removes the librdmacm headers?
> > >> > I actually see it in the make output:
> > >> >
> > >> > make INSTALL_HDR_PATH=3D/usr headers_install
> > >> >   CHK     include/generated/uapi/linux/version.h
> > >> >   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
> > >> >
> > >> > Am I doing something wrong?
> > >> > Sounds like the kernel rdma headers and librdmacm headers shouldn't
> > >> > sit in the same directory...
> > >>
> > >> It looks like this behavior (removal of header files) was from the b=
eginning of git era.
> > >> =E2=9E=9C  linux-rdma git:(rdma-next) =E2=9C=97 git co -b tmp v2.6.3=
4.8
> > >> =E2=9E=9C  linux-rdma git:(tmp) =E2=9C=97 cp ~/src/rdma-core/librdma=
cm/rdma_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=3D/tmp/h head=
ers_install | grep REMOVE
> > >>   REMOVE  rdma_verbs.h
> > >
> > > The user space files have also been sharing the directory with the
> > > kernel files since the start.. Not sure why, but I don't think we can
> > > change it now.
> > >
> > > Maybe someone can patch the kernel to exempt rdma/ from the removal
> > > process?
> >
> > Yeah, that would be a good possible fix for this.
> > I had a quick look at the kernel headers install scripts and didn't
> > see any mechanism for this, but I might've missed it.
>
> It is in scripts/Makefile.headersinst
> The change should be in the ...
>  66 # Work out what needs to be removed
>  67 oldheaders    :=3D $(patsubst $(installdir)/%,%,$(wildcard $(installd=
ir)/*.h))
>  68 unwanted      :=3D $(filter-out $(all-files),$(oldheaders))
>
> And we should filter out very specific headers, because it is a good thing
> to remove all other files to ensure that older headers are removed.

Yesterday, I took a look on various distributions in order to understand
why we didn't see this issue earlier.

Some distros install kernel headers into separate folder and not
into /usr/include, so rdmacm header files are not overwritten.

And some distros install kernel headers into different from /usr
directory, prepare all files in advance and copy them to /usr after
that without deleting the old files.

So, it looks like there is no need to fix anything, because installation
of header files with "make INSTALL_HDR_PATH=3D/usr headers_install" is an
easy thing to do for the development but is not right thing from the distro
point of view.

If there is distro which deletes rdmacm headers, it should be fixed there a=
nd
not in the kernel.

Thanks
>
> > I'm adding linux-kbuild mailing list here, maybe someone there can help?
> >
> > Thanks
> >
> > >
> > > Jason



--rq18dCD+oSRtyKma
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmer18ACgkQ5GN7iDZy
WKeNSg/6A3iqffM8mx5yPURB1Dz+cR0o0ttxWpGtN2R/AGRrOWFsQqciZT5ADFAH
/qKmZrO6hgiZW0gowdJlqpgsFBp/z9PN233/5O7NRGReUB+TYi6mLuosM1rbM7zv
tIPpt3CvxhzbJam04jqyYIbyB9uu+2G+5Dea7hnFoooHEvaKLBHsfuJ2KQZqMeFz
vTVXX43RsaTk3O1QXGZF7hIg+i5IHTQW1cpE3uhGC80OOU1yYxv8inuIXWz+QoDR
9s1PGixadZ0m/0TQ+VMD8QvjAUxGDgzoDJTe5yXIwyApdfVphF3ul1DK2lkI7Hfk
ep+OJ9tlvms1Y5QcCTh1HvIY4+3cX/pbP2snB3iZ9AP2wya3tRJXTYPJzMTQs2kQ
sGvaP0/LzUPjeOrlh4fuMwS+ytDu/QfQC8/wc7hY2vr4vt/l/rOqTU2RQZLQx9Vm
itfiiU8Ene0IVjDVdd5gYhVV89uutVDiRLdGVklu+niEUcwErYbp6vHWjNcugzWi
z7qiWmDNBHWcGgpbKAt1Uvl5Tzr1JM3VySU044wWgUsBNQHFX7J6HdM47ODx4bRY
i+fJ4jivu/7Vd08SmSWjpifGbZKXjlglNQnT9H4ypFNeYuyI9+Bev/MF9vcdBQO5
on2wUhXemexvWseYvIbjLZWwZxDUCUxJQGE39333IEc/ItVUK7w=
=CbUh
-----END PGP SIGNATURE-----

--rq18dCD+oSRtyKma--
