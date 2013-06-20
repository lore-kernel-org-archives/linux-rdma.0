From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 20 Jun 2013 16:40:52 -0400
Message-ID: <51C368D4.7020603@redhat.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com> <20130618184928.GE2204@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130618184928.GE2204-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/18/2013 02:49 PM, Jason Gunthorpe wrote:
> This is simpler:
> 
> {
> 	static char str[16];
> 	snprintf(str, sizeof(str), "%d", ibv_mtu_to_num(max_mtu));
>         return str;
> }

That is not, however, multi-thread safe nor advisable unless you clearly
indicate in the man page to the function that subsequent calls to the
function wipe out the result of previous calls.  It's not even single
thread safe if you have more than one interface and don't know that
later calls wipe this buffer out.  Best to avoid library routines such
as this.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
