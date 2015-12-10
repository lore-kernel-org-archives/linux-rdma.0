From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/37] IB/rdmavt: Add ib core device attributes to rvt driver params list
Date: Thu, 10 Dec 2015 10:22:52 -0500
Message-ID: <20151210152251.GE11526@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204314.8144.46170.stgit@phlsvslse11.ph.intel.com> <56696F63.90707@mellanox.com> <20151210132523.GB11526@phlsvsds.ph.intel.com> <56699674.3030900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56699674.3030900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 05:12:52PM +0200, Haggai Eran wrote:
>On 10/12/2015 15:25, Dennis Dalessandro wrote:
>> On Thu, Dec 10, 2015 at 02:26:11PM +0200, Haggai Eran wrote:
>>> On 07/12/2015 22:43, Dennis Dalessandro wrote:
>>>> +    /*
>>>> +     * Drivers will need to support a number of notifications to rvt in
>>>> +     * accordance with certain events. This structure should contain
>>>> a mask
>>>> +     * of the supported events. Such events that the rvt may need to
>>>> know
>>>> +     * about include:
>>>> +     * port errors
>>>> +     * port active
>>>> +     * lid change
>>>> +     * sm change
>>>> +     * client reregister
>>>> +     * pkey change
>>> Where are the event values defined?
>> 
>> They aren't really yet. A lot of the comments like this were put in and
>> made available on GitHub for an early look into the design. This will
>> all get cleaned up as the code continues to come together.
>Okay, Great. Since the events above are already defined as
>ib_event/ib_event_type maybe you can reuse them somehow.

Yeah, I don't think there is a need to redefine this.

>>>>> +     *
>>>> +     * There may also be other events that the rvt layers needs to know
>>>> +     * about this is not an exhaustive list. Some events though rvt
>>>> does not
>>>> +     * need to rely on the driver for such as completion queue error.
>>>> +     */
>>>> +     int rvt_signal_supported;
>>>
>>> What will rvt do if it learns that the device doesn't support some of
>>> the events?
>> 
>> Good question. I don't really have a great answer right now. Mostly it
>> sort of depends on what events we end up. If it's something critical
>> rdmavt will have to check during the registration and fail the call.
>> This is not yet implemented in the two patch sets posted.
>I'm not sure that's needed. If the driver doesn't satisfy what rvt
>expects from it they can break in many ways. I'm not sure this specific
>instance requires a check during registration. But it really depends on
>the specific drivers and the specific events we're going to have.

Basically if the driver is just not going to function because it doesn't 
provide something, that's probably not such a big deal. If it can lead to a 
kernel panic then we probably want to validate. In the end, yes, it just all 
depends on what we end up with.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
