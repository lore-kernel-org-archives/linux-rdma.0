From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_state_mgr.c: Don't rely on PortInfo:PortState
 for base SP0
Date: Thu, 21 Apr 2011 08:48:26 -0400
Message-ID: <4DB0279A.2070000@dev.mellanox.co.il>
References: <4DAC3CCC.4090101@dev.mellanox.co.il> <20110420141713.GD28761@calypso.voltaire.com> <4DAEF103.1000706@dev.mellanox.co.il> <20110421122243.GA2137@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110421122243.GA2137-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/21/2011 8:22 AM, Alex Netes wrote:
> On 10:43 Wed 20 Apr     , Hal Rosenstock wrote:
>> Hi Alex,
>>
>> On 4/20/2011 10:17 AM, Alex Netes wrote:
>>> Hi Hal,
>>>
>>> On 09:29 Mon 18 Apr     , Hal Rosenstock wrote:
>>>>
>>>> For base SP0, PortState in SM PortInfo attribute is not used and base SP0
>>>> is always "active". 
>>>
>>> How SM can be attached to base SP0?
>>
>> What precludes this ? AFAIK SM can run on any switch port 0 whether
>> enhanced or base.
>>
> 
> I'm probably missing something. Base Switch Port 0 - A Switch Port 0 which is
> not an Endport (IBTA p71). 

The glossary is only informative (and not compliance) and has a number
of such issues.

You can see that the Endport definition on p.73 contradicts this:
"All Channel Adapter ports on the subnet are
endports of that subnet, as is Port 0 of each Switch in the subnet.
Switch ports other than Port 0 may not be endports."

A spec comment (RefID 4352) was entered quite some time ago on this to
change this to something like:

A <Switch Port 0> with a set of basic capabilities (defined in this
specification). That set is less than the capabilities of an <Enhanced
Switch Port 0>, and also less than the minimum set of capabilities
required of a <Target Channel Adapter>.

> If you look further, Endport defined as a Port which can be a destination of 
> LID-routed communication within the same Subnet as the sender.

Actually this is imprecise as well as the phrase "within the same Subnet
as the sender" should be eliminated.

> How can SM be attached to a port which isn't an Endport?

Base SP0 does have a LID (look at PortInfo:LID Used By column is X'd).

-- Hal

> -- Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
