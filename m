From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Sun, 16 Oct 2016 10:40:27 -0400
Message-ID: <1e03ceea-5584-6bbb-6fbe-e11d9d251649@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wHI5fggH8XK2i5SS4Mc17sqQt4pXwqoc5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014231934.GC16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wHI5fggH8XK2i5SS4Mc17sqQt4pXwqoc5
Content-Type: multipart/mixed; boundary="NOsDmJiaAIxx2K8wobMStI6guIlpqiRh1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <1e03ceea-5584-6bbb-6fbe-e11d9d251649-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
References: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161014192136.11731-3-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161014231934.GC16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161014231934.GC16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--NOsDmJiaAIxx2K8wobMStI6guIlpqiRh1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/14/2016 7:19 PM, Jason Gunthorpe wrote:
> On Fri, Oct 14, 2016 at 03:21:34PM -0400, Jarod Wilson wrote:

>> diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
>> new file mode 100644
>> index 0000000..1cd031a
>> +++ b/glue/redhat/ibacm.service
>=20
> Can we just put this in ibacm/ ?
>=20
>> +Requires=3Drdma.service
>> +After=3Drdma.service opensm.service
>=20
> This is the only RH specific thiing I see.. Could we standardize on
> something here and use it on all distros? rdma-available.target?

You can't, unless you rename the rdma.service unit file to something
else.  They are tied in that way.

>> +++ b/glue/redhat/rdma.cxgb3.sys.modprobe
>> @@ -0,0 +1 @@
>> +install cxgb3 /sbin/modprobe --ignore-install cxgb3 $CMDLINE_OPTS && =
/sbin/modprobe iw_cxgb3
>> diff --git a/glue/redhat/rdma.cxgb4.sys.modprobe b/glue/redhat/rdma.cx=
gb4.sys.modprobe
>> new file mode 100644
>> index 0000000..44163ab
>> +++ b/glue/redhat/rdma.cxgb4.sys.modprobe
>> @@ -0,0 +1 @@
>> +install cxgb4 /sbin/modprobe --ignore-install cxgb4 $CMDLINE_OPTS && =
/sbin/modprobe iw_cxgb4
>=20
> What are these for? Should they be cross distro? Why are only a few
> drivers this special?

We have one of these for every two (or more) part driver.  They aren't
special, it's just the multipart drivers that are.

>> +++ b/glue/redhat/rdma.fixup-mtrr.awk
>> @@ -0,0 +1,160 @@
>> +# This is a simple script that checks the contents of /proc/mtrr to s=
ee if
>> +# the BIOS maker for the computer took the easy way out in terms of
>> +# specifying memory regions when there is a hole below 4GB for PCI ac=
cess
>> +# and the machine has 4GB or more of RAM.  When the contents of /proc=
/mtrr
>> +# show a 4GB mapping of write-back cached RAM, minus punch out hole(s=
) of
>> +# uncacheable regions (the area reserved for PCI access), then it bec=
omes
>> +# impossible for the ib_ipath driver to set write_combining on its PI=
O
>> +# buffers.  To correct the problem, remap the lower memory region in =
various
>> +# chunks up to the start of the punch out hole(s), then delete the pu=
nch out
>> +# hole(s) entirely as they aren't needed any more.  That way, ib_ipat=
h will
>> +# be able to set write_combining on its PIO memory access region.
>=20
> Yuk, a thousand times yuk.
>=20
> I thought the mtrr cleanup built into modern kernel took care of this?
>=20
> Really though, this needs to be fixed upstream in the kernel :|

It is fixed in recent kernels.  This is a holdover from rhel5 days where
this code made the difference between a 50MBit/s and 850MBit/s qib adapte=
r.

>> diff --git a/glue/redhat/rdma.kernel-init b/glue/redhat/rdma.kernel-in=
it
>> new file mode 100644
>> index 0000000..6cb4732
>> +++ b/glue/redhat/rdma.kernel-init
>=20
> I wonder if this could be split into a generic 'load the modules' part
> and a distro specific part? Every distro needs systemd to load the
> extra modules because out auto-loading is broken - IMHO, and that is
> pretty complex unfortunately.

Yes, this probably could be broken out.

