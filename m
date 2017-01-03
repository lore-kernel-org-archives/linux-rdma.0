From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB: Fix incorrect structure packing for booleans
Date: Tue, 3 Jan 2017 14:16:42 -0500
Message-ID: <02392b22-10dc-be83-d4de-c9c2db416cc1@dev.mellanox.co.il>
References: <20161223010752.GA20676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161223010752.GA20676-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/22/2016 8:07 PM, Jason Gunthorpe wrote:
> Crucially this means the kernel has never, set reversible
> correctly in the path record request. It has always asked for
> irreversible paths even if the ULP requests otherwise.

Issuing path record query with reversible bit set to 0 means that any
path (reversible or not) can be returned by SA. It is not requesting an
irreversible path. In the response, the reversible bit indicates whether
the path is reversible or not.

> When the kernel is used with a SM that supports this feature, it
> completely breaks communication management if reversible paths are
> not properly requested.
> 
> The only reason this ever worked is because opensm ignores the
> reversible bit.

OpenSM supports reversible PR queries. I tested all 3 cases (comp mask
bit not set, comp mask bit set and reversible set to 1, and comp mask
bit set and reversible set to 0) in a single subnet.

If you are referring to multiple (IB routed) subnet case, OpenSM only
has rudimentary support for this and path queries is just one area where
shortcuts were done to demo primitive IB routers a long time ago so I
would not be surprised if reversible was ignored in that scenario.
Is that what you are referring to ? If so, it would be more accurate to
add that into your description rather than a blanket statement that
OpenSM ignores the reversible bit in path queries.

Otherwise, please elaborate/provide more details on the issue you are
seeing with OpenSM.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
