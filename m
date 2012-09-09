From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC for-next] net/mlx4_core: Fix racy flow in the driver
 CQ completion handler
Date: Sun, 9 Sep 2012 17:08:45 +0300
Message-ID: <CAJZOPZK6r5rG-6Y98R_QkB-hWVf4ecp8dwCHuLkFf+cWr-pkoQ@mail.gmail.com>
References: <20549.47088.805176.786765@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20549.47088.805176.786765-AFFH1GffN5hPR4JQBCEnsQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 4, 2012 at 11:12 AM, Max Matveev <makc-puGfsi27rH1aa/9Udqfwiw@public.gmane.org> wrote:
>
> On Thu, Aug 30, 2012 at 22:35 PM Roland Dreier wrote:
>
>> On Thu, Aug 30, 2012 at 3:17 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  wrote:
>>>
>>>> Can you be explicit about the race you're worried about?
>>>
>>> few
>>>
>>> 1. on the  time CQ A is deleted an interrupt that relates to CQ B
>>> takes place and a radix
>>> tree lookup is running while an element is being deleted from the
>>> tree, looking on the radix tree API, I don't see that this is
>>> allowed.
>>
>> I don't think this is a real problem; the radix tree code is
>> explicitly designed for RCU use, and the data structure is pretty
>> clearly safe for looking up one slot while another slot is being
>> cleared.  In fact it's hard to see how this could screw up.
>
> What about races between radix_tree_extend and radix_tree_lookup?
>
> As far as I can see (even on newer kernels with rcu support) there is
> nothing which protects changes to node->height and it is used to
> decide how deep lookup must go to find the actual data.


Max,

I'm putting your response on linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as it was
wrongly sent to linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org ...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
