From: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/12] selinux: Implement Infiniband flush callback
Date: Thu, 30 Jun 2016 16:24:25 -0400
Message-ID: <CAGH-Kgs=YrCWegD9H8r4WjCPMZpaqVRDiWAFP2C0bFegS7vgbA@mail.gmail.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-4-git-send-email-danielj@mellanox.com> <20160630151005.GC22107@yuval-lap.uk.oracle.com>
 <AM4PR0501MB22578AA5FF8B4062F650C581C4240@AM4PR0501MB2257.eurprd05.prod.outlook.com>
 <CAGH-Kgtn0EFxYc+UOvVQk-0Bco0oOG=STZA+aGYza4TmbNXq3A@mail.gmail.com> <13cf2b8b-1d4e-e61f-80fe-110af2a719cf@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13cf2b8b-1d4e-e61f-80fe-110af2a719cf-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 4:16 PM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
> On 6/30/2016 12:52 PM, Paul Moore wrote:
>> On Thu, Jun 30, 2016 at 11:44 AM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>> On 6/30/2016 10:10 AM, Yuval Shaia wrote:
>>>> On Thu, Jun 23, 2016 at 10:52:49PM +0300, Dan Jurgens wrote:
>>>>
>>>>> +static void (*ib_flush_callback)(void);
>>>> Do we really want to have such ib_ prefix in security/ directory?
>>>>
>>>>> +            if (ib_flush_callback)
>>>>> +                    ib_flush_callback();
>>>> How about some generic mechanism (such as a list) in case more
>>>> modules/drivers would like to register callbacks?
>>>> ( assuming this is no longer RFC :) )
>>>>
>>> Paul Moore and I were having a higher level discussion about this in the 00/12 thread.  I think your suggestion makes sense, perhaps Paul will weigh in when he reaches this patch.
>> I'm still working on understanding IB, but my current thinking is very
>> similar to Yuval's suggestions.  There is a risk of creating a general
>> purpose mechanism to solve a specific, isolated problem, but adding a
>> LSM notification mechanism does seem like a reasonable thing to do.
>>
>> My current thinking is to have the LSM framework itself, e.g.
>> security/security.c, maintain a list of callbacks (BTW, please make it
>> a RCU protected list) with other non-LSM subsystems registering
>> callbacks, and specific LSMs making notification calls into the LSM
>> framework itself which would handle iterating through the registered
>> callbacks.  Since we're going down the general purpose solution route,
>> I might add an event field and a void pointer to the callback, for
>> example:
>>
>>   void lsm_notifier_callback(unsigned int event, void *ptr);
>>
>> ... I would expect at first we would only have a POLICY_CHANGE event
>> (ptr set to NULL), but we may want/need to add other events in the
>> future.
>>
>> Make sense?
>
> Hmm. Do you think that we'd want to rewhack the audit code
> so that it used this new, general mechanism for its callbacks?

You aren't talking about the callbacks in common_lsm_audit() are you?
I think that's a completely different beast from a LSM notifier
callback.  I'm not opposed to changes to common_lsm_audit(), but I
think that's a different topic and a different thread.

-- 
paul moore
security @ redhat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
