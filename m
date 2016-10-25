From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: NVMe Over Fabrics - Random Crash with SoftROCE
Date: Tue, 25 Oct 2016 08:47:33 +0300
Message-ID: <20161025054733.GN25013@leon.nu>
References: <CAGbt=A6q27wj79iTt=EDhCKo_6kzw29Aoz4QN6_yjTWUzKg9uQ@mail.gmail.com>
 <20161024124625.GA2389@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h9WqFG8zn/Mwlkpe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161024124625.GA2389-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ripduman Sohan <ripduman.sohan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--h9WqFG8zn/Mwlkpe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 24, 2016 at 02:46:25PM +0200, Christoph Hellwig wrote:
> Hi Ripduman,
>
> please report all NVMe issues to the linux-nvme list.  I'm reading there
> as well, but it will allow for more people to follow the issue.
>
> I'm not even sure what the error is between all the traces, but maybe
> someone understands the rxe traces better there or on the linux-rdma
> list.

Hi Ripduman,

Please include Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (RXE maintainer) in your
emails.

Thanks

>
> On Fri, Oct 21, 2016 at 10:30:15PM +0100, Ripduman Sohan wrote:
> > Hi,
> >
> > I'm trying to get NVMF going over SoftRoCE (rxe_rdma) and I get random
> > crashes.  At the simplest reduction, if I connect the initiator to the
> > target, on an idle system I will on occasion get the error below on the
> > initiator (no data has been transferred between hosts at this point - and
> > this happens randomly, sometimes it takes hours, sometimes it happens
> > within 10 mins of boot).
> >
> > I'll probably start to debug this in a couple of weeks, but I thought it
> > might be passing it by you in case it's something you might have seen
> > before/have some clues?
> >
> > Thanks
> >
> > Rip
> >
> >
> > ---- log below ---- (initiator).
> >
> > rdma_rxe: loaded
> > rdma_rxe: set rxe0 active
> > rdma_rxe: added rxe0 to eth4
> > nvme nvme0: creating 8 I/O queues.
> > nvme nvme0: new ctrl: NQN "ramdisk", addr 172.16.139.22:4420
> > nvme nvme0: failed nvme_keep_alive_end_io error=16391
> > nvme nvme0: reconnecting in 10 seconds
> > nvme nvme0: Successfully reconnected
> >
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff8801389c6800
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff8801376d8000
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff8801369ee400
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff88013a9dc400
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff88013997d000
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff880137201c00
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff88013548f800
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff880138c0b800
> > 1346: nvme nvme0: disconnect received - connection closed
> > 1317: nvme nvme0: disconnected (10): status 0 id ffff880139936400
> > 1346: nvme nvme0: disconnect received - connection closed
> > 756: rdma_rxe: qp#26 state -> ERR
> > 756: rdma_rxe: qp#26 state -> ERR
> > 756: rdma_rxe: qp#26 state -> ERR
> > 756: rdma_rxe: qp#27 state -> ERR
> > 756: rdma_rxe: qp#27 state -> ERR
> > 756: rdma_rxe: qp#27 state -> ERR
> > 756: rdma_rxe: qp#28 state -> ERR
> > 756: rdma_rxe: qp#28 state -> ERR
> > 756: rdma_rxe: qp#28 state -> ERR
> > 756: rdma_rxe: qp#29 state -> ERR
> > 756: rdma_rxe: qp#29 state -> ERR
> > 756: rdma_rxe: qp#29 state -> ERR
> > 756: rdma_rxe: qp#30 state -> ERR
> > 756: rdma_rxe: qp#30 state -> ERR
> > 756: rdma_rxe: qp#30 state -> ERR
> > 756: rdma_rxe: qp#31 state -> ERR
> > 756: rdma_rxe: qp#31 state -> ERR
> > 756: rdma_rxe: qp#31 state -> ERR
> > 756: rdma_rxe: qp#32 state -> ERR
> > 756: rdma_rxe: qp#32 state -> ERR
> > 756: rdma_rxe: qp#32 state -> ERR
> > 756: rdma_rxe: qp#33 state -> ERR
> > 756: rdma_rxe: qp#33 state -> ERR
> > 756: rdma_rxe: qp#33 state -> ERR
> > 756: rdma_rxe: qp#25 state -> ERR
> > 756: rdma_rxe: qp#25 state -> ERR
> > 756: rdma_rxe: qp#25 state -> ERR
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff8801389c6800
> > 302: rdma_rxe: qp#33 max_wr = 33, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#33 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff8801389c6800
> > 730: rdma_rxe: qp#33 state -> INIT
> > 698: rdma_rxe: qp#33 set resp psn = 0x7a0c05
> > 704: rdma_rxe: qp#33 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#33 state -> RTR
> > 684: rdma_rxe: qp#33 set retry count = 7
> > 691: rdma_rxe: qp#33 set rnr retry count = 7
> > 711: rdma_rxe: qp#33 set req psn = 0x2c631
> > 741: rdma_rxe: qp#33 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff8801389c6800
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff88013a461800
> > 302: rdma_rxe: qp#34 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#34 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff88013a461800
> > 730: rdma_rxe: qp#34 state -> INIT
> > 698: rdma_rxe: qp#34 set resp psn = 0x4e6c1c
> > 704: rdma_rxe: qp#34 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#34 state -> RTR
> > 684: rdma_rxe: qp#34 set retry count = 7
> > 691: rdma_rxe: qp#34 set rnr retry count = 7
> > 711: rdma_rxe: qp#34 set req psn = 0x186e10
> > 741: rdma_rxe: qp#34 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff88013a461800
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff88013997dc00
> > 302: rdma_rxe: qp#35 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#35 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff88013997dc00
> > 730: rdma_rxe: qp#35 state -> INIT
> > 698: rdma_rxe: qp#35 set resp psn = 0xd727f8
> > 704: rdma_rxe: qp#35 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#35 state -> RTR
> > 684: rdma_rxe: qp#35 set retry count = 7
> > 691: rdma_rxe: qp#35 set rnr retry count = 7
> > 711: rdma_rxe: qp#35 set req psn = 0xd8e512
> > 741: rdma_rxe: qp#35 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff88013997dc00
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880139d81000
> > 302: rdma_rxe: qp#36 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#36 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880139d81000
> > 730: rdma_rxe: qp#36 state -> INIT
> > 698: rdma_rxe: qp#36 set resp psn = 0x7978ee
> > 704: rdma_rxe: qp#36 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#36 state -> RTR
> > 684: rdma_rxe: qp#36 set retry count = 7
> > 691: rdma_rxe: qp#36 set rnr retry count = 7
> > 711: rdma_rxe: qp#36 set req psn = 0xc5b0ef
> > 741: rdma_rxe: qp#36 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880139d81000
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880137201800
> > 302: rdma_rxe: qp#37 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#37 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880137201800
> > 730: rdma_rxe: qp#37 state -> INIT
> > 698: rdma_rxe: qp#37 set resp psn = 0x970dd5
> > 704: rdma_rxe: qp#37 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#37 state -> RTR
> > 684: rdma_rxe: qp#37 set retry count = 7
> > 691: rdma_rxe: qp#37 set rnr retry count = 7
> > 711: rdma_rxe: qp#37 set req psn = 0x71f2a2
> > 741: rdma_rxe: qp#37 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880137201800
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880139e34c00
> > 302: rdma_rxe: qp#38 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#38 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880139e34c00
> > 730: rdma_rxe: qp#38 state -> INIT
> > 698: rdma_rxe: qp#38 set resp psn = 0x542d56
> > 704: rdma_rxe: qp#38 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#38 state -> RTR
> > 684: rdma_rxe: qp#38 set retry count = 7
> > 691: rdma_rxe: qp#38 set rnr retry count = 7
> > 711: rdma_rxe: qp#38 set req psn = 0x71fad4
> > 741: rdma_rxe: qp#38 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880139e34c00
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880134e43800
> > 302: rdma_rxe: qp#39 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#39 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880134e43800
> > 730: rdma_rxe: qp#39 state -> INIT
> > 698: rdma_rxe: qp#39 set resp psn = 0xdbca4
> > 704: rdma_rxe: qp#39 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#39 state -> RTR
> > 684: rdma_rxe: qp#39 set retry count = 7
> > 691: rdma_rxe: qp#39 set rnr retry count = 7
> > 711: rdma_rxe: qp#39 set req psn = 0xd84ac0
> > 741: rdma_rxe: qp#39 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880134e43800
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880138d15400
> > 302: rdma_rxe: qp#40 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#40 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880138d15400
> > 730: rdma_rxe: qp#40 state -> INIT
> > 698: rdma_rxe: qp#40 set resp psn = 0x6afd31
> > 704: rdma_rxe: qp#40 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#40 state -> RTR
> > 684: rdma_rxe: qp#40 set retry count = 7
> > 691: rdma_rxe: qp#40 set rnr retry count = 7
> > 711: rdma_rxe: qp#40 set req psn = 0xb917ed
> > 741: rdma_rxe: qp#40 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880138d15400
> > 1317: nvme nvme0: address resolved (0): status 0 id ffff880134f45400
> > 302: rdma_rxe: qp#41 max_wr = 129, max_sge = 1, wqe_size = 56
> > 730: rdma_rxe: qp#41 state -> INIT
> > 1317: nvme nvme0: route resolved  (2): status 0 id ffff880134f45400
> > 730: rdma_rxe: qp#41 state -> INIT
> > 698: rdma_rxe: qp#41 set resp psn = 0x8a6989
> > 704: rdma_rxe: qp#41 set min rnr timer = 0x0
> > 736: rdma_rxe: qp#41 state -> RTR
> > 684: rdma_rxe: qp#41 set retry count = 7
> > 691: rdma_rxe: qp#41 set rnr retry count = 7
> > 711: rdma_rxe: qp#41 set req psn = 0x23c909
> > 741: rdma_rxe: qp#41 state -> RTS
> > 1317: nvme nvme0: established (9): status 0 id ffff880134f45400
> > nvme nvme0: Successfully reconnected
> >
> > --
> > --rip
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--h9WqFG8zn/Mwlkpe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDvH0AAoJEORje4g2clinVSEQAKmH7zRbvXHHLO0hmuFfNnrF
jyhP/wY62/D9gXgIxOS87t0IJQ6cbVBRhLV+iMHkd9V0xEs0SZsIjQWZRh2/gU2T
hzGWITHRl+eCsejoPY5FVVC7uA/72o7K4Dxaem6N+nBz8wEiYcMYOtLViN6oculS
1pdDLsoZRtecK6TjJvp7eq8U49IFhFVATlbUdmXMR9f2TIqutaMfgqxM9dtVskdd
fB5AJ5Mt6XTDZsUdqtzwzp+oeg4w1C0MSJXNb+9pslDqyEymQVjS/XRbQNwZvZkM
4HJLcde9nwB4RIfXy9cdQ4VJxA3P7o+G6thveWjaSM7H3plMHJEPDEp4vXdBA4af
oKU9m81d4xkpKxrpF7BZ3N/tXcchNSuSaojhUHsauSZQWPw3v7u7LkjA8c/uJ3Um
TTKBXthrz/LzMcWfmxWhSENgNfnBg44xF3AOcIFfVkNOdFzRs2L4eQxezHD7pXaf
9I/gGa5Djb5R+porjTIDG2uBxVcOTsZWISUrOq8n71H9+IiGSa7qu1Qj6EsRj2O0
LJNAbxLQ+SshgPEUYtyrrql1YBOT2ijyLtMoCOHkw/3T/911sKXuXd35pODmTMvU
5RRCuEdVEDUxICsgrKNFwaYWRU4x4I2lMlUa1sUJzs8Lf00/idJdFAmWwgVn5k3N
OIazZNUtUcOf9lQ/xXml
=61Ab
-----END PGP SIGNATURE-----

--h9WqFG8zn/Mwlkpe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
