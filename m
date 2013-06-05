From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 16:39:52 +0300
Message-ID: <51AF3FA8.7000900@mellanox.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com> <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com> <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com> <51ADD489.3020902@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65AE40@xmb-rcd-x01.cisco.com> <51AEE53C.2090603@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65C855-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/2013 15:45, Jeff Squyres (jsquyres) wrote:
> On Jun 5, 2013, at 12:14 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> 
>>> Hmm; I'm confused.  How does this fix the MPI-needs-to-intercept-freed-memory problem?
>> Well, there is no problem if an application frees registered memory (in
>> an on-demand paging memory region) and that memory is returned to the
>> OS. The OS will invalidate these pages, and the HCA will no longer be
>> able to use them. This means that the registration cache doesn't have to
>> de-register memory immediately when it is freed.
> 
> 
> (must... resist... urge... to... throw... furniture...)
(ducking and taking cover :-) )

> 
> This is why features should not be introduced to solve MPI problems without an understanding of what the MPI problems are.  :-)  Please go talk to the Mellanox MPI team.
> 
> Forgive me for being frustrated; memory registration and all the pain that it entails was highlighted as ***the #1 problem*** by *5 major MPI implementations* at the Sonoma 2009 workshop (see https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/301-mpi-update-and-requirements-panel-all-presentations.html, starting at slide 7 in the "openmpi" slide deck).  
Perhaps I'm missing something, but I believe ODP deals with the first
two problems in the list (slide 8), even if it doesn't solve them
completely.

You no longer need to do dangerous tricks to catch free, munmap, sbrk.
As I explained above, these operations can work on an ODP MR without
allowing the HCA use the invalidated mappings.

In the future we want to implement an implicit memory region covering
the entire process address space, thus eliminating the need for memory
registration almost completely (you might still want memory
registration, or memory windows, in order to control permissions of
remote operations).

We can also allow fork to work with our implementation. Copy-on-write
will work with ODP regions by invalidating the HCA's page tables before
modifying the pages to be read-only. A page fault from the HCA can then
refill the pages, or even break COW in case of a write.

> Why don't we have something like ummunotify yet?
I think that the problem we are trying to solve is better handled inside
the kernel. If you are going to change the HCA's memory mappings, you'd
have to go through the kernel anyway.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
