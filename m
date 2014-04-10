From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Rare Duplicate Completions
Date: Thu, 10 Apr 2014 17:43:02 -0400
Message-ID: <CAPb9-SGvewhDLzuNCB3jNAaxO4OFq7_Pbtp5rE7rnJ5k_x1u5g@mail.gmail.com>
References: <CAPb9-SF6OS3xabKMJdT2Fe32=O1nOhS5y3Ng3ySQG3KOHvcV=Q@mail.gmail.com>
	<53434A7A.7000504@acm.org>
	<CAPb9-SEvrWWxWbjSDz5iVP16aRTbDd4tg-TN_af0ecB0o3m1Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SEvrWWxWbjSDz5iVP16aRTbDd4tg-TN_af0ecB0o3m1Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bert,

Thanks for the help. Unfortunately, it looks as if all of my
message-passing and RDMA operations use the SIGNALED flag. I'm
checking the  wc->status flag (==IBV_WC_SUCCESS), and it and
everything in the message appears to be completely identical to the
first completion. I notice that it only seems to happen when I have
server processes (ie, listeners) that also open active connections to
other listeners as well as accept connections from client processes. I
perform both RDMA and message-passing across those server-to-server
connections, so on a hunch I tried rewriting the RDMA operations as
message-passing, but the problem still occurs. Thanks in advance for
any other thoughts you might have.

Cheers,
Christopher

On Thu, Apr 10, 2014 at 5:42 PM, Christopher Mitchell
<christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org> wrote:
> Bert,
>
> Thanks for the help. Unfortunately, it looks as if all of my message-passing
> and RDMA operations use the SIGNALED flag. I'm checking the  wc->status flag
> (==IBV_WC_SUCCESS), and it and everything in the message appears to be
> completely identical to the first completion. I notice that it only seems to
> happen when I have server processes (ie, listeners) that also open active
> connections to other listeners as well as accept connections from client
> processes. I perform both RDMA and message-passing across those
> server-to-server connections, so on a hunch I tried rewriting the RDMA
> operations as message-passing, but the problem still occurs. Thanks in
> advance for any other thoughts you might have.
>
> Cheers,
> Christopher
>
>
> On Mon, Apr 7, 2014 at 9:01 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>>
>> On 4/04/2014 10:00, Christopher Mitchell wrote:
>>>
>>> I am working on building a distributed Infiniband application, testing
>>> using Mellanox Connect-X HCAs. In very rare cases, perhaps once in a
>>> few million operations, I appear to be receiving duplicate completions
>>> or incorrect completions. For instance, I'll send out an RDMA request
>>> and receive a completion for a Verb message response I had just
>>> handled, or send a Verb message request and receive a duplicate Verb
>>> message completion.. Needless to say, this is introducing instability
>>> in my application. Does anyone have experience with a bug like this,
>>> or am I encountering some arcane issue in how I'm manipulating the
>>> HCA? I'd be more than happy to furnish relevant sections of code to
>>> help nail down the issue.
>>
>>
>> Hello Christopher,
>>
>> In e.g. the SCST SRP target driver there is code present that checks for
>> duplicate and/or missing completions. Although this code is being used
>> intensively I have not yet seen any error messages being logged by the code
>> that verifies completions. Note: something that is nontrivial in the RDMA
>> API and that you might already be aware of is that even for non-signaled
>> work requests a completion is delivered if that work request fails. If these
>> non-signaled work requests do not have a unique wr_id error completions for
>> these requests might be misinterpret as duplicate completions.
>>
>> Bart.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
