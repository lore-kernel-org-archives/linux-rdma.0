From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Sat, 22 Jun 2013 13:13:28 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F69A643@xmb-rcd-x01.cisco.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com> <20130621063648.GA27963@obsidianresearch.com>
 <51C48F01.5030103@redhat.com> <20130621182617.GA17700@obsidianresearch.com>
 <51C4BE25.9000501@redhat.com> <20130621212016.GA10637@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130621212016.GA10637-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <A88987FC2F60F849B01E2285CB7FD15B-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 21, 2013, at 5:20 PM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> Jeff: If you are still reading -

I am still reading, just didn't have much to contribute until now.  :-)

> one concrete suggestion, I think, is
> to ensure compile-time failure when the new-format MTU variable is
> touched.  This is trivially done by wrapping it in a struct:
> 
> struct ibv_mtu_t {int __mtu;};

Sure, I can work up a patch that does this.

Do others agree?  Roland?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
