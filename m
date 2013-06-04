From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Tue, 4 Jun 2013 12:54:16 +0300
Message-ID: <51ADB948.5080903@mellanox.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com> <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com> <51ADA761.2080107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ADA761.2080107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/06/2013 11:37, Or Gerlitz wrote:
> On 04/06/2013 04:24, Jeff Squyres (jsquyres) wrote:
>> On May 29, 2013, at 1:53 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Have you looked on ODP? see
>>> https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/568-on-demand-paging-for-user-space-networking.html
>>>
>>
>> Is the idea behind ODP that, at the beginning of time, you register
>> the entire memory space (i.e., NULL to 2^64) and then never worry
>> about registered memory?
>>

We wish to get there eventually. In our current implementation you still
have to register an on-demand memory region explicitly. The difference
between a regular memory region is that the pages in the region aren't
pinned.

> 
> Adding Haggai from the team that works on ODP. Haggai, Jeff also made a
> comment over this thread http://marc.info/?t=136976347600006&r=1&w=2
> that a limitation of a max of 2 concurrent page faults seems fairly
> significant which you might want to address too.

We chose to support only 2 concurrent page faults per QP since this
allows us to maintain order between the QP's operations and the
user-space code using it.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
