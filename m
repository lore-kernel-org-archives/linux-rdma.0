From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Thu, 9 Nov 2017 10:28:34 +0200
Message-ID: <20171109082834.GA18825@mtr-leonro.local>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
 <20171107144517.GA25631@embeddedor.com>
 <20171107145018.GJ18825@mtr-leonro.local>
 <20171107085637.Horde.qFzN3uJQkHeQUTyEgZzV4mv@gator4166.hostgator.com>
 <20171107162804.GM18825@mtr-leonro.local>
 <20171108141625.Horde.KGzDIfS83FFw-l2cUJ_EO95@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="213E7WwkW+nU62+Y"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171108141625.Horde.KGzDIfS83FFw-l2cUJ_EO95@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--213E7WwkW+nU62+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 02:16:25PM -0600, Gustavo A. R. Silva wrote:
>
> Quoting Leon Romanovsky <leon@kernel.org>:
>
> > On Tue, Nov 07, 2017 at 08:56:37AM -0600, Gustavo A. R. Silva wrote:
> > >
> > > Quoting Leon Romanovsky <leon@kernel.org>:
> > >
> > > > On Tue, Nov 07, 2017 at 08:45:17AM -0600, Gustavo A. R. Silva wrote:
> > > > > Check on return value and goto label mbx_err are unnecessary.
> > > > >
> > > > > Addresses-Coverity-ID: 1268780
> > > > > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> > > > > Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> > > > > ---
> > > > > Changes in v2:
> > > > >  Remove assignment from "int status = -ENOMEM" as suggested by Leon
> > > > > Romanovsky.
> > > > >
> > > > >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > Please use git send-email to send patches and not reply to the
> > > conversation.
> > > >
> > >
> > > I'm using mutt.
> > > What would be the advantage of using git send-email in this case?
> >
> > New mail headers, so it won't appear as Reply-To and will be presented
> > correctly in mutt's threaded mode.
> >
>
> Oh I actually did that on purpose.
>
> So the preferred way to do this is to send the vN of the patch as a reply to
> the first patch?
> or as a new thread?

As a new thread, please. It gives numerous advantages: nice view in mutt,
easy followed links in web archives and maintainer's acceptance email as
a response to actual vN patch and not to initial patch.

Thanks

>
> Thanks
> --
> Gustavo A. R. Silva
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--213E7WwkW+nU62+Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloEEbEACgkQ5GN7iDZy
WKd7HhAAj0IX4IUW7iLi/Vx9PT+HurMJYBVHuBjcg7TnpJgH3YAouQ+GdvUXQwyh
alU+OATTi1UQdHnzcoRVoGs+NklDOZg59Ss651peKeg+Ut6y4taMPH8u9oGojO5I
boLeHm5/zjKGN1bb1KgW24GPSMiK7Jn+fbTmhM47iJ0H6Ja7JVgZNR+mhKArv2ZE
vhjjcryaKWgpHUiG73Tu3FsV410lMWGwmTutBB26dz1oZH8oYg/wZKvLhaWHxLid
oVErczqcFogl9d+iGqGY+jFsxXCFYXPegv1EbEQIwYQDM0ta4+OmlwpsdRstEXWY
epgsIPVCsvLgSEx3RvWK3Dhc5pMSH5zKQXlF8E5BfGA35nT5UiHKhjY3F5jN24zg
WsFKGfyXt5S+7rhUZpL6Sq2FHgQdD1xZGt9Loz5Bm8Z9rB0lVbefWR1jBCMFesFC
RM2DUev9i4XPF5KWC6ETcoZiTcYb8cDUczInXbIjavXAgAnY5mLr0+zTCZCckFxW
RrNSF3gCsayII1T2fh98ZHiHR+RuiUfMRhXdFFCbW47k0puNyvSULMth0LrIptaG
X03kfd4VOtcQejqcBOnZoQiWzFSLSohaki/LejA8op+7IWt8kESUed5diZt2jN2C
M+l2ptNfkqxu7+kOB4ZsGQ6dctem93P//vMazwGIMvKNqjUN2x0=
=gM3h
-----END PGP SIGNATURE-----

--213E7WwkW+nU62+Y--
