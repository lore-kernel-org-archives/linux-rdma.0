From: Yi-Man Ma <eye548-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Quick mlx4 IB SR-IOV howto?
Date: Sat, 8 Dec 2012 10:09:12 +0000 (UTC)
Message-ID: <loom.20121208T110331-55@post.gmane.org>
References: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland@...> writes:

> 
> So I have SR-IOV enabled on a ConnectX-3 adapter, and I loaded the
> driver with num_vfs=1 probe_vf=1, so in the host I see:
>  
> Thanks,
>   Roland
> --
 

Hi,

You enabled SR-IOV on ConnectX-3 adapter successfully.
I also tried to do the same thing, but I failed.
What did you do to enable SR-IOV on ConnectX-3 adapter?
I tried following steps:
1. Enable Intel VT-d in BIOS and in the kernel.
2. rmmod mlx4_en
   rmmode_mlx4_core
   modprobe mlx4_core  sr_iov=1 probe_vf=1
But it failed.

Do I still have other things to do for enabling SR-IOV on ConnectX-3 adapter?

Thanks,
Yi-Man

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
