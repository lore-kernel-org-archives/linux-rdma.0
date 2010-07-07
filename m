From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: root owned writable files under /sys
Date: Wed, 07 Jul 2010 08:42:21 +0300
Message-ID: <4C3413BD.5030008@Voltaire.com>
References: <4C082598.8000809@oracle.com> <4C0B2B24.6020304@Voltaire.com> <4C0BC819.1060201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C0BC819.1060201-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sumeet Lahorani wrote:
> # find /sys -type f -perm -222
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/port_trigger
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port2
> /sys/devices/pci0000:00/0000:00:04.0/0000:13:00.0/mlx4_port1

Jack, Tziporet 

Can you clarify the status of the upstream kernel mlx4 multi-protocol support? looking on Linus git, I see one commit, 7ff93f8b7ecbc36e7ffc5c11a61643821c1bfee5 "mlx4_core: Multiple port type support" dated to Oct 2008, wheres ofed ships couple of patches touching this area, e.g adding the above sysfs entries. So what is the extra functionality introduced or bug/s fixed by those patches? any reason not to push them upstream? 


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
