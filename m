From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1] IB/cma: Use inner P_Key to determine netdev
Date: Tue, 20 Oct 2015 11:35:36 +0300
Message-ID: <5625FCD8.8080807@mellanox.com>
References: <1445323981-28582-1-git-send-email-haggaie@mellanox.com>
 <5625EB59.4020304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5625EB59.4020304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/10/2015 10:20, Doug Ledford wrote:
> On 10/20/2015 02:53 AM, Haggai Eran wrote:
>> When discussing the patches to demux ids in rdma_cm instead of ib_cm, it
>> was decided that it is best to use the P_Key value in the packet headers.
>> However, the mlx5 and ipath drivers are currently unable to send correct
>> P_Key values in GMP headers. They always send using a single P_Key that is
>> set during the GSI QP initialization.
>>
>> Change the rdma_cm code to look at the P_Key value that is part of the
>> packet payload as a workaround. Once the drivers are fixed this patch can
>> be reverted.
>>
>> Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
>> RDMA CM")
>> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> Changes from v0:
>> - improve commit message
>>
>>  drivers/infiniband/core/cma.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>> index 59a2dafc8c57..e8324543e085 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -1067,14 +1067,14 @@ static int cma_save_req_info(const struct ib_cm_event *ib_event,
>>  		       sizeof(req->local_gid));
>>  		req->has_gid	= true;
>>  		req->service_id	= req_param->primary_path->service_id;
>> -		req->pkey	= req_param->bth_pkey;
>> +		req->pkey	= be16_to_cpu(req_param->primary_path->pkey);
>>  		break;
>>  	case IB_CM_SIDR_REQ_RECEIVED:
>>  		req->device	= sidr_param->listen_id->device;
>>  		req->port	= sidr_param->port;
>>  		req->has_gid	= false;
>>  		req->service_id	= sidr_param->service_id;
>> -		req->pkey	= sidr_param->bth_pkey;
>> +		req->pkey	= sidr_param->pkey;
>>  		break;
>>  	default:
>>  		return -EINVAL;
>>
> 
> And, to be clear, you are looking for this to be part of 4.3-rc updates,
> yes?

Yes, the issue was introduced in 4.3 in my cma demux patch.

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
