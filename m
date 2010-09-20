From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [stable] [PATCH 2.6.36] RDMA/cxgb3: Turn off rx coalescing for
 iwarp connections.
Date: Mon, 20 Sep 2010 16:59:18 -0500
Message-ID: <4C97D936.501@opengridcomputing.com>
References: <20100919003821.11904.91366.stgit@build.ogc.int>	<20100919035830.GB30706@kroah.com>	<4C97D547.60008@opengridcomputing.com> <adawrqgdqq1.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrqgdqq1.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/20/2010 04:56 PM, Roland Dreier wrote:
>   >  What am I doing wrong?  I think it meets the criteria.  And I CC'ed
>   >  stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org as suggested below.
>
> I was a bit confusing in my email.  The cc goes in the commit
> description rather than the mail with the patch, ie I put
>
> RDMA/cxgb3: blah blah
>
> Blah blah blah.
>
> Cc:<stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Roland Dreier<rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
>
> in the commit, and Greg gets it automatically when it hits Linus's tree.
> You can put the Cc: before your s-o-b line too and I'll leave it there.
>
>   - R.
>    

Ah, I get it.  Thanks for the clarification!

Stevo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
