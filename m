From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: build failure on linus' latest master branch
Date: Wed, 12 Oct 2016 11:42:43 +0300
Message-ID: <20161012084243.GQ9282@leon.nu>
References: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com>
 <20161011120219.GM9282@leon.nu>
 <004701d223cc$0772cbb0$16586310$@opengridcomputing.com>
 <20161011193633.GN9282@leon.nu>
 <c2dffb44-d600-40d6-ec5d-09ef917da877@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="utew04vv9FCWZJ01"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c2dffb44-d600-40d6-ec5d-09ef917da877-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--utew04vv9FCWZJ01
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 11, 2016 at 04:47:53PM -0400, Doug Ledford wrote:
> On 10/11/2016 3:36 PM, Leon Romanovsky wrote:
> > On Tue, Oct 11, 2016 at 09:30:35AM -0500, Steve Wise wrote:
> >>>> Is there a fix for this?
> >>>
> >>> We investigated a lot this failure and it appears on specific and very
> >>> old GCC 4.4.
> >>> http://www.spinics.net/lists/linux-rdma/msg39135.html
> >>> http://marc.info/?t=147614305200001&r=1&w=2
> >>>
> >>> And the fix is http://marc.info/?l=linux-netdev&m=147615976207362&w=2
> >>>
> >>
> >> Thanks.  So was it ever merged?
> >
> > Not yet, I hope that Dave or Doug will forward that patch to Linus
> > before -rc1 is released.
>
> That patch isn't even on my radar.

I had in mind to wait till v2 will be sent before asking you and/or Dave
forward it to Linus.
http://marc.info/?l=linux-netdev&m=147623786131380&w=2

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--utew04vv9FCWZJ01
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/feCAAoJEORje4g2clinwyoQAMlVd8vnJmVyVe6DtQDJW973
8zfYXgTAPPpwh5/a6kFsduasTUmsFMkdEFwtveB4unGqml/jN5oWK9WH4CiQPdwT
trzQZYF+QkIbn0r2LD/6TpWYPsPOGBXXkx262SaRpSy5lj6yOakziMQcusbDzUAC
QjUVfnsA+9hvZ69onmzK7Q9mgYTQtuGW8SrIZMlL1gC5a+0fd1PJCvnk2EfTv5ZQ
53J3nbhflG641pZ7sVKEkOHG5mRhVe6G60wSce0qW7BtKBELUBHXSW9N0J1wffSa
GY+MvxHFXvKVDFyMsmN7WBnxsNDJKu96KxLXolLjxMM3BOeT7p6kCpuluMLLjrHX
SkMuDkIWNKQhNXNMtn4FQ9J7S4AeUA5I8bt5tE4d9wMbqwX2oHUHohKUvWkcnPH/
KZAygrJbH+tLwbvUtVtDwkTEOcnrnaqyRbNGEsFfpaXDWwYFhciJZuA/RsvQhuJl
cLbzvXIadZDzXWDgq1Qy2SNR9Wq9j+miWabbh6OVBV7HK+YYGDjWaiEVdA3aQvKB
mfHj8pFCTuM2mof32Pq2UrB8AuR5THiIz2rgnEi2UwrC+ElOAHPKPdSDR/Q9R7q+
LC9FkkPF+v4VrHOVYVIj5ihtIRbXOu3e8E9/pTs5Kpcmue99W05o9i9Z5ZNq+CMW
J2vzxiwJhJdE381czdFa
=5dWQ
-----END PGP SIGNATURE-----

--utew04vv9FCWZJ01--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
