From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Wed, 21 Jun 2017 17:56:40 +0300
Message-ID: <20170621145640.GG1248@mtr-leonro.local>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
 <20170620073236.GO17846@mtr-leonro.local>
 <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
 <20170620180348.GV17846@mtr-leonro.local>
 <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
 <20170620184046.GW17846@mtr-leonro.local>
 <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p7qwJlK53pWzbayA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--p7qwJlK53pWzbayA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 10:46:44AM -0400, Chuck Lever wrote:
> [ Removing Doug since all mail to him seems to be bouncing ]
>
> > On Jun 20, 2017, at 2:40 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Tue, Jun 20, 2017 at 02:23:21PM -0400, Chuck Lever wrote:
> >>
> >>> On Jun 20, 2017, at 2:03 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>>
> >>> On Tue, Jun 20, 2017 at 11:43:56AM -0400, Chuck Lever wrote:
> >>>> Hi Leon-
> >>>>
> >>>>
> >>>>> On Jun 20, 2017, at 3:32 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>>>>
> >>>>> On Mon, Jun 19, 2017 at 11:26:40AM -0400, Chuck Lever wrote:
> >>>>>> The fourth parameter of the module_param_named macro is a set of
> >>>>>> file permissions. Passing 0 there means that module parameter is
> >>>>>> not created and that adding "options ib_core force_mr=1" to a
> >>>>>> modprobe.conf file has no effect.
> >>>>>>
> >>>>>> The default setting of rdma_rw_force_mr continues to be 0, or false.
> >>>>>>
> >>>>>> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
> >>>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>>>>> ---
> >>>>>> Hi Doug-
> >>>>>>
> >>>>>> This doesn't seem appropriate to go through Bruce's tree for 4.13.
> >>>>>>
> >>>>>> Last discussion didn't seem to conclude with full consensus.
> >>>>>> Probably people don't care enough one way or another. But I'd like
> >>>>>> to see this get fixed if there aren't strong objections. Would you
> >>>>>> take it for 4.13?
> >>>>>
> >>>>> I care and believe that it should be removed from exposure to users.
> >>>>> The variable force_mr should be leaved in the code for the debug,
> >>>>> but module_param should be removed.
> >>>>
> >>>> I don't understand the technical grounds of your objection.
> >>>> Why is
> >>>>
> >>>> options mlx4_core internal_err_reset=0
> >>>>
> >>>> acceptable, but
> >>>>
> >>>> options ib_core force_mr=1
> >>>>
> >>>> not?
> >>>
> >>> That mlx4 variable was exposed before I started to follow after
> >>> Mellanox's submissions.
> >>>
> >>> The force_mr parameter is for debug of new ULP and/or conversion of
> >>> existing ULP to RW API. This is not very common situation and it is
> >>> for the developers and not for the users.
> >>
> >> No disagreement on that, but that's still not an argument
> >> not to expose it. What is the risk, as you see it?
> >
> > It will be "marked" as UAPI and we won't be able to change it,
> > which IMHO bad for the debug. It also invites users to set it
> > and in perfect world, we should test our HCAs with this flag
> > on and off, because curious user can set it.
>
> We have loads of legacy debugging interfaces.
>
> And yes, ULP developers should be aware of it and test with
> both settings.
>
> I'm not convinced any of this is a problem for this particular
> setting. However, I guess the thing for you to do is propose a
> patch.

Thanks,
I'll do it with great pleasure.

>
>
> > Thanks
> >
> >>
> >>
> >>> Thanks
> >>>
> >>>>
> >>>>
> >>>>> Thanks
> >>>>>
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>> drivers/infiniband/core/rw.c |    2 +-
> >>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> >>>>>> index dbfd854..1cc8f07 100644
> >>>>>> --- a/drivers/infiniband/core/rw.c
> >>>>>> +++ b/drivers/infiniband/core/rw.c
> >>>>>> @@ -23,7 +23,7 @@ enum {
> >>>>>> };
> >>>>>>
> >>>>>> static bool rdma_rw_force_mr;
> >>>>>> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
> >>>>>> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
> >>>>>> MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
> >>>>>>
> >>>>>> /*
> >>>>>>
> >>>>>> --
> >>>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>
> >>>> --
> >>>> Chuck Lever
> >>
> >> --
> >> Chuck Lever
> >>
> >>
> >>
>
> --
> Chuck Lever
>
>
>

--p7qwJlK53pWzbayA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllKiSgACgkQ5GN7iDZy
WKcWlg//Yeg6WwfO+saH0F+HmPn7I0jEzBHvoq83T9/I89xNGNutSX07FSVTGSyG
wleN37QC06+hCkMrBlm0c/3fHecs6/pgx9fp40XQZvGBUVLxgOGjOPhob+JMQOZ7
0QaoIue5f3QHuoEZz7V9fii4BqMP9Px1bVCPI07VemLRTPfYQMMhpgZf/xw6XLLv
LvBKWdckSDNRoCtPjGW/CwHwuZu9scwshcKo1EQVNb+lo8/a7FZWhJhjt6vR5lZX
pvyZ7qv8dor37MktdKidyJMlVFUx+vamZneK7p9dN3K+/bexhmDEIIfVNuV3CQYA
RWXrI3flkyZtUCHvZiAxJ9RQOdw9V9O1+NkPE+boDnIhED6T8Os9h3Jn8SjmSV67
L5/1vWokxIAYi8QbHB7FhVRhQaiGASx0FuNlkqiW7TbzOU6l8Mc2X1UecvgfcziJ
wMLZaiN+AdhCGAllQV9Sv4hz69SH7ZScSv9YIhzfbvg2NAtFT2f6zZ2Gvt3z+KuZ
19iOtdnrtPJ8JOdy7TXlIOjKPBX/775zWdtzRK7/GIR1n+ZJfdYA82nY7Ef9ZkEM
9fy81MpRdyRXrv8t3TPx3q/OTOkIokrMwKpD2yjmePi8Jyunriife4T8HO2kCE7U
tImNAujedOR2QNkD5VRu748plT+ln+XnWkA4LLu4zjG941mobco=
=f1QC
-----END PGP SIGNATURE-----

--p7qwJlK53pWzbayA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
