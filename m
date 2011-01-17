From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Mon, 17 Jan 2011 15:33:01 -0700
Message-ID: <20110117223301.GG995@obsidianresearch.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
 <1294068834-17778-6-git-send-email-nirm@voltaire.com>
 <20110107203742.GH1211@obsidianresearch.com>
 <adamxnc9x33.fsf@cisco.com>
 <4D3417E1.9090903@voltaire.com>
 <adaaaizyyx6.fsf@cisco.com>
 <20110117221141.GE995@obsidianresearch.com>
 <ada4o97yy7u.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada4o97yy7u.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 17, 2011 at 02:14:29PM -0800, Roland Dreier wrote:
>  > I also think that introducing a new user space interface that has to
>  > remain the same forever is not to be done lightly. I'd love to also
>  > hear from the netdev folks what they think of the schema. I think it
>  > is sort of like sysfs, a lot of variation and opinions on what is
>  > right..
> 
> Is the schema documented anywhere, or does one have to read it from the code?

Nir was going to add it to the commit comment for patch 5/6.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
