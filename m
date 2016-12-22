From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Thu, 22 Dec 2016 19:13:23 +0200
Message-ID: <20161222171323.GC18935@mtr-leonro.local>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1a61e971-4944-b8db-0fd5-b73118b578db@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1a61e971-4944-b8db-0fd5-b73118b578db-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 11:53:20AM -0500, Doug Ledford wrote:
> On 12/19/2016 3:31 PM, Tatyana Nikolova wrote:
> > RQ WQE size other than 128B is not supported.
> > Correct RQ size calculation to use 128B only.
> >
> > Since this breaks ABI, add code to provide
> > compatibility with V4 kernel driver, i40iw.
> >
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Thanks, applied.

Hi Doug,

Please can you clarify a process here?

In previous discussions, you mentioned that the reason of not accepting
some code to rdma-core was because it is part of next kernel and we
patiently waited for release. This code is definitely not relevant for
current kernel, but you are already took it before we ever released first
version of rdma-core.

So why are we waiting with libpvrdma and RoCE address handle?

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhcCbMACgkQ5GN7iDZy
WKdWTw//SjGVrJ5ExlmXybPnV2nIkkLNHDos98AZk77FC6N6FKaC8DrCTOdyjghw
xkaZcdmVvs7sySOBGW8JRFw7WUdEG+DoHO4ADguDyF25v+DJf8mwW64nOkhRQzaY
SdZzu2LlQkQef4leWs14kJtXDudxsDVHUPo3gyKXd/6VcvoMYxlD4AjK5vYkjtR7
nGw1Qis3IkNwzAiMoAGcrzwc62ty1CbMsaBqZZbfHOf0s3cyBw/Zk8FoHLOJAQs5
B7Q2ABF/ZmPmxmNfCJ97ovgIuJSb3/y/hZ9jEw3H2o9HmadXIaV6KI85sRLzyYHT
S/ZZZdz+nQQTLn5FLcrtQf+djFFpHogIgvrWwUd8+Yhd/YhkLKu6KHaKovPVNymz
mNV+gg63kd4c2QHdmQIH06ZoxHQV88VmyNBQkz2/E3Gce17RglAOtKbbIGFJyehp
BMyir9hzN9aCnXuOJJdM9Og25Y9fd9ednTosVWk/KtEODuWyStey/mpFFbz3V5Va
SHXTa4LZd7TTWKCfOoWiloa5GguNIBaY5CoLykK6jo1saqsWsmb4WUJj5W0NQW/8
adQ999vRRguyIxhGdAAdo6SF6nyv3HkvChFxiYB+7NyrN0fJpFACTaPIEtE21cJb
weHdIm8QYpDVHEu7PjWIAIjRQOlY0ep9u/5U8f6w7l7ygc9qh0E=
=1Cx5
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
