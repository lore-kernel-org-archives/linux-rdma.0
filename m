From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Tue, 3 Nov 2015 09:43:34 -0800
Message-ID: <20151103174334.GA32580@kroah.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com>
 <56318B37.20207@redhat.com>
 <20151029115114.GA18466@lst.de>
 <56360148.8060608@mellanox.com>
 <20151101180609.GC13943@kroah.com>
 <5637EFC8.4010300@redhat.com>
 <20151102233726.GA18251@kroah.com>
 <D8B3250B-37D1-449B-BFA2-C4133C197AC5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D8B3250B-37D1-449B-BFA2-C4133C197AC5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 03, 2015 at 11:59:02AM -0500, Chuck Lever wrote:
>=20
> > On Nov 2, 2015, at 6:37 PM, Greg Kroah-Hartman <gregkh@linuxfoundat=
ion.org> wrote:
> >=20
> > On Mon, Nov 02, 2015 at 06:20:40PM -0500, Doug Ledford wrote:
> >> 1) Aging, but working, drivers that will be removed in the future.
> >> Since we no longer have a deprecation mechanism, I was informed th=
at the
> >> normal procedure now is to move the driver to staging for a while =
and
> >> then remove it permanently on a future schedule.  This provides an
> >> orderly removal process.  But, if you make it so that random peopl=
e can
> >> break the driver with no responsibility for fixing up their breaka=
ge, in
> >> contrast to the entire rest of the kernel, then you eliminate that
> >> orderly removal process and turn it into a completely non-determin=
istic
> >> and chaotic removal process.  So, no, if that's how it will be han=
dled,
> >> I will move the deprecated drivers back to the main rdma tree and =
time
> >> them out and perform the orderly removal myself.
> >=20
> > So you have what, one more kernel release before these are deleted?
> > Odds are, nothing is going to be broken so badly that a simple patc=
h
> > will not fix up before they are removed.  So don't worry about this=
=2E
> >=20
> > And why would you want a developer wasting time on fixing up these
> > drivers if they are about to be deleted anyway?  Obviously no one e=
ven
> > uses them, otherwise they wouldn't be about to be removed.
>=20
> I understand the stated policy, but I was recently
> bitten by it. I got dinged by the kbuild robot when I
> made a change that broke something in staging. I was
> caught between the staging policy and the guidelines
> about fixing kbuild nits before a merge window.
>=20
> My change was in the IB core, but the breakage was in
> Lustre. Their fix (which was quick because I had warned
> them in advance) was substantial, and not something I
> could have provided myself.
>=20
> If the bits in staging are truly to be ignored, then
> the kbuild robot shouldn=E2=80=99t warn about new staging
> breakage. Or the warning messages should state that
> fixing said breakage is optional.

You are always free to ignore the results of the 0-day bot for stuff
like this if you want to, that's your choice, it's just informing you o=
f
the results of the build.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
