From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [patch 5/8] ehca - ib_post_recv fixes Always set ib_post_recv()s
 bad_wr.
Date: Tue, 24 Nov 2009 17:28:51 -0600
Message-ID: <4B0C6C33.2040609@systemfabricworks.com>
References: <20091124043323.927819053@systemfabricworks.com>	<4B0C19AE.6030006@systemfabricworks.com> <20091124180621.0df9150b@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091124180621.0df9150b@alex-laptop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Alexander Schmidt wrote:
> On Tue, 24 Nov 2009 11:36:46 -0600
> frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>
> Hi Frank,
>
>   
>> Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
>> Index: linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c
>> ===================================================================
>> --- linux-2.6.31.orig/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-23 
>> 21:23:08.000000000 -0600
>> +++ linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-23 
>> 21:25:48.000000000 -0600
>> @@ -519,7 +519,7 @@
>>   	if (unlikely(!HAS_RQ(my_qp))) {
>>   		ehca_err(dev, "QP has no RQ  ehca_qp=%p qp_num=%x ext_type=%d",
>>   			 my_qp, my_qp->real_qp_num, my_qp->ext_type);
>> -		return -ENODEV;
>> +		ret = -ENODEV;
>>     
>
> aren't you missing a goto statement here?
>   

Indeed. I'll resend a patch.

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
