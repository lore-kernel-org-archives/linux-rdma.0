From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Mellanox VPI
Date: Sun, 6 Oct 2013 16:02:08 +0200
Message-ID: <20131006160208.679c1c2c@jpm-OptiPlex-GX620>
References: <CACaajQtgK1OC1_2QwY_DK7nnxcxCJh0sbs-fM7vvYjvEF8b5Zg@mail.gmail.com>
	<CAJZOPZJYc83JRc61LPG=--9VaM4DRWojsUFrhbjAcaGN7anSuQ@mail.gmail.com>
	<CACaajQsgXQm=0q9uHWxXQfRfwoFZHRFDfyMDYbee72ohpcSfmA@mail.gmail.com>
	<52511E5E.8090802@mellanox.com>
	<CACaajQu=xNfvnNZShVsy_wYk3D7WJERk7Yofgf_YiJHHCK6W3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQu=xNfvnNZShVsy_wYk3D7WJERk7Yofgf_YiJHHCK6W3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 6 Oct 2013 14:53:18 +0400
Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org> wrote:

> 2013/10/6 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> > # lspci | grep Mell
> >
> > 06:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI
> > PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
> > 07:00.0 Network controller: Mellanox Technologies MT27520 Family
> >
> > # echo ib > /sys/bus/pci/devices/0000\:06\:00.0/mlx4_port1
> > # echo eth > /sys/bus/pci/devices/0000\:06\:00.0/mlx4_port2
> 
> 
> Thanks, but as i see this car have two ports.
> How about eth and ib on the same port in the same time?
> 
You cannot have ETH and IB link layers existing on the same port at the
same time.

However, you can run IB applications over an ETH link layer by using
RoCE (RDMA over Converged Ethernet). If you do:

	ibv_devinfo

on a host where an HCA has a port configured to an ETH link layer,
you should see an entry for the ETH layer port.  Under that port
number, you will see:

	...
	link_layer:	Ethernet

-Jack

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
