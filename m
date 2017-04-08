From: Heiner Lesaar <heiner.lesaar-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: ib-iser - 4k IO req size only
Date: Sat, 8 Apr 2017 11:59:07 +0200
Message-ID: <704B9754-E679-41F3-80D7-0D783B53ADC8@googlemail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Dear all,

I use SCST 3.3.0  and ISCSI-SCST on CentOS7.3 (stock kernel) w. in-tree RDMA=
  and Mellanox ConnectX-4 cards (no OFED packages) on the target.

Same hardware / software on the initiator (w. open-iscsi and ib-iser, no OFE=
D as well).

When using iSer as the transport layer, all read and write requests from the=
 connected initiator to the target devices are always exactly 4kb (checked w=
. e.g. "iostat -xm 2"), which harms the performance of large IO a lot obviou=
sly.=20

Changing to TCP as the transport layer shows expected behaviour of larger IO=
 requests (up to max_sector_size) and expected performance.

Tested w. common everyday operations like "cp" or "dd", but also benchmark t=
ools like "filebench".
I guess its something related to ib_iser, so I hope someone on the list has a=
 good hint for me how to solve this.


Thank you very much for any kind help or response!


Heiner

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
