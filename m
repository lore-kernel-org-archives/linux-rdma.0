From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 16:51:01 +0000
Message-ID: <1501692660.2437.4.camel@wdc.com>
References: <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
         <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
         <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
         <20170801195840.GC31205@obsidianresearch.com>
         <20170802034438.GV13672@mtr-leonro.local>
         <20170802155856.GA21208@obsidianresearch.com>
         <20170802162938.GC13672@mtr-leonro.local>
         <20170802164553.GA31901@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170802164553.GA31901-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <1FCC75A962A0B44D9902061B7DDB4700-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 10:45 -0600, Jason Gunthorpe wrote:
> No, I disagree.. It is pretty clear how iwpm works, it it pushes
> unsolicted messaged directly to the userspace daemon from the kernel
> and expects the daemon to receive those messages.
>=20
> With such a scheme it is really important for the kernel to do
> everything it can to minimize the risk of message loss, and using the
> blocking sending for unsolicited messages is certainly part of it -
> that is what audit does for instance.
>=20
> The discussion really got into the weeds when people brought up
> O_NONBLOCK or ENOBUFS, or any other user space change as that has
> nothing to do with pushing unsolicited messages from the kernel to
> userspace.
>=20
> Arguing that is a 'protocol bug' doesn't make much sense, the protocol
> is a uAPI, so it is up to the kernel to provide the best
> implementation possible, which in this case means working to minimize
> loss of the messages..
>=20
> Noting again, that this is *ONLY* talking about the unsolicted
> messages the iwpm sends toward userspace. IMHO, use of blocking send
> in other contexts, such as dump callbacks, is an error.

Hello Jason,

Although I do not object against the "RDMA/core: Add wait/retry version
of ibnl_unicast" patch, I hope that you realize that it is an ugly hack
instead of a proper fix. Anything that makes user space wait longer than
the socket timeout, e.g. heavy swapping activity or running the user
space software under a debugger, will cause delivery of the netlink
message from kernel to user to fail anyway.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
