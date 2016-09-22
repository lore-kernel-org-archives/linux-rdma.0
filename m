From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 17/23] umad: Replace .nl with .sp in man pages
Date: Thu, 22 Sep 2016 09:50:55 -0400
Message-ID: <eccf516a-b193-5f35-4b78-02c6c7b2161c@dev.mellanox.co.il>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474495729-17604-18-git-send-email-jgunthorpe@obsidianresearch.com>
 <0225b26e-0b88-0116-9c23-0b1e6bcd8e50@dev.mellanox.co.il>
 <20160922132544.GE4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160922132544.GE4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/22/2016 9:25 AM, Leon Romanovsky wrote:
> On Thu, Sep 22, 2016 at 08:27:06AM -0400, Hal Rosenstock wrote:
>> On 9/21/2016 6:08 PM, Jason Gunthorpe wrote:
>>> Debian's Lintian remarks:
>>>
>>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_ca.3.gz 11: warning: macro `nl' not defined
>>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_get_port.3.gz 11: warning: macro `nl' not defined
>>> W: rdma-plumbing: manpage-has-errors-from-man usr/share/man/man3/umad_init.3.gz 11: warning: macro `nl' not defined
>>>
>>> We use .sp in other the man pages to separate function signatures, follow
>>> that practice consistently.
>>>
>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>>
>> Thanks. Applied.
> 
> Hal,
> We started to move everything to https://github.com/linux-rdma/rdma-core
> and it will be applied there.

I'm tracking changes in current repo until things have fully switched
over. I thought that was what was said to do. Previous changes that
Jason pushed were also integrated there. So yes, there's some
duplication of effort until the old repos can safely be abandoned.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
