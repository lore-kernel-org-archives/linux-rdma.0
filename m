From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libibverbs 2/3] Add support for TCP segmentation offload
 (TSO)
Date: Sun, 21 Aug 2016 19:33:51 +0300
Message-ID: <9c150d62-0197-c735-1625-c1936f8ac920@grimberg.me>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
 <1469708382-29408-3-git-send-email-yishaih@mellanox.com>
 <80ff6d05-201a-3fa6-deab-2dbb035a89c3@mellanox.com>
 <HE1PR05MB1418BA4382257289AB9DEA63CE150@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <CAJ3xEMgsaNq0bp005WPeU9X8H3tvpmCUymNKb0Ht8c6O---JSg@mail.gmail.com>
 <5c895498-caad-0ac3-5a66-286fc1ab2906@grimberg.me>
 <CAJ3xEMjYP=+Kpeda1JaMK6M7xrjC+ikKwDa=bj4dqrDzoGSO2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjYP=+Kpeda1JaMK6M7xrjC+ikKwDa=bj4dqrDzoGSO2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I tend to agree that something that is not used shouldn't exist, but
>> my concern is what is the semantics in the lack of IBV_WC_TSO? You post
>> IBV_WR_TSO and when you get the completion and happen to look at the
>> wc->opcode, what would you expect to see?
>
> again, fact is that the application (ipoib) doesn't need it, as you
> can see mlx5 even doesn't implement that.
>
> The application should expect a completion of a send, that's it.

It's sort of unprecedented to post IBV_WR_XXX and see IBV_WC_YYY but
I'm on the fence here, I guess we can go either way...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
