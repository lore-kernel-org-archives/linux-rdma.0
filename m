From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] Add IBV_*_USNIC enums for the Cisco Ethernet
 Virtual NIC.
Date: Thu, 4 Apr 2013 12:10:28 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC43FE150E@xmb-rcd-x01.cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36A3A6@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZLJWBvqFVUdYch+xU6yFwc0dKTBUb5qV_Hbxf=8HEKkqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLJWBvqFVUdYch+xU6yFwc0dKTBUb5qV_Hbxf=8HEKkqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <3621EAAD8BC69346A14D3F4C15A92BD5-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Apr 3, 2013, at 2:45 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Jeff, I agree with Sean, there's not much point to review/discuss
> these general/pre-step patches without seeing some actual device
> specific kernel (if there are such or user space code if there aren't
> any kernel ones) code. e.g you can submit the two kernel pre-step
> patches as the two first pieces in a series that has the driver code.


Unfortunately, not yet.

I just sent another mail that explained our rationale: our kernel driver and libibverbs plugin code are working their way through QA.  It'll take a little time before we can submit good patches for these.  The main driving factor for submitting these new enums is so that they can be included in RHEL 6.5.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
