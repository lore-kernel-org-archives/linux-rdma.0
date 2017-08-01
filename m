From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 17:28:54 +0000
Message-ID: <1501608534.2475.14.camel@wdc.com>
References: <20170801120536.540-1-leon@kernel.org>
         <20170801120536.540-2-leon@kernel.org>
         <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
         <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
         <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
         <1501600807.2475.4.camel@wdc.com>
         <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
         <1501606508.2475.12.camel@wdc.com>
         <20170801171454.GA8484@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801171454.GA8484-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Content-Language: en-US
Content-ID: <C5E7A1131A6D3443B65DF941A63B6B5E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 12:14 -0500, Chien Tin Tung wrote:
> On Tue, Aug 01, 2017 at 04:55:09PM +0000, Bart Van Assche wrote:
> > Yes, I had read these e-mails but I do not agree with all of what was w=
ritten
> > in these e-mails. I'm not sure whether you are aware of the original de=
sign
> > goal of the netlink mechanism? It was designed on purpose to be unrelia=
ble
> > such that sending information from the kernel to user space would never=
 block.
>=20
> Please show me a feference to Netlink design document/email on mailing li=
st
> that specifically disallowed this?

As you probably know kernel developers do not write design documents. But t=
here
is plenty of evidence on the web that the netlink mechanism was designed to=
 be
unreliable. A quote from a Linux Journal article from 2005
(http://www.linuxjournal.com/article/7356): "Netlink is asynchronous becaus=
e,
as with any other socket API, it provides a socket queue to smooth the burs=
t
of messages."

>From LWN.net article from 2005 (https://lwn.net/Articles/131802/):
"netlink is an unreliable service".

>From RFC 3549, co-authored by Alexey Kuznetsov, one of the netlink authors
(https://tools.ietf.org/html/rfc3549): "By default, however, Netlink provid=
es
an unreliable communication."

>From the netlink man page (http://man7.org/linux/man-pages/man7/netlink.7.h=
tml):
"However, reliable transmissions from kernel to user are impossible in any =
case.
The kernel can't send a netlink message if the socket buffer is full: the m=
essage
will be dropped and the kernel and the user-space process will no longer ha=
ve
the same view of kernel state. It is up to the application to detect when t=
his
happens (via the ENOBUFS error returned by recvmsg(2)) and resynchronize."

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
