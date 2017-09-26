From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Tue, 26 Sep 2017 20:55:24 +0300
Message-ID: <20170926175524.GA2297@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170926174946.GA1218-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 08:49:46PM +0300, Leon Romanovsky wrote:
> On Tue, Sep 26, 2017 at 07:08:37AM -0700, Dennis Dalessandro wrote:
> > Hi Doug,
> >
> > Here are the other two patches for opa_vnic. This adds a debugfs interface and
> > that is why I'm sending it as a separate series apart from the rest of our
> > submissions. The goal is to support view/modify of the VESW port config.
> >
> > Patches can can also be found in my GitHub repo at:
> > https://github.com/ddalessa/kernel/tree/for-4.15
> >
> > ---
>
> Can you elaborate more on the reasons why debugfs was chosen over more
> generic configuration tool?
>
> +DEBUGFS_FILE_OPS(vport_state);
>
> Maybe, I'm too biased with rdmatool, but I don't see many reasons to
> introduce debugfs for the ULP.

And honestly, netdevices have so much tools to configure them (ethtool,
iproute2, e.t.c.) so I completely don't understand the rationale behind
debugfs for OPA-VNIC.

Thanks

>
> Thanks



--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnKlIwACgkQ5GN7iDZy
WKc0Lw/+LPHAFdfBEEWXvC0H32S8qaj0VJcooTvhQyuGgrdeaRRCdmNlbt6zTULz
8/LW7xZ0LUArFwJY/+Yeeivf/T+TVlbkjf3JtpIslunVWoMhiNT5KMjbwRjzBwTa
bAK43fyDSGp7+Zy+zCW6AJnWQleYGduG9upoYse/A3CoQnxT9cPAWx/Pt8h+X2mL
x62CE68sDsankWtSXkX5pfsNPVCS/MVAggO57OBWU2T3Hqzu4Y+9AFomCBZn0L7I
BDwvkPdG7+FA6rqcasPYYvmvwAmcLWFuBC7Cm32Td3+hEqqInpoHWO+DbLMEIVhQ
Ibi1I/bEvBYVXS8Te8tcL7Z2409jJMOJ16atCr6vNG1xeVGCAurpziOxz34Qdsly
AIKwUO1EEov7iF7f7HbzRyeylq1z3smyb0wZ8w95CwjJiDcLITGpXuOoIEBltdl7
vaEO06+v4BE7chgboUP9EDEc0xp3OxLkT6qHfFaqmjcd2GHnIwx82ZqoPx0HbDYH
MEr1xBzBA8bLMAFAa8ITse6Jkg2poZClJzGmoqfKbCSdlyrX+Wgk4TbyjKs3pN8h
s8HoJ+/vF7SszZGVW4CxkeSV26RV9TvzW3gKfoYmf6KgDD0/n1aax75pQdoZG3Aa
cCebK1aspEPRTqdyWFVh4Gn01f3OhgT8emq3gS1LNrvBSrR4BoU=
=+nN+
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
