From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] avoid race condition between start_xmit and
 cm_rep_handler
Date: Sun, 19 Aug 2018 20:28:34 +0300
Message-ID: <20180819172834.GS2796@mtr-leonro.mtl.com>
References: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534541486-16263-1-git-send-email-aaron.s.knister@nasa.gov>
Sender: stable-owner@vger.kernel.org
To: Aaron Knister <aaron.s.knister@nasa.gov>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org


--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 17, 2018 at 05:31:26PM -0400, Aaron Knister wrote:
> Inside of start_xmit() the call to check if the connection is up and the
> queueing of the packets for later transmission is not atomic which
> leaves a window where cm_rep_handler can run, set the connection up,
> dequeue pending packets and leave the subsequently queued packets by
> start_xmit() sitting on neigh->queue until they're dropped when the
> connection is torn down. This only applies to connected mode. These
> dropped packets can really upset TCP, for example,  and cause
> multi-minute delays in transmission for open connections.
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
> Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>

If you want this fix in stable@, you will need to provide Fixes line
here and don't add stable@ in CC-list.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbeajBAAoJEORje4g2clinxwYP/2QaC2Xf1zzY65mDiLqNLn6N
rXjdL25sXR8ATC7Y5km7o/7B1hS+VywOlIGnb1hOfY1szCwNxO19JL8ks5WVAUpV
y6E4tjWB5PwjOOTt/jxWiqvziSGuRA53TfGrxTb0npY6dwZfPjgFv3Sw8vhpBcaa
HQEMeM3RxHcA1U3UllqZx55TEN3DfSpswLlNQ4TNeV7F645P7YlQGdJxM21E6xG+
GF8ad8w8KSGFSX1/ox0/TzW83PBdGPn2i1E5Pgta5jZ9tD8jFd8IstzdJ8BgpgTM
tkIf/fyM20616mAXT7RhE89cKReGZl9pAETA+9KlKbZoQkrNh9FgEDB5vBvDocL3
O3bh0jkULIawSx2SuPZlhtJDq3JmkrzSU+n8lEKB/NEZEiAenw5X9ylmB5ZHQ+EN
MWXbWJ+yl4NYa/4PH/YB8FyPXWcArBPXOgsKptTPw+f5uJzGwnvxW+dCifnSmaoO
YLK123y5ZTTihIDqROWHiDM4e1bVZVPibITHtSt76muwbLr9u4bCf1uNm1x82v95
U+VszA2WXcpCuKTbMPPSHAjCwtg8ruHAfS9EWISF779NVPRtURSbKyiW5iF/MTua
YX6gLJ8LBvg0F99ruUXBpKGgDS5GkgDpEgNzfBNVF/obQtST4oCANsKXea2+QDxR
h4IGQ1d7rz8mPkuFiNBZ
=za7Y
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
