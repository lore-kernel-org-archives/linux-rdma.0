From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix CM REQ retries in paravirt mode
Date: Thu, 13 Jul 2017 14:16:29 +0200
Message-ID: <74D67A9B-A781-4EFA-B731-A12EA0664DE3@oracle.com>
References: <20170620120750.32268-1-Haakon.Bugge@oracle.com> <84f89de6-0efc-ada9-2745-7af65682f02e@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84f89de6-0efc-ada9-2745-7af65682f02e-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Lijun,


> On 10 Jul 2017, at 08:30, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> 
> Hi, Haakon.Bugge
>     I am interested in your question. Will it be happened when use
> rdma cm to establish connection on other hardware environment?
> for example, arm64 board.

Yes, this bug is CPU architecture agnostic. What is required to hit the bug is a CX-3 in a virtualized environment.

>    Moreover,  Would you provide the detail test method for the bug?
> I don’t understand  slightly what  is the RDMA CM user-land application

You can provoke this bug by running for example qperf or any of the perftest applications. You must use command line switches to enable RDMA CM connection establishment. You must also insert a sleep() with a five second delay just before rdma_accept() in the source.

Now, if you run this between two VMs on the same physical machine or on two VMs on two different machines, you will hit the error.

Hope this helps :-)


Thxs, Håkon

> 
> Thanks
> Lijun Ou
> 在 2017/6/20 20:07, Håkon Bugge 写道:
>> CM REQs cannot be successfully retried, because a new pv_cm_id is
>> created for each request, without checking if one already exists.
>> 
>> By checking if an id exists before creating one, the bug is fixed.
>> 
>> This bug can be provoked by running an RDMA CM user-land application,
>> but inserting a five seconds delay before the rdma_accept() call on
>> the passive side. This delay is larger than the default CMA timeout,
>> and triggers a retry from the active side. The retried REQ will use
>> another pv_cm_id (the cm_id on the wire). This confuses the CM
>> protocol and two REJs are sent from the passive side.
>> 
>> Here is an excerpt from ibdump running without the patch:
>> 
>> 3.285092       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP Hello)
>> 7.382711       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP Hello)
>> 7.382861       LID: 4 -> LID: 4       InfiniBand 290 CM: ConnectReject
>> 7.387644       LID: 4 -> LID: 4       InfiniBand 290 CM: ConnectReject
>> 
>> and here is the same with bug fix applied:
>> 
>> 3.251010       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP Hello)
>> 7.349387       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP Hello)
>> 8.258443       LID: 4 -> LID: 4       SDP 290 CM: ConnectReply(SDP Hello)
>> 8.259890       LID: 4 -> LID: 4       InfiniBand 290 CM: ReadyToUse
>> 
>> Suggested-by: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reported-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Tested-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> drivers/infiniband/hw/mlx4/cm.c | 4 ++++
>> 1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
>> index 1e6c526..fedaf82 100644
>> --- a/drivers/infiniband/hw/mlx4/cm.c
>> +++ b/drivers/infiniband/hw/mlx4/cm.c
>> @@ -323,6 +323,9 @@ int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id
>> 			mad->mad_hdr.attr_id == CM_REP_ATTR_ID ||
>> 			mad->mad_hdr.attr_id == CM_SIDR_REQ_ATTR_ID) {
>> 		sl_cm_id = get_local_comm_id(mad);
>> +		id = id_map_get(ibdev, &pv_cm_id, slave_id, sl_cm_id);
>> +		if (id)
>> +			goto cont;
>> 		id = id_map_alloc(ibdev, slave_id, sl_cm_id);
>> 		if (IS_ERR(id)) {
>> 			mlx4_ib_warn(ibdev, "%s: id{slave: %d, sl_cm_id: 0x%x} Failed to id_map_alloc\n",
>> @@ -343,6 +346,7 @@ int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id
>> 		return -EINVAL;
>> 	}
>> 
>> +cont:
>> 	set_local_comm_id(mad, id->pv_cm_id);
>> 
>> 	if (mad->mad_hdr.attr_id == CM_DREQ_ATTR_ID)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
