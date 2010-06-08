From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Handling busy responses from the SA
Date: Tue, 8 Jun 2010 09:44:05 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F578BBE@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com>
 <20100604225739.GK15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100604225739.GK15969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Also, I guess, it would be a good API choice if the caller could say
> 'get me a reply for this mad or error within 60s' rather than specify
> details like retry counts, etc. The timeout values should be globally
> set and derived from the usual SA provided data for network transits...

I agree with this.  Within the framework of the existing umad ABI, this could be specified by setting the high bit in the ib_user_mad_hdr:timeout_ms field, assuming that no one is using that bit in practice.  The kernel could then freely select the retry/timeout policy for these clients, which for starters could include dropping BUSY responses and adjusting the timeout using an approach similar to what Mike mentioned in a separate email.  Kernel clients could be updated to use this new mode.

Any disagreements to this approach?  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
