From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 23:12:43 +0000
Message-ID: <1489101151.2597.18.camel@sandisk.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
         <20170309171014.GC12694@obsidianresearch.com>
         <1489098918.2597.12.camel@sandisk.com>
         <20170309224904.GA5867@obsidianresearch.com>
         <1489099998.2597.16.camel@sandisk.com>
         <20170309230453.GA7844@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309230453.GA7844-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <542A88AFBD167247BF2F5BC852565594-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 16:04 -0700, Jason Gunthorpe wrote:
> On Thu, Mar 09, 2017 at 10:53:31PM +0000, Bart Van Assche wrote:
> > Sorry, I used the wrong base for the diff command. How about the patch =
below
> > to fix the SuSE build:
>=20
> Are you using an older suse? I just updated my tumbleweed image and it
> built fine with HEAD.
>=20
> What is in your /etc/rpm/macros.cmake? All the suse's I looked at have
> this in that file:
>=20
>  %cmake_install \
>     DESTDIR=3D%{buildroot} %__builder install -C %__builddir
>=20
> It comes from here (tumbleweed):
>=20
> builder-40f0d1607cec:/etc/rpm # rpm -qf /etc/rpm/macros.cmake
> cmake-3.7.2-1.1.x86_64
>=20
> (13.2):
>=20
> bash-4.2# rpm -qf /etc/rpm/macros.cmake
> cmake-3.0.2-6.1.x86_64
>=20
> ?
>=20
> I also checked and it built OK on OpenSuse 13.2
>=20
> So.. I'm confused what we are trying to fix here? :)

Hello Jason,

Without that patch building an RPM fails against a recent version of
Tumbleweed:

$ rpm -qf /etc/issue.net =A0
openSUSE-release-20170304-1.1.x86_64
$ rpm -qf /etc/rpm/macros.cmake
cmake-3.7.2-1.1.x86_64
$ cat ./build-rpm.sh =A0=A0=A0=A0=A0=A0=A0=A0=A0
#!/bin/sh
name=3Drdma-core
version=3D$(sed -n 's/^Version:[[:blank:]]*//p' rdma-core.spec)
rpmtopdir=3D$PWD/rpmbuilddir
git archive --prefix rdma-core-${version}/ --output ${name}-${version}.tgz =
HEAD &&
 =A0=A0=A0rm -rf ${rpmtopdir} &&
 =A0=A0=A0mkdir -p ${rpmtopdir}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} &&
 =A0=A0=A0cp ${name}-${version}.tgz ${rpmtopdir}/SOURCES &&
 =A0=A0=A0rpmbuild --define=3D"%_topdir ${rpmtopdir}" -ba ${name}.spec
$ ./build-rpm.sh
[ ... ]
-- Build files have been written to: rdma-core/rpmbuilddir/BUILD/rdma-core-=
13/build
+ /usr/bin/make -j4 VERBOSE=3D1
make: *** No targets specified and no makefile found. =A0Stop.
error: Bad exit status from /var/tmp/rpm-tmp.4zaz5Y (%build)

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
