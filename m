From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v7 00/23] IB/Verbs: IB Management Helpers
Date: Thu, 30 Apr 2015 08:40:20 +0300
Message-ID: <5541C044.7090800@mellanox.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
 <1430324895.102408.23.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430324895.102408.23.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/29/2015 7:28 PM, Doug Ledford wrote:
> On Tue, 2015-04-28 at 17:10 +0200, Michael Wang wrote:
>> >Since v6:
>> >   * Thanks to Ira, Devesh for the review and testing:-)
>> >   * Thanks for the comments from Sean, Tom, Jason, Doug, Devesh, Ira,
>> >     Liran:-)  Please remind me if anything missed:-P
>> >   * Use query_protocol() and enum protocol type in 1#
>> >   * Use rdma_protocol_XX() in 2#
>> >   * Drop cma_set_legacy_transport()
>> >   * Reserve rdma_ib_or_iboe() and rdma_node_get_transport()
>> >   * Updated github repository to v7
> I've taken your patchset and threw it into a for-4.2 branch in my repo.
> This will get it 0day testing.  I've also pulled it into my test cluster
> and done minimal testing (bootup, finds devices, gets IP address via dhcp).

Doug,

As I wrote to Michael, this series carries way (way) over Cc: pointers 
in each it's commits. We have never had something like this since this 
stack was formed 10y ago and accepted into 2.6.12 --- and I didn't hear 
any good reason for why doing so (see the thread  for "[PATCH v7 04/23] 
IB/Verbs: Reform IB-core cm") -- can you please provide your opinion on 
the matter?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
