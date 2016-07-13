From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v6 17/46] infiniband: dma-mapping: Use unsigned long for
 dma_attrs
Date: Wed, 13 Jul 2016 12:47:06 +0200
Message-ID: <57861C2A.2090206@samsung.com>
References: <1468399167-28083-1-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-4-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-5-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-6-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-7-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-8-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-9-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-10-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-11-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-12-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-13-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-14-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-15-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-16-git-send-email-k.kozlowski@samsung.com>
 <1468399300-5399-17-git-send-email-k.kozlowski@samsung.com>
 <3ed39f35-f19e-1593-72a5-0d7240fa7a4e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <3ed39f35-f19e-1593-72a5-0d7240fa7a4e-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/13/2016 12:37 PM, Bart Van Assche wrote:
> On 07/13/2016 03:41 PM, Krzysztof Kozlowski wrote:
>> Split out subsystem specific changes for easier reviews. This will be
>> squashed with main commit.
> 
> Apparently my comment has been ignored
> (http://thread.gmane.org/gmane.linux.ports.m68k/8746/focus=37703). Are
> you aware that you are expected to reply to feedback on patches?

Of course your comment was not ignored. I am sorry that you have such
impression. However I thought you are referring only to local variable
which name I changed.

Do you want me to rename also the argument in the ib_dma_map_sg_attrs()
and ib_dma_unmap_sg_attrs() functions?

Best regards,
Krzysztof
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
