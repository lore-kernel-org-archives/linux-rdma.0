From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [pull request][for-next V2 00/11] Mellanox, mlx5 E-Switch updates 2017-12-19
Date: Fri, 29 Dec 2017 00:53:47 +0200
Message-ID: <CALzJLG8U=CLk-ZG=tiKxLkG_2DzgMkv+Tpka6gEjgfPMrYC+sQ@mail.gmail.com>
References: <20171224134547.600-1-saeedm@mellanox.com> <20171227.170122.256080933244367774.davem@davemloft.net>
 <20171227.170320.289782853552941901.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227.170320.289782853552941901.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 12:03 AM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:
> From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Date: Wed, 27 Dec 2017 17:01:22 -0500 (EST)
>
>> Pulled, thank you.
>
> Actually, I had to revert.  Please fix this and resubmit:
>
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c: In function =
=E2=80=98esw_offloads_load_reps=E2=80=99:
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:774:2: warning=
: this =E2=80=98for=E2=80=99 clause does not guard... [-Wmisleading-indenta=
tion]
>   for (rep_type =3D 0; rep_type < NUM_REP_TYPES; rep_type++)
>   ^~~
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:776:3: note: .=
..this statement, but the latter is misleadingly indented as if it is guard=
ed by the =E2=80=98for=E2=80=99
>    if (err)
>    ^~

Thanks Dave! this is not just a warning, this is an actual bug. We
will fix and re-spin soon.
Sorry for any inconvenience.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
