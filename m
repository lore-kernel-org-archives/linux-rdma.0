From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib()
Date: Thu, 23 Apr 2015 11:31:13 +0200
Message-ID: <5538BBE1.6060400@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <5534BBC2.4010902@profitbricks.com> <20150422054058.GB29609@obsidianresearch.com> <553760A8.2090802@profitbricks.com> <20150422164512.GC1494@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422164512.GC1494@phlsvsds.ph.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 06:45 PM, ira.weiny wrote:
> On Wed, Apr 22, 2015 at 10:49:44AM +0200, Michael Wang wrote:
>>
>> On 04/22/2015 07:40 AM, Jason Gunthorpe wrote:
>>> On Mon, Apr 20, 2015 at 10:41:38AM +0200, Michael Wang wrote:
>>>  
>>>> Introduce helper cap_ipoib() to help us check if the port of an
>>>> IB device support IP over Infiniband.
>>>
>>> I thought we were dropping this in favor of listing the actual
>>> features the ULP required unconditionally? One of my messages had the
>>> start of a list..
> 
> ???  I forget.  I was arguing that we should not have it.  But I thought others
> disagreed with me so it was left in.
> 
> V4 of this patch had no responses.
> 
> https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg24040.html
> 
> Jason, I can't find the email where you mentioned a list?

I don't see a list too :-P but agreed the ULP reform idea, the check should be

ipoib_init()
{
	if (device don't suport SA or IB CM or...)
		return error;
	...
}

So I'll put the reform to that series.

Regards,
Michael Wang

> 
> Ira
> 
