From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Tue, 4 Apr 2017 22:57:20 +0300
Message-ID: <20170404195720.GA20443@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404194750.GC10780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w5er4h4/Yf2qR8D9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404194750.GC10780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--w5er4h4/Yf2qR8D9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 01:47:50PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 10:17:26PM +0300, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > This patchset mostly comes from Erez with one exception in the first patch.
> >
> > That patch origins from two different commits, first from Niranjana who added
> > RDMA netdev interface and second from Erez who added IPoIB support.
> >
> > During the preparation to submission, I squashed their commits into one
> > and refactored code to allow submission as a standalone topic without creating
> > dependecies between different submissions. This caused to change in author line.
> > I hope that it doesn't really matter and it won't stop you from merging it.
> >
> > Per-your request, I based this patch set on v4.11-rc3.
>
> I didn't dig into the details of the ipoib part, but I think the
> core change and the overall look is now what I would expect. modulo
> the little comments
>
> It would still have been nicer to isolate the 'default' implementation
> so those functions did not touch ipoib_priv, but that is also
> something that could be done in a followup..

Thanks, Jason

>
> Jason

--w5er4h4/Yf2qR8D9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljj+qAACgkQ5GN7iDZy
WKdf/hAAoWLfI5UHRVw7Oqv6gKSnn6G8I8u50Qw5DEw6Z3MKcgq31t12AulyPHmv
eCvF4XlYqH9N/Z0ajhotaerWe9AqLjhJDcLwpzuoy2/fnO6/oZE/208BkHKy9dsd
qvSoy0Q4onbspQANlnOYGWWBYyiDrPa0zxOgJ7IhX9uKOztAj0uyJvB6DXlpDzfK
JeRJW5T3JgMWY/WXOXzI80CWzkHtf/6J+l90tSGKZsiMIH74CtLo85uXURGradKi
KiE5oXFyig37czE3I7euQ44lIlg2uCJdKlzEx1t33LlTovB2QlNo2xPv8BlqK4T2
yfc0PPGUXaU78vDJvVmXeRANacAkQNsNmObt9VJy9rh0ECNlRhaVrJvNQsYRwGYx
mO3a93AdY84hDA6tWCZEfbnV0ZltsN5zPUK5EppRruiTnyAb3JjXNksKi0v5dlrH
eyvaznQ0Q3aaDo7qYZxhFc0RJNf/t51RnvheNSx6CQA/La+iQIUz/JZlrd0Fejy8
mEW2/jlsl/cX9mDNNX0PSLpIx+tqqR5PdTyQdfqPXe/9AbX/NDoN/Iwxpmb+WiSB
z0wEV3Vy5Xr0CKtaapCLJtEMmD///2Q2r7dldmUEGIbNlmINXCrFQJRgp4Bb1+lu
NnJRuIhmBsc4g4ztzPE7EQpNSArAFNztwsSrWmK0HFqzaSHGjoM=
=W/05
-----END PGP SIGNATURE-----

--w5er4h4/Yf2qR8D9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
