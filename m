From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH libibverbs 0/3] Add support for TCP segmentation offload
 (TSO)
Date: Wed, 17 Aug 2016 17:38:26 +0300
Message-ID: <d42edf65-00af-6d4a-be85-a22f1fdd4b1a@grimberg.me>
References: <1469708382-29408-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469708382-29408-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> Hi Doug,
>
> This patch set from Bodong exposes to user space applications an API to use the
> TSO offload over verbs and let them enjoying from its benefits.
>
> The relevant kernel patches regarding capabilities were already taken into your
> tree for coming kernel of 4.8.
>
> The series was tested successfully with mlx5 driver (lib, kernel) and can be
> accessed also from my openfabrics GIT at:
> git://openfabrics.org/~yishaih/libibverbs.git branch: tso
>
> Will send shortly the candidate libmlx5 patch as some driver reference
> code for that API.

Any updates on this set? Would love to see it in your tree Doug!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
