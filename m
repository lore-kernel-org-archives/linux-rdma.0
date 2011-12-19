From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Mon, 19 Dec 2011 10:14:13 +0100
Message-ID: <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

I've already sent this to the open-iscsi mailing list, but I guess
this is more relevant for linux-rdma.

=46inally I've got IB/iSER running on Debian Squeeze with Linux kernel =
3.0
smoothly.

The problem was that we did not have the suitable OFED for our kernel
and we did not use the open-iscsi from OFED. Kernel 3.0 is supported
since OFED-1.5.4 from 2011-12-05.

So, I've taken the 1.5.2-based stuff from Debian/Experimental and I've
updated it to 1.5.4 from OFA. Then, I've noticed that Debian doesn't
build "ib_iser" in the OFA kernel source and that they don't build the
open-iscsi kernel/user-space code - I made it do so.

The next problem was that open-iscsi kernel code in OFED-1.5.4 is for <=
=3D
2.6.32 based RedHat distributions. I had to port the source from 2.6.30
to 3.0 due to kernel API changes. OFA even forgot libiscsi_tcp.[ch] in
OFED-1.5.4. So, I had to import it from 2.6.30 mainline.
I did so, because we wanted to compare TCP and iSER speed over
InfiniBand. Our Solaris COMSTAR targets provide both.

After fixing the kernel, there was still a problem in the open-iscsi
2.0.869 user-space from OFED. Some sysfs magic has changed - so that th=
e
iSCSI host number couldn't be found.

After fixing that, it worked for me.

Cheers,

Sebastian


--
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
10405 Berlin, Germany

Tel.: =A0+49 - 30 - 51 64 09 20
=46ax: =A0 +49 - 30 - 51 64 09 22
Email: sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: =A0 http://www.profitbricks.com/

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
