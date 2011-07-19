From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Tue, 19 Jul 2011 13:24:22 +0200
Message-ID: <CAO+b5-rfaf2DQtuGQePivWppzX5YC+Zbj_6Et1U6HrMJF6CLXA@mail.gmail.com>
References: <201106251010.30994.bvanassche@acm.org> <1309018469.6908.3.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309018469.6908.3.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 25, 2011 at 6:14 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Sat, 2011-06-25 at 10:10 +0200, Bart Van Assche wrote:
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
> >
> > Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> > Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
>
> Thanks for the additional detail in the commit message.
>
> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

Hi Dave,

Thanks for acking. Through which tree should this patch go in ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
