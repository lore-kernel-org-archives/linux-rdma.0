From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Tue, 4 Jun 2013 10:56:21 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com>
 <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ADB948.5080903-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <B5F448911D51204A9B622E8DD76302B8-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 4, 2013, at 2:54 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> We wish to get there eventually. In our current implementation you still
> have to register an on-demand memory region explicitly. The difference
> between a regular memory region is that the pages in the region aren't
> pinned.

Does this mean that an MPI implementation still has to register memory upon usage, and maintain its own registered memory cache?

> We chose to support only 2 concurrent page faults per QP since this
> allows us to maintain order between the QP's operations and the
> user-space code using it.


I talked to someone who was at the OpenFabrics workshop and saw the ODP presentation in person; he tells me that a fault will be incurred when a page is not in the HCA's TLB cache (vs. when a registered page is not in memory and must be swapped back in), and that this will trigger an RNR NAK.

Is this correct?

He was very concerned about what the size of the TLB on the HCA, and therefore what the actual run-time behavior would be for sending around large messages via MPI -- i.e., would RDMA'ing 1GB messages now incur this HCA-must-reload-its-TLB-and-therefore-incur-RNR-NAKs behavior?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
