From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 2 Feb 2017 10:52:36 +0200
Message-ID: <782c31cb-e247-1094-955f-2766f9c66cbd@grimberg.me>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This patchset from Leon adds direct access to mlx5 devices.
>
> The libibverbs API is an abstract API. It is agnostic to any underlying
> provider specific implementation. While this abstraction has the advantage of
> user applications portability it has a performance penalty. For some
> applications optimizing performance is more important than portability.
>
> The mlx5 direct verbs API introduced in this patchset is intended for such
> applications. It exposes mlx5 specific low level data path
> (send/receive/completion) operations, allowing the application to bypass the
> libibverbs data path API.

Yishai and Leon this is good stuff !!

Couple of comments:

- The user of this is pretty intimate with the driver, which makes a
   somewhat strange combo of having both ibv_ and mlx5dv_ API. I
   understand that it can inflate the the implementation, but perhaps
   for completeness we can have also the control plane API as well (even
   as a trampoline to the generic equivalent where it's useless).

   The rational here is that extended features that needs allocation
   flags can be contained to mlx5 and not pollute/inflate the generic
   verbs implementation.

- This brings me to the next step of this. What is still missing is
   how we allow the user to have more control and information about how
   his db records (namely UARs) are allocated. How does the user
   know if he needs to protect the DB write? Is it BF? How can the user
   ask for more UARs than originally allocated to it by the kernel?
   The user of this can really use an API that allows more control
   of this area.

   Hopefully we can come up with something that is abstract enough to
   not expose how exactly UARs are strided on pages and the exact
   interface with the kernel, but still let the user choose if to use
   a dedicated db_rec and let the driver manage all the internal details.

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
