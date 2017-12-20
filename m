From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Wed, 20 Dec 2017 18:36:55 +0200
Message-ID: <20171220163655.GW2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 09:53:33AM -0600, Steve Wise wrote:
> Hey,
>
> I have a need to provide tools for customers to gather runtime state for an
> rdma device.   Say, when an application is stuck waiting for some completion
> or other rdma event.   This includes hw/fw state of course, and equally as
> important, rdma object sw state.  Is debugfs the correct way to export this
> sw state?  The data is quite large potentially; each QP, its structures, the
> dma queue memory, etc.  Ditto for CQs.  Also MR state, etc etc.  It seems
> that would be overloading debugfs to me.  Currently the hw/fw state is being
> gathered via ethtool dump commands (--get-dump, --register-dump,
> --eeprom-dump).  I am considering using the ethtool --get-dump method for
> the low level driver to also include dumping the rdma queue state for the
> device.   Is that a reasonable approach?

In this cycle, I'm going to submit RDMA resource tracking feature, which
will give an infrastructure to do it in RDMA:

The kernel code, it is based on RCU and not final, because my call to
synchronize_rcu is not effective.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/restrack-rcu

There is supplementary part in RDMAtool, which presents global
information, QP information with options to filter.

It is initial stage.

+ /mnt/iproute2/rdma/rdma res
1: mlx5_0: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
2: mlx5_1: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
3: mlx5_2: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
4: mlx5_3: curr/max: pd 2/16777216 cq 3/16777216 qp 2/262144
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
+ /mnt/iproute2/rdma/rdma res show mlx5_4
5: mlx5_4: curr/max: pd 3/16777216 cq 5/16777216 qp 4/262144
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/0
Wrong device name
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/1
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/1  7          UD    RTS    0          [mlx5-gsi]
mlx5_4/1  1          GSI   RTS    0          [rdma-mad]
mlx5_4/1  0          SMI   RTS    0          [rdma-mad]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/-
DEV/PORT  LQPN       TYPE  STATE  PID        COMM
mlx5_4/-  8          UD    RESET  0          [ipoib-verbs]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/- -d
DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM            SQ-PSN     RQ-PSN     PATH-MIG
mlx5_4/-  8          ---        UD    RESET  0          [ipoib-verbs]   0          ---        ---
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/1 display pid,lqpn,comm
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/1 display pid,lqpn,comm -d
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]
+ /mnt/iproute2/rdma/rdma res show qp link mlx5_4/1 display pid,lqpn,comm pid 0-2000
DEV/PORT  LQPN       PID        COMM
mlx5_4/1  7          0          [mlx5-gsi]
mlx5_4/1  1          0          [rdma-mad]
mlx5_4/1  0          0          [rdma-mad]

>
> Any thoughts/suggestions?

Care to try?

>
> Thanks in advance,
>
> Steve.
>
>
> ---
> This email has been checked for viruses by AVG.
> http://www.avg.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6kacACgkQ5GN7iDZy
WKcnbxAAhp0mLRi6DKtNbLqu1ijtIBlVUoesTiTWONw8DOLWNA0unbOrD9+jG+sE
QuYHPVUamTFOcMdNEs73F6b87YOgOdefhLJ+HFywmAnJYfZ8hYWEnarWTolwjsce
C1FDCt/PSvyH+raCOphlaWAM95fyp8B8zKuFQCpejLMzkSqH0SM6g9wMf+TowoYF
bwokFi3zcpQ/qOOUxwe/l0NBQ87dEhPdX5R/4RpR1zYJgzYP/1Ji8Y2JEUE6b8GO
5muqHGXWWYIR8acXz0M7N6tdbxKGR7EhBlcpukFX7nh0XY+txWATTXr/QNYooX5E
++koTcDlSp2RpLz5a86ehgYStMaR4pWXd62lOTY6Gluqc9pgikyte1673mZ+H2nj
EzPT5WCOZh7ieQxi5owXqBL4eFAAnvsdbCZh2wf37VZ7GBaIKVipbe8iKVNHaYRN
8PTjF2zdbjZ9fll5Dv7nCErH+rplr4Q5AS3wK4Sl0DDDyq9LlvlBNdHBr/IQio6c
foM4mTFj2bq31gnmzPfx+EvjDpZO0cnVcXGWiQZDr97f54VS9pgIPJ559uozgGZg
z+f7i+St6+b/5PitxZeOt3eCj3jJF9mVHcuqcQ01NhG79LBhFZehBVPhGOlnmByA
Jt2SFXygz/vkJ/SkjYlGBmg0ctosywuzQKaN170tg+WnlNVD9r4=
=6GDn
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
