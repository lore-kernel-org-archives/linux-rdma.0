From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: intel iommu causing performance drop in mlx4 ipoib
Date: Mon, 16 May 2016 15:05:10 +0300
Message-ID: <CAJ3xEMg=OWmRH2evqzchkh_=exwWo8bis9nboMG0y+Pdw4zebg@mail.gmail.com>
References: <5739A347.20807@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5739A347.20807-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 1:39 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
[...]
> Essentially the majority is spent in just receiving the packets and the
> sustained rate is 26Gbps. So the question why does compiling in (but not
> enabling intel_iommu=on kills performance) only on the receive side, e.g. if

add iommu=pt to your boot, this is 2009 material [1]

Or.

[1] https://lwn.net/Articles/329174/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
