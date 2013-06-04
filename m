From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Tue, 4 Jun 2013 01:24:57 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com>
 <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <89757B515B632B4BAA7C5E753F6C738F-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On May 29, 2013, at 1:53 AM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Have you looked on ODP? see
> https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/568-on-demand-paging-for-user-space-networking.html


Is the idea behind ODP that, at the beginning of time, you register the entire memory space (i.e., NULL to 2^64) and then never worry about registered memory?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
