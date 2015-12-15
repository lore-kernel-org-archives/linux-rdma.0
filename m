From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/5] IB/core: Add ib_is_udata_cleared
Date: Tue, 15 Dec 2015 16:13:55 +0200
Message-ID: <56702023.5080307@mellanox.com>
References: <1449157463-25313-1-git-send-email-matanb@mellanox.com>
 <1449157463-25313-3-git-send-email-matanb@mellanox.com>
 <56658718.8080308@mellanox.com>
 <CAAKD3BC7bhKC+jKV3aH9W+pcBwV19PJZYwXdZue6hNew=CJW9g@mail.gmail.com>
 <5669983E.5000200@mellanox.com>
 <CAAKD3BDfobwroOnvoxPMTA5zL=wxY3KDL=FAvq5EdUOkFG_F+Q@mail.gmail.com>
 <566D9315.9050807@mellanox.com>
 <CAAKD3BBKu493f539h+SfG=JLgW-OKrsUZ8FhZPHy598n6+j4=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBKu493f539h+SfG=JLgW-OKrsUZ8FhZPHy598n6+j4=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14/12/2015 18:31, Matan Barak wrote:
> I'm not sure regarding the string.c location, as it deals with user
> buffers, but in order not to
> be dependent on this, I'll change this code to the following.
> 
> static inline bool ib_is_udata_cleared(struct ib_udata *udata,
>                                        u8 cleared_char,
>                                        size_t offset,
>                                        size_t len)
> {
>         const void __user *p = udata->inbuf + offset;
>         bool ret = false;
>         u8 *buf;
> 
>         if (len > USHRT_MAX)
>                 return false;
> 
>         buf = kmalloc(len, GFP_KERNEL);
>         if (!buf)
>                 return false;
> 
>         if (copy_from_user(buf, p, len))
>                 goto free;
> 
>         ret = !memchr_inv(buf, cleared_char, len);
> 
> free:
>         kfree(buf);
>         return ret;
> }

Looks good to me.

Thanks,
Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
