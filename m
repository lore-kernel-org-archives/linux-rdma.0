From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 17:42:48 +0300
Message-ID: <5627A468.1090302@mellanox.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-2-git-send-email-eranbe@mellanox.com>
 <56274E02.7010002@mellanox.com>
 <CAKHjkj=k6QSKj0gMe0z5=Kjbe2e7cVCbPhkq9Z457gpvnRyitg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKHjkj=k6QSKj0gMe0z5=Kjbe2e7cVCbPhkq9Z457gpvnRyitg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 21/10/2015 16:46, eran ben elisha wrote:
>>> +ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
>>> >> +                         struct ib_device *ib_dev,
>>> >> +                         const char __user *buf, int in_len,
>>> >> +                         int out_len)
>>> >> +{
>>> >> +     struct ib_uverbs_create_qp      cmd;
>>> >> +     struct ib_uverbs_ex_create_qp   cmd_ex;
>>> >> +     struct ib_udata                 ucore;
>>> >> +     struct ib_udata                 uhw;
>>> >> +     ssize_t resp_size = sizeof(struct ib_uverbs_create_qp_resp);
>>> >> +     int                             err;
>> >
>> > I would expect a check here that in_len >= sizeof(cmd). But I see the
>> > previous code didn't have it either. Any reason adding the check would
>> > break user-space?
> This patch just refactor in ib_uverbs_create_qp and doesn't change any
> of it's logic or fix any bug. we can consider such a fix for the
> future.

Fair enough.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
