From: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Adding queue drain functions
Date: Mon, 4 Apr 2016 09:39:17 +0300
Message-ID: <57020C15.3000601@grimberg.me>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
 <570141FE.4090400@grimberg.me> <20160404013152.GD5264@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404013152.GD5264-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Sagi,
> Can you please explain why iWARP devices need explicit drain QP logic?

Steve can explain it much better than I can (so I'd wait for him to
confirm).

My understanding is that in iWARP, after moving the QP to error state,
all the posts should fail instead of completing with a flush error (I
think that SQ_DRAIN is the state that triggers flush errors).

This is why iWARP devices need a special handling for draining a
queue-pair.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
