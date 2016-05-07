From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/4] IB/core: Introduce capabilitymask2 field
 in ClassPortInfo mad
Date: Sat, 7 May 2016 14:53:39 +0300
Message-ID: <20160507115339.GN29160@leon.nu>
References: <1462448219-24571-1-git-send-email-erezsh@mellanox.com>
 <1462448219-24571-2-git-send-email-erezsh@mellanox.com>
 <0c160894-776d-2a28-5754-146abf82bb9d@dev.mellanox.co.il>
 <CAAk-MO-QuXT1Ko0JrE99V2eOGmhW=t7K57PaR=3CcUbPa1UepQ@mail.gmail.com>
 <904cc673-8208-8cb9-88fa-194db12f6332@dev.mellanox.co.il>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QQNwO3VdVfodZayb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <904cc673-8208-8cb9-88fa-194db12f6332-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--QQNwO3VdVfodZayb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 06, 2016 at 08:32:30AM -0400, Hal Rosenstock wrote:
> On 5/6/2016 8:28 AM, Erez Shitrit wrote:
> > On Fri, May 6, 2016 at 3:14 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
> >> On 5/5/2016 7:36 AM, Erez Shitrit wrote:
> >>> Change struct ib_class_port_info to conform to IB Spec 1.3
> >>> That in order to get specific capability mask from ClassPortInfo mad.
> >>>
> >>> >From the IB Spec, ClassPortInfo section:
> >>>         "CapabilityMask2 Bits 0-26: Additional class-specific capabil=
ities...
> >>>          RespTimeValue the rest 5 bits"
> >>>
> >>> The new struct now has one field for capabilitymask2 (previously was =
the
> >>> reserved field) and the resp_time field.
> >>>
> >>> And it fixes up qib use of the field repurposed to be used as capabil=
itymask2:
> >>> IB/qib: Change pma_get_classportinfo
> >>>
> >>> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> ---
> >>>  drivers/infiniband/hw/qib/qib_mad.c | 4 +++-
> >>>  include/rdma/ib_mad.h               | 2 +-
> >>>  2 files changed, 4 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband=
/hw/qib/qib_mad.c
> >>> index 0bd1837..c5f6248 100644
> >>> --- a/drivers/infiniband/hw/qib/qib_mad.c
> >>> +++ b/drivers/infiniband/hw/qib/qib_mad.c
> >>> @@ -1158,6 +1158,7 @@ static int pma_get_classportinfo(struct ib_pma_=
mad *pmp,
> >>>       struct ib_class_port_info *p =3D
> >>>               (struct ib_class_port_info *)pmp->data;
> >>>       struct qib_devdata *dd =3D dd_from_ibdev(ibdev);
> >>> +     char *p_cap_mask2;
> >>>
> >>>       memset(pmp->data, 0, sizeof(pmp->data));
> >>>
> >>> @@ -1172,7 +1173,8 @@ static int pma_get_classportinfo(struct ib_pma_=
mad *pmp,
> >>>        * Set the most significant bit of CM2 to indicate support for
> >>>        * congestion statistics
> >>>        */
> >>> -     p->reserved[0] =3D dd->psxmitwait_supported << 7;
> >>> +     p_cap_mask2 =3D (char *)&p->capability_mask2;
> >>> +     p_cap_mask2[0] =3D dd->psxmitwait_supported << 7;
> >>>       /*
> >>>        * Expected response time is 4.096 usec. * 2^18 =3D=3D 1.073741=
824 sec.
> >>>        */
> >>> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> >>> index 37dd534c..0761ab9 100644
> >>> --- a/include/rdma/ib_mad.h
> >>> +++ b/include/rdma/ib_mad.h
> >>> @@ -243,7 +243,7 @@ struct ib_class_port_info {
> >>>       u8                      base_version;
> >>>       u8                      class_version;
> >>>       __be16                  capability_mask;
> >>> -     u8                      reserved[3];
> >>> +     __be32                  capability_mask2;
> >>>       u8                      resp_time_value;
> >>
> >> This looks wrong to me as CapabilityMask2 is 27 bits and RespTimeValue
> >> is the remaining 5 bits in a 32 bit field in ClassPortInfo attribute.
> >>
> >> -- Hal
> >=20
> > Can you please elaborate more on that?
> > In V0 I kept both fields in the same field in the struct and you
> > suggested to keep them each by its own field, now we are going back
> > again ?
>=20
> It's the field widths that looks problematic to me. Everything starting
> with resp_time_value is moved down/off by a byte since capability mask2
> is 32 bits here followed by 8 bits of response time value rather than
> both of them fitting into 32 bits.

V0 patch which I reviewed had the following declaration (32 bits
were replaced by 32 bits field):
@@ -243,8 +243,8 @@ struct ib_class_port_info {
        u8                      base_version;
        u8                      class_version;
        __be16                  capability_mask;
-       u8                      reserved[3];
-       u8                      resp_time_value;
+         /* 27 bits for cap_mask2, 5 bits for resp_time */
+       __be32			cap_mask2_resp_time;
	u8			redirect_gid[16];
	__be32			redirect_tcslfl;
	__be16			redirect_lid;


>=20
> >=20
> >>
> >>>       u8                      redirect_gid[16];
> >>>       __be32                  redirect_tcslfl;
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--QQNwO3VdVfodZayb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXLddDAAoJEORje4g2clinskMP/09Y1y5y+EPQB5uIg4H+F10C
CZ+Vb+Ud6neNOEqg4MOSDNp4b8QPa8C7tvMAQ5rwNjt/447Hv1KScuE3S7MBVy4b
IgbN8c8PcFMLHEtU1iLJ1XZIXnG7pGu7ocXe3CPn2cjj+Bv8F6EnI+TZc3f+3v5i
l/20yUriJXhKImeQ0tC/jM8Jlxs/NdIlebMBC4qB80XpQ0QN7b0jov8AxCpJaoGH
cQcCaiFWIaaZjZkdyqlGWGq0gxxKDqTy6ITnQYe2c2azrNS8YJnZmDDFW/BFCLt5
jb5yRzPhmvgZDIa73UKLqiFkylvMYko3GOPxl9XvmC/DEjCMqt5If0sBoi6YvG4t
BZk4M8d+iE6ynbf+FxW42NufGXJDAeuTWYgw02wlHKrtou1YBpTl1mIkOCJgkU8I
HodNS7XCxOlhDFqm4N/+mKoNdiLV01EsklhpZmBt7b0jqZ3RnvmuZBHtHq/Bo0+R
Lk3VnLzo0JZU0jfgqyBl2dmxX7DUAW302nSr94O59eUdojQs4oS9QB2fsgkyVTAi
q6VMMjkd+J9TPsyIoWsLsPH+PQhYaAcQImqZsa7e8Cb8FN2EmkLwYAT0BGzr+A7u
taUn5lLl+gUlwzfI6+cgc1/BrpE7SkWZfIo/8Y77YHwhnUkTv9k2+eVwM86b4TR4
5SRl+vLmXZOggEr5aQQE
=mB6b
-----END PGP SIGNATURE-----

--QQNwO3VdVfodZayb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
