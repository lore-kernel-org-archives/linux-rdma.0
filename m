From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Thu, 28 Apr 2016 14:17:29 +0300
Message-ID: <5721F149.1090004@grimberg.me>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> What is the status of getting RXE included in the mainline kernel? I
> saw a post from Kamal Heib on 22 Sep 2015 with a patchset for
> inclusion [0], but there didn't seem to be any discussion about it. I
> diffed the kernel tree with the RXE tree on GitHub using the
> rxe_submission_v8 branch [1], but there was over 10 million lines in
> the patch file for the same kernel version. I'd rather patch into the
> vanilla kernel tree so that I can see the differences rather than just
> building the tree that someone else provides.
>
> I will probably go through all 32 patches anyway, but thought I would
> prod here about the status as it can be very helpful for
> compatibility.

FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
some patches to contribute for it.

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
