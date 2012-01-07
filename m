From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibswitches command displays wrong information when switch
 description string includes "base"
Date: Fri, 6 Jan 2012 17:51:44 -0700
Message-ID: <20120107005144.GB329@obsidianresearch.com>
References: <4F079048.8050709@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F079048.8050709-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pierre orzechowski <pierre.e.orzechowski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 06, 2012 at 04:22:32PM -0800, pierre orzechowski wrote:

> We have a customer reporting an issue with the "ibswitches" command
> part of the infiniband-diags package.
> If the switch description includes the string "base" anywhere, then
> the match operation in the awk section of ibwitches does not behave
> as expected and output is garbled.

These shell tools have all been de-supported by the infiniband-diags
maintainer, exactly because they are prone to these sorts of problems
due to inherent design flaws.

The recommendation is to use the new C based commands, but there is
not an exact correspondence.

python-rdma's ibtool command has work-alikes for all of the old
commands that do not have these issues for people who absolutely must
have the old commands.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
