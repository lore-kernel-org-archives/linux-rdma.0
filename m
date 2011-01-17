From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Mon, 17 Jan 2011 15:11:41 -0700
Message-ID: <20110117221141.GE995@obsidianresearch.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
 <1294068834-17778-6-git-send-email-nirm@voltaire.com>
 <20110107203742.GH1211@obsidianresearch.com>
 <adamxnc9x33.fsf@cisco.com>
 <4D3417E1.9090903@voltaire.com>
 <adaaaizyyx6.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaaaizyyx6.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 17, 2011 at 01:59:17PM -0800, Roland Dreier wrote:
>  > If comparing to all the patches that landed @ your for-next branch for 
>  > this merge window, this set went through the most detailed review, any 
>  > reason not to push them now?
> 
> Jason did a great job of reviewing the netlink stuff as it evolved, but
> I didn't pay much attention and I need to learn about details of netlink
> and then really look at the code first.  When the final patches arrive
> on Jan 3 and the merge window opens the next day, there's not much time
> to get non-trivial changes merged.

I also think that introducing a new user space interface that has to
remain the same forever is not to be done lightly. I'd love to also
hear from the netdev folks what they think of the schema. I think it
is sort of like sysfs, a lot of variation and opinions on what is
right..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
