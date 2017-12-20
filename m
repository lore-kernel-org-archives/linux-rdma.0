From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Wed, 20 Dec 2017 20:05:49 +0200
Message-ID: <20171220180549.GY2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
 <20171220163655.GW2942@mtr-leonro.local>
 <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
 <20171220171146.GX2942@mtr-leonro.local>
 <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 11:42:22AM -0600, Steve Wise wrote:
> > WIP: no manuals, no review yet and not massively tested - but works for me
> :
> >
> >
> > >
> > > Is there a way to extend commands with provider-specific data?
> > >
> >
> > In future yes, rdmatool provides "-d" option (detailed output) and IMHO
> > all vendor specific will got there.
>
> Cool.
>
> Looksie:
>
> [root@stevo1 iproute2]# ./rdma/rdma res
> 1: mlx4_0: curr/max: pd 4/32764 cq 17/65408 qp 3/163768
> 2: cxgb4_0: curr/max: pd 2/65536 cq 16/24576 qp 2/12288
> 2: cxgb4_0: curr/max: pd 2/65536 cq 16/24576 qp 2/12288
>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp link cxgb4_0
> DEV/PORT  LQPN       TYPE  STATE  PID        COMM
> cxgb4_0/- 1028       RC    RTS    0          [rdma-cm]
> cxgb4_0/- 1026       RC    RTS    0          [rdma-cm]
>
> I'm not sure why the port is not specified on the above cxgb4 QPs which are
> connected.  They should have a port number.  But perhaps it isn't filled in
> correctly in the cm_id or something?

I'm not using CM and take this information from ib_query_qp
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/tree/drivers/infiniband/core/nldev.c?h=topic/restrack-rcu#n236
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/tree/drivers/infiniband/core/nldev.c?h=topic/restrack-rcu#n249

Most probably it returns port = 0 and it is not valid for the RDMAtool.

>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp link mlx4_0
> DEV/PORT  LQPN       TYPE  STATE  PID        COMM
> mlx4_0/1  537        RC    RTS    0          [rdma-cm]
> mlx4_0/1  536        RC    RTS    0          [rdma-cm]
> mlx4_0/1  1          GSI   RTS    0          [rdma-mad]
> [root@stevo1 iproute2]#
>
> rdma should probably understand enough transport-specific details to not
> display ib-specific stuff on an iwarp qp.  Here PSNs and PATH-MIG are all
> IB-specific:

Right, it is bug.

>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp link cxgb4_0 -d
> DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM
> SQ-PSN     RQ-PSN     PATH-MIG
> cxgb4_0/- 1028       0          RC    RTS    0          [rdma-cm]       0
> 0          MIGRATED
> cxgb4_0/- 1026       0          RC    RTS    0          [rdma-cm]       0
> 0          MIGRATED
>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp link mlx4_0 -d
> DEV/PORT  LQPN       RQPN       TYPE  STATE  PID        COMM
> SQ-PSN     RQ-PSN     PATH-MIG
> mlx4_0/1  537        537        RC    RTS    0          [rdma-cm]
> 13145128   12441844   MIGRATED
> mlx4_0/1  536        536        RC    RTS    0          [rdma-cm]
> 14218681   1982803    MIGRATED
> mlx4_0/1  1          ---        GSI   RTS    0          [rdma-mad]      0
> ---        ---
>
> Looking good though!

Check filters options too, to filters by numbers and display columns.

>
> Why did you prefer netlink vs debugfs for this stuff?  (I'm sure it was
> discussed on the list but I missed it).

Three reasons:
1. We wanted rdmatool to be part of iproute2.
2. Debugfs requires root access and netlink doesn't
3. Better extensibility, if the device doesn't support the netlink won't
provide attribute and all neltink libraries know how to deal with it.

>
> Steve.
>

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6pn0ACgkQ5GN7iDZy
WKdNzhAAktqCM1Sze1hOwJhMUwTDBSM5APltC1SaLhgYtHd5YeSu9o9XUphyUN38
cvKPthRtEsP/FgnUAin23AFeOsHrUSadSk//yV4r9iSvZ2jC33F0QxbRC9LgA8Ka
M/8GmXJ8ipp7SfpQH9gOL+KdqzxWo8hSS365SdmZbnGw1uDEHSYvXqz9v1R4zTgB
68mANe8p9UvFqi3Jj6VG6ndo7++Chal7vZOj5sKe5y3rjX4MEbsf2egiNDlsX8je
Dlovkk9KXQrqnG9l2KFvVMUmtljw47pmCs45WgPb8sYqszkiBAgcBHIVE9SEcy0E
+psZUs9aXeOXIIoWW2gGqpaBgDABHLy3UDA76SMBjsmmylgKoeFSzaMNFvCGn4Nt
zyakzoM7O4lbl2EkRWnY/V9HXaG3z6g4BhOrqNEyjeQvPmyVZObd3mtnS+TSalot
S3nYzBa+DXrblyVEw73r8yamkbALTS10q5GuWOMOvBFqWbplik8sQbLVxPYc5gXN
OsWfACNPxHUYzQWtVSqPv8Z745uKwoz/uGhFEhBcXAZk6TC7OBlQMh+VZg0GKndu
oJAHxvt0h5U8CnZD4g57dD67mWk+0cjhOmdywIF0SDbehXhQnglnWChiYNEcEXYt
j5U0u13QBr+rlBQmoty/AAZrq1E7119lwotQw5icnYuiuUxP8Vg=
=J4vR
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
