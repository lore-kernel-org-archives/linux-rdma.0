From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: "isert: isert_setup_id: rdma_bind_addr() failed: -19" spam,
 followed by Recursive Fault on reboot
Date: Sun, 29 Jan 2017 09:39:39 +0200
Message-ID: <81437a39-c0e0-0215-08e5-50d8b9da1d8b@grimberg.me>
References: <20170129000124.7199b7b5@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170129000124.7199b7b5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Stevie Trujillo <stevie.trujillo@gmail.com>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org


> Hello

Hey Steve,

> I'm trying (failing) to get iSER working. After rebooting with some settings
> saved in targetcli, I got an endless stream of messages like this:
>
> [  192.701299] isert: isert_setup_id: rdma_bind_addr() failed: -19
> [  192.702733] isert: isert_setup_id: rdma_bind_addr() failed: -19
> [  192.704021] isert: isert_setup_id: rdma_bind_addr() failed: -19
> [  192.705458] isert: isert_setup_id: rdma_bind_addr() failed: -19
> [  192.706979] isert: isert_setup_id: rdma_bind_addr() failed: -19

You get -ENODEV errors because you don't have an RDMA device.
This is probably due to the fact that the mlx5_ib (or mlx4_ib, depending
on your device) is not loaded.

Can you try loading mlx[4|5]_ib module before you enable iser on
a network portal?

I do see that mlx5 and mlx4 are requesting the mlx_ib module at probe
time, I wander how that didn't happen on your system..

I didn't see a endless loop of this error? can you share your
targetcli json?

> I tried deleting everything from targetcli, but the flood would not stop. The
> ib_isert module did not unload. When rebooting I got a "Recursive Fault"
> with a stacktrace inside configfs.
>
> I hope this is enough information to fix this bug. I assumed the stacktrace
> would be saved to the log so I didn't write it down, and I haven't been able to
> retrace all the wrong stuff I did trying to make iSER work.
>
> Linux Version: Linux 4.8.15-2~bpo8+2 (Debian 8 Backports)

Would it be possible to try with upstream kernel and report what you
are seeing?
