From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH RFC] IB/verbs: introduce rdma_transport_is_ib() to check
 transport type
Date: Thu, 19 Mar 2015 18:29:36 +0100
Message-ID: <550B0780.9040406@profitbricks.com>
References: <550AD2D6.7030800@profitbricks.com> <1828884A29C6694DAF28B7E6B8A8237399E821EA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E821EA@ORSMSX109.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, "Weiny, Ira" <ira.weiny@intel.com>, Moni Shoua <monis@mellanox.com>, "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>, Steve Wise <swise@opengridcomputing.com>, Yan Burman <yanb@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, Yann Droneaud <ydroneaud@opteya.com>, "David S. Miller" <davem@davemloft.net>, "Estrin, Alex" <alex.estrin@intel.com>, Doug Ledford <dledford@redhat.com>, Eric Dumazet <edumazet@google.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Eli Cohen <eli@dev.mellanox.co.il>, Matan Barak <matanb@mellanox.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

Hi, Sean

Thanks for point it out for me :-)

I'll try to follow the conversation to understand what
really needs to be done, see if I could do some
contribution on it.

Regards,
Michael Wang

On 03/19/2015 06:02 PM, Hefty, Sean wrote:
>> We have plenty of places where we don't care what exactly the
>> transport type is, but only care if it's IB type.
>>
>> This patch introduce rdma_transport_is_ib() as shortcuts to check
>> whether an 'ib_device' is infiniband transport type, which help us to
>> save some code.
> In most of these places, the check that we want is whether IB management is used.  The transport check is an indirect way of checking for that, and I believe we should use a more direct method of checking for the functionality that's actually desired.
>
> Please see the following thread that is related to these changes:
>
> http://www.spinics.net/lists/linux-rdma/msg23484.html
>
> - Sean
