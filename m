From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] build: Fix build script to use correct cmake cmd
Date: Wed, 9 Nov 2016 09:27:09 +0200
Message-ID: <20161109072709.GK27883@leon.nu>
References: <20161021172728.27367.86783.stgit@scvm10.sc.intel.com>
 <20161021180523.GA554@obsidianresearch.com>
 <9745f6c7-8d09-8bed-d04c-78f610330ead@redhat.com>
 <20161021193034.GA616@obsidianresearch.com>
 <20161025101200.GP25013@leon.nu>
 <20161107235709.GF7002@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3W6riq+uV6J42Ub"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161107235709.GF7002-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--u3W6riq+uV6J42Ub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 07, 2016 at 04:57:09PM -0700, Jason Gunthorpe wrote:
> On Tue, Oct 25, 2016 at 01:12:00PM +0300, Leon Romanovsky wrote:
> > > stuff I have - eg should I make it pushable? It is easy to use, but
> > > you need to have docker installed.
> >
> > I would be happy to get it and be more confident in my local tests.
>
> You can test it out with this commit:
>
> https://github.com/jgunthorpe/rdma-plumbing/commit/ef24b991c949ad4f50614bf6bf549e1cdf841358
>
> It will need some tidying before it can merged, but let me know if it
> is useful as-is.

Thanks, I'll do my best to try it next week.

>
> Jason

--u3W6riq+uV6J42Ub
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYIs/NAAoJEORje4g2clinLx4P/jaStCMiJ5yOsAR4hyeS5+7s
O1yX4B0SbI5E3eWoBzlDIQrgMUsKfSfvO4Hrrp4NrZZssBMhX8bzs34W9EPpKfX8
156qEM6HgkfxxQ/Qv65gKnIMjcCIkZVeiLWHeT94ptx3pKvBfwzWiQaczCFQIgY/
81VE3dIFKdD+SQEV8izcFWZSn9zVOlUIWvD7Usbqz3H1E/4brq7VugHqofpak/tV
9bpEOMsIHW48vW9mN6uXVJdZTokR0eBduMzP+CuLXHy4354TKc8sVeevUCi6mrbF
pJ+Ph2xcWJoYtyB9VeyzZBaiTxALTOhouMHll5LFU/ohpBE1iDe+Zneclhq5Oh3r
b6vsSh9rtPCTY6e5sqlg9Ohu5a2iHANJrxyB7QebDPGYFLVeQfHaILrjMM26+1bX
aKFZC3ZUAikZMrrB8O08bZaifcR3yRf/R5SYOWS7ds/so7u8wEQNfBSm4DKquq6b
SPcgaAHOd9msmg1V3fE6nRFNI7ga3LzJNXj5QdwXR9YB8dQu8GI8t3d3FdKWQCot
fgUjtGDs18UHHBq1A9WG6cBpGMcprtSyFy0vZXV17mv7cPS9g1xDObjo+Myl3eaj
tOhv/Pj0nNPfSmveznTLbnQx+sBfLZHkprWgZaO5DWKqxBJZpwoEXpTzNTGaMLdV
JxX7Z0MeclVqmGPdaOEi
=M9vs
-----END PGP SIGNATURE-----

--u3W6riq+uV6J42Ub--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
