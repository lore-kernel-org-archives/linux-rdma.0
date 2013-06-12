From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 12 Jun 2013 21:10:57 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6808D7@xmb-rcd-x01.cisco.com>
References: <51AF3FA8.7000900@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D5D3@xmb-rcd-x01.cisco.com>
 <20130605171426.GC30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DC0D@xmb-rcd-x01.cisco.com>
 <20130605181853.GB1946@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DF6F@xmb-rcd-x01.cisco.com>
 <20130605190529.GA3044@obsidianresearch.com> <51B023B9.9050000@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66B79C@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F66E403@xmb-rcd-x01.cisco.com>
 <20130607235731.GA25942@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F676E59@xmb-rcd-x01.cisco.com>
 <D554B471892C914E90E136467281724DAD695B50@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D554B471892C914E90E136467281724DAD695B50-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Content-Language: en-US
Content-ID: <6FBFBBEC9C6AD64C89A6D27A4952DFF4-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 10, 2013, at 11:56 AM, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>> "Register all address space" is the moral equivalent of not having userspace
>> registration, so let's talk about it in those terms.  Specifically, there's a subtle
>> difference between:
>> 
>> a) telling verbs to register (0...2^64)
>>   --> Which is weird because it tells verbs to register memory that isn't in my
>> address space
> 
> Another way to look at it is "specify IO access permissions" for address space ranges.
> This could be useful to implement a buffer pool to be used for a specific MR only, yet still map/unmap memory within this pool on the fly to optimize physical memory utilization.
> In this case, you would provide smaller ranges than 2^64...


Hmm; I'm not sure I understand.

Userspace doesn't control what virtual addresses it gets back from mmap/etc.  So how is what you're talking about different than regular/reactive memory registration? (vs. pre-emptively registering a whole pile of memory that doesn't exist yet)

Specifically: I'm confused because you said you could (preemptively) register some small regions (that assumedly don't yet exist in your virtual memory address space) and use them as memory pools.  But given that userspace doesn't control its virtual address ranges, I'm not sure how that's useful.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
