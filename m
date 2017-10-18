From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/core: Fix use workqueue without
 WQ_MEM_RECLAIM
Date: Wed, 18 Oct 2017 17:21:55 +0300
Message-ID: <20171018142155.GP2106@mtr-leonro.local>
References: <20171016054517.30643-1-leon@kernel.org>
 <20171016054517.30643-5-leon@kernel.org>
 <4f08314e-fd5d-c108-438a-d9e83821e4b3@redhat.com>
 <3c717580-d1fe-943d-8df2-5d4858244e9b@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkzoT2Bc9VsM/9ev"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3c717580-d1fe-943d-8df2-5d4858244e9b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vkzoT2Bc9VsM/9ev
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2017 at 12:58:20PM +0300, Sagi Grimberg wrote:
>
> > This looks like a -stable patch candidate. Once accepted this should
> > probably be queued for v4.9+.
>
> AFAICT, this was broken forever because single threaded workqueues are
> set with MEM_RECLAIM. If anything the Fixes tag is incorrect.

You are right. I suggested this Fixes to Parav, because it is needed
for stable tree and/or backporting. It makes no sense for me to put
Fixes which will point to the code which was completely different
before Fixes.

Thanks

--vkzoT2Bc9VsM/9ev
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnnY4MACgkQ5GN7iDZy
WKdgcA//RoqJ8vIWnIphgeGuxr38vG7ho86ns02UOPwDf/zoP61iGfbSgT6Y3n46
M0PPkdqYS+zrQVC3g9sbhTkg+mfxlJPdXArRcNin0VtTFhAS8u3CxvVFev3HssSS
JSil88m/LffpL5F41KJVcnItpxm/Jm4nXma8KY4gFST3ZNbDd7WtZ2efaO5bAp02
C4iWpIvN+HeAdb2Sp4OoJXNR41iXT/BXJFbGuV4kMntgGPbVo2DIF72pp3VObSfP
q+HxqH3quTg8MSxbwVcOEgtmYlo2eeqFVXw8ONOLstEwwfeKrWC7/nzFf4ZGXZYJ
ymiG6HlTOIRtxOMHfDI1RvhKYJp8p58NzjB80hcuKvgSICcnNm03pP/UX6O2jcT/
3Ci4iyZsyUSk6W7CyYg1M8AAo5k33ZhUtv+xWVMLpd5DtfWt1pW+ovgFwC8V29L4
3tdZkNSMmNAwDt/6Wa4AYHUcScaC24CsDGWM8qJQ0prjJQSIIfIvEuEOsHG+O7Cz
RPb4fbUlJfXVoqvGkfWo6gwQZyLgKI6isixUPTpanXDIe9ADQl93YR6Nt2c0aner
H+IsGmBo4WG8VDqHz/kaGP3q254xSL7gnVdZhWbh83Jq31X7zkyjBbjThPP/HZoR
LrE8FKfxUO2H3yTJB7pXmQYSoEKt4YDMFcmB2yLMesYL7iG1VsE=
=pU1M
-----END PGP SIGNATURE-----

--vkzoT2Bc9VsM/9ev--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
