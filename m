From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 17:58:29 +0000
Message-ID: <1501610305.2475.16.camel@wdc.com>
References: <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
         <20170801141023.GM13672@mtr-leonro.local>
         <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
         <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
         <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
         <1501600807.2475.4.camel@wdc.com>
         <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
         <1501606508.2475.12.camel@wdc.com>
         <20170801171454.GA8484@ctung-MOBL3.amr.corp.intel.com>
         <1501608534.2475.14.camel@wdc.com>
         <20170801175236.GA14048@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801175236.GA14048-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Content-Language: en-US
Content-ID: <A94CB3ED80F0564D9D36075D87C270A7-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-01 at 12:52 -0500, Chien Tin Tung wrote:
> On Tue, Aug 01, 2017 at 05:28:54PM +0000, Bart Van Assche wrote:
> > On Tue, 2017-08-01 at 12:14 -0500, Chien Tin Tung wrote:
> > > On Tue, Aug 01, 2017 at 04:55:09PM +0000, Bart Van Assche wrote:
> > > > Yes, I had read these e-mails but I do not agree with all of what w=
as written
> > > > in these e-mails. I'm not sure whether you are aware of the origina=
l design
> > > > goal of the netlink mechanism? It was designed on purpose to be unr=
eliable
> > > > such that sending information from the kernel to user space would n=
ever block.
> > >=20
> > > Please show me a feference to Netlink design document/email on mailin=
g list
> > > that specifically disallowed this?
> >=20
> > As you probably know kernel developers do not write design documents. B=
ut there
> > is plenty of evidence on the web that the netlink mechanism was designe=
d to be
> > unreliable. A quote from a Linux Journal article from 2005
> > (http://www.linuxjournal.com/article/7356): "Netlink is asynchronous be=
cause,
> > as with any other socket API, it provides a socket queue to smooth the =
burst
> > of messages."
>=20
> So what happens when the queue is full?  you can fail at that point or yo=
u
> can choose the 1-shot retry with timeout as we have done.  What is _wrong=
_
> with the 1-shot retry?

Why is the one-shot retry necessary? What aspect of the portmapper design m=
akes
this one-shot retry necessary? Why is this one-shot retry only necessary fo=
r the
portmapper and not for any other Netlink client?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
