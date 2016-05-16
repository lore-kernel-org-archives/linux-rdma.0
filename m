From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: intel iommu causing performance drop in mlx4 ipoib
Date: Mon, 16 May 2016 15:37:00 +0300
Message-ID: <5739BEEC.3070308@kyup.com>
References: <5739A347.20807@kyup.com>
 <1463396094.2484.194.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463396094.2484.194.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 05/16/2016 01:54 PM, David Woodhouse wrote:
> On Mon, 2016-05-16 at 13:39 +0300, Nikolay Borisov wrote:
>>
>> I've observed a strange performance pathology with it when running ipoib 
>> and using a naive iperf test. My setup has multiple machines with a mix 
>> of qlogic/mellanox cards, connected via an QLogic 12300 switch. All of 
>> the nodes are running on 4x 10Gbps. When I run  a performance test and 
>> the mellanox card is a server i.e it is receiving data I get very bad 
>> performance. By this I mean I cannot get more than 4 gigabits per 
>> second - very low. 'perf top' clearly shows that the culprit is 
>> intel_map_page which is being called form the receive path 
>> of the mellanox adapter: 
>>
>> 84.26%     0.04%  ksoftirqd/0  [kernel.kallsyms]  [k] intel_map_page                            
>>             |
>>             --- intel_map_page
>>                |          
>>                |--98.38%-- ipoib_cm_alloc_rx_skb
> 
> Are you *sure* it's disabled? Can you be more specific about where the
> time is spent? intel_map_page() doesn't really do much except calling
> in to __intel_map_single()... which should return fairly much
> immediately.

Oops, turned out I had intel_iommu=on, though I'm sure some days ago I
didn't and performance suffered. I now tried with this option removed
and performance is again back to normal. All in all this driver +
intel_iommu is a bad combination I guess. Anyway, sorry for the noise
and thanks for the prompt reply.


Regards,
Nikolay
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
