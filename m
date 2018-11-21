From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH iproute2-next v3] rdma: Document IB device renaming option
Date: Wed, 21 Nov 2018 08:59:31 -0500
Message-ID: <591a18e0-0057-0b7e-032f-3357f9566b36@intel.com>
References: <20181104191122.11979-1-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE61B8E2@FMSMSX108.amr.corp.intel.com>
 <20181118110535.GJ24359@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181118110535.GJ24359@mtr-leonro.mtl.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc: David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 11/18/2018 6:05 AM, Leon Romanovsky wrote:
> On Fri, Nov 16, 2018 at 08:10:35PM +0000, Ruhl, Michael J wrote:
>>> -----Original Message-----
>>> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
>>> owner@vger.kernel.org] On Behalf Of Leon Romanovsky
>>> Sent: Sunday, November 4, 2018 2:11 PM
>>> To: David Ahern <dsahern@gmail.com>
>>> Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
>>> <netdev@vger.kernel.org>; RDMA mailing list <linux-rdma@vger.kernel.org>;
>>> Stephen Hemminger <stephen@networkplumber.org>
>>> Subject: [PATCH iproute2-next v3] rdma: Document IB device renaming
>>> option
>>>
>>> From: Leon Romanovsky <leonro@mellanox.com>
>>
>> Hi Leon,
>>
>> After looking at this and Steve Wise's changes for the ADDLINK/DELLINK,
>> it occurred to me that the driver that handed the name to ib_register_device()
>> might be interested in knowing that this name change occurred.
>>
>> Are there plans to include a some kind of notify mechanism so drivers can
>> find out when things like this occur?
> 
> At least for device rename, I don't see any real need for such event,
> because drivers are not supposed to rely on names.

It just seems like something they want to know. But agree driver should 
not rely on a name.

> I would say that it is probably driver bug to rely on device name
> during its execution.
> 
>>
>> Is this something that should be done?
> 
> I think yes, we can extend ib_event to support more events than now,
> but should we?

On one hand it make sense to have an event. In case the driver had 
something it wanted to do with the name but I can't really think of a 
compelling reason it does. So I'd say we don't worry about it now but if 
someone finds a use for it then adding it later should be an option that 
is on the table.

-Denny
