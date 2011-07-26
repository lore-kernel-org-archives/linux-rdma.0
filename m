From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Tue, 26 Jul 2011 15:57:35 +0300
Message-ID: <20110726125735.GB1948@calypso.mtl.com>
References: <20110710120442.GA11284@localhost.localdomain>
 <20110712162740.29e2d7d1.weiny2@llnl.gov>
 <20110712235222.GG10216@obsidianresearch.com>
 <20110712165817.16076a3d.weiny2@llnl.gov>
 <20110713041441.GA26663@obsidianresearch.com>
 <20110713082640.GA2024@localhost.localdomain>
 <CAL1RGDVXJd7Sq0-CcYR6heN_HCsrmc1CtrkKfxLWxYe3WN=ghA@mail.gmail.com>
 <20110714161056.GB4502@obsidianresearch.com>
 <20110714092129.b29a7ca0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110714092129.b29a7ca0.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:21 Thu 14 Jul     , Ira Weiny wrote:
> On Thu, 14 Jul 2011 09:10:56 -0700
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>=20
> > On Wed, Jul 13, 2011 at 05:40:57PM -0700, Roland Dreier wrote:
> > > On Wed, Jul 13, 2011 at 1:26 AM, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=
 wrote:
> > > > +dnl Where to place opensm.pid
> > > > +piddir=3D/var/run
> > >=20
> > > FWIW the future seems to be /run instead of /var/run, eg
> > > http://lists.fedoraproject.org/pipermail/devel/2011-March/150031.=
html
> > >=20
> > > Not sure what the best way to handle this in a way that doesn't c=
ause
> > > hassles for packagers is.
> >=20
> > Donno, I find it still unclear if /run is just for early boot stuff
> > that might start prior to /var being mounted or a general replaceme=
nt
> > for all /run directories - I think it is the just for early boot
> > stuff, and /var/run will bind mount/symlink to it (maybe forever?)?
> >=20
> > In any event, it is the packager's responsibility to understand det=
ails
> > like this for their distribution..
>=20

There is a Filesystem Hierarchy Standard from 2004, which
define the use of /var/run/ as:

This directory contains system information data describing the system s=
ince it
was booted. Files under this directory must be cleared (removed or trun=
cated
as appropriate) at the beginning of the boot process. Programs may have=
 a
subdirectory of /var/run; this is encouraged for programs that use more=
 than
one run-time file. [42] Process identifier (PID) files, which were orig=
inally
placed in /etc, must be placed in /var/run. The naming convention for P=
ID
files is <program-name>.pid. For example, the crond PID file is named
/var/run/crond.pid.

http://proton.pathname.com/fhs/pub/fhs-2.3.html#VARRUNRUNTIMEVARIABLEDA=
TA


> It seems like the right thing to do would be to use an autoconf varia=
ble like "localstatedir".  But every reference I find seems to indicate=
 it is not automatic to say the least...
>=20
> http://www.linuxfromscratch.org/pipermail/lfs-support/2003-June/01772=
0.html
> http://openbsd.monkey.org/ports/200001/msg00065.html
> http://www.spinics.net/lists/ac/msg04439.html
>=20
> http://fedoraforum.org/forum/showthread.php?t=3D262824
> https://bugzilla.redhat.com/show_bug.cgi?id=3D702769
>=20
> :-(
>=20

There is some confusion about the usage of localstatedir. Here is a
definition of localstatedir:
http://www.gnu.org/prep/standards/html_node/Directory-Variables.html#Di=
rectory-Variables

=E2=80=98localstatedir=E2=80=99
The directory for installing data files which the programs modify while=
 they
run, and that pertain to one specific machine. Users should never need =
to
modify files in this directory to configure the package=E2=80=99s opera=
tion; put such
configuration information in separate files that go in =E2=80=98$(datad=
ir)=E2=80=99 or
=E2=80=98$(sysconfdir)=E2=80=99. =E2=80=98$(localstatedir)=E2=80=99 sho=
uld normally be =E2=80=98/usr/local/var=E2=80=99, but
write it as =E2=80=98$(prefix)/var=E2=80=99. (If you are using Autoconf=
, write it as
=E2=80=98@localstatedir@=E2=80=99.)

Moreover, localstatedir=3D ${prefix}/var could be overwritten by using
config.stte script as described here:
http://www.gnu.org/software/autoconf/manual/autoconf.html#Site-Defaults

So I guess we can define the default piddir=3D@localstatedir@/run/ unle=
ss the
user decides to overwrite it and hope that the packager is using=20
appropriate site.conf. But if he doesn't, the default would be
/usr/local/var/run which isn't a good thing though.


> Ira
>=20
> >=20
> > Jason
>=20
>=20
> --=20
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
