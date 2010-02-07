From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] bug 1918 - openmpi broken due to rdma-cm changes
Date: Sun, 07 Feb 2010 10:39:26 -0600
Message-ID: <4B6EECBE.6020509@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com> <4B6E15C4.9020703@opengridcomputing.com> <4B6EAA5F.1000208@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6EAA5F.1000208-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tziporet Koren wrote:
> On 2/7/2010 3:22 AM, Steve Wise wrote:
>>   
>>>>
>>>> Good catch, I'll update the patch and submit for 2.6.33 on Monday.
>>>>
>>>>
>>>>        
>> NOTE: This doesn't solve our IB/openmpi regression for ofed-1.5.1.
>>
>>    
> If this patch will be accepted to the kernel 2.6.33 we can take it too
>
If ofed-1.5.1 is based on 2.6.33 then it will get this patch 
automatically (assuming it goes upstream and makes 2.6.33).  Or we can 
pull it in as a kernel_patches/fixes/ patch.

My point, though, is that even with this patch in ofed-1.5.1, we still 
have an openmpi/IB/rdmacm regression.  The only way to avoid this 
regression without changing openmpi is to disallow _all_ rdma binds to 
127.0.0.1.

Steve.




> Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
