From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rmmod mlx4_core panic 3.16-rc1
Date: Sun, 22 Jun 2014 13:25:52 +0300
Message-ID: <CAJZOPZ+_uZzyh2-t6n4rVAFnD4fDpm2cAbfGef-aakH7vOCSWg@mail.gmail.com>
References: <53A259F3.3040203@oracle.com>
	<CAJZOPZK__Qo2LcTpL3R0=WOzsLKY2FYT_7VkKXThGiPWF8wv_g@mail.gmail.com>
	<53A46C2B.8030301@oracle.com>
	<53A6A1DD.3020907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A6A1DD.3020907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 22, 2014 at 12:29 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> As for the crash you reported, indeed, it seems we have a bug there on the error flow of module loading when single ported VF are requested in conjunction with IB ports. I have it fixed on my system with this patch which are will review etc


Just posted a patch fixing the crash you reported to netdev
http://marc.info/?l=linux-netdev&m=140343252214146&w=2

Thanks for the report and tell us if you have further issues.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
