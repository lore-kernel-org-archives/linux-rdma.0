From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/core: Add support for extended query device
 caps
Date: Sun, 22 Feb 2015 09:14:36 +0200
Message-ID: <54E981DC.5050801@mellanox.com>
References: <1424244364-6242-1-git-send-email-haggaie@mellanox.com>
 <1424244364-6242-2-git-send-email-haggaie@mellanox.com>
 <CAAKD3BAPL82RC5u5uxJg9QPgiM+05TcnURzO14Y5OKYxhYrmqw@mail.gmail.com>
 <20150219182750.GA30093@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150219182750.GA30093-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/02/2015 20:27, Jason Gunthorpe wrote:
> On Thu, Feb 19, 2015 at 02:30:29PM +0200, Matan Barak wrote:
>> > Furthermore, ibv_create_flow and ibv_destroy_flow were already
>> > accepted using the old schema.
> IIRC they didn't have values that could meaningfully be 0?

I think they don't have any extension yet -- I don't see any change
before 69ad5da41b4e ("IB/core: Re-enable create_flow/destroy_flow uverbs").

They verify comp_mask == 0 on command entry, and create_flow zeros the
response's comp_mask when it returns.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
