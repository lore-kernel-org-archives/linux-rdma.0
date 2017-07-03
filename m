From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix uninitialized variable use in check_qp_port_pkey_settings
Date: Mon, 3 Jul 2017 19:02:59 -0400
Message-ID: <CAHC9VhTedbdnV4_G-o2raZfxOiXEvSkEXk_CV80=7oamJ1LPyw@mail.gmail.com>
References: <1498833335-937-1-git-send-email-danielj@mellanox.com> <CAHC9VhSqk1cS+8wpphZgmZt40iMZKLVmUPmnWcjpgf3vqj9zmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhSqk1cS+8wpphZgmZt40iMZKLVmUPmnWcjpgf3vqj9zmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 1, 2017 at 9:40 AM, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Fri, Jun 30, 2017 at 10:35 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Check the return value from get_pkey_and_subnet_prefix to prevent using
>> uninitialized variables.
>>
>> Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/infiniband/core/security.c | 20 ++++++++++++--------
>>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> Since the original patch went in via the SELinux tree, would the
> IB/RDMA folks prefer this to go in via the SELinux tree as well?

I went ahead and merged this into the selinux/stable-4.13 tree and I'm
doing a sanity build now, assuming all goes well I'll send this up for
v4.13.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
