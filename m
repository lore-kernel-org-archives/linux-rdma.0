From: Devesh Sharma <desh.t2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 9/9] IB/mlx4: Enable mlx4_ib support for MODIFY_QP_EX
Date: Thu, 12 Sep 2013 17:16:42 +0530
Message-ID: <CAGgPuS2mdDnjfdUJYi=U5KTk0cnof_qnFs+VRz3LegjEZgpn2Q@mail.gmail.com>
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

Inline Below on Second question:

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
>
>
>> The patch you have pointed in v4-0 patch still seems to be incomplete. Are
>> these broken?
>
>
> I don't understand the question. During the review of V4 we were pointed to
> a part missing in patch 5/9
> and this will be fixed in V5, sure.
Yes, 5/9 miss a part related to populatin gid table during load time.
Well I was totally concerned about the user space apps, with current
git of libibverbs/librdmacm user app will fail to perform data
transfer operations.
After digging more into the liunx-rdma git I found the completed set
of patches for flow-steering which introduces extension commands in
kernel space. Still looking for corresponding patches for
liblibverbs/librdmacm.

-Regards
 Devesh Sharama

>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
