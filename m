From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 16:55:09 +0000
Message-ID: <1501606508.2475.12.camel@wdc.com>
References: <20170801120536.540-1-leon@kernel.org>
         <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
         <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
         <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
         <1501600807.2475.4.camel@wdc.com>
         <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801162135.GA240-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Content-Language: en-US
Content-ID: <CDD41A03DBC64943B4291C98049BC568-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 11:21 -0500, Chien Tin Tung wrote:
> On Tue, Aug 01, 2017 at 03:20:11PM +0000, Bart Van Assche wrote:
> > What Leon wrote, namely that calls that send netlink data from kernel t=
o user
> > space should be non-blocking makes sense to me.
>=20
> That's been addressed in so many emails I won't rehash.  If _no_one_ shou=
ld
> block (it is actually a one shot retry with a timeout) sending Netlink me=
ssage
> from kernel to user, why don't Leon or you patch that code out?  All of
> it, not just ibnl_unicast().
>=20
> > So please be more constructive than replying with "NAK".
>=20
> I've sent so many emails (some you were CC'd), so I'm not sure how
> much more constructive I can be.  BTW, did you see the one with my
> attempt at world peace (https://www.spinics.net/lists/linux-rdma/msg50591=
.html)?
>=20
> Here are the relevant threads for people that are interested in participa=
ting
> in this discussion.
>=20
> https://patchwork.kernel.org/patch/9814367/
>=20
> https://patchwork.kernel.org/patch/9752855/

Hello Chien,

Yes, I had read these e-mails but I do not agree with all of what was writt=
en
in these e-mails. I'm not sure whether you are aware of the original design
goal of the netlink mechanism? It was designed on purpose to be unreliable
such that sending information from the kernel to user space would never blo=
ck.
If sending data over a netlink socket can block then analyzing whether or n=
ot
any deadlocks can occur is only possible by examining kernel and user space
together. If sending data over a netlink socket never blocks then a only th=
e
kernel has to be considered when analyzing whether or not a deadlock can oc=
cur.
We do not want that userspace can cause the kernel to lock up. So it's very
strange to me to see that today the kernel has facilities for both blocking
and non-blocking sends over netlink sockets. My opinion here is that any
client that needs reliable communication from kernel to user space should u=
se
another mechanism than netlink sockets. Additionally, since the kernel repo=
rts
netlink socket buffer overflows to user space through the ENOBUFS error cod=
e,
what's so hard about detecting that error code in user space and
resynchronizing state if recv() fails with ENOBUFS?

Is your concern perhaps about the code in iwpmd/iwarp_pm_server.c? From wha=
t
I see in process_iwpm_netlink_msg() it seems like all receive errors are
treated equal and no state resynchronization occurs if the kernel reports
ENOBUFS?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
