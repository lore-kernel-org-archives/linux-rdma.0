From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an error wc
Date: Wed, 9 Mar 2011 20:09:27 +0100
Message-ID: <AANLkTinB6tyeeRF---NZg0ixtDwcVGy3HBm=ogfSUUZY@mail.gmail.com>
References: <20110309042613.GA21606@obsidianresearch.com> <4D771E0F.7040402@mellanox.com>
 <20110309070441.GA25213@obsidianresearch.com> <4D772E36.90103@mellanox.com> <20110309174044.GO22729@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110309174044.GO22729-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2011 at 6:40 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> [ ... ]
> Like any other non-portable construct using it or not depends on what
> you are trying to accomplish and how much performance you gain. But in
> any event, having the information is better for diagnostics so I think
> the patch should be applied :)

Even if your patch would be applied, in portable code it wouldn't be
possible to make any assumptions about the validity of the opcode and
qp_num fields in error completions for a long time. Which is
unfortunate.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
