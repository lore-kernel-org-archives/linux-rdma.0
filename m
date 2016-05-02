From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG
 for SendOnly join
Date: Mon, 2 May 2016 18:15:34 +0300
Message-ID: <CAAk-MO_EX9jUC2NAW=vkzbvJnBY0u50=MTYem5RbiciG+wngpA@mail.gmail.com>
References: <1462194141-8902-1-git-send-email-erezsh@mellanox.com>
	<1462194141-8902-5-git-send-email-erezsh@mellanox.com>
	<alpine.DEB.2.20.1605021011330.29573@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605021011330.29573-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 2, 2016 at 6:11 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, 2 May 2016, Erez Shitrit wrote:
>
>> +             if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
>> +                 priv->sm_fullmember_sendonly_support)
>> +                     /* SM supports sendonly-fullmember, otherwise fallback to full-member */
>> +                     rec.join_state = 8;
>
> Why 8?

bit no 3 indicates the fullmember-sendonly for the sm.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
