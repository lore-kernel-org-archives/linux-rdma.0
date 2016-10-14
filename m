From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: trivial sparse fixes for rdma-core
Date: Fri, 14 Oct 2016 08:04:15 +0300
Message-ID: <CALq1K=JJknUYif67PbUH+vuRFJYtowdsXmkm4NzUgKZm4D5uSg@mail.gmail.com>
References: <1476381095-20041-1-git-send-email-hch@lst.de> <20161013190326.GA19904@obsidianresearch.com>
 <20161014043705.GF9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014043705.GF9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 7:37 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Oct 13, 2016 at 01:03:26PM -0600, Jason Gunthorpe wrote:
>> On Thu, Oct 13, 2016 at 07:51:03PM +0200, Christoph Hellwig wrote:
>> > This is the low hanging fruit in terms of reducing sparse noise before
>> > looking into endianess and iomem annotations.
>>
>> Looks fine to me. Since I gave them a good compile test I also
>> prepared the pull request for the first 15 that made it to the list:
>>
>> https://github.com/linux-rdma/rdma-core/pull/19
>>
>> Here is the patch to turn on gcc -Wstrict-prototypes
>>
>> https://github.com/jgunthorpe/rdma-plumbing/commit/dd80c3b362ae90d0de36a6249409c20581bae864
>
> I didn't look on it yet, but maybe someone already knows the answer.
> Can we run static analyzer tools as part of our TravisCI runs?

It looks like the answer is yes:
https://developer.fedoraproject.org/tech/languages/c/static-analysis.html

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
