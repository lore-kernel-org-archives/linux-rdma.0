From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: root owned writable files under /sys
Date: Wed, 7 Jul 2010 14:25:34 +0300
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443A943033CD@MTLMAIL.mtl.com>
References: <4C082598.8000809@oracle.com> <4C0B2B24.6020304@Voltaire.com>
	<4C0BC819.1060201@oracle.com> <4C3413BD.5030008@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3413BD.5030008-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/7/2010 8:42 AM, Or Gerlitz wrote:
>
> Jack, Tziporet 
>
> Can you clarify the status of the upstream kernel mlx4 multi-protocol support? looking on Linus git, I see one commit, 7ff93f8b7ecbc36e7ffc5c11a61643821c1bfee5 "mlx4_core: Multiple port type support" dated to Oct 2008, wheres ofed ships couple of patches touching this area, e.g adding the above sysfs entries. So what is the extra functionality introduced or bug/s fixed by those patches? any reason not to push them upstream? 
>
Jack is on vacation and will be back in 2 weeks
I will ask him to look at this when he is back

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
