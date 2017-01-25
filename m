From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Wed, 25 Jan 2017 17:14:05 -0500
Message-ID: <CAHC9VhQTwwQmg-2fR4-UiEAGvkx_F8z7mUs7zHz4KK=+34mW4Q@mail.gmail.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
 <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov> <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
 <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
 <1485294015.43764.91.camel@redhat.com> <CAHC9VhTfuftm1oyiBOa4Fx4L-12eX8MCySiS1H98yroCuuoieA@mail.gmail.com>
 <1485365121.2432.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485365121.2432.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 12:25 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2017-01-25 at 02:58 -0500, Paul Moore wrote:
>> On Tue, Jan 24, 2017 at 4:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> wrote:
>> >
>> > On Tue, 2016-12-13 at 17:17 -0500, Paul Moore wrote:
>> > >
>> > > On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellano
>> > > x.co
>> > > m> wrote:
>> > > >
>> > > >
>> > > > On 12/13/2016 9:01 AM, Stephen Smalley wrote:
>> > > > >
>> > > > >
>> > > > > For the LSM/SELinux bits,
>> > > > > Acked-by: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
>> > > > >
>> > > > > Note that there will be a merge conflict on classmap.h due to
>> > > > > commits in
>> > > > > the selinux next branch, but that should be easy to resolve.
>> > > > >
>> > > > > We'll need the patches for the selinux userspace and
>> > > > > refpolicy.
>> > > >
>> > > > Thanks Stephen, I need to rebase the user space and do some
>> > > > patch
>> > > > breakup.  I'll start on that soon.
>> > >
>> > > Sorry, I haven't had a chance to look at v6, but considering all
>> > > our
>> > > discussions on the previous versions I don't expect any issues
>> > > from
>> > > me.  I was hoping for some more generic hooks/controls, but that
>> > > doesn't look to be possible given the nature of RDMA.  I also
>> > > want to
>> > > mention again the need for tests; we've talked about this in the
>> > > past
>> > > and while it isn't possible to run the tests without IB hardware,
>> > > I
>> > > would like to see us merge tests into the selinux-testsuite so
>> > > that
>> > > those who do have the required h/w available could run the tests.
>> > >
>> > > Assuming we can sort out the SELinux userspace and and tests by
>> > > the
>> > > end of January, I see no reason why this couldn't go in for
>> > > v4.11.
>> >
>> > Daniel, can you work with people on the userspace and tests?  I'll
>> > pull
>> > this into a branch (I assume by Paul's and Stephen's comments that
>> > they
>> > expect it to go through my tree) ready to go, but hold actually
>> > submitting it in the merge window until I've heard more from you
>> > all
>> > that userspace is ready.
>>
>> I don't have a problem pulling this in via the SELinux tree, assuming
>> you are okay with that Doug.  I'm just waiting to see tests for the
>> selinux-testsuite first.
>
> When I tried to apply the patchset, the conflicts started on the very
> first file of the very first patch.  It can go through your tree, but I
> suspect there will be lots of conflicts that way as this upcoming
> release has been touching the cache area of the IB stack and so does
> this code.  There might be significant SELinux conflicts too, I don't
> know, but we know there are IB ones so far.

My apologies, I should have been more clear.  What I meant to say is
that I have no objection to merging this patchset via the SELinux
tree, in principle.  If there are significant merge conflicts they
will need to be resolved first; I have no problem dealing with small
fixups as part of the merge process, but any substantial changes would
need a respin.  Also, while I haven't looked at this latest patchset,
I would still want to review it for obvious reasons, although having
discussed previous drafts in detail I don't expect to see anything
objectionable.

However, my biggest concern remains the lack of working tests; without
those this patchset doesn't get my ACK.  We need to have some basic
method of regression testing this, even if it does require IB
hardware, to have any hope of maintaining this long term.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
