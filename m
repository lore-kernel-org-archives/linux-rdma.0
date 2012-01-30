From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Help with strange problem passing mlx4 device into kvm guests
Date: Sun, 29 Jan 2012 18:29:44 -0800
Message-ID: <CAL1RGDWeDeua-_nVOC7xh5t7E76CJVNGXaMfBxnG==9Wj5z=RQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

I'm having a strange problem passing an mlx4 device into a kvm guest.
The device in question is:

    05:00.0 InfiniBand [0c06]: Mellanox Technologies MT26428 [ConnectX
VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] [15b3:673c] (rev b0)

running the latest (I believe) FW version 2.9.1000.  The host system
is a fairly standard dual-socket Xeon 5600 system, perhaps a tiny bit
unusual in that it is a dual Tylersburg motherboard.  I'm using

    QEMU emulator version 1.0 (qemu-kvm-1.0 Debian 1.0+dfsg-3),
Copyright (c) 2003-2008 Fabrice Bellard

and

    Linux pure-driver3 3.1.0-1-amd64 #1 SMP Tue Jan 10 05:01:58 UTC
2012 x86_64 GNU/Linux

(the latest Debian testing versions).  The symptom of the problem is
that when the mlx4_core driver starts, I get normal output like

    mlx4_core 0000:00:04.0: FW version 2.9.1000 (cmd intf rev 3), max
commands 16
    mlx4_core 0000:00:04.0: Catastrophic error buffer at 0x1f020, size
0x10, BAR 0
    mlx4_core 0000:00:04.0: FW size 385 KB

up until the driver tries to enable interrupts, when I get a long
stream of

    Completion event for bogus CQ 00000000

and then it gives up because the NOP command interrupt test
fails.

Apparently what happens is that the SW2HW_EQ firmware command succeeds
as far as the driver is concerned, but the EQ buffer is left as all
0s, so the driver thinks every entry is a completion event (for CQN 0).

Several things are weird here: first, the command interface including
DMA from the device is definitely working since we get a
reasonable-looking response for the query FW command etc, so I'm not
sure what is different about the SW2HW_EQ command (it is the first
thing that uses the MTT I guess, so maybe there is a problem setting
that up?)  The guest is running 2.6.39, so there is no SR-IOV support
in the mlx4 driver (but I am passing the only physical function of a
non-virtualized device through, so I hope that isn't needed -- the
device shouldn't know it's talking to a guest at all)

Second, passing through another device on the same system:

    86:00.0 Ethernet controller [0200]: Intel Corporation 82599EB 10
Gigabit TN Network Connection [8086:151c] (rev 01)

works fine, including MSI-X interrupts, running traffic works, etc.

Finally, the craziest thing is that this setup was working a week or
so ago, but there may have been BIOS, kernel and kvm updates since
then (my guest image is unchanged at least ;).

Anyone have any idea what might be going on or how to debug this
further?  Unfortunately I don't have a PCIe analyzer handy to get a
better idea of what's happening with the device...

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
