From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/1] RDMA/core: create struct ib_port_cache
Date: Tue, 17 Jan 2017 13:51:06 +0200
Message-ID: <20170117115106.GN32481@mtr-leonro.local>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
 <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
 <20170113150103.GP20392@mtr-leonro.local>
 <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
 <20170115085014.GB20392@mtr-leonro.local>
 <f08926e7-54c1-fa48-2105-308f82ddcc23@profitbricks.com>
 <20170117112426.GL32481@mtr-leonro.local>
 <a68939e6-62d3-0d83-16f4-e7784c6fedad@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="64LDleNqNegJ4g97"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a68939e6-62d3-0d83-16f4-e7784c6fedad-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--64LDleNqNegJ4g97
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 12:34:18PM +0100, Jack Wang wrote:
> Hi Leon,
>
> On 17.01.2017 12:24, Leon Romanovsky wrote:
> > On Tue, Jan 17, 2017 at 10:11:12AM +0100, Jack Wang wrote:
> >>
> >>
> >> As Jason suggested, we have 4 elements for per port arrays,
> >> it's better to have a separate structure to represent them.
> >>
> >> It simplifies code a bit, ~ 30 lines of code less :)
> >
> > The commit message should be descriptive.
> > You really NEED to read SubmittingPatches before sending patches.
> > http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L106
> Okay, I can improve the commit message.
>
> >
> > 106 2) Describe your changes
> > 107 ------------------------
> > 108
> > 109 Describe your problem.  Whether your patch is a one-line bug fix or
> > 110 5000 lines of a new feature, there must be an underlying problem that
> > 111 motivated you to do this work.  Convince the reviewer that there is a
> > 112 problem worth fixing and that it makes sense for them to read past the
> > 113 first paragraph.
> >
> > And if I read email headers correctly, you still didn't use "git send-email" to send the patch.
>
> Yes, you're right. But I thought I can have my own preference, or only git send-email is allowed?

It is convenient way to send patches to Linux kernel. In your specific
case, your mail client set wrong email headers which caused to attach
your patch to wrong thread.

So, you can send patches with any tool you want as long as you know what
you are doing and I'm not sure that it is a case here.

Thanks

>
> Thanks,
>
> >
> > Thanks
> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--64LDleNqNegJ4g97
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh+BSoACgkQ5GN7iDZy
WKeMiA//RepYz+OunVfS5jrm9oqPvYEmvEHE0d86H9ocYTWgMhfXjh6B0LWqfRIr
2Z5EMiTkp0AwgtqMthTni6o0nEXzBlEZD4sr6WHfP8lCRjaAqkYzAzUNKyzJUeYz
ZWcDAlVCWLiY5snZL1hJ0XbtCmbDwBYbAP0H6mPW8K+ZdBePxDBQBbYs12RHmE+s
Mfq6HNkBeegcFsBb9loTqWfWyhNz72rWWXyrGYbb7/Klw0JtLoeOnaNuUVYKz4lu
oigfCM/j+m+EeyCQQtUFWC5KTz6gNRgYp+ShPakg2PeBbcnvabZgsLYCLoDtKCGj
9C56jmlaBdk13qjY//xIaR+8NzsRQgAkeoNaNBFxZVdR3mRorecO9IXMF+C1J+K5
8QZGlX1plJuRGbynrm0nhTDbt92ktkQqHF2j+It83K0Pk/17OoWr8ZniXGvvVoBf
89t6HVNO63R6CAMdl5z5H0m35SMemb3mDi5Lwiqr5jOfNtt3OsTL3IoSzp5/xtz1
Y+k3/y6NWWQWFcq4V9zA49npWxW5XJgVH01yMc3o86U7Yed1joWXJlBMiS8c6CFq
7xRv9ZRl59sMKFp5rTdvgBPcP3ZQmSD+LPUM8SdJdNtMcn8KIi/2MwgdMb6Un0Lf
/v9fTzyyk1vcZuZQT4naHjx7KxDuqEFP3cDIBjxE83MOjpci1kk=
=wv6z
-----END PGP SIGNATURE-----

--64LDleNqNegJ4g97--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
