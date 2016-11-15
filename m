From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: suspicious rcu_dereference_protected() usage in mlx4 when tearing
 down an interface
Date: Tue, 15 Nov 2016 22:19:50 +0200
Message-ID: <CAJ3xEMi+p2NOavQO+uDaay6TUWdfnBjqEkJok-QsH-jy-vRc5w@mail.gmail.com>
References: <52285420-40b9-afdb-cb29-7e0c939ece26@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52285420-40b9-afdb-cb29-7e0c939ece26-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 15, 2016 at 2:30 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:

> I just hit this with 4.9-rc4 on my test vm.
> Didn't find any patches on the list so maybe this is new?

Yep, seems to be new, I stepped on it today as well and sent note to
Tariq (cc-ed) who is  the driver maintainer,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
