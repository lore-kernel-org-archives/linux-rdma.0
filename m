From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: how to preserve QP over HA events for librdmacm applications
Date: Thu, 20 Sep 2012 14:18:20 -0400
Message-ID: <168EBAAE-9D89-4F47-9B4D-347256DADEB1@ornl.gov>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
 <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com>
 <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov>
 <505B5470.9030707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <505B5470.9030707-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sep 20, 2012, at 1:37 PM, Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> On 09/19/2012 11:14 AM, Atchley, Scott wrote:
>> On Sep 19, 2012, at 1:05 PM, "Hefty, Sean"<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>  wrote:
>> 
>>>> I too would be interested in bringing a QP from error back to a usable state. I
>>>> have been debating whether to reconnect using the current RDMA calls versus
>>>> trying to transition the existing RC QP.
>>>> 
>>>> I assumed to transition the existing QP that I would need to open a socket to
>>>> coordinate the two sides. Is that correct?
>>>> 
>>>> If I were instead to use rdma_connect(), does it require a new CM id or just a
>>>> new QP within the same id?
> 
> What if you say pre-created a second (fail over) QP for HA purposes all 
> under the covers of a single socket? And both QPs were connected before 
> the failure. Not sure if that would work with the same CM id though. If 
> not, we will need to rdma_connect() the second QP after failure.
> 
> By having a second QP and bound to say a different port/device, one 
> could survive not just link up/down events, but device failures too. 
> Would that be more generic?

Hi Pradeep,

What is the memory cost of a QP? I assume it will require a second CM id as well.

Involving a second device and/or port is not an option for my usage.

Scott--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
