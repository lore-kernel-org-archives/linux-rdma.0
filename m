From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 2/5] verbs: Introduce tag matching SRQ
Date: Tue, 13 Jun 2017 00:45:45 +0300
Message-ID: <fc8f2d3f-95a4-6f43-26ed-87d0631d4bc6@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-3-git-send-email-artemyko@mellanox.com>
 <20170612163856.GA12282@obsidianresearch.com>
 <0c00c167-1cfb-d169-134d-d608079b53df@mellanox.com>
 <20170612205015.GA24893@obsidianresearch.com>
 <af1d8a49-7d4a-6f3c-b5a1-c4aba79d74d1@mellanox.com>
 <20170612211816.GA27649@obsidianresearch.com>
 <bd402c01-f12e-52e8-c96f-0d2db0459b22@mellanox.com>
 <20170612214047.GA30578@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612214047.GA30578-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13/06/2017 00:40, Jason Gunthorpe wrote:
> On Tue, Jun 13, 2017 at 12:31:11AM +0300, Artemy Kovalyov wrote:
>
>> I not insist, just want to clarify whether this code standard was
>> chosen for the project.
>
> It is, and we already have things that are not C89 in the public
> headers for some time.
>
> If someone wishes to support C89 then they will need to make a patch
> and travis support, otherwise please continue to follow the existing
> examples of adding the trailing, as other new cases do.

Legit.

>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
