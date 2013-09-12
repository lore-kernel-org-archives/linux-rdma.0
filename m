From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Thu, 12 Sep 2013 13:45:12 +0300
Message-ID: <52319B38.5070807@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com> <1378824099-22150-10-git-send-email-ogerlitz@mellanox.com> <CAGgPuS1tAiyA3TZ5_fpua3ue6JrZ9ruS+O+QU-7t28i0dZ7cUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGgPuS1tAiyA3TZ5_fpua3ue6JrZ9ruS+O+QU-7t28i0dZ7cUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/09/2013 08:26, Devesh Sharma wrote:
> I don't see any patches to librdmacm/libibverbs git to call _EX version of uverbs commands.

We've posted the kernel patches, that should be enough for the review. 
If you have any specific questions re user
space aspects of this series, feel free to send them now.

> The patch you have pointed in v4-0 patch still seems to be incomplete. Are these broken?

I don't understand the question. During the review of V4 we were pointed 
to a part missing in patch 5/9
and this will be fixed in V5, sure.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
