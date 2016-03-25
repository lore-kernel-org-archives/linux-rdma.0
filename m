From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Fix a recently introduced locking bug
Date: Fri, 25 Mar 2016 08:49:26 -0700
Message-ID: <56F55E06.2050009@sandisk.com>
References: <56F55A3C.2080608@sandisk.com>
 <CAJFSNy5g9OLwNYwOfbXHUyX-sJQUvbJ=r_rmozKnefCKYADttA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJFSNy5g9OLwNYwOfbXHUyX-sJQUvbJ=r_rmozKnefCKYADttA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/25/2016 08:41 AM, Nikolay Borisov wrote:
> Is this supposed to fix the issue I reported earlier on the list?
> http://marc.info/?l=linux-rdma&m=145890571132495&w=2

Hello Nikolay,

Although I have not yet analyzed your report in depth, I doubt this will 
fix what you reported earlier today.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
