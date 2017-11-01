From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 19:28:30 +0200
Message-ID: <287a10c2-15a7-0748-c59e-3f084e7538f4@dev.mellanox.co.il>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101163915.GB1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/1/2017 6:39 PM, Jason Gunthorpe wrote:
> On Wed, Nov 01, 2017 at 12:07:07PM +0000, Amrani, Ram wrote:
>> Hi All,
>> I've installed rdma-core-15 on kernel 4.3 and ran into issues.
>>
>> It seems this kernel doesn't include the following patch:
>> https://github.com/torvalds/linux/commit/aa744cc01fe0f21dfbe2744d3fd5f2fb3244c9b3
>>
>> So IB_QP_SMAC is present in kernel 4.3 but not in rdma-core-15.

Was it ever appeared at verbs.h in libibverbs ? this value from kernel 
4.3 (IB_QP_SMAC = (1<<21)) appears in current kernel as IB_QP_RESERVED1.

>> This caused a failure here:
>>
>> int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
>>                        int attr_mask,
>>                        struct ibv_modify_qp *cmd, size_t cmd_size)
>> {
>>          /*
>>           * Masks over IBV_QP_DEST_QPN are only supported by
>>           * ibv_cmd_modify_qp_ex.
>>           */
>>          if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
>>                  return EOPNOTSUPP;
> 
> WTF is this?
> 
> Based on the comment it should be:
> 
>           if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))

The above rdma-core code is correct, look at verbs.h:
IBV_QP_DEST_QPN = 1 << 20,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
