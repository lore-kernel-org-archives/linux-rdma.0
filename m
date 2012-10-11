From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: if/how to dictate IB device name per PCI BDF
Date: Thu, 11 Oct 2012 13:02:45 +0200
Message-ID: <5076A755.30605@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

We got a report that on a system with multiple (say two) ConnectX HCAs, 
its possible
for the order of device probing to be different across simple reboots, 
that is sometimes
the device with PCI BDF X is probed 1st and gets to be IB device mlx4_0 
and some
other-timesthe device with BDF Y gets to be mlx4_0 and X becomes mlx4_1, 
and so on,
which for some reason creates a hassle for them.

I don't fully understand how the PCI scan order can change between 
different
reboots, but have the feeling its possible (in black box manner, the 
reports claims that).

Thinking about this a bit, will it be possible to provide a udev 
rulethat can dictate
to the IB core what name / suffix digit to assign for a device with 
certain BDF?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
