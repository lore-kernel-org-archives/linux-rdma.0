From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Quick mlx4 IB SR-IOV howto?
Date: Tue, 11 Dec 2012 20:29:13 +0200
Message-ID: <50C77B79.3010704@gmail.com>
References: <CAL1RGDU0XPCyS6fVeHHxnhLHpREjqi6kjKFCX8hBwrLuVD2HwA@mail.gmail.com> <loom.20121208T110331-55@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20121208T110331-55-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi-Man Ma <eye548-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yi-Man.

>   
>
> Hi,
>
> You enabled SR-IOV on ConnectX-3 adapter successfully.
> I also tried to do the same thing, but I failed.
> What did you do to enable SR-IOV on ConnectX-3 adapter?
> I tried following steps:
> 1. Enable Intel VT-d in BIOS and in the kernel.
In some servers this isn't enough, there is a "virtualization 
technology" option and you need to enable it too.
> 2. rmmod mlx4_en
>     rmmode_mlx4_core
>     modprobe mlx4_core  sr_iov=1 probe_vf=1
> But it failed.
Do you have an SR-IOV capable firmware in your HCA?

> Do I still have other things to do for enabling SR-IOV on ConnectX-3 adapter?
>
>
The output of dmesg or /var/log/messages with the error message can be 
useful.

Thanks
Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
