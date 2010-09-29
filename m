From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 12:27:49 -0500
Message-ID: <4CA37715.4020302@opengridcomputing.com>
References: <20100929141112.26944.21931.stgit@build.ogc.int> <adawrq431sr.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrq431sr.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/29/2010 12:19 PM, Roland Dreier wrote:
>   >  @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
>   >   	.open    = qp_open,
>   >   	.release = qp_release,
>   >   	.read    = debugfs_read,
>   >  +	.llseek  = default_llseek,
>   >   };
>
> I think this could actually be generic_file_llseek (right, Arnd?).
>
> Also could qp_read() and other read methods be simplified by using
> simple_read_from_buffer()?  I don't see anything fancy there, seems like
> the read methods could become one-liners that way.
>
>    

I assume you mean debugs_read()...Like this?

static ssize_t debugfs_read(struct file *file, char __user *buf, size_t 
count,
                             loff_t *ppos)
{
         struct c4iw_debugfs_data *d = file->private_data;

         return simple_read_from_buffer(buf, ppos, d->buf, d->pos);
}


Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
