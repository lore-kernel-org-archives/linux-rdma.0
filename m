From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/ipoib: fixup multicast locking issues
Date: Tue, 31 Mar 2015 13:04:52 -0400
Message-ID: <20150331170452.GA6261@phlsvsds.ph.intel.com>
References: <cover.1424562072.git.dledford@redhat.com> <CAJ3xEMjHrTH_F=zPDsH9A9qRWo=AYN4sgbsdDKV62nzBkB5kXA@mail.gmail.com> <F42024C5-60A5-4B92-B4AC-4D225E2C0FC3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F42024C5-60A5-4B92-B4AC-4D225E2C0FC3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 15, 2015 at 11:52:44AM -0700, Doug Ledford wrote:
>=20
> > On Mar 13, 2015, at 1:41 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> >=20
> > On Sun, Feb 22, 2015 at 2:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> >> This is the re-ordered, squashed version of my 22 patch set that I
> >> posted on Feb 11.  There are a few minor differences between that
> >> set and this one.  They are:
> > [...]
> >=20
> > Doug, you wrote here a very detailed listing of the changes from
> > earlier posts and the testing the patches went through, which is
> > excellent. It would be very good if you can also post few liner
> > telling the changes done by the series in high level, so we can hav=
e
> > this test as part of a "merge" commit that says in the kernel logs.
>=20
> OK.  I would take what I had in the original message and expand upon =
it then:
>=20
> This entire patchset was intended to address the issue of ipoib
> interfaces being brought up/down in a tight loop, which will hardlock
> a standard v3.19 kernel.  It succeeds at resolving that problem.


I pulled this series and did some medium weight testing on 3.19 (module
reloads, insmod/rmmod, opensm restarts (client re-register)).  IPoIB re=
covered
without issue on each of the tests.

Tested-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>=20
> In order to accomplish this goal, it reworks how the IPOIB_MCAST_FLAG=
_BUSY flag is used.  Conceptually, that flag used to be set when we sta=
rted a multicast join, and would stay set once the join was complete.  =
This left no way to tell if the multicast join was complete or still in=
 flight.  This allowed race conditions to develop between joining multi=
cast groups and taking an interface down.  A previous attempt to resolv=
e these race conditions used the flag IPOIB_MCAST_JOIN_STARTED, but did=
 not succeed at fully resolving the race conditions.  This patchset res=
olves this issue, plus a number of related issues discovered while work=
ing on this issue.  The primary fix itself is patch 6/9 and a more comp=
lete description of the changes to how the IPOIB_MCAST_FLAG_BUSY flag i=
s now used can be found in that commit log.
>=20
> =E2=80=94
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 	GPG Key ID: 0E572FDD
>=20
>=20
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
