From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: kernel space iWARP broken with CONFIG_SECURITY_INFINIBAND enabled
Date: Thu, 16 Nov 2017 08:13:22 -0600
Message-ID: <11e34c3d-b2ac-a2dc-909d-711c5fd9c699@mellanox.com>
References: <20171115131525.GB25574@chelsio.com>
 <8ac43c6a-e2d9-572e-b4bf-03cdf3be57a8@mellanox.com>
 <20171116074049.GB9284@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116074049.GB9284-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-XVmvHMARGATQT0dZR+AlfA@public.gmane.org" <leon-XVmvHMARGATQT0dZR+AlfA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2017 1:40 AM, Potnuri Bharat Teja wrote:
> On Wednesday, November 11/15/17, 2017 at 23:51:08 +0530, Daniel Jurgens wrote:
>> On 11/15/2017 7:15 AM, Potnuri Bharat Teja wrote:
>>> Hi all,
>>> With CONFIG_SECURITY_INFINIBAND kernel config option enabled iWARP kernel 
>>> space applications are failing at rdma_create_qp(). Apparantly SELinux 
>>> support for Infiniband RDMA caused this regression.
>>>
>>> Here is the failure with NVMEof discovery:
>>> [  129.294943] nvme nvme0: rdma_resolve_addr wait failed (-22).
>>>
>>> Failure is at ib_get_cached_pkey(), for invalid pkey_index, called by the 
>>> following call chain: 
>>> rdma_create_qp()-> cma_init_conn_qp()-> ib_modify_qp()-> 
>>> ib_security_modify_qp()-> check_qp_port_pkey_settings()-> 
>>> get_pkey_and_subnet_prefix()
>>>
>>> SELinux support for Infiniband RDMA:
>>> https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-rdma%2Fmsg38705.html&data=02%7C01%7Cdanielj%40mellanox.com%7C562dfe4029994b668c8808d52c2af77a%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636463485413049982&sdata=zjyS9aC9I2vRRxPyrIeLmCAl0Cg3cNJS7Tfz96Fzl%2F4%3D&reserved=0
>>>
>>> I am trying to understand how IB security enforcing works with iWARP. 
>>> From the commit messages these appears to be an IB specific changes.
>>> If true, how is iw_cm supposed to handle it?
>>> iWARP doesn't use or have partition keys (pkey), How is this handled by the 
>>> IB security enforcing changes?
>>>
>>> Thanks,
>>> Bharat.
>>>  
>> Thanks Bharat, would you mind testing a patch for me? I don't have any iWARP hardware. I'll send to you it by EOB today.
> Thanks for the quick patch Daniel.
> Tested the patch for iwarp and it fixes the regression.
> I think this should be marked for stable as well.

Thanks, Bharat.

> Thanks,
> Bharat.
>
>
>
>  


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
