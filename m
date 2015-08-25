From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 00/10] Add RoCE support to the mlx5 driver
Date: Tue, 25 Aug 2015 16:06:34 +0300
Message-ID: <55DC685A.8060402@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
 <55DB8152.6080402@talpey.com> <55DC28C2.4020705@mellanox.com>
 <55DC6040.5080907@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55DC6040.5080907-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/25/2015 3:32 PM, Tom Talpey wrote:
> On 8/25/2015 4:35 AM, Achiad Shochat wrote:
>> On 8/24/2015 11:40 PM, Tom Talpey wrote:
>>> On 8/20/2015 12:46 PM, Achiad Shochat wrote:
>>>> Hi Doug,
>>>>
>>>> This patchset adds RoCE V1 and RoCE V2 support to the mlx5 device
>>>> driver.
>>>
>>> Question - assuming I read them correctly, these patches add the
>>> RoCE v1 and RoCE v2 support on a per-port basis. That is, a port
>>> can be either IB, RoCE v1 or RoCE v2, but not a combination.
>>>
>>> Has any thought been put toward supporting these protocols on a
>>> per-QP basis, i.e. the caller of rdma_connect() can specify the
>>> desired protocol? Or to have some sort of discovery?
>>>
>>> I know that there may be implementation restrictions on today's
>>> devices, but it's my personal belief that future devices will
>>> support multiple protocols (perhaps beyond the three above), and
>>> laying the groundwork for this today will be important.
>>>
>>> Tom.
>>>
>
>>
>> RoCE v1 and RoCE v2 are supported on a per-GID basis, not sure what got
>> you to understand it is per-port.
>
> Because the protocol capabilities were being marked at the ib_device
> level. Ok, it's good that the protocol is per-endpoint.
>
> But I don't understand how it will work per-GID. What if the target
> node is RoCEv2 and on another subnet? How will it discover the remote's
> capability and establish the right protocol? How does the initiator
> select the protocol, if there is a choice?
>
> Another way of asking this question is, why is all this stuff in the
> driver, at the bottom of the stack? I think it should be in the
> rdmacm layer.
>
> Tom.
>

Selection of the RoCE version to be used per connection and discovering 
the RoCE versions supported by the target is up to the application.

It is not done by the driver of course, neither by the kernel stack.

The driver only exposes add/del_gid callbacks, used by the ib_core to 
configure the device GID table entries (including RoCE version per 
entry) based on netdev IPs configured in the system.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
