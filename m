From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 00/10] Rework the verb init scheme
Date: Thu, 28 Sep 2017 17:03:49 +0300
Message-ID: <20170928140349.GA2297@mtr-leonro.local>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F41/6/O0EvKTfNqT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--F41/6/O0EvKTfNqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 19, 2017 at 03:18:41PM -0600, Jason Gunthorpe wrote:
> This changes how verbs providers register with the core and are bound to
> drivers.
>
> The end goal is to have textual a list of 'modalias' that each provider
> supports, similar to the kernel. This list can then ultimately be used to
> demand load the modules instead of loading every module like we do today.
>
> This series does the work to bring all providers to use common code to match
> their supported devices, and provides the core code the supported device
> list. This is done by extending the verbs_driver_ops to include the matching
> information that the driver needs.
>
> Quite a lot of duplicated driver code is removed in the process, and verbs
> startup reads fewer sysfs files.
>
> https://github.com/linux-rdma/rdma-core/pull/214
>
> Jason Gunthorpe (10):
>   verbs: Change verbs_register_driver to accept the ops struct directly
>   cxgb4: Move sysconf up to driver_init
>   verbs: Split init_device into a match and alloc/bind step
>   providers: Use the new match_device and allocate_device ops
>   verbs: Remove the init_device entry point
>   verbs: Provide common code to match providers against kernel devices
>   providers: Use the new common PCI matching infrastructure
>   cxgb: Use the new common PCI matching infrastructure
>   hns: Use the generic modalias matcher
>   rxe: Use VERBS_NAME_MATCH to match the rxe device
>

Thanks, applied.

--F41/6/O0EvKTfNqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNAUQACgkQ5GN7iDZy
WKfuPw/8DkplyZ1VBkxq8ipMQvZkD94IA5uioqtrHWF5kCVhsYnigo5YG7zL3kx5
wn5ALb1RSytZ+dy7D3eML5s8k5oxOgqGhuFzE/WO4CDxNzqZ8h7l0wzI/fYhIROA
mJPUpQcWBxn3nBtCpXCmn+TBUg2imIokXcVh2gLd6+hYrMBe8E3o7uuDF5nnXYZK
H1QU33gNeAHiUAiHyBjLnyz3nDSpcMiRTRAMci3AoP9UtM/PjjohTSEKjqInttMA
Oo5F+nwaV9FO143ImMXPzdd5dXzUwYAsgFgGE4UBIXk8CTjsQyLaiehwiatdwCA6
S+bQlSSNDFYBO8oOVlpJjV+ma8kqusO0PkvfWGE4UhPlxgB10SjTYZHaKROoFcZ1
UZVkNQcJvgdVhcG3aRSCfbfzgFwK1O67RSSrZnt17z8FZk8ZBwbN8ThArwPcP3F7
Mw9PsncDvTbs+5Qp9qm2U+2XdQ4WnHwXTcpLClD8PY4M201kcdJLhf1+hQhLpZrm
TKjW+OwcLEK3CfGTSZto8n9aWKCPvu/LloWgIO/ROLn7fkZKfc93zGfma0p1DwQ/
Fa32K0SIzu+FbH8tJ97QUZDjs0frqKJ8ESDW5VSJ7y/x5sTvloXcpPun/K+xuIEU
O1vuVB+hUUCkGSdVTnmpkH4no4YvEbh/Mon1sIIu5xE5tnpnA6Q=
=c6MU
-----END PGP SIGNATURE-----

--F41/6/O0EvKTfNqT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
