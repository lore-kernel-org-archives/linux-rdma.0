From: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: root owned writable files under /sys
Date: Thu, 18 Nov 2010 14:59:00 +0200
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443D1BDCA193@MTLMAIL.mtl.com>
References: <4C082598.8000809@oracle.com> <4C0B2B24.6020304@Voltaire.com>
	<4C0BC819.1060201@oracle.com> <4C3413BD.5030008@Voltaire.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443B38B99C02@MTLMAIL.mtl.com>
	<4C43309E.4020001@Voltaire.com> <4CE4F811.2010006@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE4F811.2010006-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Port trigger belongs to Yevgeny P.
Please interact with him regarding this.

-Jack

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org]
Sent: Thursday, November 18, 2010 11:55 AM
To: Jack Morgenstein
Cc: Sumeet Lahorani; Tziporet Koren; Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Yevgeny Petrilin
Subject: Re: root owned writable files under /sys

Jack,

I didn't see any further response on the matter, I got customers to complain on why the port_trigger sysfs entry is world writable and I wonder why isn't this pushed upstream, once you guys do that we can fix the permissions. Also they noted that the diag_counters entry has the same problem and its also not upstream (ofed patch mlx4_0320_diag_counters_sysfs.patch), can some progress be made here?

Or.

Or Gerlitz wrote:
> Jack Morgenstein wrote:
>> The sysfs entries you refer to are introduced in commit 7ff93f8b7ecbc36e7ffc5c11a61643821c1bfee5
>> which patches in ofed but not upstream are you referring to?
>
> Hi Jack,
>
> I took another look, indeed the mlx4_port{1,2} sysfs entries are introduced in the commit
> you pointed on and their permissions looks okay (S_IRUGO | S_IWUSR), they are not world writable.
>
> As for the port_trigger sysfs entry, it is introduced by a patch shipped with ofed which isn't upstream (mlx4_1190_sense_port_trigger.patch) and indeed this entry is world writable.
>
> So the question here, if there's any reason for multi-protocol related patches such as this
> guy and its such not to be pushed upstream? I failed to get any constructive response (== pathces to Roland or Dave Miller) from Yevgeny and I was hoping you could be helpful here.
>
> Or.
>
>> Sumeet Lahorani wrote:
>>> # find /sys -type f -perm -222
>>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/port_trigger
>>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port2
>>> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
