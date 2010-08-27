From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 14:51:47 -0600
Message-ID: <AANLkTikvA8oaksoszCoAvUs=sHp7uap-q+d9=f+AoQ96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In scouring the many manuals with the Window's IB drivers I found a
clue as to why I can't get SRP working in WinOF:

  Windows PNP (Plug-n-Play) will match the IOC device ID with
DriverStore installed drives and then will load the IBiou.sys driver

How do I set the "IOC device ID" and what is DriverStore?

I can make the Windows SRP miniport devices appear and disappear by
removing/reloading ib_srpt on the target (at least with the 2.1.1
driver from Mellanox; the latest at openfabrics.org panics the
WS2008R2 system when ib_srpt is rmmod'ed).

Beyond that, Windows never sees the drives... Linux initiators don't
have an issue.

Someone throw me a bone!  The SRP initiator seems to have been broken
for many months on WinDoh's.

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
