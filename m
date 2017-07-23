From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/core: Allow QP state transition from
 reset to error
Date: Sun, 23 Jul 2017 16:18:51 +0300
Message-ID: <20170723131851.GK3259@mtr-leonro.local>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
 <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
 <20170530054609.GG17751@mtr-leonro.local>
 <20170723073905.GE3259@mtr-leonro.local>
 <20170723074153.GF3259@mtr-leonro.local>
 <1500812883.2610.7.camel@redhat.com>
 <20170723130445.GG3259@mtr-leonro.local>
 <10f7f884-8e65-b563-bdd8-7c2735906d14@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4vu0d+lqoSa2/ZEk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <10f7f884-8e65-b563-bdd8-7c2735906d14-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4vu0d+lqoSa2/ZEk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 23, 2017 at 09:14:02AM -0400, Doug Ledford wrote:
> On 7/23/2017 9:04 AM, Leon Romanovsky wrote:
> > On Sun, Jul 23, 2017 at 08:28:03AM -0400, Doug Ledford wrote:
> >> On Sun, 2017-07-23 at 10:41 +0300, Leon Romanovsky wrote:
> >>> On Sun, Jul 23, 2017 at 10:39:05AM +0300, Leon Romanovsky wrote:
> >>>> On Tue, May 30, 2017 at 08:46:09AM +0300, Leon Romanovsky wrote:
> >>>>> On Mon, May 29, 2017 at 05:20:53PM -0700, Dennis Dalessandro
> >>>>> wrote:
> >>>>>> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>>
> >>>>>> Playing with IP-O-IB interface can trigger a warning message:
> >>>>>> "ib0: Failed to modify QP to ERROR state" to be logged.
> >>>>>> This happens when the QP is in IB_QPS_RESET state and the stack
> >>>>>> is trying to transition it to IB_QPS_ERR state in
> >>>>>> ipoib_ib_dev_stop().
> >>>>>>
> >>>>>> According to the IB spec, Table 91 - "QP State Transition
> >>>>>> Properties"
> >>>>>> it looks like the transition from reset to error is valid:
> >>>>>>
> >>>>>> Transition: Any State to Error
> >>>>>> Required Attributes: None
> >>>>>> Optional Attributes: None allowed
> >>>>>> Actions: Queue processing is stopped. Work Requests pending or
> >>>>>> in
> >>>>>> process are completed in error, when possible.
> >>>>>>
> >>>>>> This patch allows the transition and quiets the message.
> >>>>>>
> >>>>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>>>>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> >>>>>>>
> >>>>>> ---
> >>>>>
> >>>>> Thanks,
> >>>>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>
> >>>> Doug,
> >>>>
> >>>> After digging more with Erez's help, it looks like the sentence "it
> >>>> looks like the transition from reset to error is valid:" is not
> >>>> correct.
> >>>>
> >>>> According to the InfiniBandTM Architecture Release 1.3, Figure 126
> >>>> QP/EE Context
> >>>> State Diagram - transition to error from reset is not valid.
> >>>>
> >>>> The quote from the spec:
> >>>> "An error can be forced from any state, except Reset, with the
> >>>> Modify QP/EE Verb."
> >>>>
> >>>> I'll send revert patch along with proper fix.
> >>>
> >>> Ahh, it wasn't pushed to kernel.org, so no need to revert and you can
> >>> simply drop it.
> >>
> >> It *is* on kernel.org, and has already been pulled by Linus:
> >
> > Thanks, I updated the trees and got it.
> >
> > Also I prepared revert and patch and will send once it will finish our regression runs.
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=b287b76e89503ef1d403cc5cc8bd74b035d25bfa
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=5dc78ad1904db597bdb4427f3ead437aae86f54c
> >
> > BTW, when will you post for-4.14 branch so we will be able to base our
> > submission queue for the -next?
>
> Tomorrow.  I wanted to base it on 4.13-rc2 so it would get all of the
> fixes that went in this week.

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--4vu0d+lqoSa2/ZEk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll0ojsACgkQ5GN7iDZy
WKfNaxAAixepFn1ZhZjLtVMy/YUGjEDuaVtethMqeV8NqbQmiBx6+Om9I1Sgag+K
pcigwDIEXJxqNXKE9vSnta9O2sCrwWfi7A2qO99gbH+k7D5s7qDoxB8Gxn7MIK1i
0xHrEfU24r1FEjTDoFeV5gxQKavwmR4Cqoq7Ixc7/zoJ4AgwzyUuESU19a61RA9x
5kXpknpfnbSW/gPhWQNKO9LcdlTuV3YXvQ0bAtaHf5heJnjO+qYOXhxU+erdRUwM
doMB4M9ZLT2xArQ82frZLFmnOim7BmXY8Tn4PZiC6gaWQupYkBsHakNxWqsRfIi6
a+YcEHxTOqt5hyy0HWD/gfcKVyYcRHD8IBiO8asI1PwDIFY0bbN0iw0KO7SxNQHv
CjtSn/lINJzJ/b6v8mBJDuL4tbJ1rCg4yzg2I/TDDtAyEesUuLRHynrW5GNIzIoy
aJ21iQ7yZmye7wlVOdrBJyNWZEsHsqnvi2gZetxZ6pTEiJvILUqUyq6trq7+1eBF
PpYyvw/Wi87M+iIDO3SFpCdB/BKOdei/ZxOsUw8p6VLG7J6LQvsJhgarIT3DQN1P
GDJUqZNxHIpE3cvyaQtI1afGnnt2mBXYf4g8Apdm/141iBo4jFFdHhTW1ctiugeI
Lr/xx6bmQBesyXA8iE1CXZFXyxb08Z69FH0VymHH2NKKnvvbm+k=
=RaFI
-----END PGP SIGNATURE-----

--4vu0d+lqoSa2/ZEk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
