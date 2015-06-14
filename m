From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Upstream mlx4 driver very broken (when using SRIOV)
Date: Sun, 14 Jun 2015 17:31:06 +0300
Message-ID: <CAJ3xEMi--ygFeYC12iiivXnbZLd=ox22fzt_f1+TFn7M0Emhug@mail.gmail.com>
References: <557BC105.3070405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557BC105.3070405-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 13, 2015 at 8:35 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I ran across a problem today when I went to do some run tests of my
> for-4.2 tree.  For a second there, I was about to seriously have a
> conniption fit.  But, after about 6 hours of work bisecting and
> debugging, I've come to find that I wasn't so crazy after all.
>
> When I went to install my for-4.2 tree, IPoIB was totally busted, as in
> DOA.  I knew the 4.1 code I submitted to Linus I had checked, but I
> wanted to have a good starting point for a bisection so I compiled a
> kernel from my for-4.1-rc branch.  And it was DOA too.  That seriously
> unnerved me because I knew I tested that code.  I did a number of manual
> checkouts at possible suspicious code points, and none of them showed
> that the problem was resolved.  Then I started doing some debugging on
> both the afflicted machine and on the opensm server.  I finally saw that
> the afflicted machine was claiming that it was attempting to join the
> multicast group, but was reporting error 110 (ETIMEDOUT).  The opensm
> server was not seeing the requests at all.
>
> Long story short, I did my testing in the 4.1 merge window and rc phase
> on machines without SRIOV enabled, but when you enable SRIOV in the mlx4
> driver, the current driver seems to have broken QP0/QP1 multiplexing
> support because the host becomes unable to join the IPoIB multicast
> groups.  In addition, with SRIOV enabled, mlx4_en throws corruption
> errors on reboot and requires that the machine be power cycled as
> opposed to rebooting cleanly.  From what I can tell, the 4.0 release
> kernel has this problem too, and it still exists at least as far as
> 4.1-rc7 + all of my queued up -next patches.
>
> From my /etc/modprobe.d/mlx4.conf file if you want to try and duplicate:
>
> options mlx4_core probe_vf=0 num_vfs=7 port_type_array=1,2

Doug,

You were 100% right, due to recent FW bug SRIOV QP0/QP1 PV is broken
with VPI config of IB/Eth (port_type_array=1,2), personally, I didn't
step on it, since I moved my working environment to Eth/IB (2,1)
couple of weeks ago, Oh well.

The fix is easy, disable Granular VF QoS in that VPI config, I tested
it and sent that now to net [1]

We should check how come the upstream regression environment didn't
catch that up.

Or.

[1] http://patchwork.ozlabs.org/patch/483991/

> options mlx4_en pfctx=0x28 pfcrx=0x28
>
> And I'm guessing that your internal regression tests must not have a
> machine in IB/Eth SRIOV mode as a standard config.  I would consider
> adding it to the mix.  I have it myself, but only on a few machines and
> I don't always use them for initial testing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
