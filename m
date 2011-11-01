From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Tue, 1 Nov 2011 08:40:12 +0200
Message-ID: <CAJZOPZ+K3u+u5XutGfBhKh3DaBpNRKV_bw67CLK6jy3060OHqA@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
	<CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 31, 2011 at 9:38 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrot=
e:

> Sorry for the late review here

Oh yes... BTW this is patch 4/5, I don't see patches 1,2,3 on your for-=
next
tree/branch @ kernel.org, have you accepted them?


> Sorry for the late review here, but does it seem like the best
> approach to have a separate "counters_ext" directory for
> some subset of performance counters? =A0Instead we could
> have two attribute_groups, one the basic counters and one
> the basic and extended counters, and basically do
>
> =A0 =A0 =A0 =A0if (is_pma_class_cap_ext_width(device, port_num) =3D=3D=
 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sysfs_create_group(...basic and extend=
ed counters...)
> =A0 =A0 =A0 else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sysfs_create_group(...basic counters..=
=2E)

Basically, I don't see a problem to have one directory along the lines
of your suggestion

> Or is there some reason why users would want to make the
> distinction between basic and extended counters?

Today, e.g in some IBoE perf monitoring scripts we wrote, the
distinction is done by if (the ext counter directory exists) then go
and read the counters from there, else read from the non extended
counters directory. With the change you propose, that if (.) would
become a little less elegant and would check if this or that --file--
exists (e.g the 64 bit tx data counter) and if yes, would read the
four 64 bit counters (rx/tx packets/data) else the four 32 bits
counters, so from our user standpoint, diff dirs seems better, but we
can get along with same dir with diff contents depending on the
device.

> (by the way, is_pma_class_cap_ext_width() seems backwards
> since it returns 0 for true. =A0How about bool pma_has_ext_width()
> and have it return true if the extended counters ARE supported?)

sure, I will be able to handle this little change Wed, but we should
be okay / enough time for the  current merge window, correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
