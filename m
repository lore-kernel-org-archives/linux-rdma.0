From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add new verb: uv_query_port_max_datagram()
Date: Tue, 20 Aug 2013 13:41:26 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F80DB8E@xmb-rcd-x01.cisco.com>
References: <1376942704-25270-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA6D9F@ORSMSX109.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F80AF3E@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA6DF1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA6DF1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <9BAB3707B456C643BA22DBE6541B734E-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 19, 2013, at 8:59 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> Any suggestions on how one adds a new driver call without breaking ABI?
> 
> It could be built on the verbs extension mechanism.

Where is the documentation for this?  Multiple people have referred to it, but I don't see any mention of it in libibverbs.git.

> Is it necessary to call into a provider library, versus simply dropping into the kernel?


I don't think I have much of an opinion here, other than: it would seem weird to not call the provider library, given that all other verbs do that.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
