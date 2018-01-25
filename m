From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 0/3] IB/srp patches for kernel v4.16
Date: Thu, 25 Jan 2018 10:47:54 -0500
Message-ID: <1516895274.27592.125.camel@redhat.com>
References: <20180122222713.13197-1-bart.vanassche@wdc.com>
         <1516727351.27592.46.camel@redhat.com> <1516743303.3339.36.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NA7WgBZfrmPjDXVYRiZN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516743303.3339.36.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-NA7WgBZfrmPjDXVYRiZN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-23 at 21:35 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-23 at 12:09 -0500, Doug Ledford wrote:
> > I took the series as is.  But, I don't know the target core well enough
> > to know what the third patch actually does (that doesn't impact my
> > decision to take it, it's a knob into the target core to allow you to
> > tweak things, that's obvious enough and since you find it useful, I hav=
e
> > no problem with it).  I know the cmd_per_lun setting sets the queue
> > depth of the scsi device on the initiator side, I would have assumed
> > that normally mirrors the advertised ability of the target, but this
> > patch now makes me think otherwise.  So what does this third patch
> > actually do to the target code?
>=20
> Hello Doug,
>=20
> Thanks! Regarding the third patch: the word "target" in the "target_can_q=
ueue"
> member refers to a parameter at the SCSI initiator side. The object hiera=
rchy
> in the Linux SCSI initiator stack is as follows:
> * The top level objects are called SCSI hosts (struct Scsi_Host). These o=
bjects
>   have a representation in sysfs under /sys/class/scsi_host/ and also und=
er
>   /sys/class/scsi_host.
> * The next level objects are called SCSI targets (struct scsi_target). Th=
ere is
>   one directory per SCSI target in sysfs, e.g. /sys/bus/scsi/devices/targ=
et1:0:0.
> * The lowest level objects are called SCSI devices (struct scsi_device). =
There
>   is one directory per SCSI device instance in /sys/class/scsi_device/ an=
d also
>   in /sys/bus/scsi/devices/.
>=20
> Each SCSI device is identified by four numbers, called the host, channel,=
 ID
> and LUN indexes. Usually these four numbers are mentioned in the order H:=
C:I:L.
> The host part (H) identifies the SCSI host. The H:C:I part identifies the=
 SCSI
> target. From drivers/scsi/scsi_scan.c:
>=20
> 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
>=20
> And from drivers/scsi/scsi_sysfs.c:
>=20
> 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
> 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>=20
> Unlike other block drivers, the SCSI core imposes more restrictions on th=
e
> number of commands that can be queued than just the queue depth of the bl=
ock
> layer device.

Sure, I know most of the stuff above, as I used to maintain the aic7xxx
driver back when SCSI was actually popular.  But the target layer in the
scsi core didn't exist back in the day.  Our structure was block layer-
>scsi disk/scsi cd-rom drivers->scsi core->scsi low level driver.  The
setup back then was that block layer had its own request queue depth,
then it would pass block layer requests to the scsi disk driver that
turned them into scsi command blocks and would issue up to host-
>cmd_per_lun scbs at a time (assuming the device allowed tagged
commands, without that you only got one at a time).  Being out of the
loop, but knowing how things used to work, I figured the SRP driver
already controlled how many commands would be presented to the target at
the other side by hooking into the scsi core as a low level device
driver and setting cmd_per_lun.  I think what's happened in the
intervening years is that they seem to have taken the scsi disk driver
and scsi cd-rom drivers and replaced them with a generic target driver
that handles all block targets and then uses the old scsi disk and scsi
cd-rom drivers as personalities for the given target, yes?  And they now
allow per-target command depth setting where as in the old days the
queue depth for all tagged allowed targets was the device driver's
cmd_per_lun, yes? (Back when I worked on this, multi-lun devices were
not well supported, and cmd_per_lun, which should have really been
cmd_per_device, was truly applied per lun and could easily cause a
tagged device to have many more outstanding commands than intended if it
was a multi-lun tagged capable device, at least on the old aic7xxx
driver it could)  So that the queue depth on devices now a days is
essentially min(target->can_queue, shost->cmd_per_lun), yes?

>  The maximum number of commands that the block layer is allowed to
> queue per SCSI host is Scsi_Host.can_queue. The maximum number of command=
s
> that can be queued per SCSI target is scsi_target.can_queue. And the limi=
t for
> a single SCSI device is Scsi_Host.cmd_per_lun. See also scsi_host_is_busy=
(),
> scsi_target_is_busy() and scsi_device_is_busy() in the SCSI core.
>=20
> Bart.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-NA7WgBZfrmPjDXVYRiZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpp/CoACgkQuCajMw5X
L90Kgw//Y7HW250rRGgOLrOSfKGRxuqEn5TSXDro5BVxmrMsnxMx+hPE9NHOqiMm
lLwLCAg2e4LKtfl++nE7k7KKJV88/987E1AjLq6p7Z0hxG4Nyyk1i9jGL3a8UKMF
LSY5K8ZYutwXkrsIdW/MDFTyqJCtniPP8ZCt7IrY0xWBz5MVXr4p09zi2OMG7yc2
S2nxmItNuG4/YrZSi7/2UcyWfoAU7PaGh4EpqQZRpg3DsG3+1i7T3XeSsEQ3BVMK
sy7eLmDsDL3uer01XtBwWofuZo6/hzeWz/R56ziHvauKO4bCDcAcEMz08+Y9Gchr
C/rd6il34oybzBPtEzMKltVe4esFwh0ofIs37B3BUL+OQsaeT1KBXN+mDVYWZbsW
nhh23TFtqvK59wOkrnlDQjJo4UOAjGeoCG2knTgbTc5E3mxj3wP9hKr7FKOHwYVz
lwZ8iVlJPnb+c1GVnCV7eOTnqs2O2/pCMwS6yEngeBSV67M7GIsJPZxiZ4yoTs4V
5ISdqMkgCTT54w2ZYlGAhxuHXOIeKrZka24cjMetQaVtDuUefxdvzWeogSgDSfNQ
rv4FP79ny4FyACcxUuBc+48t5zPJJJBLIA/+zbchCc7EUybPPMGETkW8vBYiiX2b
QDtQV+jk+kHc9ARiR6IATf67gYA3WbHLjB7HIgknbVMSsYbqeOM=
=D//x
-----END PGP SIGNATURE-----

--=-NA7WgBZfrmPjDXVYRiZN--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
