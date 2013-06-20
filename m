From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 20 Jun 2013 20:50:34 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6950B1@xmb-rcd-x01.cisco.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com>
 <20130618184928.GE2204@obsidianresearch.com> <51C368D4.7020603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C368D4.7020603-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <2A724A8E01203740A06016693B24A882-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 20, 2013, at 4:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>> {
>> 	static char str[16];
>> 	snprintf(str, sizeof(str), "%d", ibv_mtu_to_num(max_mtu));
>>        return str;
>> }
> 
> That is not, however, multi-thread safe nor advisable unless you clearly
> indicate in the man page to the function that subsequent calls to the
> function wipe out the result of previous calls.  It's not even single
> thread safe if you have more than one interface and don't know that
> later calls wipe this buffer out.  Best to avoid library routines such
> as this.

This is in the devinfo.c program (which is single-threaded), not in the library itself.

But regardless, this whole function went away in V2 of the patch.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
