From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] srp_daemon.service: Add support for
 hot-plugging
Date: Wed, 24 May 2017 20:33:32 +0000
Message-ID: <1495658010.2823.36.camel@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
         <20170515224733.29586-12-bart.vanassche@sandisk.com>
         <20170515232551.GA10834@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515232551.GA10834-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <81921B828E85B1498D194F83F91C8F95-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-05-15 at 17:25 -0600, Jason Gunthorpe wrote:
> On Mon, May 15, 2017 at 03:47:33PM -0700, Bart Van Assche wrote:
> > srp_daemon.service is modified such that instead of starting
> > /usr/sbin/srp_daemon.sh that it does not start any process. A new
> > template service is added, namely srp_daemon_port@.service. This
> > service replaces srp_daemon.sh and controls /usr/sbin/srp_daemon
> > for a single port. A udev rule is added that instantiates the
> > srp_daemon_port@.service every time an RDMA port is hot-added.
> > Since the per-port service depends on the srp_daemon service,
> > starting or stopping the srp_daemon service affects all per-port
> > services.
>=20
> This looks pretty good to me ... You are happy with how the user experien=
ce works?

Yes, except for one aspect, namely that starting srp_daemon does not start
the per-port services. I have addressed that as follows in srp_daemon.servi=
ce:

ExecStart=3D.../srp_daemon_start_all.sh

where srp_daemon_start_all.sh is the following script:

#!/bin/sh
for p in /sys/class/infiniband/*/ports/*; do
=A0=A0=A0=A0[ -e "$p" ] || continue
=A0=A0=A0=A0p=3D${p#/sys/class/infiniband/}
=A0=A0=A0=A0nohup /usr/bin/systemctl start "srp_daemon_port@${p/\/ports\//:=
}" </dev/null >&/dev/null &
done

> A few minor thoughts
>=20
> > +++ b/srp_daemon/90-srp-daemon.rules
> > @@ -0,0 +1 @@
> > +ACTION=3D=3D"add", SUBSYSTEM=3D=3D"infiniband_mad", PROGRAM:=3D"/usr/b=
in/systemctl show srp_daemon -p UnitFileState", RESULT=3D=3D"UnitFileState=
=3Denabled", TAG+=3D"systemd", ENV{SYSTEMD_WANTS}+=3D"srp_daemon_port@$attr=
{ibdev}:$attr{port}.service"
>=20
> I think we should have a main rdma udev rules file that always creates
> .device targets inside systemd for umad, unconditionally. This should
> be useful for other things like opensm/etc.
>=20
> So we'd have a line like:
>=20
> ACTION=3D=3D"add", SUBSYSTEM=3D=3D"infiniband_mad", TAG+=3D"systemd", ENV=
{SYSTEMD_ALIAS}=3D"/dev/infiniband/umad/$attr{ibdev}:$attr{port}"
>=20
> So we get (unescaped)
>=20
> /dev/infiniband/umad0.device
> /dev/infiniband/umad/mlx4_0:0.device
>=20
> Then the srp-daemon.rule would just be the wants:
>=20
> ACTION=3D=3D"add", SUBSYSTEM=3D=3D"infiniband_mad", PROGRAM:=3D"/usr/bin/=
systemctl show srp_daemon -p UnitFileState", RESULT=3D=3D"UnitFileState=3De=
nabled", ENV{SYSTEMD_WANTS}+=3D"srp_daemon_port@$attr{ibdev}:$attr{port}.se=
rvice"
>=20
> > index 00000000..666400ab
> > +++ b/srp_daemon/srp_daemon_port@.service
> > @@ -0,0 +1,18 @@
> > +[Unit]
> > +Description=3DSRP daemon that monitors port %i
> > +Documentation=3Dman:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_=
daemon.conf
> > +DefaultDependencies=3Dfalse
> > +Conflicts=3Demergency.target emergency.service
> > +Requires=3Drdma.service
> > +Wants=3Dopensm.service
> > +After=3Drdma.service opensm.service srp_daemon.service
> > +After=3Dnetwork.target
> > +Before=3Dremote-fs-pre.target
> > +BindsTo=3Dsrp_daemon.service
>=20
> Using the new .device, we can add a requires:
>=20
> Requires: -dev-infiniband-umad0-%i.device
>=20
> Now, systemd will never start the port service until udev says that
> the umad is available for that port. It will actually wait until udev
> says that umad is present if something requires it.

All of this has been addressed in the following updated pull request:
https://github.com/linux-rdma/rdma-core/pull/135

> I also wonder if the systemd activation protocol should be used by
> srp_daemon, this should defer mount until srp_daemon has done the
> right stuff, but that might be no good if the 'right stuff' requires a
> link up?
>
> However, if the admin is using the above .mount unit Requires then
> they would want to wait until the link is up and the SM has been
> contacted before attempting the first mount? systemd obnoxiously does
> not have mount retries so everything should be perfect before mount is
> done.

I think that systemd mount units should have a dependency on /dev/disk/by-i=
d
or /dev/disk/by-uuid instead of srp_daemon. Even after an srp_daemon_port@
service has been started it can take some time
before login occurs. Using a
dependency on /dev/disk/by-*id avoids that the mount service gets started
before the path it needs is available.

> Does
>   systemctl mask srp_daemon_port@mlx4_0:1
>=20
> Work to inhibit the daemon on a specific port? If yes that should be
> mentioned in here I think. Otherwise, we probably still need a way to
> do that.

Information about masking has been added to the srp_daemon_port@ man page.

> The final bits would be to see if any security sandboxing options are
> appropriate for the .unit file, since srp_daemon is network
> facing. Drop caps, ro filesystems, etc. It should also dump root.

Sorry but since srp_daemon writes=A0into /sys/class/infiniband_srp/*/add_ta=
rget
I don't think it's possible to drop root privileges for the srp_daemon_port=
@
service.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
