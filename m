From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Fri, 12 Jan 2018 08:39:06 +0200
Message-ID: <20180112063906.GJ15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-2-leon@kernel.org>
 <1515700046.2752.52.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515700046.2752.52.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 07:47:27PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > +struct rdma_restrack_entry {
> > +       struct list_head        list;
> > +
> > +       /*
> > +        * The entries are filled during rdma_restrack_add,
> > +        * can be attempted to be free during rdma_restrack_del.
> > +        *
> > +        * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > +        */
> > +       bool                    valid;
> > +
> > +       /*
> > +        * Sleepabale RCU to protect object data.
> > +        */
> > +       struct srcu_struct      srcu;
> > +
> > +       struct task_struct      *task;
> > +       char                    *task_comm;
> > +};
>
> Please use the kernel-doc syntax to document the meaning of the names of the
> fields in this structure. It is e.g. nontrivial to guess what "task_comm" stands
> for. The presense of a task_struct pointer is also nontrivial.
>
> PS: I think the spelling of "Sleepabale" should be fixed.

I'll fix and resend.

>
> Thanks,
>
> Bart.

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYWAoACgkQ5GN7iDZy
WKdgnRAAw6rgphr6LF0iDaQZ91wUROlPPgH9AS5wBDSiQu6esFE2wh4iDEW9GNBG
7ELlYZFLOl3roNmP6wzUZnZJbjykQa/MX+yet0uS8C51reAofyK9M9GoTt81zVQN
vy0TM/XcxPQ3MDVQ8W56fzwC+GzvSbRqpnn2AA2TSFfCLeD2PL2fge2uzLFPH99+
8bVVUlBlMw3rha78qcDkwkAtvVdsYboyHTbuLZ6JC9905N2xKUumisgrykW0x/88
dAENG45xskb7EHf1Zf5v/AVCFJngowO+j34jipSC2hA2lzrS9/UYW9Zodt5Wn/Z3
FgF/uHtVPcBRlaWrdyk74nRcI7kivgz5yhQTA5D2pkElYqJmnY+PFxH0wtP0vmpD
WH3P+2yT8pvBZukor9Ejx62OMOE1jtQJy9p2oBd81PfA8ryMR85iVt3SuMmp2YD8
ssyJJvmHFLt39fDfBkt4aMcGc027zlI9CBfh0aeuI7dkJPPSkGaRxVQOH5XAChog
sOnRcFU1bjT1HF2wSzS4J5z1fuUHpeqpGlMbdZs0JmwTMUtH30MVLGZyvhAaGv1g
k6lqZzaM+gRXFSf5XVKnz1QuKYURsQ1kRzn6Pd1HPEBt+8FO2vkwXFKCFGk7PpY6
Z/35in5JeUvLr5HHx72re/hy+e7pBycaiSB6Tt/tgfvtOoWOFeA=
=WvIa
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
