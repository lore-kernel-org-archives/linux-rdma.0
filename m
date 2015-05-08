From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] RDMA/core: Fix for parsing netlink string attribute
Date: Fri, 8 May 2015 15:53:28 -0600
Message-ID: <20150508215328.GB3917@obsidianresearch.com>
References: <20150508213633.GA13012@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150508213633.GA13012@TENIKOLO-MOBL2>
Sender: stable-owner@vger.kernel.org
To: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, swise@opengridcomputing.com, john.s.lacombe@intel.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 08, 2015 at 04:36:33PM -0500, Tatyana Nikolova wrote:
> The string iwpm_ulib_name is recorded in a nlmsg as a netlink attribute.
> Without this fix parsing of the nlmsg by the userspace port mapper service fails
> because of unknown attribute length, causing the port mapper service not to
> register the client, which has sent the nlmsg.

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

This actually will copy some kernel memory to userspace. I think the
overflow is in .text, so probably not a security issue..

Jason
