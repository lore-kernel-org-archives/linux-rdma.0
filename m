From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: VERBOSE flags
Date: Tue, 20 Sep 2016 13:42:05 +0300
Message-ID: <20160920104205.GH26673@leon.nu>
References: <CALq1K=KfU+N87pyfjfSd=G-thpyR0mjzuuxQ8eTuqrc2Mb+yZQ@mail.gmail.com>
 <77cd1f09-fa39-6f75-6c01-c7ef18909f30@redhat.com>
 <CALq1K=+0S-YnXQo5Hvc3bdOBNuEpowdSMYJThdmHqMNwOu8z1Q@mail.gmail.com>
 <0a26585a-2e54-1c24-d212-0e2469afb8d8@redhat.com>
 <20160919061558.GG3273@leon.nu>
 <02761057-02de-d3d1-13d9-ca64e4ee9556@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+Z7/5fzWRHDJ0o7Q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02761057-02de-d3d1-13d9-ca64e4ee9556-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+Z7/5fzWRHDJ0o7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 19, 2016 at 12:03:34PM -0400, Doug Ledford wrote:
> On 9/19/2016 2:15 AM, Leon Romanovsky wrote:
> > On Sun, Sep 18, 2016 at 04:35:37PM -0400, Doug Ledford wrote:
>
> > Doug,
> > The function pointers will cause us to create two similar functions
> > (debug/regular) for every important function. It will leave to code
> > duplication and/or introducing of new code to fill additional fields
> > in returns to debug functions, so they will be able to print it.
>
> That's situationally specific.  The original patch you posted that I
> said no to is an example of where this wouldn't have been true.
> Basically it all boils down to whether or not your debug code can be a
> wrapper of your existing function or if it needs to be embedded in the
> middle of it.  If the latter, then you are more likely to have code
> duplication as you point out.  But, then refactoring code can help with
> that problem too.

That specific patch was sent to ensure that if(0) {...} code isn't
removed by mistake.

>
> > I wanted to propose to use tracepoints to provide debug information in
> > data paths. The tracepoints infrastructure uses hooks in the code with
> > minimal impact on performance.
>
> Yes, but one of the things you said before was "zero impact on normal
> operations", but with tracepoints you just said "minimal impact".  So it
> sounds like tracepoints don't meet your own initial requirements.  I'm
> not against them, but utilizing the entry points allows for achievment
> of the "zero impact" requirement.  And as Denny pointed out, some things
> can't be done with tracepoints.  So, the final solution might be a mix
> of different things including different entry points, tracepoints, and
> some core infrastructure.

You are right and my initial requirement which is fine in theory (zero
impact) not so good in real life (precompile e.t.c).

Let's start from the tracepoints and see what elase we need to add to core.

>
> >
> >> Then we can drop the CONFIG_*_DEBUG options out of all of the
> >> drivers.  That would be my preference.  I don't want any compile time
> >> options because you never will be running a debug kernel when you need
> >> it.  Per device, run time selectable so that you get 0 overhead in the
> >> normal case is what I would like to see.
> >
> > Great,
> > We are aligned on this point, so do I. I see no reason in special compiled
> > kernel or global module parameter to print debug prints for whole driver.
>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--+Z7/5fzWRHDJ0o7Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX4RJ9AAoJEORje4g2clinelkQALwO366w06i+P+1JcEx6pWgm
bLGtVBhb+mNYrpbRpvTQNZyiFC7aL0tLNuI/qITge6V14Uu5N8o9mSz7A6MeK+AF
lHaTpGElw5mTIh1cHzAiMjdADUhyxWfCwoHwsiLKHcfoFezvbvWJMndd0sLiw8Zy
xV8JD6mxJV9VLgYtBbRmxXEFOrJP+Iq5NgyqtGfUDL3bwCUaUE3olIXRhxSLs4if
gg75ZrMAZ8Yy+TUnbAsqj1D1YJGVqb6KEwrTwARPhIt/BJ/loTHfj7GUPn/RQIyP
8/pali5QEzawJjyUd17z/rmRqtA6PDspxjOKbt8T9tOOloU3JXIXkcayF67Hvf7n
fF3+yuPIiayFzAUrG9E5CFi5y2/Z9kI1bHNEy2lrgt0ENdZIe8ENP0o6wYVoSk8A
zPVvxwqJmLbK5cm0drDL9sC1KWfCWHGob/FDgjEfQ86RtD7idgnTlcM3hYk0g7LN
4m+DXRswxU3pRlvbjPoK3bIwP7cnS8xIkEwmBa6pvDujfy13W9FoJZMBa93iRvIZ
WQ7lJHcaJ1z3O8MJ2yACzkudQsCs16gSVbVAHSQQKLCDs3lKccwTB3GQnko1/joW
leSeJdnWhY2FNTSWQDRlHmabE+4xVVzOg+mXT8Imu+zPXHxpJTu9c64Hjv+BBHmd
QfvSw4qd0IXrgIU/wjuF
=wqUm
-----END PGP SIGNATURE-----

--+Z7/5fzWRHDJ0o7Q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
