From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add generic function to extract IB speed from
 netdev
Date: Tue, 6 Jun 2017 15:36:59 +0000
Message-ID: <1496763416.2692.3.camel@sandisk.com>
References: <20170606123854.1236-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606123854.1236-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <4E38BC5E95A67140A70EC7E2C61A9D0D-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selvin.xavier@bro
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-06-06 at 15:38 +0300, Yuval Shaia wrote:
> Logic of retriving netdev speed from net_device and translating it to IB
> speed is implemented both in rxe and bnxt drivers.

Hello Yuval,

Have you noticed that there is another copy of eth_speed_to_ib_speed() in
the usnic driver?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
