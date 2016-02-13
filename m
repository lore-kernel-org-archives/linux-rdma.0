From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v3 0/3] new ib_drain_qp() API
Date: Sat, 13 Feb 2016 18:50:01 +0200
Message-ID: <20160213165001.GC14741@leon.nu>
References: <cover.1455230646.git.swise@chelsio.com>
 <20160213161049.GB14741@leon.nu>
 <20160213163253.GA8843@infradead.org>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160213163253.GA8843-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Feb 13, 2016 at 08:32:53AM -0800, Christoph Hellwig wrote:
> On Sat, Feb 13, 2016 at 06:10:49PM +0200, Leon Romanovsky wrote:
> > 
> > Hi Steve,
> > For future submission, can you please use versioning on all patches
> > submitted in the series and not only in cover letter?
> > 
> > In such way, internal filtering of new emails will be more informative.
> 
> That's very unusual and not the git-send-email default for a reason.
> I'd suggest you fix your 'internal filtering' instead.

>From my perspective there are many top developers which are using
proposed format as you said "for a reason".

My flow is based on mutt mail reader and I'll be glad to hear how
it can be fixed.

Can you suggest me how do I suppose "to fix" my filtering?
Right now, the flow is:
1. Open mutt
2. Navigate to linux-rdma mailbox
3. Hit "l" (limit open)
4. Write "new"
5. Get only new (unread) mails.
6. Read all emails and for Steve's mails only, I need to disable
limit in order to say if it is new version of patches or old ones.

P.S. get_maintainer.pl script has strange defaults too, it doesn't say
that we need to follow blindly them.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
