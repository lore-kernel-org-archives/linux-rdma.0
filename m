From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Wed, 19 Apr 2017 08:55:17 +0300
Message-ID: <20170419055517.GH14088@mtr-leonro.local>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
 <20170418172852.GD7181@obsidianresearch.com>
 <20170418173815.GC14088@mtr-leonro.local>
 <20170418181736.GF7181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170418181736.GF7181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2017 at 12:17:36PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 18, 2017 at 08:38:15PM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 18, 2017 at 11:28:52AM -0600, Jason Gunthorpe wrote:
> > > On Tue, Apr 18, 2017 at 06:52:00PM +0300, Yishai Hadas wrote:
> > >
> > > We could use a hash scheme or something to multiple the lock, but I'm
> > > really not sure that 32 bit performance matters to anyone anymore?
> >
> > In a hard way, I learned that we have a customer who expects that his 3=
2bit
> > application will continue to work, so the answer is - no, I care.
>
> Of course it continues to work.
>
> Does your customer fit this very narrow definition:
>  - Would actually upgrade to rdma-core
>  - 32 bit
>  - No SSE hardware (any Intel chip capable of PCI-E has SSE hardware)
>  - Multiple same-provider devices with a single program touching all
>    devices (single device performance is unchanged)
>  - Sensitive to the performance difference of a potential spinlock
>    contention / cache misplacement for ~4 instructions
>
> It is hard to understand who cares so much about peformance but leaves
> a wack on the table by running in 32 bit mode.

It doesn't matter if customer cares or not cares about performance. We
as a company provided satisfactory numbers to them and would like to
ensure that these numbers don't reduce over time.

I'm not looking for a performance boost in 32bit environment, but I
don't expect decrease either.

>
> Is this something like x32? We can certainly improve for x32.

=46rom the customer ticket, the system is x86 (32 bits).

>
> PPC32 could also potentially have a path like SSE..
>
> Jason

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj2+8UACgkQ5GN7iDZy
WKcuRw//ZYT+gclZjYgiVNvE1d3hsbB8NcX1rPk3gDENJaU80YXQCmKIVct/MP6K
e95OO91jBsgeR3CugTVBCm+9POvmiU62wU22Sj2pRX0vNnnzjSILoxZPwO7Qf9QS
vpVjqQ5RCNbPnyer6ljEYH2sEu1lQdo35A1gX/Lgm5wcyK9SskkXnNfrR+he1tZI
gG3tmO2f6SHkOSrHS01JoDQ/Qge8FCSG1vxRdwiuNAfY5dh/LyXgsyzEHUUuAIjg
ihHcH6qJZT3ppLovr/PBS9ONIH+6pHtF0bX2JBWdG1ik8QokaOFIBBVsMFMK8T14
42I3x3GHIBOTt0cAKtnrxDlwar2crBPb6SDu3/Iqyp3G11kq20ke1b7gTPllkpEX
SH6gzT6cGuqSGWQ+8Conyagv8JUrmno7fqBqoPMBM597Jeum1uyukwsT79Wk6wIp
miHtZhXnYfALT0K75XYo6HgrUIdGiWfSFuVfNK/NrJf/jIE6crA1OEWHR+DsuWgf
QSR2uHPy2bresrU/I+LPI2EMclvglshmmKJLtXzSNAWTbuV/od8Pc57qFIafRQI3
qCMgx4rC7K1xHlbKksYM/wo+4IxT0ui9MvPbuV2cnwvKRhlTPXXd3PSkTLkfvKrG
ybZY/tTuxRujWveJFDnWLi6zZgDo4nEZYEAHQYzDpFqnh6NFEqs=
=jNUo
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
