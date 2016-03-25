From: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Fix a recently introduced locking bug
Date: Fri, 25 Mar 2016 17:51:51 +0200
Message-ID: <CAJFSNy7KszhSUtHef9o_s0X0GmNKA2ZvFrAgRAHUE=1NzSHAqA@mail.gmail.com>
References: <56F55A3C.2080608@sandisk.com>
	<CAJFSNy5g9OLwNYwOfbXHUyX-sJQUvbJ=r_rmozKnefCKYADttA@mail.gmail.com>
	<56F55E06.2050009@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F55E06.2050009-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The reason for asking was due to me being CCed and I thought it was
relevant, Sorry for the noise :)

On Fri, Mar 25, 2016 at 5:49 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 03/25/2016 08:41 AM, Nikolay Borisov wrote:
>>
>> Is this supposed to fix the issue I reported earlier on the list?
>> http://marc.info/?l=linux-rdma&m=145890571132495&w=2
>
>
> Hello Nikolay,
>
> Although I have not yet analyzed your report in depth, I doubt this will fix
> what you reported earlier today.
>
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
