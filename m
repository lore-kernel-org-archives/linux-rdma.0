From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Add generic function to extract IB speed from
 netdev
Date: Tue, 6 Jun 2017 22:05:43 +0300
Message-ID: <20170606190542.GC4341@yuvallap>
References: <20170606123854.1236-1-yuval.shaia@oracle.com>
 <1496763416.2692.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496763416.2692.3.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org" <sagi-TmH2Wj2nsNJBDLzU/O5InQ@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 06, 2017 at 03:36:59PM +0000, Bart Van Assche wrote:
> On Tue, 2017-06-06 at 15:38 +0300, Yuval Shaia wrote:
> > Logic of retriving netdev speed from net_device and translating it to IB
> > speed is implemented both in rxe and bnxt drivers.
> 
> Hello Yuval,
> 
> Have you noticed that there is another copy of eth_speed_to_ib_speed() in
> the usnic driver?

Missed that one.
I will post v1 of the patch soon that utilize this new function in
usnic_ib_query_port.
Problem i see here is that usnic_ib_query_port directly call
__ethtool_get_link_ksettings and not via netdev->ethtool_ops. So asking
usnic folks to review and approve the change.

> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
