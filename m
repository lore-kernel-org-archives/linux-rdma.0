From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: Mellanox VPI
Date: Sun, 6 Oct 2013 14:53:18 +0400
Message-ID: <CACaajQu=xNfvnNZShVsy_wYk3D7WJERk7Yofgf_YiJHHCK6W3Q@mail.gmail.com>
References: <CACaajQtgK1OC1_2QwY_DK7nnxcxCJh0sbs-fM7vvYjvEF8b5Zg@mail.gmail.com>
 <CAJZOPZJYc83JRc61LPG=--9VaM4DRWojsUFrhbjAcaGN7anSuQ@mail.gmail.com>
 <CACaajQsgXQm=0q9uHWxXQfRfwoFZHRFDfyMDYbee72ohpcSfmA@mail.gmail.com> <52511E5E.8090802@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52511E5E.8090802-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2013/10/6 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> # lspci | grep Mell
>
> 06:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0
> 5GT/s - IB QDR / 10GigE] (rev b0)
> 07:00.0 Network controller: Mellanox Technologies MT27520 Family
>
> # echo ib > /sys/bus/pci/devices/0000\:06\:00.0/mlx4_port1
> # echo eth > /sys/bus/pci/devices/0000\:06\:00.0/mlx4_port2


Thanks, but as i see this car have two ports.
How about eth and ib on the same port in the same time?

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
