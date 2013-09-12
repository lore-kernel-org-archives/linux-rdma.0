From: Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Thu, 12 Sep 2013 17:01:59 +0530
Message-ID: <CAGgPuS07Vp6Zrd=cXmZeNps_S6wOswOoXHbp5Ec14tAy5aS5=A@mail.gmail.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
	<1378824099-22150-10-git-send-email-ogerlitz@mellanox.com>
	<CAGgPuS1tAiyA3TZ5_fpua3ue6JrZ9ruS+O+QU-7t28i0dZ7cUw@mail.gmail.com>
	<52319B38.5070807@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52319B38.5070807-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Inline Below:

On Thu, Sep 12, 2013 at 4:15 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/09/2013 08:26, Devesh Sharma wrote:
>>
>> I don't see any patches to librdmacm/libibverbs git to call _EX version of
>> uverbs commands.
>
>
> We've posted the kernel patches, that should be enough for the review. If
> you have any specific questions re user
> space aspects of this series, feel free to send them now.

Yes! for kenel space I see the above set of patches will work fine
without any issues. On the other hand, if from user space some
application tries to establish a connection using RDMACM, the Driver
will receive dmac and vlanid fields as Zeros because
libibverbs/librdmacm still does not call _EX versions of UVERBS/UCM
commands, which are introduced in these set of patches (7/9, 8/9). So,
for example if I try to run ib_send_bw with -R, traffice will not
run!!

So what are the plans to add these changes in libibverbs/librdmacm libraries.
                 OR
there is some flaw in my understanding that librdmacm/libibverbs needs
changes in order to uses newly proposed scheme. Please clarify.

-Regards
 Devesh
>
>
>> The patch you have pointed in v4-0 patch still seems to be incomplete. Are
>> these broken?
>
>
> I don't understand the question. During the review of V4 we were pointed to
> a part missing in patch 5/9
> and this will be fixed in V5, sure.
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
