From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Remove redundant fw_ver sysfs
 entry
Date: Fri, 15 Sep 2017 09:36:07 +0300
Message-ID: <20170915063607.GC3405@mtr-leonro.local>
References: <20170914132140.9812-1-leon@kernel.org>
 <CAOBf=mvHS+P+n-Bvcr9g9qfWaN8RbRUdPJn2YGm-QD5SS_VcKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gMqNd2jlyJQcupG/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOBf=mvHS+P+n-Bvcr9g9qfWaN8RbRUdPJn2YGm-QD5SS_VcKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gMqNd2jlyJQcupG/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 15, 2017 at 10:51:58AM +0530, Somnath Kotur wrote:
> Hi Leon,
>                 Thanks for the patch, however this will not compile as
> the corresponding entry from the bnxt_re_attributes[] was not removed.
> Having said that, there is already a patch in the works in my sandbox
> that addresses this area that i plan to push as part of features
> patchset right after my recent bug-fixes patch series is accepted.
> So we could drop this for now and wait for the patch series that will
> address this please ?

Thanks for catching it, your driver is dependent on CONFIG_DCB and it
wasn't enabled in my default config.

>
> Thanks
> Som
>
> On Thu, Sep 14, 2017 at 6:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > The IB/core has general sysfs knob to print FW version.
> > This eliminates the need for the custom bnxt_re implementation,
> > which is similar to the general.
> >
> > Cc: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/bnxt_re/main.c | 9 ---------
> >  1 file changed, 9 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> > index ceae2d92fb08..c686887bf71e 100644
> > --- a/drivers/infiniband/hw/bnxt_re/main.c
> > +++ b/drivers/infiniband/hw/bnxt_re/main.c
> > @@ -525,14 +525,6 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
> >         return scnprintf(buf, PAGE_SIZE, "0x%x\n", rdev->en_dev->pdev->vendor);
> >  }
> >
> > -static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
> > -                          char *buf)
> > -{
> > -       struct bnxt_re_dev *rdev = to_bnxt_re_dev(device, ibdev.dev);
> > -
> > -       return scnprintf(buf, PAGE_SIZE, "%s\n", rdev->dev_attr.fw_ver);
> > -}
> > -
> >  static ssize_t show_hca(struct device *device, struct device_attribute *attr,
> >                         char *buf)
> >  {
> > @@ -542,7 +534,6 @@ static ssize_t show_hca(struct device *device, struct device_attribute *attr,
> >  }
> >
> >  static DEVICE_ATTR(hw_rev, 0444, show_rev, NULL);
> > -static DEVICE_ATTR(fw_rev, 0444, show_fw_ver, NULL);
> >  static DEVICE_ATTR(hca_type, 0444, show_hca, NULL);
> >
> >  static struct device_attribute *bnxt_re_attributes[] = {
> > --
> > 2.14.1
> >

--gMqNd2jlyJQcupG/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm7dNcACgkQ5GN7iDZy
WKcikBAAkVGSXYJ4t0MKkd9RuYFxkqWan1oW0mowpGnI3lae9ybgyAFo7B5qf9x4
9EL0/GQ+3ngLF+2uLRTxOeF8lGyiBlMklT4j3c2tIqbQqfilBigKnlUqpj/vF5yt
vn/PZqLNHWLhxalq3U0s07hxbLdAMXoIwNy2YSLMfB8977Bh6vWK3eWT6URxNbiz
wLbWMr3K5f+FOvhKICDtfHCAlMWPZXx5O5blJSJP0TabDkwPNInr/zB5hgRmQhpx
DL1ksCZlHRwZ00vsp2MN+Zg0gdfefA5HRVkf243ZeAXnHC2wzCHK9jMsQGqTW6+B
sdpk/4iXdkiYU2ArgJjFecyU8JDCQKpRB/gpCS4ySkTBCwjh+Ic9TkQlDIZWEn95
GA8bxaLAOA7YR002a6Ijz5sZWGss5b8Hq/SSFGidQ+DQ5KnQigpuuHufrYPhjeAK
a8sieg2W+F16DaP3LIw8OPBbiH+cTjog8wHlmAUrgqZoI7SsAcjPs4HYYZH+Bl6u
oGiTAIWPVgACmCxqUwuMvX21XpJVc/Gl6lTT3smtafbCZQhWAweCSMTlVuQ1Uu56
FD/F/bdG+ptqw/6s2jkWT5JeNhANFItXM5/CTTDfCjDYRSMN6faOuAat+/KOwbRL
ssuQQoYSbumrmttDDlRgqcVkEITbZdYSMiBbAlNcsv7UAJmcJtM=
=C7/Z
-----END PGP SIGNATURE-----

--gMqNd2jlyJQcupG/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
