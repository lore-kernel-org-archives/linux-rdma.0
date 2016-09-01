From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/6] Refactor RDMA IOCTL declarations
Date: Thu, 1 Sep 2016 14:17:49 +0300
Message-ID: <20160901111749.GB21847@leon.nu>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <20160823214759.GA16595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823214759.GA16595-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 23, 2016 at 03:47:59PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 24, 2016 at 12:31:41AM +0300, Leon Romanovsky wrote:
> > This patch set refactors RDMA IOCTL declarations, unifies their
> > location, moves all current IOCTL exporters to one place and renames
> > them to fix the differences in coding style.
>
> The end result looks reasonable enough to me.
>
> For the series
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Hi Ira and Dennis,
Can I get your tested-by/reviewed-by too?

I want to be sure that it is done deal.

Thanks.

>
> Jason

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXyA5dAAoJEORje4g2clins4EP/01DxBbcFuAP+rZY1Nlvtek3
55zIfoMN+Jk+LFgJ1Ee6TgvVmRTJPpP75g7NGJup+mbkoAqTcRuvZ2aUskCM2oD/
Obh61ppjOPvOIXanqWZkdYWGQYG6rWLucK+yMJ83MH77gDOO05WhzSsRny03r6WK
Gg8ROAhGF/zi8T7297y80rRFFoW2/Piq2oHKmDejXaOdC0McSgqs6Y5TGRDU9QBS
VGif+3FfGQIBeJ6IqBPJDE+LPJ5edHOVJaJ+Cjfi2CpimYBqxzOAAViovbXnixxG
OVMylD5qepjPtd838jUQHH1UvRCo0kEWIiYRBokbKv1rDwHSy8Sm6/3ivmunO/Vj
FHkEhkpMmmfxFcyEPViXDbb49QwrRr3LJfLl7k1ZSFS0+dm7vqZpNFsk+N/ftuWk
EGPo0RxbEYutkwa2NYtLd04PD3yMFVuYwiwru+NeqyszIIVHydsOn8ORCYX+XeJd
0kfouMsHOM2tKNZQrbf4KyBEMKXm3Q/AluJZ47CzuKWQfWb5u+h6OI/rVByCi3KB
b0q3MOyYkSEep5l1kD94013wyscYncYXOOr3QuW0hh1/2VnyrchVky3jXiPMCWH5
Zs6+u60MMlxoGjvpt8baLhtpu6slafId7ILPtPhnxENKPn/HsNF6ehgElfnmoI5d
a0Ls/BJJQquoj5jMyR92
=7nZy
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
