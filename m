From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state for
 multicast
Date: Fri, 29 Apr 2016 12:27:30 -0400
Message-ID: <c99ef08a-77d8-1524-042a-0f269a52028d@dev.mellanox.co.il>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
 <20160427064239.GO7974@leon.nu> <5722C839.2070704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5722C839.2070704-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/28/2016 10:34 PM, Doug Ledford wrote:
> On 04/27/2016 02:42 AM, Leon Romanovsky wrote:
>> On Tue, Apr 26, 2016 at 08:57:08PM +0000, Hefty, Sean wrote:
>>>>> +* There are 4 types of join states:
>>>>> +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
>>>>> +*/
>>>>> +enum {
>>>>> +	FULLMEMBER_JOIN,
>>>>> +	NONMEMBER_JOIN,
>>>>> +	SENDONLY_NONMEBER_JOIN,
>>>>> +	SENDONLY_FULLMEMBER_JOIN,
>>>>> +	NUM_JOIN_MEMBERSHIP_TYPES = 4
>>>
>>> These seem better suited as flags -- fullmember (y/n), sendonly (y/n) 
>>
>> Thanks, excellent point.
> 
> This doesn't seem to make any sense to me.  Without going back and
> re-reading this part of the spec, as I recall, there is:
> 
> UnJoined
> SendOnly Join
> Full Join
> 
> You can never have a SendOnly_FullMember join.  Once you are FullMember,
> you are no longer SendOnly.
> 
> Is a NonMember (assuming here that NonMember is referring to what the CA
> is listed as according to the SM) even allowed to join, either as
> SendOnly or FullMember?  I would have thought if the SM listed that CA
> as a NonMember, that any joins would be flat rejected and NonMember join
> states wouldn't make any sense.

There is now a new SendOnlyFullMember option added by IBTA MgtWG post
IBA 1.3.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
