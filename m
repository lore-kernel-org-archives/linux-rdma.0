From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Bug report: ConnectX-5 unable to use non-default P_Key
Date: Mon, 28 Aug 2017 18:54:58 -0400
Message-ID: <1503960898.52034.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is with plain 4.13-rc7.

Attempts to bring up the 0x8002 P_Key IPoIB device using dhcp fail and
NetworkManager releases the device.

Switch to static IP configuration, the device comes up, but IPoIB is
unable to ping other devices on the 0x8002 P_Key.

I tried other means of trying to communicate over a specific P_Key, and
I seem to recall we used to have the option to specify the target using
the GUID, but I couldn't find any tools that still allow me to specify
a target that way and also allow me to specify the P_Key (it probably
exists, I just don't know which tool to use to do it).

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
