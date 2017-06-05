From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Mon, 5 Jun 2017 20:41:51 +0300
Message-ID: <20170605174151.GR6868@mtr-leonro.local>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org>
 <20170605170825.GP6868@mtr-leonro.local>
 <20170605171749.GA20477@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3loezlmesXOUD0D5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170605171749.GA20477-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3loezlmesXOUD0D5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 11:17:49AM -0600, Jason Gunthorpe wrote:
> On Mon, Jun 05, 2017 at 08:08:25PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 05, 2017 at 11:44:00AM -0500, Christoph Lameter wrote:
> > > On Wed, 10 May 2017, ahmad omary wrote:
> > >
> > > > We have considered using mmap(), but As the size of device memory may be limited
> > > > ,the way to access it from host cpu may differ from vendor to vendor, due to
> > > > the 4K (page) aligment limitation of mmap() and the need not to directly
> > > > allow user to access the device memory, there is a need for a wrapper access
> > > > methods API that allows allocating and managing chunks that are smaller than
> > > > 4KB and not necessarily aligned to 4KB (page size).
> > >
> > > Why are 4k sized chunks a problem given that there are megabytes of memory
> > > in these devices? We are using various adapters already with an mmapped
> > > solution here.
> >
> > Ahmad presented use case where he needs access to small objects
> > (semaphores) in large scale (MPI). 1MB in the granularity of 4k will give us
> > 256 chunks only, and it is definitely not enough.
>
> Is 256 chunks per machine not enough? A single process could carve out
> smaller regions from the 4k kernel allocation.

It is rough calculation for 1MB, when I asked Ahmad about this
limitation (4K) he explained to me that exposed device memory is less
than 1MB.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--3loezlmesXOUD0D5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1l98ACgkQ5GN7iDZy
WKeW+Q//abb6J3j5G3rdptp+zOLMgiMN+ZknV7iT1B7l6ikiYEZdH7mjwUjozLVt
gDE2P+fsA33W4hXqb27jGBoTUzKmeUpane6/XHY+zokqa7Ft/JnCAILNpH3/8EJX
7IrYDH7cDVFU0dZK12WlV4FGOeclQ/LKDDtIah1sb6+bhHr3Ca4Sdp+CFwObW5mU
FYErD9Xkx3mGDk/kQTs5S6A00mqzxjtxt2nYdee4Xxx4DEwp7tTT7QOeNurt1s/c
0l93HxvYRFaK0a0xMNpp9WUImBV2nteHLb0vFo4bvzk6BYHe/YL4LESK+6I0QUx+
z0rjij3emXQvDJVDOizOziQJHe4VX0YKThptcqk66gt2KgVXLPNyI/dE89rJvo2e
Hz8/FEvv5GWOqa9T+vPbSzfiKtAYWTQbXs51vs7BFgrwWt0s9lOeTkv5ZeUjaf+S
uAWytll0i7DmMVE8YKkw5UzSSMAa+TQZKDIcxXu+f5YLO2QWQdcrK5hDcR31m1R+
r6jRviNADLhRhrhe6YI7tTcpaw/dJnjd2rwDCHEuTtK1vFswa3dwFJPLXMyYn45G
gd5UP56gCtoJt/tuVkaEDU8BTXClZeRrGJDWe9B8s2ahDNrhzJnBXMiakVL1LUEh
8ZHNfE0zCq202RduOiWjRJJd+8UsnUiaue8qQPT41XCe71COaaU=
=iRY4
-----END PGP SIGNATURE-----

--3loezlmesXOUD0D5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
