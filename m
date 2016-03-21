From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Mon, 21 Mar 2016 10:59:26 +0200
Message-ID: <56EFB7EE.9010006@mellanox.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
 <20160315203112.GA2786@obsidianresearch.com>
 <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw@mail.gmail.com>
 <20160317161237.GB19501@obsidianresearch.com>
 <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA@mail.gmail.com>
 <20160317164831.GI19501@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317164831.GI19501-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/17/2016 6:48 PM, Jason Gunthorpe wrote:
> +		if (file->ucontext) {
> +			file->ucontext = NULL;
> +			mutex_unlock(&file->cleanup_mutex);
> +			ib_dev->disassociate_ucontext(file->ucontext);
> +			ib_uverbs_cleanup_ucontext(file, file->ucontext);
>  		}

The general locking scheme sounds good to me, but obviously you need to keep
the original value of file->ucontext before clearing it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
