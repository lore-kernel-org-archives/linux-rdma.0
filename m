From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Rare Duplicate Completions
Date: Mon, 07 Apr 2014 18:01:46 -0700
Message-ID: <53434A7A.7000504@acm.org>
References: <CAPb9-SF6OS3xabKMJdT2Fe32=O1nOhS5y3Ng3ySQG3KOHvcV=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPb9-SF6OS3xabKMJdT2Fe32=O1nOhS5y3Ng3ySQG3KOHvcV=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/04/2014 10:00, Christopher Mitchell wrote:
> I am working on building a distributed Infiniband application, testing
> using Mellanox Connect-X HCAs. In very rare cases, perhaps once in a
> few million operations, I appear to be receiving duplicate completions
> or incorrect completions. For instance, I'll send out an RDMA request
> and receive a completion for a Verb message response I had just
> handled, or send a Verb message request and receive a duplicate Verb
> message completion.. Needless to say, this is introducing instability
> in my application. Does anyone have experience with a bug like this,
> or am I encountering some arcane issue in how I'm manipulating the
> HCA? I'd be more than happy to furnish relevant sections of code to
> help nail down the issue.

Hello Christopher,

In e.g. the SCST SRP target driver there is code present that checks for 
duplicate and/or missing completions. Although this code is being used 
intensively I have not yet seen any error messages being logged by the 
code that verifies completions. Note: something that is nontrivial in 
the RDMA API and that you might already be aware of is that even for 
non-signaled work requests a completion is delivered if that work 
request fails. If these non-signaled work requests do not have a unique 
wr_id error completions for these requests might be misinterpret as 
duplicate completions.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
