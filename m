From: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 partitions + SR-IOV - P_Key not found
Date: Thu, 6 Apr 2017 08:19:28 -0600
Message-ID: <CADvaNzWedJOts4z6Nr3Ssx4Qur09h4=iY9mhZBxH4KdPnJke_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am using a ConnectX-3 (MCX354A-FCB_A2-A5).  The system is Ubuntu
16.04 with 4.4.0-72-generic

I can use partitions fine with the root device, and I can do
unpartitioned ipoib in qemu-kvm using virtual functions.

However, when I try to use a partition in the guest, it gives me
errors like this: ib0.8010: P_Key 0x8010 is not found

I tried both the inbox mlx4 driver and OFED 4.0-2.0.0.1

Should partitions work with SR-IOV virtual functions?  If so, what
should I do to debug this?

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
