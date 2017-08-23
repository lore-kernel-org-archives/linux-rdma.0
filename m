From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-next 0/8] Export device and port properties
Date: Wed, 23 Aug 2017 19:27:18 +0300
Message-ID: <20170823162718.GS1724@mtr-leonro.local>
References: <20170815091431.12822-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zfsaV+LVqEQKX7k4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zfsaV+LVqEQKX7k4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 12:14:23PM +0300, Leon Romanovsky wrote:
> Hi,
>
> This is the third part of RDMAtool infrastructure changes. In this series,
> I'm exporting various device and port properties which are parsed in
> RDMAtool.
>
> Due to the fact, that the "IB/hfi1: Document phys port state bits not
> used in IB", I embed its content into the actual patches.
>
> As part of this series, I performed small code cleanup to improve our
> static checker situation.
>
> Thanks
>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ----------------------------------------------------------------

Doug,
To be clear, this PR is not needed.

Thanks,

--zfsaV+LVqEQKX7k4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdrOYACgkQ5GN7iDZy
WKd3chAAhbw9NrOosjS3YrrwlTYizKjOspEAEgNO9UlAT5lgTTCfK7LLGxZ9PyaV
YjVQ/wDJ4Og90PPovqcInb7Vq1PA+jF8tk/XTwmK7zHed7cvEeS5uuV86RwtBi65
56gUA8P1IwPDwotGPRLi2fLUqrbvziMeerHaoGLcgEXy9G29xMT3A/X/7HFQBS5U
q0GtRnicaT9hZ5OTAWSozudFQRA9e4Sp18k6uTInoK6vlg4ppJwHYtLuFhsnghkQ
V1Tm/KSanry0UQRTJk8HYkvxT+5pZPX4eQ95AfHfeLThCeTO6ijgAzko12BC7IVB
8E1lpbI5Pk9kg0VY5sUFSAFndF587APrhmR744MxIoSPBjku4UTHCMvgx2OwVuuU
CZ9IqkDxfH2zY/shVz8rOOxqrbd9/eQ/8f63tiULTO2H/RvTePVyc7vCaQCkfi9I
pfLxDj62Mdhr2pmnmaXy0pQuWOcQRdRRIwh2etu7db2AHr6y96Pl3Vp02j5zpqDl
aJVtFpR9qJZKbC4zNr/oBDbOyw3Fu2nl6AsDHAQcz4faVDlI9UFk9OIo1/uXYc/G
kReWiqHGEijxdWp91TfXwWUEwTfgNk9MWu2uLNzYWMIR7KsDPd4I2vPls6BzFh+8
o/EySYPeGLr+SO+/PciXjmqBQCR2BGW1ceuFCzbgA7vzlzNisZQ=
=8+T5
-----END PGP SIGNATURE-----

--zfsaV+LVqEQKX7k4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
