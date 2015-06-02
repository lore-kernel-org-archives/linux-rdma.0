From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 2 Jun 2015 17:44:55 +0300
Message-ID: <556DC167.5070205@mellanox.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433255724.114391.225.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/2/2015 5:35 PM, Doug Ledford wrote:
> On Mon, 2015-06-01 at 10:43 -0600, Jason Gunthorpe wrote:
>> On Mon, Jun 01, 2015 at 07:25:04AM -0400, Doug Ledford wrote:
>>
>>> attempted abstraction of ibverbs.  Passing in the wc struct allows the
>>> driver to internally allocate a wc struct with extra private elements
>>> and pass that back to the user, when the user passes it back to
>>> ibv_get_timestamp the elements are there in the private portion of the
>>> struct.
>> wc structures are allocated by the caller, there is no option for the
>> driver to create private elements.
> Well, they *are* using an extended work completion structure.  Unlike
> what I mentioned, where they create a larger one themselves, you have to
> allocate a struct ibv_wc_ex instead of a struct ibv_wc and then you have
> to call poll_cq_ex, which expects a struct ibv_wc_ex.
>
> So, just so everyone is clear on this point: the current user space
> implementation of this feature creates an unversioned, newly named
> ibv_wc_ex struct that is ibv_wc with a 64bit timestamp tacked on at the
> end (not 64bit aligned either).  If we ever wanted to have a different
> extension to our ibv_wc struct, there is no good way to do that.  If, at
> some point, we had multiple extension and the user was able to select
> which they wanted to utilize, this structure extension is not flexible
> enough to deal with that.  At a minimum, if we are going to have a one
> shot extension to the wc struct like this, I would prefer to see it
> called struct ibv_wc_timestamp and there be a ibv_poll_cq_timestamp.  At
> least that way people would not use the generic _ex and assume this is
> the one and only _ex that we will ever need for work completions.
>
> Jason, when the XRC and flow steering extensions were added to
> libibverbs, you complained loudly that they were not added in the agreed
> upon format and cited a previous on list discussion.  Do you have a link
> to that discussion?

Doug,

Do we agree that this part of the discussion (and also the below point) 
are related to the libibverbs API to applications and not to the kernel 
-> user API to support time-stamping?

Or.

>
>> AFAIK, Christoph's use case is essentially the only meaningful use
>> case for this feature, generalizing too much may destroy the
>> performance that is valuable here.
> There is actually room in a 64byte cacheline for two 64bit timestamps
> and another 2 bytes of padding or something else.
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
