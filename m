From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RFCv3: Consolidated userspace RDMA library repo
Date: Thu, 8 Sep 2016 07:26:38 -0400
Message-ID: <2e2b54f5-1a9d-bb31-ffd9-fe6936011aaf@dev.mellanox.co.il>
References: <20160907040925.GA27361@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160907040925.GA27361-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/7/2016 12:09 AM, Jason Gunthorpe wrote:
> Hello Everyone,
> 
> I've updated the repo, and I think we are now at the point to begin to
> engage the distribution packagers and collect their feedback. As Doug
> has suggested, there are many modifications that the distros have done
> that could be folded back upstream.
> 
> It is available at:
>   https://github.com/jgunthorpe/rdma-plumbing
> 
> Prior posts on this topic are still informative:
>   http://www.spinics.net/lists/linux-rdma/msg39026.html
>   http://www.spinics.net/lists/linux-rdma/msg39328.html
>   http://www.spinics.net/lists/linux-rdma/msg40014.html

Looks to me that librdmacm is missing some patches. Sean moved this repo
from the OFA server to github some time ago. What repo was used as basis
for librdmacm in rdma-plumbing ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
