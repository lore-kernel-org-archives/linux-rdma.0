From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [PATCH 08/21] IB/hfi1: Adjust default MTU to be 10KB
Date: Mon, 18 Apr 2016 08:03:36 -0400
Message-ID: <20160418120335.GB17987@phlsvsds.ph.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com> <20160412181708.21853.23423.stgit@scvm10.sc.intel.com> <20160418070708.GJ6349@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418070708.GJ6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 10:07:08AM +0300, Leon Romanovsky wrote:
 
>> diff --git a/drivers/staging/rdma/hfi1/qp.c 
>> b/drivers/staging/rdma/hfi1/qp.c
>> index 29a5ad2..e68d08a 100644
>> --- a/drivers/staging/rdma/hfi1/qp.c
>> +++ b/drivers/staging/rdma/hfi1/qp.c
>> @@ -167,8 +167,12 @@ static inline int opa_mtu_enum_to_int(int mtu)
>>   */
>>  static inline int verbs_mtu_enum_to_int(struct ib_device *dev, enum ib_mtu mtu)
>>  {
>> -	int val = opa_mtu_enum_to_int((int)mtu);
>> +	int val;
>>  
>> +	/* Constraining 10KB packets to 8KB packets */
>> +	if (mtu == (enum ib_mtu)OPA_MTU_10240)
>> +		mtu = OPA_MTU_8192;
>> +	val = opa_mtu_enum_to_int((int)mtu);
>
>Just spotted my attention,
>Curious names, castings and type conversions.
>

Is there a question being implied here? I'm not clear on what kind of 
response you are looking for here.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
