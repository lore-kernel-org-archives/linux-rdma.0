From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 00/10] Add RoCE support to the mlx5 driver
Date: Wed, 26 Aug 2015 08:31:35 +0300
Message-ID: <55DD4F37.4020306@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
 <55DB8152.6080402@talpey.com> <55DC28C2.4020705@mellanox.com>
 <55DC6040.5080907@talpey.com> <55DC685A.8060402@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55DC685A.8060402-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 25/08/2015 16:06, Achiad Shochat wrote:
> On 8/25/2015 3:32 PM, Tom Talpey wrote:
>> But I don't understand how it will work per-GID. What if the target
>> node is RoCEv2 and on another subnet? How will it discover the remote's
>> capability and establish the right protocol? How does the initiator
>> select the protocol, if there is a choice?
>>
>> Another way of asking this question is, why is all this stuff in the
>> driver, at the bottom of the stack? I think it should be in the
>> rdmacm layer.
>>
>> Tom.
>>
> 
> Selection of the RoCE version to be used per connection and discovering
> the RoCE versions supported by the target is up to the application.
> 
> It is not done by the driver of course, neither by the kernel stack.
> 
> The driver only exposes add/del_gid callbacks, used by the ib_core to
> configure the device GID table entries (including RoCE version per
> entry) based on netdev IPs configured in the system.

Let me add that when using RDMA CM, it is in charge of choosing the gid
index for a connection, and needs to be aware of the different
protocols. The patchset that includes the core changes for RoCE v2 [1]
allows configuring the preferred protocol for each port. There is also a
heuristic that selects RoCE v2 (which is routable) when the address
resolution detects more than one hop to the destination.

Regards,
Haggai

[1] http://www.spinics.net/lists/linux-rdma/msg28120.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
