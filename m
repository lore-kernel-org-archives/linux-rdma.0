From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [Suspected SPAM] Re: [RFC PATCH 2/4] uverbs: Add common	ib_iomem_get
 service
Date: Thu, 29 Jul 2010 21:16:26 -0500
Message-ID: <4C5235FA.2080001@opengridcomputing.com>
References: <20100729162339.14674.15788.stgit@build.ogc.int> <20100729162509.14674.34237.stgit@build.ogc.int> <1280427723.6820.56.camel@chromite.mv.qlogic.com> <4C51D15F.8060708@opengridcomputing.com> <20100729201317.GA7920@obsidianresearch.com> <20100729204150.GC7920@obsidianresearch.com> <1280443789.6820.153.camel@chromite.mv.qlogic.com> <20100729225705.GC26390@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729225705.GC26390-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org" <brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "swise-/Yg/VP3ZvrM@public.gmane.org" <swise-/Yg/VP3ZvrM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/29/10 5:57 PM, Jason Gunthorpe wrote:
>> You would need to modify ib_umem_get() to check for the VM_PFNMAP
>> flag and build the struct ib_umem similar to the proposed
>> ib_iomem_get(). However, the page reference counting/sharing issue
>> would need to be solved. I think there are kernel level callbacks
>> for this that could be used.
>>      
> But in this case the pages are already mmaped into a user process,
> there must be some mechanism to ensure they don't get pulled away?!
>
>    
This is not virtual memory. It's real memory.

> Though, I guess, what happens if you hot un-plug the PCI-E card that
> has a process mmaping its memory?!
>
>    
Exactly. The memory would have to be physically detached for it to get 
'pulled away'

> What happens if you RDMA READ from PCI-E address space that does not
> have any device responding?
>
>    

bus error.

> Jason
>    

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
