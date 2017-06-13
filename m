From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/3] IB/core: Fix the validations of a multicast
 LID in attach or detach operations
Date: Tue, 13 Jun 2017 10:44:51 +0300
Message-ID: <CAG9sBKNCbS0zYmKKwkLi5pFBFd6QMORqQq6-_k2=OYa_kj-=pA@mail.gmail.com>
References: <20170612081404.17553-1-leon@kernel.org> <20170612081404.17553-2-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB142896@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB142896-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 7:15 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> +static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>> +{
>> +     struct ib_qp_init_attr init_attr = {};
>> +     struct ib_qp_attr attr = {};
>> +     int num_eth_ports = 0;
>> +     int port;
>> +
>> +     /* If QP state >= init, it is assigned to a port and we can
>> check this
>> +      * port only.
>> +      */
>> +     if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT,
>> &init_attr)) {
>> +             if (attr.qp_state >= IB_QPS_INIT) {
>> +                     if (qp->device->get_link_layer(qp->device,
>> attr.port_num) !=
>> +                         IB_LINK_LAYER_INFINIBAND)
>> +                             return true;
>> +                     goto lid_check;
>> +             }
>> +     }
>> +
>> +     /* Can't get a quick answer, iterate over all ports */
>> +     for (port = 0; port < qp->device->phys_port_cnt; port++)
>> +             if (qp->device->get_link_layer(qp->device, port) !=
>> +                 IB_LINK_LAYER_INFINIBAND)
>> +                     num_eth_ports++;
>> +
>> +     /* If we have at lease one Ethernet port, RoCE annex declares
>> that
>> +      * multicast LID should be ignored. We can't tell at this step
>> if the
>> +      * QP belongs to an IB or Ethernet port.
>> +      */
>> +     if (num_eth_ports)
>> +             return true;
>
> Reporting that a lid *might* be valid is a really weak check.  Can we require that RoCE QPs be in the INIT state prior to joining, or use the mgid, or something to make the validation check work?  Do we even know if the qp is a roce qp?
>
>
This is not a join flow but attach flow. AFAIK, attaching a QP to a
mcast group can be when QP is in RESET state. This patch does the best
it can to give a valid answer but when QP is in RESET state and at
least one of the ports is Eth port then we can't invalidate a MLID.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
