From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Thu, 17 Nov 2016 20:15:11 +0200
Message-ID: <20161117181511.GN4240@leon.nu>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gh4H09KImyIEQ1se"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477909297-14491-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gh4H09KImyIEQ1se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 31, 2016 at 12:21:33PM +0200, Leon Romanovsky wrote:
> When sending from a 10G host to a 1G host, it is easy to overrun the receiver,
> leading to packet loss and traffic backing off. Similar problems occur when
> a 10G host sends data to a sub-10G virtual circuit, or a 40G host sending
> to a 10G host. Packet pacing could control packet injection rate and reduces
> network congestion to maximize throughput & minimize network latency.
>
> Packet pacing is a rate limiting and shaping for a QP (SQ for RAW QP), set
> and change the rate is done by modifying QP. This series of patch made the
> following high level changes:
>  1. Report rate limit capabilities through user data. Reported capabilities
>     include: The maximum and minimum rate limit in kbps supported by packet
>     pacing; Bitmap showing which QP types are supported by packet pacing
>     operation.
>  2. Extend modify QP interface for growing attributes. Add rate limit support
>     to the extended interface.
>  3. Enable mlx5-based hardware to be able to update the rate limit for
>     RAW QP packet.
>
> Available in the "topic/packet_pacing" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/packet_pacing

Hi Doug,

Please drop this patch series, we discovered an issue with proposed
modify_qp implementation and will respin it.

Sorry for the inconvenience.

Thanks

>
> Thanks,
>   Bodong & Leon
>
> Bodong Wang (4):
>   IB/mlx5: Report mlx5 packet pacing capabilities when querying device
>   IB/core: Support rate limit for packet pacing
>   IB/uverbs: Extend modify_qp and support packet pacing
>   IB/mlx5: Update the rate limit according to user setting for RAW QP
>
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 178 +++++++++++++++++++++-------------
>  drivers/infiniband/core/uverbs_main.c |   1 +
>  drivers/infiniband/core/verbs.c       |   2 +
>  drivers/infiniband/hw/mlx5/main.c     |  16 ++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h  |   1 +
>  drivers/infiniband/hw/mlx5/qp.c       |  71 ++++++++++++--
>  include/rdma/ib_verbs.h               |   2 +
>  include/uapi/rdma/ib_user_verbs.h     |  12 +++
>  include/uapi/rdma/mlx5-abi.h          |  13 +++
>  10 files changed, 219 insertions(+), 78 deletions(-)
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gh4H09KImyIEQ1se
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLfOvAAoJEORje4g2clinYNQQAKk3T0lmKVmEHzBSb9dqfyQn
/35dbOXGrCzlHAIw3uLL65yRAUGcilCT6gR/uqPTxYBJAjYqce5sB+nrmpnsPiTj
FS04Tw3IhTiAUsjkkrxrkn7Bv+4uc6LUHvbrg60H2dTbQaijBi0oA0TnH3/BDKCx
NxQaYpcIfVQvOaa17VaoDkbyOBXdEkHNVBp6BKOkFvRjfmYtoqAzD60g97LpEnVq
+xovvZIloiLlBP74Htn5EE9rJ3yI60Xw9QIcOxJUna0iPVcK5E0eAKHKOggPoZDM
LzVXfh6fJ7kCAhChKi+yGX5yKBo1rxD0/o8fCkIhkW+gGOryRTwUgAYedriDOKjX
aqG/eRJ6ycLCHMs859jB3l8b1JfcRaWb7O9zu78aefzQbwsVON1yviLiT77Obc/M
9HzXiQ54muXMPl8Zs85grhHVpJrPtLWted9iJemg0BuchNAETU4on3gRZQ7NFv9U
eg40kRLUkDHHn2qegn4ePBI+q/gmgAmlcCk6wDBZ6qfuZxbWRUd2yYI9BLDYHwe7
rew6YjQqLZzNIaDA4RLjhQCVwykJN6SknzF426CUitNkr8MQhL+zhHRjDTcrHSI3
YVIJwS/FRK1tCs5ZlhMj8pKWlzjlpgv4gfGVHk8RTOEg2VK8y9BgXaWw9R/Z2gvt
LWzK2VFcw8wY6/DCAquk
=uZMy
-----END PGP SIGNATURE-----

--gh4H09KImyIEQ1se--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
