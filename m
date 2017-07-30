From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Kernel oops
Date: Sun, 30 Jul 2017 13:25:14 +0300
Message-ID: <20170730102514.GQ13672@mtr-leonro.local>
References: <20170724211606.GA1705@obsidianresearch.com>
 <CAAKD3BAdB2aRk3WGdbeDYof6dUfkEwhQf27cG0FWe5DRuQ15NQ@mail.gmail.com>
 <CAAKD3BDFrTMMgX0nErD50rp2je=HC9zeaYWHDKf0mqQwc5fM9g@mail.gmail.com>
 <20170727204437.GA16986@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nljfjKcp9HDtPSOP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170727204437.GA16986-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--nljfjKcp9HDtPSOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 02:44:37PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 27, 2017 at 03:54:07PM +0300, Matan Barak wrote:
>
> > Digging a bit, we found a fix that might be related to this issue.
> > I would be happy if you could try that and report if it solved this problem.
> > We plan to send it soon.
>
> Yep this looks like it.
>
> FWIW, it causes random kernel memory corruption and failures in my
> experience, I was very lucky to get such a clean oops the first time..
>
> > commit 1d4ecbf034193f000fe6686586c40ab4b2a95da1
> > Author: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Thu Jul 27 15:49:00 2017 +0200
> >
> >     IB/uverbs: Fix device cleanup
> >
> >     Uverbs device should be cleaned up only when there is no
> >     potential usage of.
> >
> >     As part of ib_uverbs_remove_one which might be triggered upon reset flow
> >     the device reference count is decreased as expected and leave the final
> >     cleanup to the FDs that were opened.
> >
> >     Current code increases reference count upon opening a new command FD and
> >     decreases it upon closing the file. The event FD is opened internally
> >     and rely on the command FD by taking on it a reference count.
> >
> >     In case that the command FD was closed and just later the event FD we
> >     may ensure that the device resources as of srcu are still alive as they
> >     are still in use.
> >
> >     Fixing the above by moving the reference count decreasing to the place
> >     where the command FD is really freed instead of doing that when it was
> >     just closed.
> >
> >     Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >     Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Tested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> Please add a fixes line

Hi Jason,

I queued it [1] for submission, once the IPoIB fixes [2] will be
accepted, I'll submit it.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-rc&id=38a974d578451dbbde0c40fc2d81fba44027a338
[2] http://marc.info/?l=linux-rdma&m=150109276402195&w=2

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nljfjKcp9HDtPSOP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll9tAoACgkQ5GN7iDZy
WKfWjRAAzeH1o3orPidTUDC6d378jvPYAMQuyVDA7Owjx4OiJ4tzIdUiK5sAZoVb
mOJw1p5dW8x0BbWfrTVdS2eME80qHdnaRfRkIB+yUgNT6e63VvxuzoAdxtiwKT7d
RjQCOIYY+8N2lZbmE17r2qXa9+RmNh1EG4Jottue4iAqPkQ6PIZjeX+fVPhJI0Xv
QvnFS/QvvJtduZcGnanZjaYJJuWkEQNrASgKSHVcpT1KFZeB2XvNFw6CHQ78L52z
9SnLZnp9cbopkS5zsR6aOA1f2k0wZ2LP27ClMfKZ2yq5gtOvekG7y4SGJp9h/RHC
48b/OsvV+smYeFv3FjYA8HTedC0UJyY1uuUHAkJJtB2d2HwnSiCCwetDeTmQB31J
/XheJGnKEX+ldfe1B2n2JlxmZKXyQkc3gp0DfAV+A0WaBvmyfFAO0HGt2zcF+6Lc
+iWZYDVO2rc392kYFNh0+CaBWwpx+WIXn0wmVSkQS8fUoG7/u/98wbfubRVC+cMk
ufGnsXkOCu/F70EYQTk4dkORC0R9xNa7efhP7JX5CwD3Yemhi7zUmIIGlxodyVxz
8ttjyLF5/6fsXR3ioMG9kPeBWnCIHOv6ccTa+izJ1FCpRq/yfoTg/4fQAedWpERz
uchI88xkQNQupJLviuErl+HTYzk4r0synRPekeOfiF89kJ9Q50w=
=GcxE
-----END PGP SIGNATURE-----

--nljfjKcp9HDtPSOP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
