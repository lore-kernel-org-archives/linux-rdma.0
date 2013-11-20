From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Wed, 20 Nov 2013 12:07:55 +0200
Message-ID: <528C89FB.6050005@mellanox.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>	<1384381792-2023-8-git-send-email-ogerlitz@mellanox.com>	<CAG4TOxOUFfPMU+q1yKy6S7v3QiLVgMQwxNC-_vw-7UeUb7LoBg@mail.gmail.com> <CAJZOPZ+5UJCAObzFjK5w=bnnSjRM102vR5Ft1nd4nO48Lr2HOg@mail.gmail.com> <EE7902D3F51F404C82415C4803930ACD3FD8348A@CMEXMB1.ad.emulex.com> <dad4986f-4b34-47dc-b6bb-b4882ad1405a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dad4986f-4b34-47dc-b6bb-b4882ad1405a-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/11/2013 09:15, Somnath Kotur wrote:
>> However, in the approach to move address resolution to core verbs i.e.
>> >ib_modify_qp() and ib_create_ah(), vendor driver will have freedom to
>> >resolve l2 addresses in its own way.
> This I am not sure if it's a good idea for each vendor driver to implement L2 address resolution in it's own way? Not sure if that was the intent behind Roland's statement ?

I agree with Somnat, I don't see the point in putting L3 --> L2 address 
resolution within vendor drivers. This will create huge code 
duplication, and more problems. Again, with the proposed patches all 
kernel ULPs that are applicable to RoCE are covered and hence there's no 
address resolution for kernel session. To comply with non-modified user 
space applications/libraries V5 added a code to do address resolution 
and Roland just pointed out it may makes more sense to put that small 
code piece in the core verbs modify_qp function and not in the uverbs call.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
