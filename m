From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 03/11] RDMA/cxgb4: CQ size must be IQ size - 2.
Date: Thu, 20 May 2010 17:16:49 -0500
Message-ID: <4BF5B4D1.1010504@opengridcomputing.com>
References: <20100520215727.32394.90669.stgit@build.ogc.int> <20100520215738.32394.60360.stgit@build.ogc.int> <27BBA4336B784434AAE16BB1126AD59C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27BBA4336B784434AAE16BB1126AD59C-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> 	/* account for the status page. */
>> 	entries++;
>>
>> +	/* IQ needs one extra entry to differentiate full vs empty. */
>> +	entries++;
>> +
>> 	/*
>> 	 * entries must be multiple of 16 for HW.
>> 	 */
>> @@ -801,7 +804,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int
>> entries,
>>
>> 	chp->rhp = rhp;
>> 	chp->cq.size--;				/* status page */
>> -	chp->ibcq.cqe = chp->cq.size;
>> +	chp->ibcq.cqe = chp->cq.size - 1;
>>     
>
> Why does the status page adjust using size--, but we use size - 1 for the extra
> entry?
>
>   
chp->cq.size is the actual number of entries that can write-to by the 
HW.  But since one must always be available to detect "full" vs "empty", 
we tell the ULP that the size is one less than that.


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
