From: "Joel Nider" <JOELN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_create_qp failing
Date: Tue, 30 Jan 2018 10:30:13 +0200
Message-ID: <OF85410752.DF2BA5BF-ONC2258225.002CFF83-C2258225.002EB65B@notes.na.collabserv.com>
References: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558@notes.na.collabserv.com>
 <AM4PR0501MB27239EF18E2C07A64B045674D4E50@AM4PR0501MB2723.eurprd05.prod.outlook.com>
 <OF09394B7D.58CD59F8-ONC2258224.006BDAF8-C2258224.006F854D@notes.na.collabserv.com>
 <fd693fbd-1387-0298-49d0-035e224f07d8@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fd693fbd-1387-0298-49d0-035e224f07d8-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Mark,

Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote on 29/01/2018 22:47:04:

> > I am using ConnectX5 EN with special firmware (I just mention it so 
you 
> > know, but I'm pretty sure that's not the problem).  I have used 
dynamic 
> > debug - it shows me that the call is failing like this:
> > 
> > mlx5_core 0000:01:00.0: mlx5_cmd_check:714:(pid 120772): 
CREATE_QP(0x500) 
> > op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x48b5c0)
> 
> The syndrome means: "create_qp: invalid service type for RoCE"
> what QP type are you trying to create and with what parameters?

I'm trying to create an RC connection - here is an outline of my code:
In module_init(): ib_register_client() -> registers callback 
on_device_add()
On_device_add(): I only have one device (mlx5_0) and I save the ib_device* 
to a linked list
>From sysfs, a user writes the name (string) of the device to use - this 
starts the setup procedure
ib_register_event_handler(rpf_ib_qp_event_handler)
ib_query_port(dev, 1) -> state=4 max_mtu=4096 active_mtu=1024 gid_len=256 
caps=0x4010000
ib_create_cq() -> rx completion queue
ib_create_cq() -> tx completion queue
ib_alloc_pd() -> the protection domain
ib_create_qp() with: 

        struct ib_qp_init_attr qp_attr = {
                .event_handler = rpf_ib_qp_event_handler,
                .qp_context = res,
                .send_cq = res->tx_cq,
                .recv_cq = res->rx_cq,
                .srq = NULL,
                .cap = {
                        .max_send_wr = 16,
                        .max_recv_wr = 48,
                        .max_send_sge = 2,
                        .max_recv_sge = 1,
                },
                .sq_sig_type = IB_SIGNAL_REQ_WR,
                .qp_type = IB_QPT_RC,
        };

Fails with the code I mentioned earlier.  This used to fail even earlier 
until I discovered that ib_query_port() has some interesting side effects, 
and is mandatory. Maybe there is some other function that I need to call 
to set up some state first?

> 
> > 
> > Is there any way for me to look up the syndrome?
> > 
> > Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote on 29/01/2018 21:04:57:
> >>>
> >>> I have used the net/smc module extensively as a reference, but there 

> > seems
> >>> to be something fundamental that I'm missing.  How can I find out 
> > what's
> >>> going wrong here?
> >>
> >> Hi Joel,
> >> What ROCE device are you using?
> >> There are many debug prints in the Mellanox drivers.
> >> You should try enabling  dynamic debug for mlx4_ib or mlx5_ib, it 
might 
> > give 
> >> you more information.
> >>
> >> Good luck,
> >> Ilya
> >>
> > 
> Mark
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
