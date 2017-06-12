From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 0/5] Hardware tag matching
Date: Mon, 12 Jun 2017 23:43:42 +0300
Message-ID: <a6757fac-f4a6-4877-9d90-9feb0d67df8b@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <20170612164001.GB11993@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612164001.GB11993-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/06/2017 19:40, Jason Gunthorpe wrote:
> On Mon, Jun 12, 2017 at 09:42:42AM +0300, Artemy Kovalyov wrote:
>> Introduction
>> ============
>
> This entire text should go into a documentation/ file in rdma-core, or
> perhaps a man page.
Sure.

This is only request for comments.
For the beginning I send only conceptual things - proposed API changes
and documentation to explain it.

Once it will get acceptance I'll send patch series, with all technical
stuff: this text in Documentation/tag_matching.md, CMakeLists.txt
update, man pages updates, examples updates and provider/mlx5
implementation.

>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
