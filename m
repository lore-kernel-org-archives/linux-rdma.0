From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 16/44] infiniband: dma-mapping: Use unsigned long for
 dma_attrs
Date: Mon, 13 Jun 2016 17:08:04 +0200
Message-ID: <20160613150804.GA3219@kozik-lap>
References: <1465553521-27303-1-git-send-email-k.kozlowski@samsung.com>
 <1465553521-27303-17-git-send-email-k.kozlowski@samsung.com>
 <b4d3a64b-afa6-fb2d-1516-831b5ea45129@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b4d3a64b-afa6-fb2d-1516-831b5ea45129-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 10, 2016 at 11:18:31AM -0700, Bart Van Assche wrote:
> On 06/10/2016 03:11 AM, Krzysztof Kozlowski wrote:
> >Split out subsystem specific changes for easier reviews. This will be
> >squashed with main commit.
> 
> Please rename 'attrs' into 'dma_attrs' in this patch such that it remains
> clear that that variable refers to DMA attributes.

Good point, thanks.

Best regards,
Krzysztof
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
