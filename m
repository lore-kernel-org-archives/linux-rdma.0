From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Sat, 25 Jun 2011 11:42:31 +0200
Message-ID: <BANLkTinuQKz9_uBZVDirNMaEH1WVRyMEnQ@mail.gmail.com>
References: <201106251010.30994.bvanassche@acm.org> <20110625085843.GA3172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110625085843.GA3172-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 25, 2011 at 10:58 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>=
 wrote:
>
> On Sat, Jun 25, 2011 at 10:10:30AM +0200, Bart Van Assche wrote:
> > SCSI scanning of a channel:id:lun triplet in Linux works as follows=
 (function
> > scsi_scan_target() in drivers/scsi/scsi_scan.c):
> > - If lun =3D=3D SCAN_WILD_CARD, send a REPORT LUNS command to the t=
arget and
> > =A0 process the result.
> > - If lun !=3D SCAN_WILD_CARD, send an INQUIRY command to the LUN co=
rresponding
> > =A0 to the specified channel:id:lun triplet to verify whether the L=
UN exists.
> > So a SCSI driver must either take the channel and target id values =
in account
> > in its quecommand() function or it should declare that it only supp=
orts one
> > channel and one target id. Currently the ib_srp driver does neither=
=2E As a
> > result scanning the SCSI bus via e.g. rescan-scsi-bus.sh causes man=
y
> > duplicate SCSI devices to be created. For each 0:0:L device, severa=
l
> > duplicates are created with the same LUN number and with (C:I) !=3D=
 (0:0). Fix
> > this by declaring that the ib_srp driver only supports one channel =
and one
> > target id.
>
> Looks good. =A0We should probably consider chosing sane defaults at l=
east
> for max_channel, but for now this is the best fix.

The default for max_channel is already zero, so strictly speaking it
is not necessary to set max_channel in srp_target_create(). I choose
to set it anyway to make the intent clear that currently ib_srp only
supports channel =3D=3D 0 and id =3D=3D 0.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
