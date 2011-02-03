From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: SRP automatic target discovery
Date: Thu, 3 Feb 2011 12:32:05 +0100
Message-ID: <AANLkTin+Lc5e3VB05n5dHtUykPTPoQyuGZWp3n3KN++d@mail.gmail.com>
References: <4D49BE2B.3000503@hpc.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D49BE2B.3000503-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 2, 2011 at 9:27 PM, Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org> w=
rote:
>
> I'm having a problem with SRP automatic target discovery. =A0I am usi=
ng srp_daemon with OFED 1.5.2 on the initiator. =A0My one target machin=
e with several LUNs also uses OFED 1.5.2, and I am using scst 2.0.0.1 a=
nd srpt 2.0.0 on top of that.
>
> On the initiator, I have SRP_LOAD=3Dyes and SRP_DAEMON_ENABLE=3Dyes. =
=A0This seems to work fine, and after rebooting, I can see the SRP targ=
ets on the initiator, and srp_daemon running in the background:
>
> [root@hpcoss2 ~]# ps auxww | grep srp
> root =A0 =A0 =A06635 =A00.0 =A00.0 =A063840 =A01176 ? =A0 =A0 =A0 =A0=
S =A0 =A012:04 =A0 0:00 /bin/bash /usr/sbin/srp_daemon.sh
> root =A0 =A0 =A06638 =A00.0 =A00.0 =A063836 =A01164 ? =A0 =A0 =A0 =A0=
S =A0 =A012:04 =A0 0:00 /bin/bash /usr/sbin/run_srp_daemon -e -c -n -i =
mlx4_1 -p 1 -R 60 -V
> root =A0 =A0 =A06647 =A00.0 =A00.0 =A031012 =A0 996 ? =A0 =A0 =A0 =A0=
SLl =A012:04 =A0 0:00 srp_daemon -e -c -n -i mlx4_1 -p 1 -R 60 -V
>
> But if I add an additional target on the same target machine with, sa=
y:
>
> [root@hpcoss1 ~]# echo "add 7:0:1:0 3" >/proc/scsi_tgt/groups/Default=
/devices
>
> the srp_daemon on the initiator never sees the new storage and restar=
ting srp_daemon doesn't seem to help.
>
> If I remove the SRP scsi devices, unload the ib_srp module, and reloa=
d it, I can see the new LUN (and I don't need to restart srp_daemon, ei=
ther). =A0But I don't think that is how it is supposed to work.

Hello Craig,

In addition to what Dave and Vlad already wrote:
* In the SCSI Architectural Model (SAM) it is specified that a logical
unit shall generate a unit attention condition whenever e.g. the
INQUIRY data has changed. The mechanism for reporting unit attention
conditions to an initiator is transport specific.
* As Vlad explained, the SCST core supports this mechanism. The
ib_srpt driver however ignores unit attention conditions and does not
propagate these to the SRP initiator.
* The mechanism defined in the SRP draft for reporting unit attention
conditions by a target to an initiator is the SRP_AER_REQ information
unit.
* Neither the Linux SRP initiator nor the VMware ESX initiator nor the
Windows SRP initiator currently support the SRP_AER_REQ information
unit. Even worse, some versions of these initiators cause a kernel
crash upon reception of a SRP_AER_REQ information unit.
* Support in the Linux SCSI layer (at the initiator side) for unit
attention conditions is very limited. Currently only media change
events are supported (SDEV_EVT_MEDIA_CHANGE).
* As Dave already wrote, you can tell the initiator SCSI layer to
rescan LUNs manually. This script can be convenient to rescan LUNs:
http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh-1.48.
* The goal of srp_daemon is to discover targets. It is out of scope
for srp_daemon to detect LUN changes of a target.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
