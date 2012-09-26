From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Wed, 26 Sep 2012 10:01:10 -0700
Message-ID: <CAL1RGDVTLhSXZQNpcX_HqzqD-Et7G96mXUkWtj4vg0nqz5M14g@mail.gmail.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org> <CAL1RGDUm4Zxnoby5O2RkoahbPUtYBL5UPxAFiwDnNNv4pdy7vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUm4Zxnoby5O2RkoahbPUtYBL5UPxAFiwDnNNv4pdy7vA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 25, 2012 at 9:46 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> By the way, I still get a steady stream of
>
> mlx4_core 0000:05:00.0: Unknown command:0x4d accepted from slave:0
> mlx4_core 0000:05:00.0: Sense command failed for port: 1
>
> once I load the driver... it seems SENSE_PORT is a wrapped command
> but there's no entry in cmd_info[] for it?

I guess Jack is on vacation until next week.  Or, anyone else who knows
anything about this stuff?

In particular I'm planning on including the patch in this thread in my pull
request with SR-IOV in it -- the patch is the difference between crashing
on driver load and mostly working on my setup.

But it seems you guys don't use SR-IOV in setups where the driver
calls SENSE_PORT?  Is something different about my test setup?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
