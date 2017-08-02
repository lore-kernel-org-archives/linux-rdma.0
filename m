From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 17:11:33 +0000
Message-ID: <1501693892.2437.6.camel@wdc.com>
References: <20170801141023.GM13672@mtr-leonro.local>
         <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
         <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
         <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
         <20170801195840.GC31205@obsidianresearch.com>
         <20170802034438.GV13672@mtr-leonro.local>
         <20170802155856.GA21208@obsidianresearch.com>
         <20170802162938.GC13672@mtr-leonro.local>
         <20170802164553.GA31901@obsidianresearch.com>
         <1501692660.2437.4.camel@wdc.com>
         <20170802170823.GA32513@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170802170823.GA32513-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <9481A4F3346964459924FE4D35AD0CD3-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 11:08 -0600, Jason Gunthorpe wrote:
> On Wed, Aug 02, 2017 at 04:51:01PM +0000, Bart Van Assche wrote:
> =20
> > Although I do not object against the "RDMA/core: Add wait/retry version
> > of ibnl_unicast" patch, I hope that you realize that it is an ugly hack
> > instead of a proper fix. Anything that makes user space wait longer tha=
n
> > the socket timeout, e.g. heavy swapping activity or running the user
> > space software under a debugger, will cause delivery of the netlink
> > message from kernel to user to fail anyway.
>=20
> Yes, I assume the iwpm people are aware of this as well, this is why I
> used the phrase 'minimize loss'.
>=20
> I'm not sure I'd call it a hack though. There is no proper fix here,
> messages from kernel to user space must be delivered and processed for
> iwpm to function as designed. Maximizing the chance of delivering
> unsolicited messages via blocking netlink_unicast is going to be a
> necessary component of any design...
>=20
> The big point in all of this discussion is that none of this allows
> iwpmd to ignore lost messages and it needs to have a sane well thought
> out process for resynchronizing with the kernel. Particularly, the
> flow that causes sockets to closed must have some kind of resync.
>=20
> But even if all that loss resynchronization works perfectly, it is
> still very desirable to avoid triggering it!

Hello Jason,

Because it is not possible to make the current iwpm netlink code work 100%
reliably, my proposal is to add a new and redesigned interface for iwpm
communication between user space and kernel and to deprecate the current AP=
I.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
