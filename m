From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/2] ib_srpt: convert printk's to pr_* functions
Date: Fri, 28 Nov 2014 10:07:42 +0100
Message-ID: <54783B5E.10803@acm.org>
References: <cover.1413847199.git.dledford@redhat.com> <5f85bfc1e69ebb8dcd8c048d3a3a6bf135f5fc36.1413847199.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5f85bfc1e69ebb8dcd8c048d3a3a6bf135f5fc36.1413847199.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/21/14 01:24, Doug Ledford wrote:
> The driver already defined the pr_format, it just hadn't
> been converted to use pr_info, pr_warn, and pr_err instead
> of the equivalent printks.  Convert so that messages from
> the driver are now properly tagged with their driver name
> and can be more easily debugged.
>
> In addition, a number of these printk's were not newline
> terminated, so fix that at the same time.
>
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The second hunk of this patch does not apply on kernel v3.18-rc6. 
Anyway, if you want you can add:

Reviewed-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
