From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: ib_srpt and mellanox mthca device
Date: Tue, 10 Apr 2012 16:09:21 -0700
Message-ID: <CAL1RGDWNqMdQGrXbh2gj==_KvVRF1mUQw2D3NqEhjvuq2q2+6Q@mail.gmail.com>
References: <5f95768153388b91a2ffa0cd118d7ad8@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5f95768153388b91a2ffa0cd118d7ad8-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 10, 2012 at 7:52 AM, Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wr=
ote:
> I'm =A0trying to use ib_srpt from mainline kernel (3.3.x and 3.4-rcX)
> But right after loading ib_srpt i always get error in dmesg
>
> srpt_add_one(mthca0) failed.

I would suggest the following: make sure ib_mthca is NOT loaded, and lo=
ad
the srpt module.  Then enable ftrace -- config options

    CONFIG_FUNCTION_TRACER
    CONFIG_DYNAMIC_FTRACE
    CONFIG_FUNCTION_GRAPH_TRACER

and use the function graph tracer to see what srpt_add_one() calls:

# cd /sys/kernel/debug/trace
# echo srpt_add_one > set_graph_function
# echo function_graph > current_tracer
# modprobe ib_mthca
# cat trace

and send the output of that "cat trace" command to the list.  Then we c=
an
see what step of initialization fails and debug from there.

(cf the section "the function_graph tracer" in https://lwn.net/Articles=
/370423/)

Thanks!
 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
