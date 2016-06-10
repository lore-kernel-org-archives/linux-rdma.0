From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 12/13] IB/core: Export a common fw_ver sysfs entry
Date: Fri, 10 Jun 2016 17:00:59 +0300
Message-ID: <20160610140059.GB5408@leon.nu>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
 <1465509248-11324-13-git-send-email-ira.weiny@intel.com>
 <20160609224038.GB13366@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160609224038.GB13366-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 09, 2016 at 04:40:38PM -0600, Jason Gunthorpe wrote:
> On Thu, Jun 09, 2016 at 05:54:07PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > =20
> > +static ssize_t show_fw_ver(struct device *device, struct device_attrib=
ute *attr,
> > +			   char *buf)
> > +{
> > +	char tmp[ETHTOOL_FWVERS_LEN];

Very minor request,
Can we avoid variable names like this?
fw_str can be a good candidate for the name.


> > +	struct ib_device *dev =3D container_of(device, struct ib_device, dev);
> > +
> > +	ib_get_device_fw_str(dev, tmp, sizeof(tmp));
> > +
> > +	return scnprintf(buf, PAGE_SIZE, "%s\n", tmp);
>=20
> No need to use the stack:
>=20
> ib_get_device_fw_str(dev, buf, PAGE_SIZE);
> strlcat(buf, "", PAGE_SIZE);
> return strlen(buf);
>=20
> >  	&dev_attr_node_guid,
> > -	&dev_attr_node_desc
> > +	&dev_attr_node_desc,
> > +	&dev_attr_fw_ver
>=20
> Should be=20
>  +	&dev_attr_fw_ver,
>=20
> Note trailing comma. Avoids git churn like the above on append.
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXWsgbAAoJEORje4g2clin4RwQANJl6NtL6LYSMaMoO2B+Xkqq
QCOctnS2S2Dbxey9IXChaikhr51phgVgAxFkv7uJ5dKVH/cC/m1SPztgnqgpjYxb
8o1O9jHM/bRvIQnlEjZbI05uIjSqUUgx2OsI5yXTq7oqHIiOfDAM6LKxPis6OILn
TGe9i+SmbnoOmxoEroNsO4ba14A8jOB70mKtEnNRG1u3PMI38WetHjlBDJ9IQrvT
PBrcG9DmMtPlKWckgDfFwOLP/qAT5bESgphpRGhR3W5ioQFuqMW9HF2xyAm3fQiQ
5pq6YBGpUnqSpVhJ5cSDee7wZ/VBnq3WRl4V76k4O5EjkiEMbr13GW3uzc2FONRv
TJUwWagrXLXWjhgW/buippt+8X3/n38YfUQqj7ORKAknbe/JnkIH24TBjZneRp79
acC5Uzg7n2d6Nw//Vcz7VQSSOgVjkWqdVkeGIQA+dQBuBtNsfiTnWwx7jRX3XlRk
2Rk8DyzCyuGPoaY7Ib4+mdCvmJCiiDhWMMMw71Y8285lg4VJQ4Wr4GeaMOh5HZeW
+BHVKXYPCragkh8On2YOrymTTmJfdq2S3iPsOlU/FjYEzeA80unZ343hpmS1JVnQ
oNJkbp3Ustj3hcB0FbjHZP+NEqgObsscswdHnITy9llM8uWrYEFLaV0zZu4buDtd
5dXCFKqxjwhA1mWFFpAD
=Wedf
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
