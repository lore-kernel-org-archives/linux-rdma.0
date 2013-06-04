From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Tue, 4 Jun 2013 20:13:06 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com>
 <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ADD489.3020902-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <522F25E30966274CBA00074B6D85E80B-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 4, 2013, at 4:50 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>> Does this mean that an MPI implementation still has to register memory upon usage, and maintain its own registered memory cache?
> Yes. However, since registration doesn't pin memory, you can leave
> registered memory regions in the cache for longer periods, and you can
> register larger memory regions without needing to back them with
> physical memory.

Hmm; I'm confused.  How does this fix the MPI-needs-to-intercept-freed-memory problem?

>> 
>>> We chose to support only 2 concurrent page faults per QP since this
>>> allows us to maintain order between the QP's operations and the
>>> user-space code using it.
>> 
>> 
>> I talked to someone who was at the OpenFabrics workshop and saw the ODP presentation in person; he tells me that a fault will be incurred when a page is not in the HCA's TLB cache (vs. when a registered page is not in memory and must be swapped back in), and that this will trigger an RNR NAK.
>> 
>> Is this correct?
> 
> Our HCAs use their own page tables, in addition to a TLB cache. A miss
> in the TLB cache that can be filled from the HCA's page tables will not
> cause an RNR NAK, since the HCA can fill it relatively fast without the
> help of the operating system. If the page is missing from the HCA's page
> table though it will trigger a page fault and ask the OS to bring that
> page. Since this might take longer, in these cases we send an RNR NAK.

Ok.

But the primary use case I care about is fixing the MPI-needs-to-intercept-freed-memory problem, and it doesn't sounds like ODP fixes this.

>> He was very concerned about what the size of the TLB on the HCA, and therefore what the actual run-time behavior would be for sending around large messages via MPI -- i.e., would RDMA'ing 1GB messages now incur this HCA-must-reload-its-TLB-and-therefore-incur-RNR-NAKs behavior?
>> 
> We have a mechanism to prefetch the pages needed for a large message
> upon the first page fault, which can also help amortizing the cost of
> the page fault for larger messages.


Ok, thanks.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
