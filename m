From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 00/10] Add network namespace support in the RDMA-CM
Date: Thu, 19 Mar 2015 16:12:34 +0200
Message-ID: <550AD952.7060900@mellanox.com>
References: <1423667204-8807-1-git-send-email-raindel@mellanox.com>
 <54E363E7.5090507@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E363E7.5090507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/17/2015 5:53 PM, Or Gerlitz wrote:
>
> On 02/11/2015 05:06 PM, Shachar Raindel wrote:
>> RDMA-CM uses IP based addressing and routing to setup RDMA 
>> connections between
>> hosts. Currently, all of the IP interfaces and addresses used by the 
>> RDMA-CM
>> must reside in the init_net namespace. This restricts the usage of 
>> containers
>> with RDMA to only work with host network namespace (aka the kernel 
>> init_net NS
>> instance).
>>
>> This patchset allows using network namespaces with the RDMA-CM.
>>
>> Each RDMA-CM and CM id is keeping a reference to a network namespace.
> [...]
>
>
> Hi Sean,
>
> Did you had the chance to look on the patches that do the changes to 
> the cm and cma code?
>

Sean, ping... you are the maintainer of the rdma-cm, these patches are 
here for many weeks,  can you please take a look and provide your feedback.

thanks,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
