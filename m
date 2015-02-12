From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/22] IB/ipoib: Fixups for multicast issues
Date: Wed, 11 Feb 2015 23:46:52 -0500
Message-ID: <54DC303C.2020207@mellanox.com>
References: <cover.1423703861.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423703861.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/11/2015 8:43 PM, Doug Ledford wrote:
> This patchset revives the 8 patches that were reverted from 3.19,
> the 11 patches that fixed the problems with the first 8, the single
> patch that was related to reaping of ah's and failure to dealloc
> resources on shutdown, and then adds two new patches that would
> have been enhancements and not bugfixes and hence weren't appropriate
> to post in the 3.19 tussle.
Doug, as asked few times... please provide public git tree where this 
series can be pulled from. So no squashes for patches which actually 
represent a fix to a downstream patch within the series? any specific 
reason for that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
