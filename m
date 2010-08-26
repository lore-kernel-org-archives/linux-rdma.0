From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: add '-f' flag to show full information
 (ports' speed and width).
Date: Thu, 26 Aug 2010 07:17:58 -0400
Message-ID: <AANLkTimpAQNGo+wzCY8VmnvGf7zfwqm3cak49eZRQs1V@mail.gmail.com>
References: <4C6B9A42.9020505@voltaire.com>
	<20100824040354.GH5837@me>
	<4C73B34A.4080508@voltaire.com>
	<AANLkTi=V9Xb92KPgqKnFFWzp-izSsHi7c+-HXYBmggYN@mail.gmail.com>
	<4C73C8BC.6010702@voltaire.com>
	<AANLkTime9OX4EPS_c+pKwnchuVfyLqeLcuX0rXDjOCgR@mail.gmail.com>
	<20100825170656.GM5837@me>
	<4C761B1B.5030804@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C761B1B.5030804-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 26, 2010 at 3:43 AM, Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org> wro=
te:
> add '-f' flag to show full information (ports' speed and witdh).
> mainly to work with ibsim (using links real speed and width).

Just a couple of (output formatting) nits below...

> Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0infiniband-diags/src/ibnetdiscover.c | =C2=A0 16 ++++++++++++++=
--
> =C2=A01 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/=
src/ibnetdiscover.c
> index f20058c..df9e5a6 100644
> --- a/infiniband-diags/src/ibnetdiscover.c
> +++ b/infiniband-diags/src/ibnetdiscover.c
> @@ -77,6 +77,7 @@ static char *diff_cache_file =3D NULL;
> =C2=A0static unsigned diffcheck_flags =3D DIFF_FLAG_DEFAULT;
>
> =C2=A0static int report_max_hops =3D 0;
> +static int full_info;
>
> =C2=A0/**
> =C2=A0* Define our own conversion functions to maintain compatibility=
 with the old
> @@ -357,13 +358,16 @@ void out_switch_port(ibnd_port_t * port, int gr=
oup, char *out_prefix)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_port_str ?=
 ext_port_str : "");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (port->remoteport->node->type !=3D IB_N=
ODE_SWITCH)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(f, "(%=
" PRIx64 ") ", port->remoteport->guid);
> - =C2=A0 =C2=A0 =C2=A0 fprintf(f, "\t\t# \"%s\" lid %d %s%s",
> + =C2=A0 =C2=A0 =C2=A0 fprintf(f, "\t\t# \"%s\" lid %d %s%s ",

I'd leave this alone and move the space below.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rem_nodename,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->node->type =3D=3D IB_NODE_SWITCH ?
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->node->smalid :
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->base_lid,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dump_linkwidth=
_compat(iwidth), dump_linkspeed_compat(ispeed));
>
> + =C2=A0 =C2=A0 =C2=A0 if (full_info)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(f, "s=3D%d=
 w=3D%d", ispeed, iwidth);
> +

I'd move the space here before s=3D

> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ibnd_is_xsigo_tca(port->remoteport->gu=
id))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(f, " s=
lot %d", port->portnum);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (ibnd_is_xsigo_hca(port->remotepor=
t->guid))
> @@ -397,13 +401,17 @@ void out_ca_port(ibnd_port_t * port, int group,=
 char *out_prefix)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->r=
emoteport->node->guid,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 port->r=
emoteport->node->nodedesc);
>
> - =C2=A0 =C2=A0 =C2=A0 fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d =
%s%s\n",
> + =C2=A0 =C2=A0 =C2=A0 fprintf(f, "\t\t# lid %d lmc %d \"%s\" lid %d =
%s%s ",

Ditto,

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->base_lid=
, port->lmc, rem_nodename,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->node->type =3D=3D IB_NODE_SWITCH ?
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->node->smalid :
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0port->remotepo=
rt->base_lid,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dump_linkwidth=
_compat(iwidth), dump_linkspeed_compat(ispeed));
>
> + =C2=A0 =C2=A0 =C2=A0 if (full_info)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(f, "s=3D%d=
 w=3D%d", ispeed, iwidth);

Ditto.

-- Hal

> + =C2=A0 =C2=A0 =C2=A0 fprintf(f, "\n");
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0free(rem_nodename);
> =C2=A0}
>
> @@ -926,6 +934,9 @@ static int process_opt(void *context, int ch, cha=
r *optarg)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case 's':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cfg->show_prog=
ress =3D 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> + =C2=A0 =C2=A0 =C2=A0 case 'f':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 full_info =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'l':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0list =3D LIST_=
CA_NODE | LIST_SWITCH_NODE | LIST_ROUTER_NODE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> @@ -964,6 +975,7 @@ int main(int argc, char **argv)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ibnd_fabric_t *diff_fabric =3D NULL;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct ibdiag_opt opts[] =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 {"full", 'f', 0, N=
ULL, "show full information (ports' speed and witdh)"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"show", 's', =
0, NULL, "show more information"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"list", 'l', =
0, NULL, "list of connected nodes"},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{"grouping", '=
g', 0, NULL, "show grouping"},
> --
> 1.5.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
