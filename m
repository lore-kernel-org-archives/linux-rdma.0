From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 09:31:08 +0300
Message-ID: <20170606063108.GV6868@mtr-leonro.local>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
 <20170605172058.GB20477@obsidianresearch.com>
 <20170606055229.GT6868@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YvpO9wCO44Ze8QQC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170606055229.GT6868-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YvpO9wCO44Ze8QQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 06, 2017 at 08:52:29AM +0300, Leon Romanovsky wrote:
> On Mon, Jun 05, 2017 at 11:20:58AM -0600, Jason Gunthorpe wrote:
> > On Wed, May 10, 2017 at 02:25:23PM +0300, ahmad omary wrote:
> >
> > > struct ibv_dm *ibv_alloc_dm(struct ibv_context *context,
> > >    struct ibv_alloc_dm_attr *dm_attr);
> > >
> > > struct ibv_alloc_dm_attr{
> > > size_t length;
> > > uint32_t comp_mask; /*enable future extensions*/
> > > }
> >
> > Can we please stop this madness where every function call needs to
> > accept a struct?
> >
> > It is perfectly fine to add new function calls if new arguments are
> > needed someday.
>
> IMHO, generally speaking, it is better and cleaner to have similar functions
> signatures for all APIs which is exported to user.
>
> >
> > > int ibv_memcpy_dm(struct ibv_dm *dm, struct ibv_memcpy_dm_attr *
> > > memcpy_dm_attr);
> >
> > To be clear, this is has to be a sycall, right?
>
> Yes

Or to be more clear, it depends on the memory type exposed and specific vendor
implementation (memcpy, e.t.c.).

Thanks

>
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--YvpO9wCO44Ze8QQC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk2TCwACgkQ5GN7iDZy
WKezJg/9HIa3M1WlCFJK8bxZqHF4ybn6v4DN0mth+HPHIAIXe63mogRzLT/0DugR
3uyxVbYiisbHcMscM870hHtofYuSGTdteJawyomQbnUvYxLwWx9ojsj9TD+jekBk
6yBjnAObM6IcG/1aYf84wcGUabD1v5LrtHKxB2qgcoTHOQef3ShnZrJfg1YsiQQw
wIty6Q7a3eDfPcxr4w72mKWUH+ymZ+fc32fQ6kERHdaQm7/PC/mGhLJF+PywlK3E
wuZ5bExThADuvCu1Lfe/mP6MqmmwPRkh6lafv+ahgabezGV4Le7BZPYGt2WlSK7P
eqrb4cWUxDUAYtP9z9nQkQVpyZR02+IFVf/vAxHSwCFEFTBXcGGmgdkB+SDWJYk7
pFbMbb1uYt54Cjs9ClWaETLiyFSpBzeOCmlZ0Gg1YlDe6ppdEQZYtfq1jHwQtgdz
LoTXLoRiSTBc53FO7DepnLOtxhbFea4LgEe8z/VUjTxfPQijrUYks3LUvZ8ZezFj
kEPZAYLc32jjJD+sfgxUzasiHXC7QTYjDrJ4+mfDZFlWlsnG2JOUDDZEeZTvQfFQ
hyZpI/anqoP1zBsS45HfvriReecc0Gtan8iXLIt5341lXRea4NRxXHgJ8R1tzex5
iFSJjom5RMcqK4urSCPzpXf0fS5gRKXaAdNMdKUE2chcDjAsYiY=
=WbWl
-----END PGP SIGNATURE-----

--YvpO9wCO44Ze8QQC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
