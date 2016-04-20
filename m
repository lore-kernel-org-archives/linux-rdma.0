From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/4] IB/sa: Add support for sa get ClassPortInfo
Date: Wed, 20 Apr 2016 16:12:33 +0300
Message-ID: <CAJ3xEMihe-54UExbp3ptqH5yqg7dc6a6tKcJw0gNytTECce5TQ@mail.gmail.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
	<1461070287-13469-3-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461070287-13469-3-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 3:51 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> New sa query function to return the ClassPortInfo struct from the sa.

sa --> SA in all your change-logs, please

and in the subject it's the SA agent not the SA your are patching
here, reflect that
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
