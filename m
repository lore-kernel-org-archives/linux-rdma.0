From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] RDMA/bnxt_re: Update the driver version
Date: Wed, 10 May 2017 18:54:30 +0300
Message-ID: <20170510155430.GC1839@mtr-leonro.local>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-15-git-send-email-selvin.xavier@broadcom.com>
 <84d9a0ce-0e5c-fc50-237f-b7ad9d541324@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <84d9a0ce-0e5c-fc50-237f-b7ad9d541324-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 11:06:31AM -0400, Dennis Dalessandro wrote:
> On 5/10/2017 6:45 AM, Selvin Xavier wrote:
> > Update the driver version to the scheme used in the internal
> > development branches.
>
> See the feedback [1] we got from Greg KH on a similar patch.
>
> [1] https://patchwork.kernel.org/patch/7490321/

Yeah, the things go worse when this driver ported to old kernel. This
numbers are entirely useless.

>
> > Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> > index 30bff05..9041c23b 100644
> > --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> > +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> > @@ -40,7 +40,7 @@
> >  #ifndef __BNXT_RE_H__
> >  #define __BNXT_RE_H__
> >  #define ROCE_DRV_MODULE_NAME		"bnxt_re"
> > -#define ROCE_DRV_MODULE_VERSION		"1.0.0"
> > +#define ROCE_DRV_MODULE_VERSION		"20.6.1.0u"
> >
> >  #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkTN7YACgkQ5GN7iDZy
WKc3+g//f7qqeVeC6ODPeUSDa4GovNgYjisxailjabzthgdON2XmHVu21micU4jR
/GBEV8gx38kM0FaT2yEMbEyI+XS8e9rAWCZAhQLhtKWIziJarlFRUWvSImISMLDZ
zVxzYazF14tpgdQDlu6uyj+RA28L1OLGSxxq++mfYJBYrXVW38U19CrdtBOPlYbf
t1P3on2rbdlraKzZ5MCP5XKrFkzkHbK/1W6PrEvoQNzpHokXz68N+bhDwxrRpGe6
du+f8j/VHimnGIBCz1CKeFlRND0bK5OhC3xUy9rpBcMS+Kq3vSzUjFKEsTx0MAQN
gMk++UOcbdJO1+ev6dJh2yt8XF73F31pR2VgVXjUv616Hal8Ob+1cBCx/i+4EbKr
M8ISHg5UVYGpHAVsayIbb9eMe0UqdG27yEAEMyuVhaEf0cTRmHeiZ7H3KFO0smxu
u00xLyYyp0LtmaMLjCN7baiH26oqC9CD1ScV8JQnz1DVxuDc00JmeddJpjcmQ8HB
1JPriZlENf07YhIkJ8wGSdmsjhbh8vmB1K2PU8Oe9ZYdxIh/h6QcFE7+2affE1oo
8hyRwrc0uwLjkMCDiNJ+Iy1/mCD3qQdSp2oFUi6fXgENbaIFqBplmZCrnT0A7X/e
fApxi71/3rD5L8xpcFXUXBXBJrR/MEmB3DyxfNJp8QYYQ9eWhbs=
=7CNl
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
