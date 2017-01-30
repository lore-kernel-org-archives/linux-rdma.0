From: Stevie Trujillo <stevie.trujillo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: "isert: isert_setup_id: rdma_bind_addr() failed: -19" spam,
 followed by Recursive Fault on reboot
Date: Mon, 30 Jan 2017 23:52:46 +0100
Message-ID: <20170130235246.17fe123f@localhost>
References: <20170129000124.7199b7b5@localhost>
        <81437a39-c0e0-0215-08e5-50d8b9da1d8b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <81437a39-c0e0-0215-08e5-50d8b9da1d8b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 29 Jan 2017 09:39:39 +0200
Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:

Hello, thank you very much for your help. I'm very sorry but I think
I've made too many changes to my system to recreate the problem.
I tried recreating my targtetcli config and downgrading
linux+userspace+firmware to the versions I used when it broke, but
never got this problem again :(

> > I'm trying (failing) to get iSER working. After rebooting with some
> > settings saved in targetcli, I got an endless stream of messages
> > like this:
> >
> > [  192.701299] isert: isert_setup_id: rdma_bind_addr() failed: -19
> > [  192.702733] isert: isert_setup_id: rdma_bind_addr() failed: -19
> > [  192.704021] isert: isert_setup_id: rdma_bind_addr() failed: -19
> > [  192.705458] isert: isert_setup_id: rdma_bind_addr() failed: -19
> > [  192.706979] isert: isert_setup_id: rdma_bind_addr() failed: -19  
> 
> You get -ENODEV errors because you don't have an RDMA device.
> This is probably due to the fact that the mlx5_ib (or mlx4_ib,
> depending on your device) is not loaded.
> 
> Can you try loading mlx[4|5]_ib module before you enable iser on
> a network portal?
> 
> I do see that mlx5 and mlx4 are requesting the mlx_ib module at probe
> time, I wander how that didn't happen on your system..
> 
> I didn't see a endless loop of this error? can you share your
> targetcli json?
> 
> > I tried deleting everything from targetcli, but the flood would not
> > stop. The ib_isert module did not unload. When rebooting I got a
> > "Recursive Fault" with a stacktrace inside configfs.
> >
> > I hope this is enough information to fix this bug. I assumed the
> > stacktrace would be saved to the log so I didn't write it down, and
> > I haven't been able to retrace all the wrong stuff I did trying to
> > make iSER work.
> >
> > Linux Version: Linux 4.8.15-2~bpo8+2 (Debian 8 Backports)  
> 
> Would it be possible to try with upstream kernel and report what you
> are seeing?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
