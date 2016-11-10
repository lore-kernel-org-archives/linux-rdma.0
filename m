From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Thu, 10 Nov 2016 10:07:53 -0600
Message-ID: <334be0e0-e593-8529-9d78-202c21113208@mellanox.com>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
 <20161109064009.GE27883@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7F0A@ORSMSX109.amr.corp.intel.com>
 <20161110072242.GC28957@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161110072242.GC28957-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/10/2016 1:22 AM, Leon Romanovsky wrote:
> On Wed, Nov 09, 2016 at 05:06:52PM +0000, Hefty, Sean wrote:
>>> On Tue, Nov 08, 2016 at 05:49:26PM +0000, Hefty, Sean wrote:
>>>>> When sending from a 10G host to a 1G host, it is easy to overrun
>>> the
>>>>> receiver,
>>>>> leading to packet loss and traffic backing off. Similar problems
>>> occur
>>>>> when
>>>>> a 10G host sends data to a sub-10G virtual circuit, or a 40G host
>>>>> sending
>>>>> to a 10G host. Packet pacing could control packet injection rate
>>> and
>>>>> reduces
>>>>> network congestion to maximize throughput & minimize network
>>> latency.
>>>> Why isn't the path record data and existing mechanisms sufficient to
>>> handle this?
>>> Packet pacing allows different combinations of traffic shaping: per-
>>> CPU,
>>> per-flow and their combinations with better and steady QoS requirements
>>> without involving subnet management.
>> The patch adds this as a QP attribute, and we already have a rate for that.  I still don't see why the standard mechanisms are insufficient or couldn't be adapted.
> I'll let to Bodong to elaborate on it more, but as far as I see, the AH
> attribute is relevant to UD QP only, while the packet pacing is intended
> for all types of QPs.
>
> Thanks
While the path record data can prevent the overrun but cannot control 
the rate speed easily within the hardware limitation range. One main use 
case for packet pacing is for streaming vendors to control the speed for 
different customers based on service coverage. For example, user's NIC 
supports 10G speed but only pays for 1G speed service, packet pacing can 
achieve this purpose only by modify_qp.

Another advantage, packet pacing doesn't need to involve with subnet 
admin which path record data has to. Moreover, like indicated in the 
other thread, the main flaw of the static rate is its limitations on the 
speed options.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
