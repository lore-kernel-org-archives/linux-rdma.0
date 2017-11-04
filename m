From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Sat, 4 Nov 2017 12:08:46 +0200
Message-ID: <20171104100846.GA1636@mtr-leonro.local>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171101161328.GB7815-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 01, 2017 at 10:13:28AM -0600, Jason Gunthorpe wrote:
> On Wed, Nov 01, 2017 at 06:00:40PM +0800, Lijun Ou wrote:
> > @@ -385,7 +385,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
> >  		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
> >  			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
> >  			wc->wc_flags = IBV_WC_WITH_IMM;
> > -			wc->imm_data = cqe->rkey_immtdata;
> > +			wc->imm_data = be32toh(cqe->rkey_immtdata);
> >  			break;
>
> This can't be right, wc->imm_data is marked be32.

Lijun,

Are you going to fix it?

Thanks

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln9kaIACgkQ5GN7iDZy
WKcBrw//dicsmOdJrL8O7gOjejXEv0WY/U+J2uvNnRGFOwzF+sBwEZZwwhyXlHnh
gVYzw1NPPd1YiXWOD6Ci4VFFlD3cpdckVlrBIo9+Zk3+Mun0vUNAkUWVTjlgIVBB
oeNWPmZBFsHsD+k6dVlpWEWEYHPZoL2eBGlMRXt+U/nul2igDv5vYsYPKpRBHTcW
FooaeXiF2gnEwWMiYsykebuNsIpkw1LVWTP7uSej6auY9AqsBcFq6IUjlQYnOWEC
qKBj5vJa/pUNnpLuzYsXkTVu0dwnPX2ayv2TAk2gxp6n7UJ9B9UiFnZwniVSoPc+
VhJ1tlZVVkhAgDm+xwsOmncGpusItAq7anhlp8sr2s9JC92Boh/AfxdlHlpXJ6on
ZE8ofQj8SMZ7gwGzHtkgZozeWsqq4YVf7HhgConkcLk/PRTf14h2jIX4fOCVuzNO
NamVwvfenpq6/9Goh6Yn+HEVJ2z/Cn4gORtJtx1f2Op7DKmpLKh/735TBJOT7pQX
s5HfTvMhYOdaBLakxPe4hDuc4TaMhZPs/t3MjIr7OpmcMBawsK8YceNQG/1TDDDD
+HxmjTo45ZSrwY5lGXqVf+0LprDEckCqeSptmbq7ZZujsykdwIAo2zudEsOAnAS/
XVKW1PmGFC4w1t+Z9XM5ZL22DMWj6eIXDpvag0wJFU8NDC/cjEo=
=D1/e
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
