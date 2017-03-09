From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 22:35:30 +0000
Message-ID: <1489098918.2597.12.camel@sandisk.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
         <20170309171014.GC12694@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309171014.GC12694-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <BDD342A513FB1F40A8D7C4AAE379E1CC-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 10:10 -0700, Jason Gunthorpe wrote:
> On Thu, Mar 09, 2017 at 11:25:27AM +0100, Philipp Thomas wrote:
>=20
> > I'm trying to build latest rdma-core but it fails in ibacm because a
> > library is missing:
>=20
> The suse cmake rpm macros are broken, this is worked around in the
> shipped rdma-core.spec:
>=20
> # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flag=
s
> # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' sty=
le
> # module libraries (eg ibacmp).
> %define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=3D""
>=20
> Ideally you would consult internally to globally fix the rpm cmake
> macro, otherwise you have to use the above hack..

Something else is also broken, namely the SuSE section in rdma-core.spec. I
just figured out that the following is needed to build an RPM on SuSE syste=
ms:

diff --git a/rdma-core.spec b/rdma-core.spec
index f7a440d7..aa486371 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -28,7 +28,7 @@ BuildRequires: ninja,make
 %define __builder ninja
 # cmake_install,make_jobs is specified by opensuse
 %define cmake cmake
-%define cmake_install DESTDIR=3D%{buildroot} ninja install
+%define cmake_install DESTDIR=3D%{buildroot} make install
=20
 # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
 # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' styl=
e

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
