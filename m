From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/mlx5: Fix mlx5_set_path for Raw Packet QP
Date: Mon, 4 Jul 2016 15:29:16 +0300
Message-ID: <CAJ3xEMhP3PAKXFs9wb7EO3d5YRn6+ciKRCpoKOq65wTNA14tLw@mail.gmail.com>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
 <1467549727-23479-4-git-send-email-leon@kernel.org> <CAJ3xEMhZiBjQwjgXj8peLYW4wETEE96UJ8BC7TLyO0G_jn-iBg@mail.gmail.com>
 <20160704051403.GB5289@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704051403.GB5289-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 4, 2016 at 8:14 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Jul 04, 2016 at 12:55:36AM +0300, Or Gerlitz wrote:

> If I read your response and code correctly, we can safely drop this
> patch. Am I right?

Of course no. You are fixing a bug and I pointed you that you need to
extend the fix a bit.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