>> +errata_58()
>> +{
>> +    # Check AMD chipset issue Errata #58
>> +    if test -x /sbin/lspci && test -x /sbin/setpci; then
>> +	if ( /sbin/lspci -nd 1022:1100 | grep "1100" > /dev/null ) &&
>> +	   ( /sbin/lspci -nd 1022:7450 | grep "7450" > /dev/null ) &&
>> +	   ( /sbin/lspci -nd 15b3:5a46 | grep "5a46" > /dev/null ); then
>> +	    CURVAL=3D`/sbin/setpci -d 1022:1100 69`
>=20
> Another yuk. Why isn't this handled upstream in drivers/pci/quirks.c
> with the rest of the 8131 errata?
>=20
> Fortunately I expect all 8131 hardware is long since gone, that chip
> was end-of-manufacturing'd very quickly 2003ish IIRC.

See the above about the mtrr registers.  Same thing here.  Holdover from
long ago.

>> +++ b/glue/redhat/rdma.service
>> @@ -0,0 +1,15 @@
>> +[Unit]
>> +Description=3DInitialize the iWARP/InfiniBand/RDMA stack in the kerne=
l
>> +Documentation=3Dfile:/etc/rdma/rdma.conf
>> +RefuseManualStop=3Dtrue
>> +DefaultDependencies=3Dfalse
>> +Conflicts=3Demergency.target emergency.service
>> +Before=3Dnetwork.target remote-fs-pre.target
>=20
> This is an area we really need to cross-distro standardize - we really
> need a set of rdma-*.targets.
>=20
> eg
>  rdma-available.target
>    - RDMA hardware is available and all prep is done
>      opensm (if installed) is started, etc
>      Use in place of rdma.service
>   rdma-detected.target
>    - udev detected rdma hardware

It's not that easy, unfortunately.  Creating a target is a big deal.  A
service is not.  And targets don't work the way someone would expect in
systemd.  Putting a Before=3D tag in a systemd unit file doesn't mean wha=
t
I would expect (I think I'm probably fairly common in this regard, but I
could be wrong).  I would have thought it means "Start this unit before
starting the target listed in the Before=3D line", instead it means "Star=
t
this unit and make sure it finishes before the target in the Before=3D
line is considered complete".  It can be started after the listed target
is started, but the listed target won't be considered complete until it
is also complete.  This caused me lots of heartache when I was creating
these files :-/

Fortunately, the targets listed in the unit files are pretty standard
(they are part of the systemd upstream), and so I think they can be
cross distro just as they are.

>> +# When we detect a new verbs device is added to the system, set the n=
ode
>> +# description on that device
>> +# If rdma-ndd is installed, defer the setting of the node description=
 to it.
>> +SUBSYSTEM=3D=3D"infiniband", KERNEL=3D=3D"*", ACTION=3D=3D"add", TEST=
!=3D"/usr/sbin/rdma-ndd", RUN+=3D"/bin/bash -c 'sleep 1; echo -n `hostnam=
e -s` %k > /sys/class/infiniband/%k/node_desc'"
>=20
> Shouldn't this udev drop-in by in the rdma-ndd package?
>=20
>> +++ b/glue/redhat/srp_daemon.service
>> @@ -0,0 +1,17 @@
>> +[Unit]
>> +Description=3DStart or stop the daemon that attaches to SRP devices
>> +Documentation=3Dfile:///etc/rdma/rdma.conf file:///etc/srp_daemon.con=
f
>> +DefaultDependencies=3Dfalse
>> +Conflicts=3Demergency.target emergency.service
>> +Requires=3Drdma.service
>> +Wants=3Dopensm.service
>> +After=3Drdma.service opensm.service
>> +After=3Dnetwork.target
>> +Before=3Dremote-fs-pre.target
>=20
> Also should be common, why does it reference opensm.service?

Because if opensm is running on this host, then it must be up before the
configured srp targets are valid any time there is a non-default subnet
prefix.

>> +
>> +[Service]
>> +Type=3Dsimple
>> +ExecStart=3D/usr/sbin/srp_daemon.sh
>=20
> Hurm, someday we have to make better systemd integration for these
> daemons..

There really isn't any better integration to get with our complex
daemons unless we update the daemons themselves to get rid of their
shell script starters...


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--NOsDmJiaAIxx2K8wobMStI6guIlpqiRh1--

--wHI5fggH8XK2i5SS4Mc17sqQt4pXwqoc5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYA5FbAAoJELgmozMOVy/dHVkP/RWcXopZv/fj9GsKa4hdgPXk
7W63L2qae+wpAkTLwNjX0VJRBopBnAqnmRHRYyZVF9yB6jqJu8aSDmWj4ZdlPNkn
kKOBJ5Ml3grgfKXtda2mMf/mWQEqpgGERZ7r9VurCskUHzPAOTEdDm+pyuGrBX5E
dLA4XQnp2hivdPd3Hz2UpkQ8VPZJGjoZ0TlK2+RzGfZZSRi5/8lKLaITRff/2XRm
ZsgkGL1w8x6+mnOE1B9anXs+k09m4B+M0ky3JIx9vsgVVoT6CBhGFo0qEiWMqF+H
UmUlP8BMWcyng3schJC6fqCUU117SU1zps7e/F4C84z3WHBPApLhe1Q+UaJrLldV
1yyAbfKVlRZF3CT9ubshScB6ZpsHiDrcLcWGlc0zI2O/qH9wqVIaccNkOkHB3kFx
7TE2NPidt2kf4gN4TZw3TaIKLc8dUHsg0z0tnRQii8lbtr4CRNVrwJs60dJimWGC
IQ/Uet2Ns1fM0QDib6Zz6CC8W6I1H0apUxBZv/4eL5Tnwb4zzRDg0RQTAxxtHdSg
Z24jdHm2jflApBjbjqgl5ZBBMWhrvAeocrNwkLKQmRyrbpgaObGtZH1L0MAz1wcw
T3qyLn2u0zJSeJFLK1a1Z/+9ro5FEhmJ5ek//GQ70lnponZAnwtfjriQfh9F2rNa
Ggrb9fOp9F20OXERUUD/
=p74s
-----END PGP SIGNATURE-----

--wHI5fggH8XK2i5SS4Mc17sqQt4pXwqoc5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
