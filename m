From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC for accelerated IPoIB 00/27] Enhanced mode for IPoIB driver
Date: Thu, 2 Mar 2017 21:17:16 +0200
Message-ID: <CAAk-MO-YvUZq8Y-CiU6+O8CTYOV1cuodSmTc1XMzrPhWmWFS-Q@mail.gmail.com>
References: <1488376954-8346-1-git-send-email-erezsh@mellanox.com> <20170301182833.GD14791@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301182833.GD14791-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 1, 2017 at 8:28 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Mar 01, 2017 at 04:02:08PM +0200, Erez Shitrit wrote:
>>     However, New features are exisiting in common network interfaces that
>>     are very hard to implement in IPoIB interfaces while it uses the RDMA
>>     layer, examples include TSS and RSS, tunneling offloads, and XDP.
>>     Rather than continuously porting IP network interface developments into
>>     the RDMA stack, we propose adding an abstract network data-path interfaces
>>     to RDMA devices.
>
> I should also say that we have discussed this for a while and I am
> broadly in favor of this approach of delegating IPoIB skb transmit
> directly to the low level driver.
>
> There are too many optimizations that do not fit sanely into verbs,
> and the entire overhead of building a verbs wr and posting it then
> translating that to a driver wr is unnecessary layering.
>
> Longer term, it might be quite nice if the part verbs specific part of
> ipoib was cleanly split out into the 'default' implementation of your
> get_ipoib_accel_ops.

That what we tried to do here (hopefully..) we tried to keep the
separating of the control from data-path and verbs.
The accelerating functions are only for  data-path or HW resources handling.

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
