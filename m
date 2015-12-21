From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: ocrdma failure in 4.4.0-rc5
Date: Mon, 21 Dec 2015 09:59:31 +0530
Message-ID: <CANjDDBiJAyfS7wFr9yYs7fAnn1-h9t1JH9s1LDf-Q8RYk=Ayyw@mail.gmail.com>
References: <5675BA00.5060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5675BA00.5060101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dough,

Thanks for your note.

We will root cause the issue asap and get back to you with the fix.

-Regards
Devesh

On Sun, Dec 20, 2015 at 1:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Devesh,
>
> Testing 4.4.0-rc5, the ocrdma driver is failing for me (100% reliably).
>  If you have vlans off of the main device, this is what I get from the
> Fedora rawhide 4.4.0-rc5 kernel:
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
