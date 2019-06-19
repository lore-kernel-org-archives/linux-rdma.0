From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Date: Wed, 19 Jun 2019 08:12:29 +0000
Message-ID: <20190619081226.GI11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
 <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
 <20190619074338.GG11611@mtr-leonro.mtl.com>
 <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
Content-Language: en-US
Content-ID: <EFF0DA22E8C65A4B91AAE2B9CC8899D4@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Jianbo Liu <jianbol@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Roi Dayan <roid@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 19, 2019 at 07:58:51AM +0000, Mark Bloch wrote:
>
>
> On 6/19/2019 00:43, Leon Romanovsky wrote:
> > On Wed, Jun 19, 2019 at 07:26:54AM +0000, Mark Bloch wrote:
> >>
> >>
> >> On 6/18/2019 23:51, Leon Romanovsky wrote:
> >>> On Wed, Jun 19, 2019 at 06:40:16AM +0000, Jianbo Liu wrote:
> >>>> The 06/19/2019 13:04, Leon Romanovsky wrote:
> >>>>> On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> >>>>>> The 06/18/2019 18:19, Leon Romanovsky wrote:
> >>>>>>> On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> >>>>>>>> From: Jianbo Liu <jianbol@mellanox.com>
> >>>>>>>>
> >>>>>>>> If vport metadata matching is enabled in eswitch, the rule creat=
ed
> >>>>>>>> must be changed to match on the metadata, instead of source port=
.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> >>>>>>>> Reviewed-by: Roi Dayan <roid@mellanox.com>
> >>>>>>>> Reviewed-by: Mark Bloch <markb@mellanox.com>
> >>>>>>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >>>>>>>> ---
> >>>>>>>>  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> >>>>>>>>  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> >>>>>>>>  drivers/infiniband/hw/mlx5/main.c   | 45 ++++++++++++++++++++++=
+------
> >>>>>>>>  3 files changed, 63 insertions(+), 9 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infin=
iband/hw/mlx5/ib_rep.c
> >>>>>>>> index 22e651cb5534..d4ed611de35d 100644
> >>>>>>>> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>>>> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>>>> @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(=
struct mlx5_eswitch *esw, int vport)
> >>>>>>>>  	return mlx5_eswitch_vport_rep(esw, vport);
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>> +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_es=
witch *esw)
> >>>>>>>> +{
> >>>>>>>> +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_es=
witch *esw,
> >>>>>>>> +						 u16 vport)
> >>>>>>>> +{
> >>>>>>>> +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> >>>>>>>> +}
> >>>>>>>
> >>>>>>> 1. There is no need to introduce one line functions, call to that=
 code directly.
> >>>>>>
> >>>>>> No. They are in IB, and we don't want them be mixed up by the orig=
inal
> >>>>>> functions in eswitch. Please ask Mark more about it.
> >>>>>
> >>>>> Please enlighten me.
> >>>>
> >>>> It was suggested by Mark in prevouis review.
> >>>> I think it's because there are in different modules, and better to w=
ith
> >>>> different names, so introduce there extra one line functions.
> >>>> Please correct me if I'm wrong, Mark...
> >>>
> >>> mlx5_ib is full of direct function calls to mlx5_core and it is done =
on
> >>> purpose for at least two reasons. First is to control in one place
> >>> all compilation options and expose proper API interface with and with=
out
> >>> specific kernel config is on. Second is to emphasize that this is cor=
e
> >>> function and save us time in refactoring and reviewing.
> >>
> >> This was done in order to avoid #ifdef CONFIG_MLX5_ESWITCH,
> >> I want to hide (as much as possible) the interactions with the eswitch=
 level in ib_rep.c/ib_rep.h
> >> so ib_rep.h will provide the stubs needed in case CONFIG_MLX5_ESWITCH =
isn't defined.
> >> (Today include/linux/mlx5/eswitch.h) doesn't provide any stubs, mlx5_e=
switch_get_encap_mode()
> >> should have probably done the same.
> >
> > This is exactly the problem, eswitch.h should provide stubs for all
> > exported functions, so other clients of eswitch won't need to deal with
> > various unrelated config options.
>
> The way it works today, code in drivers/infiniband/hw/mlx5/main.c doesn't=
 call eswitch layer directly
> but the functions in ib_rep.{c,h} as most often there is additional logic=
 we must do before calling
> the eswitch layer.
>
> If you look at drivers/infiniband/hw/mlx5/Makefile you will see ib_rep is=
 complied only when
> CONFIG_MLX5_ESWITCH id defined.

This simple patch + cleanup of ib_rep.h will do the trick.

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 67b9e7ac569a..b917ba28659e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -59,7 +59,9 @@
 #include <linux/in.h>
 #include <linux/etherdevice.h>
 #include "mlx5_ib.h"
+#if defined(CONFIG_MLX5_ESWITCH)
 #include "ib_rep.h"
+#endif
 #include "cmd.h"
 #include "srq.h"
 #include <linux/mlx5/fs_helpers.h>
@@ -6765,6 +6767,7 @@ static const struct mlx5_ib_profile  pf_profile =3D {
                        mlx5_ib_stage_delay_drop_cleanup),
	     };

+#if defined(CONFIG_MLX5_ESWITCH)
 const struct mlx5_ib_profile uplink_rep_profile =3D {
	STAGE_CREATE(MLX5_IB_STAGE_INIT,
		     mlx5_ib_stage_init_init,
@@ -6812,6 +6815,7 @@
 const struct mlx5_ib_profile uplink_rep_profile =3D {
		               mlx5_ib_stage_post_ib_reg_umr_init,
		               NULL),
		};

>
> so instead of having to deal with two places that contain stubs, we need =
to deal with only one (ib_rep.h).
> For me it makes it easier to follow, but I can adept if you don't like it=
.
>
> Mark
>
> >
> >>
> >> As my long term goal is to break drivers/infiniband/hw/mlx5/main.c (th=
at file is already 7000 LOC)
> >> I want to group together stuff in separate files.
> >
> > Yes, it is right thing to do.
> >
> >>
> >> If you prefer direct calls that's okay as well.
> >
> > Yes, please.
> >
> >>
> >> Mark
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>> 2. It should be bool and not u32.
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>
> >>>>>> --
> >>>>
> >>>> --
