From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 22:53:31 +0000
Message-ID: <1489099998.2597.16.camel@sandisk.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
         <20170309171014.GC12694@obsidianresearch.com>
         <1489098918.2597.12.camel@sandisk.com>
         <20170309224904.GA5867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309224904.GA5867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <DB34BA0A600B8E42BBC82C79475AD773-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 15:49 -0700, Jason Gunthorpe wrote:
> On Thu, Mar 09, 2017 at 10:35:30PM +0000, Bart Van Assche wrote:
> > Something else is also broken, namely the SuSE section in rdma-core.spe=
c. I
> > just figured out that the following is needed to build an RPM on SuSE s=
ystems:
> >=20
> > diff --git a/rdma-core.spec b/rdma-core.spec
> > index f7a440d7..aa486371 100644
> > +++ b/rdma-core.spec
> > @@ -28,7 +28,7 @@ BuildRequires: ninja,make
> >  %define __builder ninja
> >  # cmake_install,make_jobs is specified by opensuse
> >  %define cmake cmake
> > -%define cmake_install DESTDIR=3D%{buildroot} ninja install
> > +%define cmake_install DESTDIR=3D%{buildroot} make install
>=20
> I'm not sure what tree you are looking at? The above '-' line never
> appeared in mainline?
>=20
> The opensuse rpm macros themselves are supposed to provide
> cmake_install, so the spec file should not define it. Did they change
> their macros again or something?
>=20
> We provide it for the RH cases because they use a different cmake rpm
> macro set. :(

Hello Jason,

Sorry, I used the wrong base for the diff command. How about the patch belo=
w
to fix the SuSE build:

diff --git a/rdma-core.spec b/rdma-core.spec
index 6519bc37..aa486371 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -27,6 +27,8 @@ BuildRequires: valgrind-devel
 BuildRequires: ninja,make
 %define __builder ninja
 # cmake_install,make_jobs is specified by opensuse
+%define cmake cmake
+%define cmake_install DESTDIR=3D%{buildroot} make install
=20
 # Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
 # which is totally inappropriate and breaks building 'ENABLE_EXPORTS' styl=
e

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
