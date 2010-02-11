From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQ overrun
Date: Thu, 11 Feb 2010 17:37:09 +0100
Message-ID: <6978b4af1002110837j7d1641e8n56f29e4905ead349@mail.gmail.com>
References: <6978b4af1002110457j26224acbr3dc28f4afb8cfb86@mail.gmail.com>
	 <Pine.GSO.4.40.1002111048350.53-100000@omicron.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1002111048350.53-100000-3mrvs1K0uXjA85jc68Yv76kAi/sjxfazN7jzCyCsa88@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hari,

Thanks for your help.

>
> It looks like you're overflowing the Completion Queue. On the application
> side, this could manifest as a hang while polling the CQ.
>
> This could happen you receive more completion queue entries than the CQ
> could handle. The depth of the CQ is set while creating it. It is the
> second parameter in the call to "ibv_create_cq". You can try increasing
> this to a larger value and see if your problem goes away.
>

I'm pretty sure that I'm not doing that many requests, to overflow the
CQ that is. I have 1000+ depth and I'm doing 160 requests (and
consequently 160 completion events) before polling. The odd is that
this only happens with a large number of nodes and although the number
of requests is the same before polling. Randomly, machines fail with
the error. Moreover, this only happens if I use more than 1 queue pair
(splitting the requests on different queue pairs and then polling on
all of them). Sticking to one queue pair does not trigger the problem
(although that is not the scenario I want)!

Could the error message be related with something else?

> Another thing you could check is the Firmware version of your card
> (from the debug output, I'm assuming its a Mellanox InfiniHost card). Is
> it a really really old version (4.7.500)? If so, you could try upgrading
> that. There were some fixes for similar issues checked in after that.
>

I have a :

hca_id: mthca0
        fw_ver:                         1.2.0
        vendor_id:                      0x02c9
        vendor_part_id:                 25204
        hw_ver:                         0xA0
        board_id:                       MT_03D0130002

which afaics, is a recent fw.

Any further thoughts? Thanks.

Cheers,
Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
