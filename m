From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/iSER problems with Linux 3.0
Date: Mon, 16 Jan 2012 23:16:35 +0200
Message-ID: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> On 12/01/12 17:14, Or Gerlitz wrote:

>> you didn't send the kernel logs from the failure after opening the iser
>> (debug_level=2) and libiscsi (debug_libiscsi_session=1
>> debug_libiscsi_conn=1) debug prints

> OK, I've also set mlx4_core debug_level=2

Sebastian, I asked for the **iser** (ib_iser) and not mlx4_core debug_level=2

> I've also attached the log from the working stuff from OFED-1.5.4 for a
> compare and the settings from discovery. I'll try to backport the IB + iSCSI
> kernel code from 3.2.1 to 3.0.15 next.

Two comments:

1. yes, the logs (correct ones, please!) from success login on the
very same kernel would help

2. don't bother to backport ib/iscsi from 3.2.1 to 3.0.15, lets debug
it on 3.0.15

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
