From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] bnxt_re: Free up devices in module_exit path
Date: Thu, 14 Sep 2017 16:04:25 +0300
Message-ID: <20170914130425.GA3405@mtr-leonro.local>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
 <20170831035735.19595-5-somnath.kotur@broadcom.com>
 <20170913174255.GV3405@mtr-leonro.local>
 <CAOBf=mupXRmhNoZOfwhr-Ho7_y-Kts4XmgtHgpMQVosmj=Hpcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H14uD12u8nekTETJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOBf=mupXRmhNoZOfwhr-Ho7_y-Kts4XmgtHgpMQVosmj=Hpcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--H14uD12u8nekTETJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 14, 2017 at 09:23:53AM +0530, Somnath Kotur wrote:
> Hi Leon,
>
> On Wed, Sep 13, 2017 at 11:12 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Aug 31, 2017 at 09:27:31AM +0530, Somnath Kotur wrote:
> >> Clean up all devices added to the bnxt_re_dev_list in the
> >> module_exit entry point.
> >>
> >> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/bnxt_re/main.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> >> index 82d1cbc..00a3b74 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/main.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> >> @@ -1375,6 +1375,22 @@ static int __init bnxt_re_mod_init(void)
> >>
> >>  static void __exit bnxt_re_mod_exit(void)
> >>  {
> >> +     struct bnxt_re_dev *rdev;
> >> +     LIST_HEAD(to_be_deleted);
> >> +
> >> +     mutex_lock(&bnxt_re_dev_lock);
> >> +     /* Free all adapter allocated resources */
> >> +     if (!list_empty(&bnxt_re_dev_list))
> >
> > Hi Somnath,
> >
> > How is it possible to have the bnxt_re_dev_list to be empty at this
> > stage? Doesn't the call to bnxt_re_mod_exit mean that at least one entry
> > exists?
> Well, there is a possibility that NETDEV_UNREGISTER got invoked (not
> via rmmod , but via the pci-sysfs route)
> and this list is empty by the time rmmod of the bnxt_re was invoked.

I was under impression that calls to bnxt_re_ib_unreg() and bnxt_re_remove_one()
in NETDEV_UNREGISTER should eliminate such scenario.

Thanks

>
> Thanks
> Som

--H14uD12u8nekTETJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm6flkACgkQ5GN7iDZy
WKd1pxAAwzTRPmrPpVrFk4uEzU4tH8/V3vJtDKxLzSD9WpRdl+oE8D/HRcsxY1wt
p39TK4dZn7+CiQWy4+cKXgTiirOzbqJpebCDvzuBQFBTRS+og/tAoWdKm0d2fQ3S
AZwGIPhGSsKN2hpZP0jwhAlvBRih5TrLdnImH6ABhkc3Tix7YmRx37i4D+JJmQ3C
kl2FRS2jhLApiVG4kYYVIF5wkYX2zQF0vwfpdcKY8Au/7K32/wQHQdoBwi5QWdaI
9LQ4QhkclQgtOLvrqE3+GEk3nuJu2Tv7dyp4BeIT2fLwZ7QDMNkIaOsUMEdgFteh
NRLzddI6dMAAY7zXm5XC3ED47vv82Mt13HMuIWfrf8rXfkKztUfyC2Ee08qpFAbH
vEMAvtzQ641t9ELyRQchqV2Z6GQudrHae3oSUKOZIidRgNkVEu8Ok5pAg76dACEA
7bnJCFbyPL9/67WXb4CWkkTUy/TYgpQCSKVGBAuCkuFCXJ9dyfBk4u46Sn1QPAVC
7gnsPLfWxYwgb05+vfmNMf9VLLBDSqSAnMnbhT6OdrZU8dPqiOqdiw0IVbr8Dyss
QZEg39kw1UAEmdOxsFf9/clg9qdBmiebz8QcaUK8J2hUaSId4gI82nS7DCQiyWfF
njV0sieCYG2A/SIbr5N5AHWgxwQXETsj0CfrovErYtE5dSiwz6E=
=+tQ+
-----END PGP SIGNATURE-----

--H14uD12u8nekTETJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
