From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] avoid race condition between start_xmit and
 cm_rep_handler
Date: Thu, 16 Aug 2018 07:54:02 +0300
Message-ID: <20180816045402.GB4886@mtr-leonro.mtl.com>
References: <1534381909-2219-1-git-send-email-aaron.s.knister@nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534381909-2219-1-git-send-email-aaron.s.knister@nasa.gov>
Sender: stable-owner@vger.kernel.org
To: Aaron Knister <aaron.s.knister@nasa.gov>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 15, 2018 at 09:11:49PM -0400, Aaron Knister wrote:
> Inside of start_xmit() the call to check if the connection is up and the
> queueing of the packets for later transmission is not atomic which
> leaves a window where cm_rep_handler can run, set the connection up,
> dequeue pending packets and leave the subsequently queued packets by
> start_xmit() sitting on neigh->queue until they're dropped when the
> connection is torn down. This only applies to connected mode. These
> dropped packets can really upset TCP, for example,  and cause
> multi-minute delays in transmission for open connections.
>
> I've got a reproducer available if it's needed.
>
> Here's the code in start_xmit where we check to see if the connection
> is up:
>
>        if (ipoib_cm_get(neigh)) {
>                if (ipoib_cm_up(neigh)) {
>                        ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
>                        goto unref;
>                }
>        }
>
> The race occurs if cm_rep_handler execution occurs after the above
> connection check (specifically if it gets to the point where it acquires
> priv->lock to dequeue pending skb's) but before the below code snippet
> in start_xmit where packets are queued.
>
>        if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
>                push_pseudo_header(skb, phdr->hwaddr);
>                spin_lock_irqsave(&priv->lock, flags);
>                __skb_queue_tail(&neigh->queue, skb);
>                spin_unlock_irqrestore(&priv->lock, flags);
>        } else {
>                ++dev->stats.tx_dropped;
>                dev_kfree_skb_any(skb);
>        }
>
> The patch re-checks ipoib_cm_up with priv->lock held to avoid this
> race condition. Since odds are the conn should be up most of the time
> (and thus the connection *not* down most of the time) we don't hold the
> lock for the first check attempt to avoid a slowdown from unecessary
> locking for the majority of the packets transmitted during the
> connection's life.
>
> Cc: stable@vger.kernel.org
> Tested-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>
> ---

Sorry, but no mainly for two reasons:
1. Don't lock/unlock in different functions.
2. Don't create unbalanced number of lock/unlocks.

Thanks

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdQNqAAoJEORje4g2clinIgAP/37+U4wPiXay3CH3kgb6tII5
5m3pg0fQTHeuOZJUGGm/DnFx4cPiAN4q5WRnEECQVMTB2tyJlhnRAGZZfGt8GSm+
PaCDHlO4lJFETx2XWKwEVepruAzQKA9ezIsFpdX6iuiJKEaOVATvC+eG9ogyqLxQ
GPMfquyCf2yC1MHSH2bhZpIE9Can0tGYjjHjGG5/xrDHJlCo90EjpDUmrodnigaG
43rYUlbN/esA8Htjf4A78qMLFZV0bmViggohZshV/3ihhmFLbGlsh2Npa4PTkkbM
8iqm3n33QN1Lfqy7UMaiZftz/0VO2UhgwG15K/fwbvgYxNO+ZcZuJgGWbGUf3CHO
QM8sPqKW79iKYbK7H8D5xVMEsaoS2NxAN8n8wslQUB4tka5I/riwfOVDsG2DWwXK
Sa4srSglIFU2jVIjtXpZI/+OifJbFH4TH0V0gCcM+JIVsGSU9bZySb4M1W6TMfkC
x1/DRG+RXVoq8Nj1idyscZwh6PjH8eXNKfBZOgz08HRoE77+zl9uyWbA/jfWYDDV
sBwxxaREtQk2CE2LKdUzBnHHQeKsi2hEj/AS06BzoPS3aNM6QFcDcN1MxMpbQIk9
2D+53Zl2CHysceEUnSbRUyY3iBRpdM3K1v0kGhtA6QlcbDLF43g2D07AspEKUBrS
lPsFmU6yxzbzgyApiDVx
=Uhm2
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
