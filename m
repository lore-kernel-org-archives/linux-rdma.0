From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP issues with OpenSM 3.3.3
Date: Tue, 15 Dec 2009 10:16:42 -0500
Message-ID: <f0e08f230912150716y392cf1f1t4cd640b6663f7fea@mail.gmail.com>
References: <20091214164334.064102f0.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091214164334.064102f0.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira,

On Mon, Dec 14, 2009 at 7:43 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> Sasha, Hal,
>
> I have found that the following patch caused our SRP connected storag=
e to
> break.

What is causing the SRP target to fail ? Is it a non zero hop limit
returned in the SA PathRecord ?

> patch: 3d20f82edd3246879063b77721d0bcef927bdc48
>
> =C2=A0 =C2=A0opensm/osm_sa_path_record.c: separate router guid resolu=
tion code
>
> =C2=A0 =C2=A0Move off subnet destination (router address) resolution =
code to separate
> =C2=A0 =C2=A0function to improve readability.
>
> =C2=A0 =C2=A0Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> I further traced the problem to pr_rcv_build_pr and the patch below f=
ixes the
> bug.

On quick glance, I'm missing the connection between Sasha's patch and
this routine setting something bad in the hop limit of the returned
path record.

> 16:03:34 > git diff
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_s=
a_path_record.c
> index be0cd71..32c889f 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -800,7 +800,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN =
const osm_port_t * p_src_port,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Only set HopLimit if going through a ro=
uter */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_nonzero_gid)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_pr->hop_flow_raw=
 |=3D cl_hton32(IB_HOPLIMIT_MAX);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_pr->hop_flow_raw=
 |=3D IB_HOPLIMIT_MAX;

This may fix this issue but it doesn't look right to me and I think
would break router scenarios and corrupts other field(s). Path record
fields are in network (not host) order.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pr->pkey =3D p_parms->pkey;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_path_rec_set_sl(p_pr, p_parms->sl);
>
>
> "hop_flow_raw" is not really a 32bit value but rather 4 fields:
> Component =C2=A0 =C2=A0 Length(bits) =C2=A0 Offset(bits)
> RawTraffic =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0352
> Reserved =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0353
> FlowLabel =C2=A0 =C2=A0 20 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
356
> HopLimit =C2=A0 =C2=A0 =C2=A08 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0384
>
>
> However, I don't understand the comment "Only set HopLimit if going t=
hrough a
> router"?

Well, in a sense the HopLimit is always set. It's already set to 0
right above that code snippet in the patch where:
p_pr->hop_flow_raw &=3D cl_hton32(1 << 31);
This code is only setting the HopLimit to 255 (as this is very
primitive so far) when going through a router. Maybe it could be
stated better.

> Was the intent to only set p_dgid in pr_rcv_get_end_points if we are =
heading
> through a router? I don't think it matters if we are going through a =
router
> or not does it?

It's used when DGID is selected in the SA PR query via the comp mask
and in that instance is used for both the router and non router DGID
cases.

> If not, I think the comment needs to be removed in the patch above.

I'm not following why you say this.

-- Hal

> Thanks,
> Ira
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
