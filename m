From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Tue, 3 Nov 2015 11:59:02 -0500
Message-ID: <D8B3250B-37D1-449B-BFA2-C4133C197AC5@oracle.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de> <5631839B.30300@redhat.com> <56318B37.20207@redhat.com> <20151029115114.GA18466@lst.de> <56360148.8060608@mellanox.com> <20151101180609.GC13943@kroah.com> <5637EFC8.4010300@redhat.com> <20151102233726.GA18251@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151102233726.GA18251-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Nov 2, 2015, at 6:37 PM, Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Mon, Nov 02, 2015 at 06:20:40PM -0500, Doug Ledford wrote:
>> 1) Aging, but working, drivers that will be removed in the future.
>> Since we no longer have a deprecation mechanism, I was informed that=
 the
>> normal procedure now is to move the driver to staging for a while an=
d
>> then remove it permanently on a future schedule.  This provides an
>> orderly removal process.  But, if you make it so that random people =
can
>> break the driver with no responsibility for fixing up their breakage=
, in
>> contrast to the entire rest of the kernel, then you eliminate that
>> orderly removal process and turn it into a completely non-determinis=
tic
>> and chaotic removal process.  So, no, if that's how it will be handl=
ed,
>> I will move the deprecated drivers back to the main rdma tree and ti=
me
>> them out and perform the orderly removal myself.
>=20
> So you have what, one more kernel release before these are deleted?
> Odds are, nothing is going to be broken so badly that a simple patch
> will not fix up before they are removed.  So don't worry about this.
>=20
> And why would you want a developer wasting time on fixing up these
> drivers if they are about to be deleted anyway?  Obviously no one eve=
n
> uses them, otherwise they wouldn't be about to be removed.

I understand the stated policy, but I was recently
bitten by it. I got dinged by the kbuild robot when I
made a change that broke something in staging. I was
caught between the staging policy and the guidelines
about fixing kbuild nits before a merge window.

My change was in the IB core, but the breakage was in
Lustre. Their fix (which was quick because I had warned
them in advance) was substantial, and not something I
could have provided myself.

If the bits in staging are truly to be ignored, then
the kbuild robot shouldn=E2=80=99t warn about new staging
breakage. Or the warning messages should state that
fixing said breakage is optional.


>> 2) New drivers (one currently, one other one submitted but not yet
>> pulled in) under active development but which need specific things f=
ixed
>> up.  These have people already working on them full time.  They were
>> submitted to the staging tree with a specific TODO in order to get o=
ut.
>> If you then break that driver and force the driver author to fix it,
>> you have in essence changed the TODO list.  That means you now have =
a
>> moving goal post scenario.
>=20
> Again, this shouldn't be taking you all that long to get out of stagi=
ng,
> right?  And again, the number of api changes that cause breakage are
> usually very minor, if they happen at all (remember, this is a
> theoretical, not what usually happens.)  And a driver in this state
> doesn't deserve to be in the "real" portion of the kernel, so you can=
't
> merge it anywhere else, so overall it still benifits being in the
> staging tree, so a few minor breakages every once in a while should b=
e
> easy for you to fix up, _if_ they happen.
>=20
> Again, I don't know of any recent api change that has caused any
> problems in a long time, but the VFS developers really hate having to
> touch lustre code, and I don't blame them, so sometimes that codebase
> breaks.  That will not affect your drivers at all, so I wouldn't worr=
y
> about this.
>=20
> So relax, this isn't going to be an issue, or if it is, you can easil=
y
> handle it, it is no different from any other tree-wide api change tha=
t
> happens.
>=20
> thanks,
>=20
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
