From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Sun, 22 Jan 2017 10:16:40 +0200
Message-ID: <20170122081640.GG28570@mtr-leonro.local>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
 <20170111181042.GC22783@obsidianresearch.com>
 <1484773260.2406.58.camel@redhat.com>
 <20170118210831.GA7590@obsidianresearch.com>
 <1484784989.2406.67.camel@redhat.com>
 <20170119175802.GB8109@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170119175802.GB8109@obsidianresearch.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>, Tadeusz Struk <tadeusz.struk@intel.com>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, dennis.dalessandro@intel.com, ira.weiny@intel.com
List-Id: linux-rdma@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 19, 2017 at 10:58:02AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 18, 2017 at 07:16:29PM -0500, Doug Ledford wrote:
>
>
> > No, mlx5 could have easily hit this too as their ports are separate
> > PCI functions.
>
> Sound like intel and mellanox should collaborate on getting udev
> stable naming working right for RDMA... They are eventually going to
> get burned.

Send patches and we will be happy to review and test them.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliEamgACgkQ5GN7iDZy
WKc1PQ/+PH/GxdzdZ5OIW2P0T4qjRcoK/8cyyN4l/+kmM/ozINdNv4ue5HxsZlyx
y0q7/I+rza83FVEl/9m8C+9ezTZyVf28pRRpqqbAOagb+9JS9ErLKV6oUJ8hHRl9
WJLxJFlT/JviAWBO67YPfuJwGIKybPr1fjOrumHYN+yrBeLn0Iu/YPFOmpeOWtJN
1PVjYLXUPOXL/T/YecKjAk7OyCZ4lgPbyMhvRK144LoYeEfD8QIRHfcx2Ii4AxEH
bFqICb/XxNiuE71RHjRbFu2Q/e5mdbQOH9caRH4cox+AUPWpA0zGtxp+kHeo4MTA
VuRUtnZYiTYd+Z6nkBkqZrXkbCafZlUsJlSK+YDFnO6u9G/duaWKIDHLB+LP2zUj
8SiwcT5Jstax8R/mGfhh0oNwotIClvAjhw0V0D/OC8nWX5x/1cHuaQ1fn0idhU+j
JqxPS+BvK4vEH3wde7G7P2CcTf7EweDgt2J3nFchdHwKaAal01JkE46nMF65vVhT
xvbOGiJGy0M8L0Mv1lEbXK7Xf+lpyTBzLhb1LaOS12+FLNWI6+1TGK5TsoNQBh7U
kWPomf+Vplw6d/NCyQfHcG1giuLF7AIVNYkWJXQUEboyUYyBc7qynCfPsa6qwdnG
DvpIowXYcOvIWT/+XmSm9au2hvo9drK7EcTJlJ9xwz9Rdvjy5MI=
=crFK
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
