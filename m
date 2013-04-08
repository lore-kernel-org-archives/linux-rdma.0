From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet
 Virtual NIC.
Date: Mon, 8 Apr 2013 21:52:54 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC43FF987A@xmb-rcd-x01.cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FE14D8@xmb-rcd-x01.cisco.com>
 <CAJZOPZKQ_QFdTj-uYOBuBXcipxO1Drj7v4_U_euYzOe1Y6648Q@mail.gmail.com>
 <02A33CE5-6894-4F88-8493-2ACD9FF81B5E@cisco.com>
 <CAL1RGDXSqyAyHZbWcH5WQcaEJ_vnfn+67WYd57Hy-4EO-KRUyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXSqyAyHZbWcH5WQcaEJ_vnfn+67WYd57Hy-4EO-KRUyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <2E2FA8F25F441444B24A0E3F60672B26-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 5, 2013, at 4:40 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> I think the idea is that without context, it's hard to know if adding
> these enums makes sense or not.  And I'm sorry but I'm not that
> sympathetic to "my code isn't ready but you have to take this
> out-of-context patch so I can meet Red Hat's arbitrary schedule."


Ok, fair enough.  It'll be a few weeks before we can submit usnic.ko, so I'll re-bring up the IBV_NODE_VENDOR/related patches then.

I think the MTU discussion is still relevant, however -- there seems to be a larger design issue there.  I'll go reply separately on that thread.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
